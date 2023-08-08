#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include <iostream>
#include <tuple>



using namespace sf;

struct Skins{
	std::map <int, Vector2f> tanque;
	std::map <int, Vector2f> trike;
	std::map <int, Vector2f> windTrapH;
	std::map <int, Vector2f> windTrapO;
	std::map <int, Vector2f> windTrapA;
	
	Skins(){
		llenarFramesTanque();
		llenarFramesTrike();
		llenarFrameswindTrapH();
		llenarFrameswindTrapO();
		llenarFrameswindTrapA();
	}
	
	void llenarFramesTanque(){
		tanque.insert(std::pair<int,Vector2f>(1, Vector2f(4,2)));
		tanque.insert(std::pair<int,Vector2f>(2, Vector2f(38,2)));
		tanque.insert(std::pair<int,Vector2f>(3, Vector2f(71,2)));
		tanque.insert(std::pair<int,Vector2f>(4, Vector2f(103,2)));
		tanque.insert(std::pair<int,Vector2f>(5, Vector2f(135,2)));
		tanque.insert(std::pair<int,Vector2f>(6, Vector2f(167,2)));
		tanque.insert(std::pair<int,Vector2f>(7, Vector2f(201,2)));
		tanque.insert(std::pair<int,Vector2f>(8, Vector2f(234,2)));	
		tanque.insert(std::pair<int,Vector2f>(9, Vector2f(4,31)));
		tanque.insert(std::pair<int,Vector2f>(10, Vector2f(36,31)));
		tanque.insert(std::pair<int,Vector2f>(11, Vector2f(69,31)));
		tanque.insert(std::pair<int,Vector2f>(12, Vector2f(102,31)));
		tanque.insert(std::pair<int,Vector2f>(13, Vector2f(135,31)));
		tanque.insert(std::pair<int,Vector2f>(14, Vector2f(169,31)));
		tanque.insert(std::pair<int,Vector2f>(15, Vector2f(203,31)));
		tanque.insert(std::pair<int,Vector2f>(16, Vector2f(236,31)));
		tanque.insert(std::pair<int,Vector2f>(17, Vector2f(4,56)));
		tanque.insert(std::pair<int,Vector2f>(18, Vector2f(39,56)));
		tanque.insert(std::pair<int,Vector2f>(19, Vector2f(71,56)));
		tanque.insert(std::pair<int,Vector2f>(20, Vector2f(104,56)));
		tanque.insert(std::pair<int,Vector2f>(21, Vector2f(136,56)));
		tanque.insert(std::pair<int,Vector2f>(22, Vector2f(168,56)));
		tanque.insert(std::pair<int,Vector2f>(23, Vector2f(201,56)));
		tanque.insert(std::pair<int,Vector2f>(24, Vector2f(233,56)));
		tanque.insert(std::pair<int,Vector2f>(25, Vector2f(4,83)));
		tanque.insert(std::pair<int,Vector2f>(26, Vector2f(36,83)));
		tanque.insert(std::pair<int,Vector2f>(27, Vector2f(68,83)));
		tanque.insert(std::pair<int,Vector2f>(28, Vector2f(101,83)));
		tanque.insert(std::pair<int,Vector2f>(29, Vector2f(135,83)));
		tanque.insert(std::pair<int,Vector2f>(30, Vector2f(169,83)));
		tanque.insert(std::pair<int,Vector2f>(31, Vector2f(202,83)));
		tanque.insert(std::pair<int,Vector2f>(32, Vector2f(236,83)));
		tanque.insert(std::pair<int,Vector2f>(33, Vector2f(2,109)));
		tanque.insert(std::pair<int,Vector2f>(34, Vector2f(25,109)));
		tanque.insert(std::pair<int,Vector2f>(35, Vector2f(48,109)));
		tanque.insert(std::pair<int,Vector2f>(36, Vector2f(73,112)));
		tanque.insert(std::pair<int,Vector2f>(37, Vector2f(99,112)));
		tanque.insert(std::pair<int,Vector2f>(38, Vector2f(124,112)));
		tanque.insert(std::pair<int,Vector2f>(39, Vector2f(147,109)));
		tanque.insert(std::pair<int,Vector2f>(40, Vector2f(170,109)));	
		tanque.insert(std::pair<int,Vector2f>(41, Vector2f(195,112)));
		tanque.insert(std::pair<int,Vector2f>(42, Vector2f(219,109)));
		tanque.insert(std::pair<int,Vector2f>(43, Vector2f(243,109)));
		tanque.insert(std::pair<int,Vector2f>(44, Vector2f(2,129)));
		tanque.insert(std::pair<int,Vector2f>(45, Vector2f(25,129)));
		tanque.insert(std::pair<int,Vector2f>(46, Vector2f(48,129)));
		tanque.insert(std::pair<int,Vector2f>(47, Vector2f(73,129)));
		tanque.insert(std::pair<int,Vector2f>(48, Vector2f(99,129)));
		tanque.insert(std::pair<int,Vector2f>(49, Vector2f(124,129)));
		tanque.insert(std::pair<int,Vector2f>(50, Vector2f(147,129)));
		tanque.insert(std::pair<int,Vector2f>(51, Vector2f(170,129)));	
		tanque.insert(std::pair<int,Vector2f>(52, Vector2f(195,129)));
		tanque.insert(std::pair<int,Vector2f>(53, Vector2f(219,129)));
		tanque.insert(std::pair<int,Vector2f>(54, Vector2f(243,129)));
		tanque.insert(std::pair<int,Vector2f>(55, Vector2f(2,149)));
		tanque.insert(std::pair<int,Vector2f>(56, Vector2f(25,149)));
		tanque.insert(std::pair<int,Vector2f>(57, Vector2f(48,149)));
		tanque.insert(std::pair<int,Vector2f>(58, Vector2f(73,149)));
		tanque.insert(std::pair<int,Vector2f>(59, Vector2f(99,149)));
		tanque.insert(std::pair<int,Vector2f>(60, Vector2f(124,149)));
		tanque.insert(std::pair<int,Vector2f>(61, Vector2f(147,149)));
		tanque.insert(std::pair<int,Vector2f>(62, Vector2f(170,149)));	
		tanque.insert(std::pair<int,Vector2f>(63, Vector2f(195,149)));
		tanque.insert(std::pair<int,Vector2f>(64, Vector2f(219,149)));
	}
	
