#include <vector>
#include <string>
#include <tuple>
#include <SFML/Graphics.hpp>
#include <time.h>
#include "common_camera.h"
#include "common_model.h"

Camera::Camera(View &view, int &posX, int &posY, int sizeX, int sizeY): 
	view(view), posX(posX), posY(posY), sizeX(sizeX), sizeY(sizeY) {}
	
void Camera::render(RenderWindow &window){
	window.setView(view);
}
	
void Camera::update(Vector2i &posicion, Model &model){
	int large_x_map = model.get_x_size(); //Aca calculo los puntos mas alejados del mapa
	int large_y_map = model.get_y_size(); 

	bool move = false;
	if(posicion.x + 10 >= sizeX) posX += 1; move = true;
	if(posicion.y + 10 >= sizeY) posY += 1; move = true;
	if(posicion.x - 10 <= 0) posX -= 1; move = true;
	if(posicion.y - 10 <= 0) posY -= 1; move = true;
	if(posX < 0) posX = 0;
	if(posY < 0) posY = 0;
	if(posX + sizeX > large_x_map) posX -= 1;
	if(posY + sizeY > large_y_map) posY -= 1;
	if(move) view.reset(FloatRect(posX, posY, sizeX, sizeY));
}


bool Camera::appears_in_view(int objectX, int objectY, int largeX, int largeY){
	bool appears = false;
	int show = 0;
	if(objectX >= posX && objectX + largeX <= posX + sizeX) show += 1;
	if(objectY >= posY && objectY + largeY <= posY + sizeY) show += 1;
	if(show == 2) appears = true;
	return appears;
}

int Camera::get_posX(){
	return this->posX;
}
	
int Camera::get_posY(){
	return this->posY;
}
