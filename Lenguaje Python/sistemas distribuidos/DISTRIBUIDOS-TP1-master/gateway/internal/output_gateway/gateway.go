package output_gateway

import (
	"bufio"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	goIO "io"
	"net"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"tp1-sistemas-distribuidos/gateway/internal/config"
	io "tp1-sistemas-distribuidos/gateway/internal/utils"

	"github.com/op/go-logging"
	"github.com/streadway/amqp"
)

type Broker interface {
	Consume(queueName string) (<-chan amqp.Delivery, error)
	Close()
}

type Gateway struct {
	config       config.OutputGatewayConfig
	broker       Broker
	eofByClient  map[string]int
	statePath    string
	stateMutex   sync.Mutex
	clients      map[string]net.Conn
	clientsMutex sync.RWMutex
	running      bool
	runningMutex sync.RWMutex
	logger       *logging.Logger
}

func NewGateway(broker Broker, config config.OutputGatewayConfig, logger *logging.Logger) *Gateway {
	g := &Gateway{
		config:      config,
		broker:      broker,
		eofByClient: make(map[string]int),
		statePath:   "/tmp/output_gateway_tmp/state.json",
		clients:     make(map[string]net.Conn),
		running:     true,
		logger:      logger,
	}

	g.handleStateRecovery()

	return g
}

func (g *Gateway) Start(ctx context.Context) {
	wg := sync.WaitGroup{}

	wg.Add(1)

	listener, err := net.Listen("tcp", g.config.Address)
	if err != nil {
		g.logger.Errorf("failed to start listener: %v", err)
		return
	}

	g.logger.Infof("starting to listen in port: %s", g.config.Address)

	go func() {
		defer listener.Close()
		defer wg.Done()

		go g.gracefulShutdown(ctx, listener)
		g.acceptConnections(listener)
	}()

	wg.Add(1)
	go func() {
		defer wg.Done()
		g.listenRabbitMQ(ctx)
	}()

	wg.Wait()
}

func (g *Gateway) acceptConnections(listener net.Listener) {
	for g.isRunning() {
		g.logger.Info("Waiting for conns")

		conn, err := listener.Accept()
		if err != nil {
			if g.isRunning() {
				g.logger.Errorf("failed to accept connection: %v", err)
			}

			continue
		}

		g.logger.Info("Connection accepted")

		go g.handleConnection(conn)
	}
}

func (g *Gateway) handleConnection(conn net.Conn) {
	reader := bufio.NewReader(conn)

	var clientID string

	response, err := io.ReadMessage(reader)
	if err != nil {
		if !errors.Is(err, goIO.EOF) {
			g.logger.Errorf("error reading message: %v", err)
		}

		g.logger.Infof("connection closed: %s", err.Error())
		return
	}

	g.logger.Infof("Message read: %s", response)

	lines := strings.Split(response, "\n")
	if len(lines) != 1 {
		g.logger.Info("malformed message")
		return
	}

	parts := strings.Split(lines[0], ",")
	if len(parts) < 2 {
		g.logger.Info("invalid format, expected id in message")
		return
	}

	clientID = strings.TrimSpace(parts[1])

	g.clientsMutex.Lock()
	g.clients[clientID] = conn
	g.clientsMutex.Unlock()

	g.logger.Infof("Client connected: %s", clientID)
}

