//
// Created by ignat on 15/06/22.
//

#ifndef DUNE2000_CONFIGURATIONS_H
#define DUNE2000_CONFIGURATIONS_H

struct Configurations {
	// Terrains
	unsigned int SAND_ID;
	unsigned int DUNES_ID;
	unsigned int ROCK_ID;
	unsigned int PEAKS_ID;
	unsigned int CLIFFS_ID;
	unsigned int CONSTRUCTION_ID;

	// Infantry
	unsigned int INFANTRY_CLASS_ID;

	unsigned int L_INFANTRY_ID;
	unsigned int L_INFANTRY_HP;
	unsigned int L_INFANTRY_CREATION_TIME;
	unsigned int L_INFANTRY_RANGE;
	unsigned int L_INFANTRY_TRAVERSE_TIME;

	// Vehicles
	unsigned int VEHICLE_CLASS_ID;

	unsigned int TANK_ID;
	unsigned int TANK_HP;
	unsigned int TANK_CREATION_TIME;
	unsigned int TANK_RANGE;
	unsigned int TANK_TRAVERSE_TIME;

	unsigned int TRIKE_ID;
	unsigned int TRIKE_HP;
	unsigned int TRIKE_CREATION_TIME;
	unsigned int TRIKE_RANGE;
	unsigned int TRIKE_TRAVERSE_TIME;

	// Buildings
	unsigned int BUILDING_CLASS_ID;

	unsigned int CENTRE_ID;
	unsigned int CENTRE_HP;
	unsigned int CENTRE_WIDTH;
	unsigned int CENTRE_LENGTH;
	unsigned int CENTRE_ENERGY;

	// Weapons
	unsigned int ASSAULT_RIFLE_ID;
	unsigned int ASSAULT_RIFLE_DMG;
	unsigned int ASSAULT_RIFLE_BONUS;
	unsigned int ASSAULT_RIFLE_RECHARGE_TIME;

	unsigned int CANNON_ID;
	unsigned int CANNON_DMG;
	unsigned int CANNON_BONUS;
	unsigned int CANNON_RECHARGE_TIME;
};

extern const struct Configurations CONFIGS;

#endif //DUNE2000_CONFIGURATIONS_H
