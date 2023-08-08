#include <SFML/Graphics.hpp>
#include <SFML/Audio.hpp>
#include <time.h>
#include <iostream>
#include <tuple>

using namespace sf;

struct Skins{
	std::map <int, Vector2f> tankH;
	std::map <int, Vector2f> tankA;
	std::map <int, Vector2f> tankO;
	std::map <int, Vector2f> trike;
	std::map <int, Vector2f> shoot;
	std::map <int, Vector2f> damage;


	
	Skins(){
		fillFramesTankH();
		fillFramesTankA();
		fillFramesTankO();
		fillFramesTrike();
		fillFramesShoot();
		fillFramesDamage();
	}
	
    private:

	void fillFramesTankH(){
		tankH.insert(std::pair<int,Vector2f>(1, Vector2f(4,2)));
		tankH.insert(std::pair<int,Vector2f>(2, Vector2f(38,2)));
		tankH.insert(std::pair<int,Vector2f>(3, Vector2f(71,2)));
		tankH.insert(std::pair<int,Vector2f>(4, Vector2f(103,2)));
		tankH.insert(std::pair<int,Vector2f>(5, Vector2f(135,2)));
		tankH.insert(std::pair<int,Vector2f>(6, Vector2f(167,2)));
		tankH.insert(std::pair<int,Vector2f>(7, Vector2f(201,2)));
		tankH.insert(std::pair<int,Vector2f>(8, Vector2f(234,2)));	
		tankH.insert(std::pair<int,Vector2f>(9, Vector2f(4,31)));
		tankH.insert(std::pair<int,Vector2f>(10, Vector2f(36,31)));
		tankH.insert(std::pair<int,Vector2f>(11, Vector2f(69,31)));
		tankH.insert(std::pair<int,Vector2f>(12, Vector2f(102,31)));
		tankH.insert(std::pair<int,Vector2f>(13, Vector2f(135,31)));
		tankH.insert(std::pair<int,Vector2f>(14, Vector2f(169,31)));
		tankH.insert(std::pair<int,Vector2f>(15, Vector2f(203,31)));
		tankH.insert(std::pair<int,Vector2f>(16, Vector2f(236,31)));
		tankH.insert(std::pair<int,Vector2f>(17, Vector2f(4,56)));
		tankH.insert(std::pair<int,Vector2f>(18, Vector2f(39,56)));
		tankH.insert(std::pair<int,Vector2f>(19, Vector2f(71,56)));
		tankH.insert(std::pair<int,Vector2f>(20, Vector2f(104,56)));
		tankH.insert(std::pair<int,Vector2f>(21, Vector2f(136,56)));
		tankH.insert(std::pair<int,Vector2f>(22, Vector2f(168,56)));
		tankH.insert(std::pair<int,Vector2f>(23, Vector2f(201,56)));
		tankH.insert(std::pair<int,Vector2f>(24, Vector2f(233,56)));
		tankH.insert(std::pair<int,Vector2f>(25, Vector2f(4,83)));
		tankH.insert(std::pair<int,Vector2f>(26, Vector2f(36,83)));
		tankH.insert(std::pair<int,Vector2f>(27, Vector2f(68,83)));
		tankH.insert(std::pair<int,Vector2f>(28, Vector2f(101,83)));
		tankH.insert(std::pair<int,Vector2f>(29, Vector2f(135,83)));
		tankH.insert(std::pair<int,Vector2f>(30, Vector2f(169,83)));
		tankH.insert(std::pair<int,Vector2f>(31, Vector2f(202,83)));
		tankH.insert(std::pair<int,Vector2f>(32, Vector2f(236,83)));
		tankH.insert(std::pair<int,Vector2f>(33, Vector2f(2,109)));
		tankH.insert(std::pair<int,Vector2f>(34, Vector2f(25,109)));
		tankH.insert(std::pair<int,Vector2f>(35, Vector2f(48,109)));
		tankH.insert(std::pair<int,Vector2f>(36, Vector2f(73,112)));
		tankH.insert(std::pair<int,Vector2f>(37, Vector2f(99,112)));
		tankH.insert(std::pair<int,Vector2f>(38, Vector2f(124,112)));
		tankH.insert(std::pair<int,Vector2f>(39, Vector2f(147,109)));
		tankH.insert(std::pair<int,Vector2f>(40, Vector2f(170,109)));	
		tankH.insert(std::pair<int,Vector2f>(41, Vector2f(195,112)));
		tankH.insert(std::pair<int,Vector2f>(42, Vector2f(219,109)));
		tankH.insert(std::pair<int,Vector2f>(43, Vector2f(243,109)));
		tankH.insert(std::pair<int,Vector2f>(44, Vector2f(2,129)));
		tankH.insert(std::pair<int,Vector2f>(45, Vector2f(25,129)));
		tankH.insert(std::pair<int,Vector2f>(46, Vector2f(48,129)));
		tankH.insert(std::pair<int,Vector2f>(47, Vector2f(73,129)));
		tankH.insert(std::pair<int,Vector2f>(48, Vector2f(99,129)));
		tankH.insert(std::pair<int,Vector2f>(49, Vector2f(124,129)));
		tankH.insert(std::pair<int,Vector2f>(50, Vector2f(147,129)));
		tankH.insert(std::pair<int,Vector2f>(51, Vector2f(170,129)));	
		tankH.insert(std::pair<int,Vector2f>(52, Vector2f(195,129)));
		tankH.insert(std::pair<int,Vector2f>(53, Vector2f(219,129)));
		tankH.insert(std::pair<int,Vector2f>(54, Vector2f(243,129)));
		tankH.insert(std::pair<int,Vector2f>(55, Vector2f(2,149)));
		tankH.insert(std::pair<int,Vector2f>(56, Vector2f(25,149)));
		tankH.insert(std::pair<int,Vector2f>(57, Vector2f(48,149)));
		tankH.insert(std::pair<int,Vector2f>(58, Vector2f(73,149)));
		tankH.insert(std::pair<int,Vector2f>(59, Vector2f(99,149)));
		tankH.insert(std::pair<int,Vector2f>(60, Vector2f(124,149)));
		tankH.insert(std::pair<int,Vector2f>(61, Vector2f(147,149)));
		tankH.insert(std::pair<int,Vector2f>(62, Vector2f(170,149)));	
		tankH.insert(std::pair<int,Vector2f>(63, Vector2f(195,149)));
		tankH.insert(std::pair<int,Vector2f>(64, Vector2f(219,149)));
	}

