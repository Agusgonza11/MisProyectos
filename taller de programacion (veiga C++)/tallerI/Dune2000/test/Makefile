CFLAGS = -Wall -Werror -pedantic -pedantic-errors -std=c++17
MAP_FILES = ../src/Model/Map/terrain_map.cpp ../src/Model/Map/block_position.cpp ../src/Model/Map/path_node.cpp
UNIT_FILES = ../src/Model/Entities/unit.cpp ../src/Model/Entities/teamable.cpp ../src/Model/Weapons/weapon.cpp
INFANTRY_FILES = ../src/Model/Entities/light_infantry.cpp ../src/Model/Mobility/infantry_mobility.cpp
VEHICLE_FILES = ../src/Model/Entities/tank.cpp ../src/Model/Entities/trike.cpp ../src/Model/Mobility/vehicle_mobility.cpp
WEAPON_FILES = ../src/Model/Weapons/assault_rifle.cpp ../src/Model/Weapons/cannon.cpp
BUILDING_FILES = ../src/Model/Entities/building.cpp ../src/Model/Entities/teamable.cpp ../src/Model/Map/block_position.cpp ../src/Server/configuration_loader.cpp
SRV_FILES = ../src/Server/mock_server.cpp ../src/Server/control_unit.cpp ../src/Server/entity_factory.cpp ../src/Server/configuration_loader.cpp

all: test_block_position test_path_node test_terrain_map test_terrain_mobility test_tank test_light_infantry test_weapons test_srv test_centre test_srv

test_block_position: block_position_test.cpp ../src/Model/Map/block_position.cpp
	g++ $(CFLAGS) -o block_position.test block_position_test.cpp ../src/Model/Map/block_position.cpp

test_terrain_mobility: terrain_mobility_test.cpp ../src/Model/Mobility/infantry_mobility.cpp
	g++ $(CFLAGS) -o terrain_mobility.test terrain_mobility_test.cpp ../src/Model/Mobility/infantry_mobility.cpp

test_path_node: path_node_test.cpp ../src/Model/Map/path_node.cpp ../src/Model/Map/block_position.cpp
	g++ $(CFLAGS) -o path_node.test path_node_test.cpp ../src/Model/Map/path_node.cpp ../src/Model/Map/block_position.cpp

test_terrain_map: terrain_map_test.cpp $(MAP_FILES) ../src/Model/Mobility/infantry_mobility.cpp
	g++ $(CFLAGS) -o terrain_map.test terrain_map_test.cpp $(MAP_FILES) ../src/Model/Mobility/infantry_mobility.cpp

test_light_infantry: light_infantry_test.cpp ../src/Model/Entities/light_infantry.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Model/Mobility/infantry_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp
	g++ $(CFLAGS) -o light_inf.test light_infantry_test.cpp ../src/Model/Entities/light_infantry.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Model/Mobility/infantry_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp

test_weapons: weapon_test.cpp ../src/Model/Weapons/weapon.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Server/configuration_loader.cpp
	g++ $(CFLAGS) -o weapon.test weapon_test.cpp ../src/Model/Weapons/weapon.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Server/configuration_loader.cpp

test_tank: tank_test.cpp ../src/Model/Entities/tank.cpp ../src/Model/Weapons/cannon.cpp ../src/Model/Mobility/vehicle_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp
	g++ $(CFLAGS) -o tank.test tank_test.cpp ../src/Model/Entities/tank.cpp ../src/Model/Weapons/cannon.cpp ../src/Model/Mobility/vehicle_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp

test_trike: trike_test.cpp ../src/Model/Entities/trike.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Model/Mobility/vehicle_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp
	g++ $(CFLAGS) -o trike.test trike_test.cpp ../src/Model/Entities/trike.cpp ../src/Model/Weapons/assault_rifle.cpp ../src/Model/Mobility/vehicle_mobility.cpp $(UNIT_FILES) $(MAP_FILES) ../src/Server/configuration_loader.cpp

test_srv: mock_server_test.cpp $(SRV_FILES) $(INFANTRY_FILES) $(VEHICLE_FILES) $(WEAPON_FILES) $(UNIT_FILES) $(MAP_FILES)
	g++ $(CFLAGS) -o srv.test mock_server_test.cpp $(SRV_FILES) $(INFANTRY_FILES) $(VEHICLE_FILES) $(WEAPON_FILES) $(UNIT_FILES) $(MAP_FILES)

test_centre: construction_centre_test.cpp ../src/Model/Entities/construction_centre.cpp $(BUILDING_FILES)
	g++ $(CFLAGS) -o centre.test construction_centre_test.cpp ../src/Model/Entities/construction_centre.cpp $(BUILDING_FILES)

clean:
	rm -f core *.o *.test