	void llenarFrameswindTrapH(){
		windTrapH.insert(std::pair<int,Vector2f>(0, Vector2f(70,135)));
		windTrapH.insert(std::pair<int,Vector2f>(1, Vector2f(0,135)));
		windTrapH.insert(std::pair<int,Vector2f>(2, Vector2f(0,213)));
		windTrapH.insert(std::pair<int,Vector2f>(3, Vector2f(40,213)));
		windTrapH.insert(std::pair<int,Vector2f>(4, Vector2f(80,213)));
		windTrapH.insert(std::pair<int,Vector2f>(5, Vector2f(120,213)));
		windTrapH.insert(std::pair<int,Vector2f>(6, Vector2f(160,213)));
	}

	void llenarFrameswindTrapA(){
		windTrapA.insert(std::pair<int,Vector2f>(0, Vector2f(65,0)));
		windTrapA.insert(std::pair<int,Vector2f>(1, Vector2f(0,0)));
		windTrapA.insert(std::pair<int,Vector2f>(2, Vector2f(0,75)));
		windTrapA.insert(std::pair<int,Vector2f>(3, Vector2f(44,75)));
		windTrapA.insert(std::pair<int,Vector2f>(4, Vector2f(44,75)));
		windTrapA.insert(std::pair<int,Vector2f>(5, Vector2f(125,75)));
		windTrapA.insert(std::pair<int,Vector2f>(6, Vector2f(165,75)));
	}
	
	void llenarFrameswindTrapO(){
		windTrapO.insert(std::pair<int,Vector2f>(0, Vector2f(70,270)));
		windTrapO.insert(std::pair<int,Vector2f>(1, Vector2f(0,270)));
		windTrapO.insert(std::pair<int,Vector2f>(2, Vector2f(0,340)));
		windTrapO.insert(std::pair<int,Vector2f>(3, Vector2f(40,340)));
		windTrapO.insert(std::pair<int,Vector2f>(4, Vector2f(79,340)));
		windTrapO.insert(std::pair<int,Vector2f>(5, Vector2f(120,340)));
		windTrapO.insert(std::pair<int,Vector2f>(6, Vector2f(160,340)));
	}
	
	
	void llenarFramesTrike(){
		trike.insert(std::pair<int,Vector2f>(1, Vector2f(5,5)));
		trike.insert(std::pair<int,Vector2f>(2, Vector2f(40,5)));
		trike.insert(std::pair<int,Vector2f>(3, Vector2f(75,5)));
		trike.insert(std::pair<int,Vector2f>(4, Vector2f(110,5)));
		trike.insert(std::pair<int,Vector2f>(5, Vector2f(140,5)));
		trike.insert(std::pair<int,Vector2f>(6, Vector2f(175,5)));
		trike.insert(std::pair<int,Vector2f>(7, Vector2f(200,5)));
		trike.insert(std::pair<int,Vector2f>(8, Vector2f(235,5)));	
		trike.insert(std::pair<int,Vector2f>(9, Vector2f(5,35)));
		trike.insert(std::pair<int,Vector2f>(10, Vector2f(40,35)));
		trike.insert(std::pair<int,Vector2f>(11, Vector2f(75,35)));
		trike.insert(std::pair<int,Vector2f>(12, Vector2f(110,35)));
		trike.insert(std::pair<int,Vector2f>(13, Vector2f(140,35)));
		trike.insert(std::pair<int,Vector2f>(14, Vector2f(175,35)));
		trike.insert(std::pair<int,Vector2f>(15, Vector2f(200,35)));
		trike.insert(std::pair<int,Vector2f>(16, Vector2f(235,35)));
		trike.insert(std::pair<int,Vector2f>(17, Vector2f(5,60)));
		trike.insert(std::pair<int,Vector2f>(18, Vector2f(40,60)));
		trike.insert(std::pair<int,Vector2f>(19, Vector2f(75,60)));
		trike.insert(std::pair<int,Vector2f>(20, Vector2f(105,60)));
		trike.insert(std::pair<int,Vector2f>(21, Vector2f(135,60)));
		trike.insert(std::pair<int,Vector2f>(22, Vector2f(165,60)));
		trike.insert(std::pair<int,Vector2f>(23, Vector2f(200,60)));
		trike.insert(std::pair<int,Vector2f>(24, Vector2f(235,60)));
		trike.insert(std::pair<int,Vector2f>(25, Vector2f(5,85)));
		trike.insert(std::pair<int,Vector2f>(26, Vector2f(40,60)));
		trike.insert(std::pair<int,Vector2f>(27, Vector2f(75,60)));
		trike.insert(std::pair<int,Vector2f>(28, Vector2f(110,60)));
		trike.insert(std::pair<int,Vector2f>(29, Vector2f(140,85)));
		trike.insert(std::pair<int,Vector2f>(30, Vector2f(175,85)));
		trike.insert(std::pair<int,Vector2f>(31, Vector2f(200,85)));
		trike.insert(std::pair<int,Vector2f>(32, Vector2f(235,85)));
	}
	
	
};