	void fillFramesTankA(){
		tankA.insert(std::pair<int,Vector2f>(1, Vector2f(4,2)));
		tankA.insert(std::pair<int,Vector2f>(2, Vector2f(38,2)));
		tankA.insert(std::pair<int,Vector2f>(3, Vector2f(71,2)));
		tankA.insert(std::pair<int,Vector2f>(4, Vector2f(103,2)));
		tankA.insert(std::pair<int,Vector2f>(5, Vector2f(135,2)));
		tankA.insert(std::pair<int,Vector2f>(6, Vector2f(167,2)));
		tankA.insert(std::pair<int,Vector2f>(7, Vector2f(201,2)));
		tankA.insert(std::pair<int,Vector2f>(8, Vector2f(234,2)));	
		tankA.insert(std::pair<int,Vector2f>(9, Vector2f(4,31)));
		tankA.insert(std::pair<int,Vector2f>(10, Vector2f(36,31)));
		tankA.insert(std::pair<int,Vector2f>(11, Vector2f(69,31)));
		tankA.insert(std::pair<int,Vector2f>(12, Vector2f(102,31)));
		tankA.insert(std::pair<int,Vector2f>(13, Vector2f(135,31)));
		tankA.insert(std::pair<int,Vector2f>(14, Vector2f(169,31)));
		tankA.insert(std::pair<int,Vector2f>(15, Vector2f(203,31)));
		tankA.insert(std::pair<int,Vector2f>(16, Vector2f(236,31)));
		tankA.insert(std::pair<int,Vector2f>(17, Vector2f(4,56)));
		tankA.insert(std::pair<int,Vector2f>(18, Vector2f(39,56)));
		tankA.insert(std::pair<int,Vector2f>(19, Vector2f(71,56)));
		tankA.insert(std::pair<int,Vector2f>(20, Vector2f(104,56)));
		tankA.insert(std::pair<int,Vector2f>(21, Vector2f(136,56)));
		tankA.insert(std::pair<int,Vector2f>(22, Vector2f(168,56)));
		tankA.insert(std::pair<int,Vector2f>(23, Vector2f(201,56)));
		tankA.insert(std::pair<int,Vector2f>(24, Vector2f(233,56)));
		tankA.insert(std::pair<int,Vector2f>(25, Vector2f(4,79)));
		tankA.insert(std::pair<int,Vector2f>(26, Vector2f(36,79)));
		tankA.insert(std::pair<int,Vector2f>(27, Vector2f(68,79)));
		tankA.insert(std::pair<int,Vector2f>(28, Vector2f(101,79)));
		tankA.insert(std::pair<int,Vector2f>(29, Vector2f(135,79)));
		tankA.insert(std::pair<int,Vector2f>(30, Vector2f(169,79)));
		tankA.insert(std::pair<int,Vector2f>(31, Vector2f(202,79)));
		tankA.insert(std::pair<int,Vector2f>(32, Vector2f(236,79)));
		tankA.insert(std::pair<int,Vector2f>(33, Vector2f(2,104)));
		tankA.insert(std::pair<int,Vector2f>(34, Vector2f(28,104)));
		tankA.insert(std::pair<int,Vector2f>(35, Vector2f(52,104)));
		tankA.insert(std::pair<int,Vector2f>(36, Vector2f(82,104)));
		tankA.insert(std::pair<int,Vector2f>(37, Vector2f(109,104)));
		tankA.insert(std::pair<int,Vector2f>(38, Vector2f(135,104)));
		tankA.insert(std::pair<int,Vector2f>(39, Vector2f(160,104)));
		tankA.insert(std::pair<int,Vector2f>(40, Vector2f(187,104)));	
		tankA.insert(std::pair<int,Vector2f>(41, Vector2f(214,104)));
		tankA.insert(std::pair<int,Vector2f>(42, Vector2f(239,104)));
		tankA.insert(std::pair<int,Vector2f>(43, Vector2f(268,104)));
		tankA.insert(std::pair<int,Vector2f>(44, Vector2f(2,129)));
		tankA.insert(std::pair<int,Vector2f>(45, Vector2f(28,129)));
		tankA.insert(std::pair<int,Vector2f>(46, Vector2f(52,129)));
		tankA.insert(std::pair<int,Vector2f>(47, Vector2f(82,129)));
		tankA.insert(std::pair<int,Vector2f>(48, Vector2f(109,129)));
		tankA.insert(std::pair<int,Vector2f>(49, Vector2f(135,129)));
		tankA.insert(std::pair<int,Vector2f>(50, Vector2f(160,129)));
		tankA.insert(std::pair<int,Vector2f>(51, Vector2f(187,129)));	
		tankA.insert(std::pair<int,Vector2f>(52, Vector2f(214,129)));
		tankA.insert(std::pair<int,Vector2f>(53, Vector2f(239,129)));
		tankA.insert(std::pair<int,Vector2f>(54, Vector2f(268,129)));
		tankA.insert(std::pair<int,Vector2f>(55, Vector2f(2,150)));
		tankA.insert(std::pair<int,Vector2f>(56, Vector2f(28,150)));
		tankA.insert(std::pair<int,Vector2f>(57, Vector2f(52,150)));
		tankA.insert(std::pair<int,Vector2f>(58, Vector2f(82,150)));
		tankA.insert(std::pair<int,Vector2f>(59, Vector2f(109,150)));
		tankA.insert(std::pair<int,Vector2f>(60, Vector2f(135,150)));
		tankA.insert(std::pair<int,Vector2f>(61, Vector2f(160,150)));
		tankA.insert(std::pair<int,Vector2f>(62, Vector2f(187,150)));	
		tankA.insert(std::pair<int,Vector2f>(63, Vector2f(214,150)));
		tankA.insert(std::pair<int,Vector2f>(64, Vector2f(239,150)));
	}
	
