require "#{File.dirname(__FILE__)}/../app/models/usuario"
require "#{File.dirname(__FILE__)}/../app/models/pedido"
require "#{File.dirname(__FILE__)}/../app/models/menu"
require "#{File.dirname(__FILE__)}/../app/models/errors/pedido_error"

class WebApi
  API_BASE_URL = ENV['API_URL'] || 'http://webapp:3000'
  AUTORIZACION = { 'Authorization' => ENV['LANONNA_API_KEY'] }.freeze
  HEADER = { 'Content-Type' => 'application/json', 'Authorization' => ENV['LANONNA_API_KEY'] }.freeze
  URL_USUARIOS = "#{API_BASE_URL}/usuarios".freeze
  URL_MENUS = "#{API_BASE_URL}/menus".freeze
  URL_PEDIDOS = "#{API_BASE_URL}/pedidos".freeze

  API_HTTP_OK = 200
  API_HTTP_CREADO = 201
  API_HTTP_ERROR_ESTADO = 409

  def initialize(logger = nil)
    @logger = logger
    @logger&.debug "WebApi iniciado: #{API_BASE_URL}"
  end

  def consultar_version_api
    respuesta = Faraday.get(API_BASE_URL + '/', nil, AUTORIZACION)
    respuesta.body
  end

  def crear_usuario(nombre_usuario, nombre, direccion, telefono)
    @logger&.debug "POST WebApi::crear_usuario => nombre_usuario:#{nombre_usuario} nombre:#{nombre} direccion:#{direccion} telefono:#{telefono}"
    respuesta = Faraday.post(URL_USUARIOS, { 'nombre_usuario' => nombre_usuario,
                                             'nombre' => nombre,
                                             'direccion' => direccion,
                                             'telefono' => telefono }.to_json, HEADER)
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_CREADO

    respuesta = JSON.parse(respuesta.body)
    Usuario.new(respuesta['nombre_usuario'], respuesta['nombre'])
  end

  # rubocop:disable Metrics/AbcSize
  def menus
    @logger&.debug 'GET WebApi::menus'
    respuesta = Faraday.get(URL_MENUS, nil, AUTORIZACION)
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_OK

    lista_menus = []
    menus = JSON.parse(respuesta.body)
    menus.each do |menu|
      lista_menus << Menu.new(menu['id'], menu['nombre'], menu['precio'])
    end
    lista_menus
  end

  def pedir_menu(nombre_usuario, numero_menu)
    @logger&.debug "POST WebApi::pedir_menu => usuario:#{nombre_usuario} pedido:#{numero_menu}"
    respuesta = Faraday.post(URL_PEDIDOS, { 'nombre_usuario': nombre_usuario,
                                            'numero_menu': numero_menu }.to_json, HEADER)
    if respuesta.status == API_HTTP_ERROR_ESTADO
      lista_pedidos = []
      pedidos = JSON.parse(respuesta.body)['pedidos']
      pedidos.each do |pedido|
        lista_pedidos << Pedido.new(pedido['id'], pedido['nombre'], pedido['usuario'], pedido['estado'])
      end
      raise CalificacionesPendientes, lista_pedidos
    end
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_CREADO

    respuesta = JSON.parse(respuesta.body)
    Pedido.new(respuesta['id'], respuesta['nombre'], respuesta['usuario'], respuesta['estado'])
  end
  # rubocop:enable Metrics/AbcSize

  def consultar_pedido(nombre_usuario, numero_pedido)
    @logger&.debug "GET WebApi::consultar_pedido => usuario:#{nombre_usuario} pedido#{numero_pedido}"
    respuesta = Faraday.get("#{URL_PEDIDOS}/#{numero_pedido}", { nombre_usuario: nombre_usuario }, AUTORIZACION)
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_OK

    respuesta = JSON.parse(respuesta.body)
    Pedido.new(respuesta['id'], respuesta['nombre'], respuesta['usuario'], respuesta['estado'])
  end

  def cancelar_pedido(nombre_usuario, numero_pedido)
    @logger&.debug "POST WebApi::cancelar_pedido => usuario:#{nombre_usuario} pedido#{numero_pedido}"
    respuesta = Faraday.post("#{URL_PEDIDOS}/#{numero_pedido}/estado/cancelado", { nombre_usuario: nombre_usuario }, AUTORIZACION)
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_OK

    respuesta = JSON.parse(respuesta.body)
    Pedido.new(respuesta['id'], respuesta['nombre'], respuesta['usuario'], respuesta['estado'])
  end

  def calificar_pedido(nombre_usuario, numero_pedido, calificacion, comentario = nil)
    @logger&.debug "PATCH WebApi::calificar_pedido => usuario:#{nombre_usuario} pedido#{numero_pedido} calificacion:#{calificacion}"
    body = { 'nombre_usuario': nombre_usuario, 'calificacion': calificacion, 'comentario': comentario }

    respuesta = Faraday.patch("#{URL_PEDIDOS}/#{numero_pedido}", body.to_json, HEADER)
    raise PedidoError, JSON.parse(respuesta.body)['error'] if respuesta.status != API_HTTP_OK

    respuesta = JSON.parse(respuesta.body)
    Pedido.new(respuesta['id'], nil, nil, nil, respuesta['calificacion'], respuesta['comentario'])
  end
end