class Build: public Drawable{
	public:
	
	RectangleShape lifeMax;
	RectangleShape lifeRest;
	
	float x;
	float y;
	int largoX;
	int largoY;
	int frameBuild;
	int cont;
	int hp = 40;
	int hpMax = 50;
	
	int team;
	
	bool esta_atacando;	

	
	void draw(RenderTarget &target, RenderStates states) const {

	}
	
	
	Build(float x, float y, int team){
		this->x = x;
		this->y = y;
		this->cont = 0;
		this->team = team;
		frameBuild = 1;	
		lifeMax.setSize(Vector2f(50,3));
		lifeMax.setFillColor(sf::Color::Black);  
		int c = hp * 30 / hpMax;
		lifeRest.setSize(Vector2f(c,3));
		lifeRest.setFillColor(sf::Color::Green);
		lifeMax.setPosition(x, y - 8);
		lifeRest.setPosition(x, y - 8);
		
	}
	
	void modifyHp(int new_hp){
	/*
		int life = hp * 30 / max_hp;
		lifeRest.setSize(Vector2f(life,3));
		int porcentual_life = hp * 100 / max_hp;
		if(porcentual_life < 30){
			lifeRest.setFillColor(sf::Color::Red);
			frameBuild = 0;
		} else {
			lifeRest.setFillColor(sf::Color::Green);
		}
		this->hp = new_hp;
		*/
	}
	
	bool is_there(float cord_x, float cord_y){
		int is_in = 0;
		if(this->x <= cord_x && cord_x <= this->x + this->largoX) is_in += 1;
		if(this->y <= cord_y && cord_y<= this->y + this->largoY) is_in += 1;
		return is_in == 2;
	}
	
	int get_team(){
		return team;
	}
	
	std::tuple<int, int, int, int> get_bits(){
		return std::make_tuple(x, y, largoX, largoY);
	}
	
	virtual void animateBuild() {};
	
};


class WindTrap: public Build{
	Sprite spriteBuild;
	Texture textBuild;
	Sprite windows;
	int frameWindow;
	std::map <int, Vector2f> &frames;
	bool is_constructed;
	Texture textConstruction;
	Sprite spriteConstruction;
	int frameConstruction;
	public:
	
	WindTrap(std::map <int, Vector2f> &frames, float x, float y, int team): Build(x,y,team), frames(frames) {
		this->largoX = 65;
		this->largoY = 75;
		frameWindow = 2;
		frameConstruction = 1;
		textBuild.loadFromFile("windtrap.png");
		spriteBuild.setTexture(textBuild);
		windows.setTexture(textBuild);
		Vector2f &posicionBuild = frames[frameBuild];
		spriteBuild.setTextureRect(IntRect(posicionBuild.x, posicionBuild.y,65,75));
		spriteBuild.setPosition(x,y);
		Vector2f &posicionWindow = frames[frameWindow];
		windows.setTextureRect(IntRect(posicionWindow.x, posicionWindow.y,40,55));
		windows.setPosition(x + 15,y + 7);		
		is_constructed = false;
	}
	
	void draw(RenderTarget &target, RenderStates states) const {
		if(hp < hpMax){
			target.draw(lifeMax,states);
			target.draw(lifeRest,states);
		}
		if(is_constructed){
			target.draw(spriteBuild, states);
			target.draw(windows, states);
		} 
		if(frameConstruction > 1 && frameConstruction < 22){
			target.draw(spriteConstruction, states);
		}
	}
	
	void construct(){
		std::string f = "windtrap/" + std::to_string(frameConstruction) + ".bmp";
		Image image;
		image.loadFromFile(f);
		image.createMaskFromColor(sf::Color::Black);	
		textConstruction.loadFromImage(image);
		spriteConstruction.setTexture(textConstruction);
		spriteConstruction.setPosition(x,y);
		spriteConstruction.setTextureRect(IntRect(0,0,70,70));
		frameConstruction++;
		if(frameConstruction == 14) is_constructed = true;
		if(frameConstruction == 22) frameConstruction = 0;
	}
	
	virtual void animateBuild() override{
		if(cont % 30 == 0 && frameConstruction != 0) construct();
		if(cont % 100 == 0){
			if(frameWindow < 6){
				frameWindow++;
			} else {
				frameWindow = 2;
			}
		}
		Vector2f &posicionBuild = frames[frameBuild];
		spriteBuild.setTextureRect(IntRect(posicionBuild.x, posicionBuild.y,65,75));
		Vector2f &posicionWindow = frames[frameWindow];
		windows.setTextureRect(IntRect(posicionWindow.x, posicionWindow.y,40,55));
		cont++;
	}
	

};

class Explosion: public Drawable{
	public:
	Sprite sprite;
	Texture texture;
	Image image;
	SoundBuffer buffer;
	Sound sonido;
	int frame;
	int lastFrame;
	int cont;
	bool finish;
	float x;
	float y;
	

	void draw(RenderTarget &target, RenderStates states) const {
		target.draw(sprite, states);
	}
	
	Explosion(float x, float y){
		image.loadFromFile("explosion/1.png");
		image.createMaskFromColor(sf::Color::Black);
		texture.loadFromImage(image);
		sprite.setTexture(texture);
		sprite.setPosition(x,y);
		buffer.loadFromFile("explosion/1.wav");
		sonido.setBuffer(buffer);
		sonido.setVolume(5);
		this->frame = 1;
		this->lastFrame = 0;
		this->x = x;
		this->y = y;
		finish = false;
		cont = 0;
	}

	
	bool termino(){
		return finish;
	}