	void fillFramesTankO(){
		tankO.insert(std::pair<int,Vector2f>(1, Vector2f(4,2)));
		tankO.insert(std::pair<int,Vector2f>(2, Vector2f(38,2)));
		tankO.insert(std::pair<int,Vector2f>(3, Vector2f(72,2)));
		tankO.insert(std::pair<int,Vector2f>(4, Vector2f(105,2)));
		tankO.insert(std::pair<int,Vector2f>(5, Vector2f(140,2)));
		tankO.insert(std::pair<int,Vector2f>(6, Vector2f(170,2)));
		tankO.insert(std::pair<int,Vector2f>(7, Vector2f(205,2)));
		tankO.insert(std::pair<int,Vector2f>(8, Vector2f(241,2)));
		tankO.insert(std::pair<int,Vector2f>(9, Vector2f(4,31)));
		tankO.insert(std::pair<int,Vector2f>(10, Vector2f(36,31)));
		tankO.insert(std::pair<int,Vector2f>(11, Vector2f(72,31)));
		tankO.insert(std::pair<int,Vector2f>(12, Vector2f(105,31)));
		tankO.insert(std::pair<int,Vector2f>(13, Vector2f(140,31)));
		tankO.insert(std::pair<int,Vector2f>(14, Vector2f(170,31)));
		tankO.insert(std::pair<int,Vector2f>(15, Vector2f(205,31)));
		tankO.insert(std::pair<int,Vector2f>(16, Vector2f(241,31)));
		tankO.insert(std::pair<int,Vector2f>(17, Vector2f(4,60)));
		tankO.insert(std::pair<int,Vector2f>(18, Vector2f(39,60)));
		tankO.insert(std::pair<int,Vector2f>(19, Vector2f(72,60)));
		tankO.insert(std::pair<int,Vector2f>(20, Vector2f(105,60)));
		tankO.insert(std::pair<int,Vector2f>(21, Vector2f(140,60)));
		tankO.insert(std::pair<int,Vector2f>(22, Vector2f(170,60)));
		tankO.insert(std::pair<int,Vector2f>(23, Vector2f(205,60)));
		tankO.insert(std::pair<int,Vector2f>(24, Vector2f(241,60)));
		tankO.insert(std::pair<int,Vector2f>(25, Vector2f(4,87)));
		tankO.insert(std::pair<int,Vector2f>(26, Vector2f(36,87)));
		tankO.insert(std::pair<int,Vector2f>(27, Vector2f(72,87)));
		tankO.insert(std::pair<int,Vector2f>(28, Vector2f(105,87)));
		tankO.insert(std::pair<int,Vector2f>(29, Vector2f(140,87)));
		tankO.insert(std::pair<int,Vector2f>(30, Vector2f(170,87)));
		tankO.insert(std::pair<int,Vector2f>(31, Vector2f(205,87)));
		tankO.insert(std::pair<int,Vector2f>(32, Vector2f(241,87)));
		tankO.insert(std::pair<int,Vector2f>(33, Vector2f(2,116)));
		tankO.insert(std::pair<int,Vector2f>(34, Vector2f(25,116)));
		tankO.insert(std::pair<int,Vector2f>(35, Vector2f(54,116)));
		tankO.insert(std::pair<int,Vector2f>(36, Vector2f(80,116)));
		tankO.insert(std::pair<int,Vector2f>(37, Vector2f(110,116)));
		tankO.insert(std::pair<int,Vector2f>(38, Vector2f(135,116)));
		tankO.insert(std::pair<int,Vector2f>(39, Vector2f(159,116)));
		tankO.insert(std::pair<int,Vector2f>(40, Vector2f(184,116)));	
		tankO.insert(std::pair<int,Vector2f>(41, Vector2f(215,119)));
		tankO.insert(std::pair<int,Vector2f>(42, Vector2f(242,116)));
		tankO.insert(std::pair<int,Vector2f>(43, Vector2f(265,116)));
		tankO.insert(std::pair<int,Vector2f>(44, Vector2f(2,138)));
		tankO.insert(std::pair<int,Vector2f>(45, Vector2f(25,138)));
		tankO.insert(std::pair<int,Vector2f>(46, Vector2f(54,138)));
		tankO.insert(std::pair<int,Vector2f>(47, Vector2f(80,138)));
		tankO.insert(std::pair<int,Vector2f>(48, Vector2f(110,138)));
		tankO.insert(std::pair<int,Vector2f>(49, Vector2f(135,138)));
		tankO.insert(std::pair<int,Vector2f>(50, Vector2f(159,138)));
		tankO.insert(std::pair<int,Vector2f>(51, Vector2f(184,138)));	
		tankO.insert(std::pair<int,Vector2f>(52, Vector2f(215,138)));
		tankO.insert(std::pair<int,Vector2f>(53, Vector2f(242,138)));
		tankO.insert(std::pair<int,Vector2f>(54, Vector2f(265,138)));
		tankO.insert(std::pair<int,Vector2f>(55, Vector2f(2,162)));
		tankO.insert(std::pair<int,Vector2f>(56, Vector2f(25,162)));
		tankO.insert(std::pair<int,Vector2f>(57, Vector2f(54,162)));
		tankO.insert(std::pair<int,Vector2f>(58, Vector2f(80,162)));
		tankO.insert(std::pair<int,Vector2f>(59, Vector2f(110,162)));
		tankO.insert(std::pair<int,Vector2f>(60, Vector2f(135,162)));
		tankO.insert(std::pair<int,Vector2f>(61, Vector2f(159,162)));
		tankO.insert(std::pair<int,Vector2f>(62, Vector2f(184,162)));	
		tankO.insert(std::pair<int,Vector2f>(63, Vector2f(215,162)));
		tankO.insert(std::pair<int,Vector2f>(64, Vector2f(242,162)));
}

