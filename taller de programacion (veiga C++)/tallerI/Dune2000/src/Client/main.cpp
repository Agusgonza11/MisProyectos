#include <iostream>
#include <QApplication>
#include <QErrorMessage>
#include <QDir>
#include "Client.h"
#include "firstwindow.h"
#include "SocketException.h"
#include "Button.h"
#include "ConstructionMenu.h"

int main(int argc, char* argv[]) {


    sf::RenderWindow window(sf::VideoMode(1366, 768), "Dune", sf::Style::Close | sf::Style::Resize);
    sf::View view;

    view.setViewport(sf::FloatRect(0.81f, 0.f, 0.25f, 0.70f));
    ConstructionMenu menu(0,0,700,1000,"Harkonnen");


    window.setView(view);
    window.clear();
    menu.render(window);
    window.display();

    while (window.isOpen()) {
        sf::Event e;
        while (window.pollEvent(e)) {
            if (e.type == e.Closed) {
                window.close();
            }
            menu.update(e,window);
        }

        window.clear();
        menu.render(window);
        window.display();
    }


    /*
    try {
        auto *a = new QApplication(argc, argv);
        std::string host;
        std::string port;
        FIrstWindow w(host, port);
        w.show();
        a->exec();
        if (!host.empty() && !port.empty()) {
            Client client(host.c_str(), port.c_str());
            delete a;
            client.run();
        }
    }catch (SocketException &e){
        QErrorMessage msg;
        msg.showMessage("CONNECTION ERROR");
        msg.exec();
        return 1;
    }
    return 0;
     */
}