	void animar(){
		if(lastFrame == 0) sonido.play();
		if(cont % 20 == 0) updateTexture();
		cont++;
	}
	
	void updateTexture(){
		std::string f = "explosion/" + std::to_string(frame) + ".png";
		image.loadFromFile(f);
		image.createMaskFromColor(sf::Color::Black);	
		texture.loadFromImage(image);
		sprite.setTexture(texture);
		if(frame == 1){
			frame++; lastFrame = 1;
		} else if(frame == 7){
			frame--; lastFrame++;
			
		} else if(lastFrame < frame){
			frame++; lastFrame++;
		} else if(lastFrame > frame){
			frame--; lastFrame--;
		}
		if(frame == 1 && lastFrame == 2) finish = true;
	}
	
	std::tuple<int, int, int, int> get_bits(){
		return std::make_tuple(x, y, 58, 59);
	}

};


class Seleccion: public Drawable{
	public:
	Sprite sprite;
	Texture texture;

	void draw(RenderTarget &target, RenderStates states) const {
		target.draw(sprite, states);
	}
	
	Seleccion(){
		texture.loadFromFile("cursores.png");
		sprite.setTexture(texture);
		sprite.setTextureRect(IntRect(0,155,30,27)); 
	}
	
	void habilitar(float x, float y){
		sprite.setPosition(x, y);
	}

};
/*
class Bala: public Drawable{
	public:
	CircleShape circulo;
	float vel;
	float x;
	float y;
	float goX;
	float goY;
	
	void draw(RenderTarget &target, RenderStates states) const {
		target.draw(circulo, states);
	}
	
	void set(float xDirec, float yDirec, float actualX, float actualY){
		this->x = actualX;
		this->y = actualY;
		this->goX= xDirec;
		this->goY= yDirec;
	}
	
	Bala(){
		this->circulo = CircleShape(5.f);
 		circulo.setFillColor(sf::Color::Red);
		this->vel = 1;
	}
	
	void animar(float bartX, float bartY){
		float moveX = x;
		float moveY = y;
		if(goX > x){
			moveX +=  vel;
		}
		if(goX < x){
			moveX -=  vel;
		}
		if(goY > y){
			moveY +=  vel;
		}
		if(goY < y){
			moveY -=  vel;
		}
		circulo.setPosition(moveX, moveY);
		this->x = moveX;
		this->y = moveY;
		if((int) moveX == (int) goX){
			this->goX = moveX;
		}
		if((int) moveY == (int) goY){
			this->goY = moveY;		
		}
		if((int) x == (int) goX &&  (int) y == (int) goY){
			this->x = bartX;
			this->y = bartY; 
		} 
	}
	
	std::tuple<float, float> get_bits(){
		return std::make_tuple(x,y);
	}
};
*/

class Canion: public Drawable{
	public:
	CircleShape circulo;
	float vel;
	float x;
	float y;
	float goX;
	float goY;
	
	void draw(RenderTarget &target, RenderStates states) const {
		target.draw(circulo, states);
	}
	
	void set(float xDirec, float yDirec, float actualX, float actualY){
		this->x = actualX;
		this->y = actualY;
		this->goX= xDirec;
		this->goY= yDirec;
	}
	
	Canion(){
		this->circulo = CircleShape(5.f);
 		circulo.setFillColor(sf::Color::Red);
		this->vel = 1;
	}
	
	void animar(float bartX, float bartY){
		float moveX = x;
		float moveY = y;
		if(goX > x){
			moveX +=  vel;
		}
		if(goX < x){
			moveX -=  vel;
		}
		if(goY > y){
			moveY +=  vel;
		}
		if(goY < y){
			moveY -=  vel;
		}
		circulo.setPosition(moveX, moveY);
		this->x = moveX;
		this->y = moveY;
		if((int) moveX == (int) goX){
			this->goX = moveX;
		}
		if((int) moveY == (int) goY){
			this->goY = moveY;		
		}
		if((int) x == (int) goX &&  (int) y == (int) goY){
			this->x = bartX;
			this->y = bartY; 
		} 
	}
	
	std::tuple<float, float> get_bits(){
		return std::make_tuple(x,y);
	}

};

class Ligera: public Canion{
	bool finish = false;
	int cont = 0;
	public:
	
	void draw(RenderTarget &target, RenderStates states) const {
		if(!finish){
			target.draw(circulo, states);
		}
	}
	
	
	void animar(float xDir, float yDir){
			if(cont % 10 == 0){
				circulo.setPosition(x,y);
			}
			if(cont == 100) finish = true;
			cont++;

	}

};


class Bart: public Drawable{
	public:
	Sprite sprite;
	Texture texture;
	
	Seleccion seleccion;
	RectangleShape lifeMax;
	RectangleShape lifeRest;
	
	bool can_move;
	float x;
	float y;
	int largoX;
	int largoY;
	float goX;
	float goY;
	float vel;
	int cont;
	int hp = 40;
	int hpMax = 50;
	
	int team;
	
	bool esta_atacando;	
	public:

	
	void draw(RenderTarget &target, RenderStates states) const {
		if(hp < hpMax){
			target.draw(lifeMax,states);
			target.draw(lifeRest,states);
		}
		if(can_move) target.draw(seleccion);
		target.draw(sprite, states);
	}
	
	
	Bart(float x, float y, int team): seleccion{} {
		this->x = x;
		this->y = y;
		this->goX = x;
		this->goY = y;
		this->vel = 0.1;	
		this->can_move = false;
		this->esta_atacando = false;
		this->cont = 0;
		this->team = team;
		
		lifeMax.setSize(Vector2f(30,3));
		lifeMax.setFillColor(sf::Color::Black);
		     
		int c = hp * 30 / hpMax;
		
		lifeRest.setSize(Vector2f(c,3));
		lifeRest.setFillColor(sf::Color::Green);
		
		lifeMax.setPosition(x, y - 5);
		
	}
	
