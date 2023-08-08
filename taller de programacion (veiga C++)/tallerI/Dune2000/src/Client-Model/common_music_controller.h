#ifndef COMMON_MUSICCONTROLLER_H
#define COMMON_MUSICCONTROLLER_H
#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include <SFML/Audio.hpp>

using namespace sf;

class MusicController{
    Music attack;
    Music predifine1;
    Music predifine2;
    bool is_attacking;
    bool is_reproducing;
    int cont;

    public:
    MusicController();

    void reproducePredifine();

    void reproduceAttacking();

    void reproduce();

};
#endif