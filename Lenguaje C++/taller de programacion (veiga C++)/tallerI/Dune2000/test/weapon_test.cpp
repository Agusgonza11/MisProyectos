//
// Created by ignat on 10/06/22.
//

#include "acutest.h"
#include "../src/Model/Weapons/assault_rifle.h"

const unsigned int INFANTRY_ID = 1;
const unsigned int VEHICLE_ID = 2;
const unsigned int BUILDING_ID = 3;

void test_assault_rifle(void)
{
	AssaultRifle rifle;
	TEST_CHECK(rifle.get_weapon_id() == 1);
	TEST_CHECK(rifle.damage(INFANTRY_ID,0) == 0);
	TEST_CHECK(rifle.damage(INFANTRY_ID, 200) == 3);
	TEST_CHECK(rifle.damage(VEHICLE_ID, 200) == 2);
	TEST_CHECK(rifle.damage(BUILDING_ID, 200) == 2);
}

TEST_LIST = {
	{"assault_rifle", test_assault_rifle},
	{"NULL, NULL"}
};