	virtual void attack(float xDirec, float yDirec){
	}

	bool ataca(){
		return esta_atacando;
	}
	
	virtual void animar_ataque(){
	}
	
	
	void setMove(float x, float y){
		this->goX = x;
		this->goY = y;
	}
	
	
	bool is_in_destiny(){
		return goX == x && goY == y;
	}
	
	virtual void modifyMovePosition(bool moveRight, bool moveLeft, bool moveUp, bool moveDown){
		
	}
	
	virtual Canion get_bullet(){
		Canion bala;
		return bala;
	}
	
	void move(){
		float moveX = x;
		float moveY = y;
		bool moveRight = false; bool moveLeft = false; 
		bool moveUp = false; bool moveDown = false;
		if(goX > x){
			moveX +=  vel;
			esta_atacando = false;
			moveRight = true;
		}
		if(goX < x){
			moveX -=  vel;
			esta_atacando = false;
			moveLeft = true;
		}
		if(goY > y){
			moveY +=  vel;
			esta_atacando = false;
			moveDown = true;
		}
		if(goY < y){
			moveY -=  vel;
			esta_atacando = false;
			moveUp = true;
		}
		modifyMovePosition(moveRight, moveLeft, moveUp, moveDown);
		sprite.setPosition(moveX, moveY);
		seleccion.habilitar(moveX, moveY);
		lifeMax.setPosition(moveX, moveY - 5);
		lifeRest.setPosition(moveX, moveY - 5);
		this->x = moveX;
		this->y = moveY;
		if((int) moveX == (int) goX){
			this->goX = moveX;
		}
		if((int) moveY == (int) goY){
			this->goY = moveY;		
		}
	}
	
	void enable_move(int equipo){
		if(equipo == team){
			this->can_move = true;
			seleccion.habilitar(x,y);
		}
	}
	
	void no_enable_move(){
		this->can_move = false;
	}
	
	bool can_moves(){
		return this->can_move;
	}
	
	int get_posX(){
		return x;
	}
	
	int get_posY(){
		return y;
	}
	
	int get_larX(){
		return largoX;
	}
	
	int get_larY(){
		return largoY;
	}
	
	bool is_there(float cord_x, float cord_y){
		int is_in = 0;
		if(this->x <= cord_x && cord_x <= this->x + this->largoX) is_in += 1;
		if(this->y <= cord_y && cord_y<= this->y + this->largoY) is_in += 1;
		return is_in == 2;
	}
	
	int get_team(){
		return team;
	}
	
	std::tuple<int, int, int, int> get_bits(){
		return std::make_tuple(x, y, largoX, largoY);
	}
	
};

class Tanque: public Bart{
	int frameActual;
	int frameActualCanion;
	int ataqueX;
	int ataqueY;
	Sprite canion;
	Canion bala;
	std::map <int, Vector2f> &frames;

	public:
	Tanque(std::map <int, Vector2f> &frames, float x, float y, int team): Bart(x,y,team), frames(frames){
		this->largoX = 35;
		this->largoY = 35;
		this->goX = x;
		this->goY = y;
		this->vel = 0.1;	
		this->frameActual = 17;
		this->frameActualCanion = 49;
		texture.loadFromFile("units/harkonnenTank.png");
		sprite.setTexture(texture);
		canion.setTexture(texture);
		canion.setTextureRect(IntRect(8,109,10,18));
		sprite.setTextureRect(IntRect(5,2,30,25));
		sprite.setPosition(x, y);
		canion.setPosition(x + 5, y + 1);
	}
	
	void draw(RenderTarget &target, RenderStates states) const {
		if(can_move) target.draw(seleccion);
		target.draw(sprite, states);
		target.draw(canion, states);
	}
	
	virtual Canion get_bullet() override{
		return bala;
	}
	
	void updateCanion(){
		int frameDestino = frameActualCanion;
		bool moveRight = false; bool moveLeft = false; 
		bool moveUp = false; bool moveDown = false;
		if(ataqueX > x && ataqueX - 15 > x){
			moveRight = true;
		}
		if(ataqueX < x && ataqueX + 15 < x){
			moveLeft = true;
		}
		if(ataqueY > y && ataqueY - 15 > y){
			moveDown = true;
		}
		if(ataqueY < y && ataqueY + 15 < y){
			moveUp = true;
		}
		if(moveRight){
			if(moveUp) frameDestino = 36;
			if(moveDown) frameDestino = 46;
			else if(!moveUp && !moveDown) frameDestino = 41;	
		}
		if(moveLeft){
			if(moveUp) frameDestino = 61;
			if(moveDown) frameDestino = 53;
			else if(!moveUp && !moveDown) frameDestino = 57;
		}
		if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestino = 49;
		if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestino = 33;
		
		if(frameActualCanion > frameDestino) frameActualCanion--;
		if(frameActualCanion < frameDestino) frameActualCanion++;
		if(frameActualCanion == frameDestino) bala.animar(x, y);

		Vector2f &posicionFrameCanion = frames[frameActualCanion];
		canion.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,20,20));
	}
	
	
	virtual void attack(float xDirec, float yDirec) override{
		ataqueX = xDirec;
		ataqueY = yDirec;
		bala.set(xDirec, yDirec, x, y);
		esta_atacando = true;
	}
	
	virtual void animar_ataque() override {
		if(cont % 10 == 0) updateCanion();
		canion.setPosition(x + 5,y + 1);
		cont++;
	}
	
	virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
							bool moveUp, bool moveDown) override{
		int frameDestino;
		if(moveRight){
			if(moveUp) frameDestino = 5;
			if(moveDown) frameDestino = 13;
			else if(!moveUp && !moveDown) frameDestino = 9;	
		}
		if(moveLeft){
			if(moveUp) frameDestino = 29;
			if(moveDown) frameDestino = 21;
			else if(!moveUp && !moveDown) frameDestino = 25;
		}
		if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestino = 17;
		if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestino = 1;
		
		if(cont % 10 == 0){
			if(frameActual > frameDestino){
				frameActual--;
			}
			if(frameActual < frameDestino){
				frameActual++;
			}
		}
		Vector2f &posicionFrame = frames[frameActual];
		sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));

		frameActualCanion = frameActual + 32;
		Vector2f &posicionFrameCanion = frames[frameActualCanion];
		canion.setTextureRect(IntRect(posicionFrameCanion.x, posicionFrameCanion.y,20,20));	
		
		canion.setPosition(x + 5,y + 1);
		cont++;
	}

};


