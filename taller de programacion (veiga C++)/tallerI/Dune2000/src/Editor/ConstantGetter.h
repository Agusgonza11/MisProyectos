//
// Created by lucas on 17/06/22.
//

#ifndef EDITOR_CONSTANTGETTER_H
#define EDITOR_CONSTANTGETTER_H


#include <string>
#include <SFML/System/Vector2.hpp>

class ConstantGetter {
public:
    static std::string getResourcePath();
    static int getTsize();
    static sf::Vector2i getResolution();
};


#endif //EDITOR_CONSTANTGETTER_H
