#include <QApplication>
#include <iostream>
#include <filesystem>
#include <yaml-cpp/exceptions.h>
#include "textBox.h"
#include "Editor.h"
#include "editormainwindow.h"
#include "StateSaver.h"
#include "MapLoader.h"
#include "EditorException.h"


int main(int argc, char *argv[]) {
    try {
        QApplication editorView(argc, argv);
        std::string name;
        int x;
        int y;
        int mode = 0;
        int players;
        EditorMainWindow e(name, x, y, mode, players);
        e.show();
        editorView.exec();

        if (mode == 1) {
            Editor editor(Vector2i(ConstantGetter::getResolution().x, ConstantGetter::getResolution().y), name, x, y,
                          players);
            editor.gameloop();
        } else if (mode == 2) {
            std::vector<ConstructionCenter *> centers;
            std::vector<std::vector<int>> map;
            Editor editor(Vector2i(ConstantGetter::getResolution().x, ConstantGetter::getResolution().y),
                          name, x, y, players);
            MapLoader loader;
            std::string path("../map/" + name + ".yaml");
            loader.loadMap(path, map, players, name, centers);
            editor.setMap(map);
            editor.setCenters(centers);
            editor.gameloop();
        }
    }catch(EditorException &e){
        std::cout << e.what() << std::endl;
    }catch(YAML::TypedBadConversion<int> &e){
        std::cout << e.what() << std::endl;
    }catch(YAML::TypedBadConversion<std::string> &e){
        std::cout << e.what() << std::endl;
    }catch(YAML::TypedBadConversion<std::vector<int>> &e){
        std::cout << e.what() << std::endl;
    }
    return 0;

}