class Trike: public Bart{
	int ataqueX;
	int ataqueY;
	int frameActual;
	Ligera bala;
	std::map <int, Vector2f> &frames;

	public:
	Trike(std::map <int, Vector2f> &frames ,float x, float y, int team): Bart(x, y, team), frames(frames) {
		this->largoX = 30;
		this->largoY = 30;
		this->goX = x;
		this->goY = y;
		this->vel = 0.1;	
		this->frameActual = 17;
		texture.loadFromFile("units/trike.png");
		sprite.setTexture(texture);
		sprite.setTextureRect(IntRect(5,60,30,30));
		sprite.setPosition(x, y);
	}
	
	virtual Canion get_bullet() override{
		return bala;
	}
	
	virtual void attack(float xDirec, float yDirec) override{
		ataqueX = xDirec;
		ataqueY = yDirec;
		bala.set(xDirec, yDirec, x, y);
		esta_atacando = true;
	}
	
	virtual void animar_ataque() override {
		if(cont % 10 == 0) apuntarHacia();
		sprite.setPosition(x,y);
		cont++;
	}
	
	void apuntarHacia(){
		int frameDestino = frameActual;
		bool moveRight = false; bool moveLeft = false; 
		bool moveUp = false; bool moveDown = false;
		if(ataqueX > x && ataqueX - 15 > x){
			moveRight = true;
		}
		if(ataqueX < x && ataqueX + 15 < x){
			moveLeft = true;
		}
		if(ataqueY > y && ataqueY - 15 > y){
			moveDown = true;
		}
		if(ataqueY < y && ataqueY + 15 < y){
			moveUp = true;
		}
		if(moveRight){
			if(moveUp) frameDestino = 5;
			if(moveDown) frameDestino = 13;
			else if(!moveUp && !moveDown) frameDestino = 9;	
		}
		if(moveLeft){
			if(moveUp) frameDestino = 29;
			if(moveDown) frameDestino = 21;
			else if(!moveUp && !moveDown) frameDestino = 25;
		}
		if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestino = 17;
		if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestino = 1;
		
		if(frameActual > frameDestino) frameActual--;
		if(frameActual < frameDestino) frameActual++;
		if(frameActual == frameDestino) bala.animar(x, y);
		Vector2f &posicionFrame = frames[frameActual];
		sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
	}
	
	
	virtual void modifyMovePosition(bool moveRight, bool moveLeft, 
							bool moveUp, bool moveDown) override{
		int frameDestino;
		if(moveRight){
			if(moveUp) frameDestino = 5;
			if(moveDown) frameDestino = 13;
			else if(!moveUp && !moveDown) frameDestino = 9;	
		}
		if(moveLeft){
			if(moveUp) frameDestino = 29;
			if(moveDown) frameDestino = 21;
			else if(!moveUp && !moveDown) frameDestino = 25;
		}
		if(!moveRight && !moveLeft && !moveUp && moveDown) frameDestino = 17;
		if(!moveRight && !moveLeft && moveUp && !moveDown) frameDestino = 1;
		
		if(cont % 10 == 0){
			if(frameActual > frameDestino) frameActual--;
			if(frameActual < frameDestino) frameActual++;
		}
		Vector2f &posicionFrame = frames[frameActual];
		sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,25));
		cont++;
	}
	
};

class Camera {
	public:
	int &posX;
	int &posY;
	View &view;
	
	Camera(View &view, int &posX, int &posY):posX(posX), posY(posY), view(view) {}
	
	void Render(RenderWindow &window){
		window.setView(view);
	}
	
	void Update(Vector2i &posicion){
		bool move = false;
		if(posicion.x + 10 >= 500) posX += 1; move = true;
		if(posicion.y + 10 >= 500) posY += 1; move = true;
		if(posicion.x - 10 <= 0) posX -= 1; move = true;
		if(posicion.y - 10 <= 0) posY -= 1; move = true;
		if(posX < 0) posX = 0;
		if(posY < 0) posY = 0;
		if(posX > 1200) posX -= 1;
		if(posY > 550) posY -= 1;
		if(move) view.reset(FloatRect(posX, posY, 500, 500));
	}
	
