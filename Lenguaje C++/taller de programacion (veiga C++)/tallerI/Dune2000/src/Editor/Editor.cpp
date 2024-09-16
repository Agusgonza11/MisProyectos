//
// Created by lucas on 10/06/22.
//

#include <iostream>
#include <list>
#include <valarray>
#include "Editor.h"
#include "StateSaver.h"
#include "ConstructionCenter.h"
#include "EditorException.h"
#include <SFML/Audio.hpp>

Editor::Editor(sf::Vector2i resolution,std::string& name,int x , int y, int players): window(sf::VideoMode(resolution.x, resolution.y),
                                                "Dune - Editor", sf::Style::Close | sf::Style::Resize),
                                                game_over(false), menu(0,0,700,1000),level(y, std::vector<int>(x)),
                                                name(name),
                                                players(players){
    this->posX = 0;
    this->posY = 0;
    this->view.setViewport(sf::FloatRect(0.f, 0.f, 0.75f, 1.0f));
    this->menu_view.setViewport(sf::FloatRect(0.81f, 0.f, 0.25f, 0.70f));
    this->ground = new Ground(level, x, y);
    this->camera = new Camera(view, posX, posY, resolution.x, resolution. y);

}



void Editor::gameloop() {
    int TSIZE = ConstantGetter::getTsize();
    StateSaver saver;
    int selection = 1;
    bool dragMode = false;
    sf::Music music;
    if (!music.openFromFile(ConstantGetter::getResourcePath()+"music.ogg"))
        throw EditorException("Error abriendo archivos");
    music.play();
    while (!game_over) {
        window.clear();
        window.setView(view);
        camera->render(window);
        updateCamera();
        window.setView(menu_view);
        menu.render(window);
        window.display();

        while (window.isOpen()) {

            Event event;
            while (window.pollEvent(event)) {
                if (event.type == sf::Event::MouseButtonPressed){
                    for (int i = 0; i < (int) centers.size(); ++i) {
                        centers[i]->unSelect();
                    }
                }
                if (event.type == sf::Event::KeyPressed) {
                    if (event.key.code == sf::Keyboard::Delete) {
                        auto it = centers.begin();
                        while (it != centers.end()) {
                            if ((*it)->isSelected()) {
                                delete *it;
                                it = centers.erase(it);
                            } else {
                                ++it;
                            }
                        }
                    }
                }
                if (event.type == Event::Closed) {
                    window.close();
                }
                if (event.type == sf::Event::KeyPressed) {
                    if (event.key.code ==  sf::Keyboard::LControl) {
                        dragMode = true;
                    }
                }
                if (event.type == sf::Event::KeyReleased) {
                    if (event.key.code == sf::Keyboard::LControl) {
                        dragMode = false;
                    }
                }
                if ((event.type == sf::Event::MouseButtonPressed || dragMode) && selection!=-1) {
                    if (!dragMode) {
                        if (event.mouseButton.button == sf::Mouse::Left) setSprite(selection);
                    } else {
                        setSprite(selection);
                    }
                } else if (event.type == sf::Event::MouseButtonPressed && selection ==-1){
                    if (event.mouseButton.button == sf::Mouse::Left) {
                        window.setView(view);
                        sf::Vector2i WinPos = sf::Mouse::getPosition(window);
                        sf::Vector2f mouse = window.mapPixelToCoords(WinPos);
                        if (checkConstruction(mouse.x / TSIZE, mouse.y / TSIZE)) {
                            auto *c = new ConstructionCenter();
                            c->setPosition(mouse.x / TSIZE, mouse.y / TSIZE);
                            centers.push_back(c);
                        }
                    }
                }
                if (event.type == sf::Event::MouseButtonPressed && event.mouseButton.button == sf::Mouse::Right ){
                    window.setView(view);
                    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
                    sf::Vector2f mouse = window.mapPixelToCoords(WinPos);
                    for (int i = 0; i < (int) centers.size() ; ++i) {
                        int x = centers[i]->getPosition().x;
                        int y = centers[i]->getPosition().y;
                        int xc = mouse.x/TSIZE;
                        int yc = mouse.y/TSIZE;
                        if (xc>= x && xc <x+3 && yc>=y && yc<y+3){
                            centers[i]->select();
                        }
                    }

                }
                window.setView(menu_view);
                menu.update(window, event, selection);
                if (menu.checkSaved(window, event) && (int) centers.size()==players){
                    saver.saveStatus(name, level, players,centers);
                }
            }

            Vector2i posicion = Mouse::getPosition(window);

            window.clear();
            window.setView(view);
            camera->render(window);
            camera->update(posicion, *ground);
            updateCamera();
            for (auto & center : centers) {
                center->render(window);
            }
            window.setView(menu_view);
            menu.render(window);
            window.display();
            if (!window.isOpen()) {
                game_over = true;
            }
        }
    }

}

void Editor::updateCamera() {
    int TSIZE = ConstantGetter::getTsize();
    posX = camera->get_posX();
    posY = camera->get_posY();
    int limitX = posX +  window.getSize().x;
    int limitY = posY + window.getSize().y;
    for(int i = posX; i < limitX; i+=TSIZE){
        for(int j = posY; j < limitY; j +=TSIZE){
            int col = i / TSIZE;
            int row = j / TSIZE;
            if(ground->identify_texture(col, row)){
                ground->set(i,j);
                window.draw(*ground);
            }
        }
    }
}

void Editor::setMap(std::vector<std::vector<int>> map) {
    level = map;
}

void Editor::setSprite(int selection) {
    int TSIZE = ConstantGetter::getTsize();
    window.setView(view);
    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
    int _x = window.getSize().x;
    int _y = window.getSize().y;
    float scale = view.getViewport().width;
    float scale2 = view.getViewport().height;
    if (WinPos.x < _x * scale && WinPos.y < _y * scale2 ) {
        camera->render(window);
        sf::Vector2f mouse = window.mapPixelToCoords(WinPos);
        ground->setsSprite((mouse.y / TSIZE), (mouse.x / TSIZE), selection);
    }
}

bool Editor::checkConstruction(int x1, int y1) {
    sf::Vector2i WinPos = sf::Mouse::getPosition(window);
    int _x = window.getSize().x;
    int _y = window.getSize().y;
    float scale = view.getViewport().width;
    float scale2 = view.getViewport().height;
    if (WinPos.x > _x * scale || WinPos.y > _y * scale2 ) {
        return false;
    }
    if ((int)centers.size()>=players){
        return false;
    }
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if(ground->getTexture(x1+i, y1+j)!=1){
                return false;
            }
        }
    }

    for (auto & center : centers) {
       Vector2i position = center->getPosition();
        int distance = sqrt(pow(position.x - x1, 2) + pow(position.y - y1, 2));
        if (distance<10){
            return false;
        }
    }
    return true;
}

Editor::~Editor() {
    for (int i = 0; i <(int)centers.size() ; ++i) {
        delete centers[i];
    }
    delete this->ground;
    delete this->camera;
}

void Editor::setCenters(std::vector<ConstructionCenter *>& center) {
    this->centers = center;
}