	void fillFramesTrike(){
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
	
	void fillFramesShoot(){
		shoot.insert(std::pair<int,Vector2f>(1, Vector2f(135,0)));
		shoot.insert(std::pair<int,Vector2f>(2, Vector2f(258,0)));
		shoot.insert(std::pair<int,Vector2f>(3, Vector2f(385,0)));
		shoot.insert(std::pair<int,Vector2f>(4, Vector2f(515,0)));
		shoot.insert(std::pair<int,Vector2f>(5, Vector2f(648,0)));
		shoot.insert(std::pair<int,Vector2f>(6, Vector2f(135,134)));
		shoot.insert(std::pair<int,Vector2f>(7, Vector2f(258,134)));
		shoot.insert(std::pair<int,Vector2f>(8, Vector2f(385,134)));	
		shoot.insert(std::pair<int,Vector2f>(9, Vector2f(515,134)));
		shoot.insert(std::pair<int,Vector2f>(10, Vector2f(648,134)));
		shoot.insert(std::pair<int,Vector2f>(11, Vector2f(135,260)));
		shoot.insert(std::pair<int,Vector2f>(12, Vector2f(258,260)));
		shoot.insert(std::pair<int,Vector2f>(13, Vector2f(385,260)));
		shoot.insert(std::pair<int,Vector2f>(14, Vector2f(515,260)));
		shoot.insert(std::pair<int,Vector2f>(15, Vector2f(648,260)));
		shoot.insert(std::pair<int,Vector2f>(16, Vector2f(235,400)));
		shoot.insert(std::pair<int,Vector2f>(17, Vector2f(258,400)));
		shoot.insert(std::pair<int,Vector2f>(18, Vector2f(385,400)));
		shoot.insert(std::pair<int,Vector2f>(19, Vector2f(515,400)));
		shoot.insert(std::pair<int,Vector2f>(20, Vector2f(648,400)));
		shoot.insert(std::pair<int,Vector2f>(21, Vector2f(135,530)));
		shoot.insert(std::pair<int,Vector2f>(22, Vector2f(258,530)));
		shoot.insert(std::pair<int,Vector2f>(23, Vector2f(385,530)));
		shoot.insert(std::pair<int,Vector2f>(24, Vector2f(515,530)));
		shoot.insert(std::pair<int,Vector2f>(25, Vector2f(648,530)));
	}

	void fillFramesDamage(){
		damage.insert(std::pair<int,Vector2f>(1, Vector2f(0,0)));
		damage.insert(std::pair<int,Vector2f>(2, Vector2f(180,0)));
		damage.insert(std::pair<int,Vector2f>(3, Vector2f(355,0)));
		damage.insert(std::pair<int,Vector2f>(4, Vector2f(0,240)));
		damage.insert(std::pair<int,Vector2f>(5, Vector2f(180,240)));
	}

/*
	void llenarFrameswindTrapH(){
		damage.insert(std::pair<int,Vector2f>(0, Vector2f(70,135)));
		damage.insert(std::pair<int,Vector2f>(1, Vector2f(0,135)));
		damage.insert(std::pair<int,Vector2f>(2, Vector2f(0,213)));
		damage.insert(std::pair<int,Vector2f>(3, Vector2f(40,213)));
		damage.insert(std::pair<int,Vector2f>(4, Vector2f(80,213)));
		damage.insert(std::pair<int,Vector2f>(5, Vector2f(120,213)));
		damage.insert(std::pair<int,Vector2f>(6, Vector2f(160,213)));
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
*/
};