	bool appears_in_view(int objectX, int objectY, int largeX, int largeY){
		bool appears = false;
		int show = 0;
		if(objectX >= posX && objectX + largeX <= posX + 500) show += 1;
		if(objectY >= posY && objectY + largeY <= posY + 500) show += 1;
		if(show == 2) appears = true;
		return appears;
	}
		
	int get_x(){
		return posX;
	}
	
	int get_y(){
		return posY;
	}


};


class Ground: public Drawable {
	public:
	Texture texture;
	Sprite sprite;
	std::vector<std::vector<int> > map;
	int largo; int ancho;
	
	void draw(RenderTarget &target, RenderStates states) const {
		target.draw(sprite, states);
	}
	
	Ground(std::vector<std::vector<int> > level, int largo, int ancho): map(level), largo(largo), ancho(ancho) {
		texture.loadFromFile("terrains/terrain.bmp");
		sprite.setTexture(texture);
	}
	
	void is_sand(){
		sprite.setTextureRect(IntRect(0,8,16,16)); 
	}
	
	void is_rock(){
		sprite.setTextureRect(IntRect(112,240,16,16)); 
	}
	
	void is_cliff(){
		sprite.setTextureRect(IntRect(96,40,16,16)); 
	}
	
	void is_spice(){
		sprite.setTextureRect(IntRect(0,305,16,16)); 
	}
	
	
	
	void setear(int x, int y){
		sprite.setPosition(x,y);
	}
	
	bool identificar_textura(int col, int fil){
		bool resultado = false;
		if(col >= largo || fil >= ancho) return false;
		switch(map[fil][col]){
			case 0:
				is_sand(); resultado = true;
				break;
			case 1:
				is_rock(); resultado = true;
				break;
			case 2:
				is_spice(); resultado = true;
				break;
			case 3:
				is_cliff(); resultado = true;
				break;
		}
	return resultado;
}

	
};

class Cursorr {
	Texture texture;
	Sprite sprite;
	int frame;
	int cont;
	std::map <int, Vector2f> frames;
	bool is_enemy;
	int team;
	
	public:
	Cursorr(RenderWindow &window, int team){
		llenarFrames();
		frame = 0;
		cont = 0;
		window.setMouseCursorVisible(false);
		texture.loadFromFile("cursores.png");
		sprite.setTexture(texture);
		sprite.setTextureRect(IntRect(0,0,15,15));
		this->team = team;
		
		this->is_enemy = false;
	}
	
	void updateTexture(){
		if(is_enemy){
			if(frame > 8){
				frame++;
			} 
			if(frame < 8 || frame == 16){
				frame = 9;
			} 
		} else {
			if(frame < 8){
				frame++;
			}
			if(frame >= 8){
				frame = 1;
			}
		}
		Vector2f &posicionFrame = frames[frame];
		sprite.setTextureRect(IntRect(posicionFrame.x, posicionFrame.y,30,27));
	}
	
	void unit_move(){
		frame = 1;
	}
	
	void normal(){
		sprite.setTextureRect(IntRect(0,0,15,15));
		frame = 0;
	}


	void update(std::vector<Bart*> &barts, Vector2i &posicion, 
					int posX, int posY, RenderWindow &window){
		for(int i = 0; i < barts.size() ; i++){
			if(barts[i]->get_team() != team){
				if(barts[i]->is_there(posicion.x + posX, posicion.y + posY)){
					is_enemy = true;
					break;
				} else { 
					is_enemy = false;
				}
			}
		}
		sprite.setPosition(posicion.x + posX - 15, posicion.y + posY - 15);
		if(cont % 30 == 0 && frame != 0) updateTexture();
		window.draw(sprite);
		cont++;
	}
	
	void llenarFrames(){
		frames.insert(std::pair<int,Vector2f>(1, Vector2f(0,15)));
		frames.insert(std::pair<int,Vector2f>(2, Vector2f(35,15)));
		frames.insert(std::pair<int,Vector2f>(3, Vector2f(70,15)));
		frames.insert(std::pair<int,Vector2f>(4, Vector2f(100,15)));
		frames.insert(std::pair<int,Vector2f>(5, Vector2f(135,15)));
		frames.insert(std::pair<int,Vector2f>(6, Vector2f(168,15)));
		frames.insert(std::pair<int,Vector2f>(7, Vector2f(200,15)));
		frames.insert(std::pair<int,Vector2f>(8, Vector2f(233,15)));
		frames.insert(std::pair<int,Vector2f>(9, Vector2f(0,70)));	
		frames.insert(std::pair<int,Vector2f>(10, Vector2f(30,70)));
		frames.insert(std::pair<int,Vector2f>(11, Vector2f(65,70)));		
		frames.insert(std::pair<int,Vector2f>(12, Vector2f(95,70)));		
		frames.insert(std::pair<int,Vector2f>(13, Vector2f(125,70)));		
		frames.insert(std::pair<int,Vector2f>(14, Vector2f(157,70)));		
		frames.insert(std::pair<int,Vector2f>(15, Vector2f(187,70)));		
		frames.insert(std::pair<int,Vector2f>(16, Vector2f(220,70)));					
	}
	
};