func (g *Gateway) listenRabbitMQ(ctx context.Context) {
	msgsChan, err := g.broker.Consume(g.config.RabbitMQ.OutputQueueName)
	if err != nil {
		return
	}

	for {
		select {
		case <-ctx.Done():
			g.logger.Info("stopping RabbitMQ listener")
			return
		case msg, ok := <-msgsChan:
			if !ok {
				g.logger.Warning("rabbitMQ channel closed")
				return
			}

			if len(msg.Headers) == 0 {
				g.logger.Info("---- Filtering message due to empty headers ----")
				continue
			}

			clientID := msg.Headers["ClientID"].(string)

			g.clientsMutex.RLock()
			conn, exists := g.clients[clientID]
			g.clientsMutex.RUnlock()

			if !exists {
				g.logger.Warningf("client %s not connected", clientID)
				continue
			}

			body := strings.Split(string(msg.Body), "\n")
			body = body[1:]

			query := msg.Headers["Query"]

			queryStr, ok := query.(string)
			if !ok {
				g.logger.Errorf("Error: Query no es un string!")
				continue
			}

			g.logger.Infof("Message received for query %s: %s", query, body)
			messageType := msg.Headers["type"]
			if messageType != nil {
				isEOF := messageType.(string) == "EOF"
				if isEOF {
					g.logger.Info("---- Sending EOF message ----")
					g.handleEOFMessage(conn, clientID, queryStr)
					continue
				}
			}

			bodyStr := strings.Join(body, "\n")

			message := fmt.Sprintf("%s\n%s", queryStr, bodyStr)
			g.logger.Info("---- Message ----")
			g.logger.Infof("Sending body: %s\n", string(message))

			err := io.WriteMessage(conn, []byte(message))
			if err != nil {
				g.logger.Errorf("failed to send message to %s: %v", clientID, err)
				continue
			}

			reader := bufio.NewReader(conn)

			response, err := io.ReadMessage(reader)
			if err != nil {
				g.logger.Errorf("failed trying to read result ack for client id: %s, err: %v", clientID, err)
				continue
			}

			if response == "RESULT_ACK" {
				g.logger.Infof("Query result delivered succesfully to client: %s", clientID)
			}
		}
	}
}

func (g *Gateway) handleEOFMessage(conn net.Conn, clientID string, query string) {
	if query == QueryArgentinaEsp {
		key := fmt.Sprintf("%s-%s", clientID, query)
		if count, exists := g.eofByClient[key]; exists {
			if count > 1 {
				g.eofByClient[key]--
				g.saveState()

				g.logger.Infof("receive EOF from client %s waiting %d more to send to client", clientID, count)

				return
			}

			g.logger.Infof("receive EOF from client %s sending to client...", clientID)

			delete(g.eofByClient, key)

			g.saveState()
		} else {
			eofsCount, _ := strconv.Atoi(os.Getenv("CONSULTA_1_EOF_COUNT"))
			g.logger.Infof("setting EOF count to %d", eofsCount)

			g.eofByClient[key] = eofsCount - 1
			g.saveState()
		}
	}

	err := io.WriteMessage(conn, []byte(fmt.Sprintf("%s\n%s", query, "EOF")))
	if err != nil {
		g.logger.Errorf("failed to send message to %s: %v", clientID, err)
	}
}

func (g *Gateway) gracefulShutdown(ctx context.Context, listener net.Listener) {
	<-ctx.Done()
	listener.Close()

	g.runningMutex.Lock()
	g.running = false
	g.runningMutex.Unlock()

	g.clientsMutex.Lock()
	for clientID, conn := range g.clients {
		g.logger.Infof("closing connection for client %s", clientID)
		_ = conn.Close()
	}
	g.clientsMutex.Unlock()
}

func (g *Gateway) isRunning() bool {
	g.runningMutex.RLock()
	defer g.runningMutex.RUnlock()
	return g.running
}

func (g *Gateway) saveState() {
	g.stateMutex.Lock()
	defer g.stateMutex.Unlock()

	os.MkdirAll(filepath.Dir(g.statePath), 0o755)
	f, err := os.Create(g.statePath)
	if err != nil {
		g.logger.Errorf("Error saving state: %v", err)
		return
	}
	
	defer f.Close()
	
	enc := json.NewEncoder(f)
	
	err = enc.Encode(g.eofByClient)
	if err != nil {
		g.logger.Errorf("Error encoding state: %v", err)
	}
}

func (g *Gateway) handleStateRecovery() {
	g.stateMutex.Lock()
	defer g.stateMutex.Unlock()

	if _, err := os.Stat(g.statePath); os.IsNotExist(err) {
		g.eofByClient = make(map[string]int)
		return
	}

	f, err := os.Open(g.statePath)
	if err != nil {
		g.logger.Errorf("Error opening state file: %v", err)
		return
	}

	defer f.Close()

	dec := json.NewDecoder(f)

	m := make(map[string]int)

	err = dec.Decode(&m)
	if err != nil {
		g.logger.Errorf("Error decoding state: %v", err)
		return
	}

	g.eofByClient = m

	for k, v := range g.eofByClient {
		g.logger.Infof("[RECOVERY] EOF pendientes para %s: %d", k, v)
	}
}
