#include <vector>
#include <iostream>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include "common_music_controller.h"


using namespace sf;

MusicController::MusicController(){
    attack.openFromFile("resources/sounds/attack.ogg");
    predifine1.openFromFile("resources/sounds/neutral.ogg");
    predifine2.openFromFile("resources/sounds/neutral2.ogg");
    this->is_attacking = false;
    this->is_reproducing = false;
    this->cont = 2;
}

void MusicController::reproduceAttacking(){
    if(!is_attacking) is_reproducing = false;
    is_attacking = true;
}

void MusicController::reproduce(){
    if(is_reproducing) return;
    if(is_attacking){
        is_reproducing = true;
        predifine1.stop();
        predifine2.stop();
        attack.play();
        attack.setVolume(5);
        attack.setLoop(true);
        if(cont == 2) cont = 1;
        if(cont == 1) cont = 2;
    } else {
        is_reproducing = true;
        attack.stop();
        if(cont == 1){
            predifine2.stop();
            predifine1.play();
            predifine1.setLoop(true);
            predifine1.setVolume(5);
        }
        if(cont == 2){
            predifine1.stop();
            predifine2.play();
            predifine1.setLoop(true);
            predifine2.setVolume(5);
        }
    }
}

void MusicController::reproducePredifine(){
    if(is_attacking) is_reproducing = false;
    is_attacking = false;
}