void draw(RenderWindow &window, std::vector<Bart*> &barts, std::vector<Build*> &builds, Ground &suelos, Camera &camera, std::vector<Explosion*> &explosiones){
		int posX = camera.get_x();
		int posY = camera.get_y();
		int limitX = posX +  500;
		int limitY = posY + 500;
		
		for(int i = posX; i < limitX; i+=16){
			for(int j = posY; j < limitY; j +=16){
				int col = i / 16;
				int fil = j / 16;
				if(suelos.identificar_textura(col, fil)){
					suelos.setear(i,j);
					window.draw(suelos);
				}
			}
		}
		
		for(int i = 0; i < builds.size() ; i++){
			std::tuple<int, int, int, int> bBits = builds[i]->get_bits();
			if(camera.appears_in_view(std::get<0>(bBits), std::get<1>(bBits), 
								std::get<2>(bBits), std::get<3>(bBits))){
				builds[i]->animateBuild();
				window.draw(*builds[i]);
			}
		}
		
		for(int i = 0; i < barts.size() ; i++){
			Bart *ptr = barts[i];
			if(!ptr->is_in_destiny()){
				ptr->move();
			}
			if(ptr->ataca()){
				ptr->animar_ataque();
				std::tuple<int, int> aBits = ptr->get_bullet().get_bits();
				if(camera.appears_in_view(std::get<0>(aBits), std::get<1>(aBits),0, 0)){
					window.draw(ptr->get_bullet());
				}
			}
			std::tuple<int, int, int, int> uBits = barts[i]->get_bits();
			if(camera.appears_in_view(std::get<0>(uBits), std::get<1>(uBits), 
								std::get<2>(uBits), std::get<3>(uBits))){
				window.draw(*barts[i]);
			}
		}
		
		
		for(int i = 0; i < explosiones.size() ; i++){
			if(!explosiones[i]->termino()){
				explosiones[i]->animar();
				std::tuple<int, int, int, int> uBits = explosiones[i]->get_bits();
				if(camera.appears_in_view(std::get<0>(uBits), std::get<1>(uBits), 
								std::get<2>(uBits), std::get<3>(uBits))){
					window.draw(*explosiones[i]);
				}
			} else {
				delete explosiones[i];
				explosiones.erase(explosiones.begin() + i);
				
			}
		}
		
}


int main(){
    RenderWindow window(VideoMode(500, 500), "DUNE");
	CircleShape shape{50.f};
    shape.setOrigin({50.f, 50.f});
    Skins skins;
    window.setVerticalSyncEnabled(true);
	
	Tanque bart(skins.tanque, 0,0, 0);
	//Trike bart3(600,660, 0);
	Trike bart2(skins.trike, 100,100, 0);
	std::vector<Bart*> barts;
	barts.push_back(&bart);
	barts.push_back(&bart2);
	//barts.push_back(&bart3);
	WindTrap build(skins.windTrapH, 20,5, 0);
	WindTrap build1(skins.windTrapA, 100,5, 0);
	WindTrap build2(skins.windTrapO, 50,100, 0);
	std::vector<Build*> builds;
	builds.push_back(&build);	
	builds.push_back(&build1);	
	builds.push_back(&build2);	
	
	View view;
	
	int team = 0;
	//Cursorr cursor(window, team);
	
	std::vector<std::vector<int> > nuevo;
	for(int i = 0; i < 200; i++){
		std::vector<int> actual;
		for(int j = 0; j < 50; j++){
			if(j % 2 ==0) actual.push_back(0);
			if(j % 3 ==0) actual.push_back(1);
			if(j % 7 ==0) actual.push_back(2);
			else actual.push_back(3);
		}
		nuevo.push_back(actual);
	}
	
	int cont = 0;

	std::vector<Explosion*> explosiones;

	
	Ground suelos(nuevo, 200, 200);
	
	int posX = 0;
	int posY = 0;
	Camera camera(view, posX, posY);
	
	while(window.isOpen()){
		Event event;
		Vector2i posicion = Mouse::getPosition(window);	
		camera.Update(posicion);

		while(window.pollEvent(event)){
			if(event.type == Event::Closed){
				window.close();
			} else if (event.type == sf::Event::Resized) {
               	view.setSize({
                	static_cast<float>(event.size.width),
                    static_cast<float>(event.size.height)
                });
                window.setView(view);
            	shape.setPosition(window.mapPixelToCoords(sf::Vector2i{window.getSize() / 2u}));
            }
			if(event.type == Event::MouseButtonPressed){
				if(event.mouseButton.button == Mouse::Left){
					for(int i = 0; i < barts.size() ; i++){
						if(barts[i]->is_there(event.mouseButton.x + posX, event.mouseButton.y + posY)){
							barts[i]->enable_move(team);
							//cursor.unit_move();
							break;
						} else {
							barts[i]->no_enable_move();
							//cursor.normal();
							//explosiones.push_back(new Explosion(event.mouseButton.x + posX - 25, event.mouseButton.y + posY - 25));
						}
					}
				}
				if(event.mouseButton.button == Mouse::Right){
					for(int i = 0; i < barts.size() ; i++){
						if(barts[i]->can_moves()){
							barts[i]->setMove(event.mouseButton.x + posX, event.mouseButton.y + posY);
						} else {
							barts[i]->attack(event.mouseButton.x + posX, event.mouseButton.y + posY);
						}
					}
				}
			}
		}
		
		camera.Render(window);
		window.clear();
		//window.draw(fondo);
		draw(window, barts, builds, suelos, camera, explosiones);
		//cursor.update(barts, posicion, posX, posY, window);
		
		Image image;
		Texture texture;
		texture.loadFromFile("ordos.png");
		Sprite sprite;
		sprite.setTexture(texture);
		sprite.setPosition(0, 0);
				window.draw(sprite);

		Texture texturea;
		texturea.loadFromFile("units/harkonnenTank.png");
		Sprite spritea;
		spritea.setTexture(texturea);
		spritea.setPosition(0, 0);
		spritea.setColor(Color::Red);
		window.draw(spritea);


		std::cout << posicion.x + posX << " " << posicion.y + posY << std::endl;
		
		window.display(); 
	}
	return 0;
}
