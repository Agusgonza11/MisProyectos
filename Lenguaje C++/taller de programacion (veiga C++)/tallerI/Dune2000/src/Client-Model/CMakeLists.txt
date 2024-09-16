cmake_minimum_required(VERSION 3.16)
project(Client_Model)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -pthread")
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -pedantic -pedantic-errors")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")


find_package(SFML COMPONENTS system window graphics network audio)



file(GLOB all_SRCS
        "${PROJECT_SOURCE_DIR}/*.h"
        "${PROJECT_SOURCE_DIR}/*.cpp"
        )
file(GLOB server_SRCS
        "${PROJECT_SOURCE_DIR}/../Server/mock_server.cpp"
        "${PROJECT_SOURCE_DIR}/../Server/configuration_loader.cpp"
        "${PROJECT_SOURCE_DIR}/../Server/control_unit.cpp"
        "${PROJECT_SOURCE_DIR}/../Server/entity_factory.cpp"
        "${PROJECT_SOURCE_DIR}/../Server/mock_server.h"
        "${PROJECT_SOURCE_DIR}/../Server/configuration_loader.h"
        "${PROJECT_SOURCE_DIR}/../Server/control_unit.h"
        "${PROJECT_SOURCE_DIR}/../Server/entity_factory.h"
        )

file(GLOB Model_SRCS
        "${PROJECT_SOURCE_DIR}/../Model/Entities/*.h"
        "${PROJECT_SOURCE_DIR}/../Model/Entities/*.cpp"
        "${PROJECT_SOURCE_DIR}/../Model/Map/*.h"
        "${PROJECT_SOURCE_DIR}/../Model/Map/*.cpp"
        "${PROJECT_SOURCE_DIR}/../Model/Mobility/*.h"
        "${PROJECT_SOURCE_DIR}/../Model/Mobility/*.cpp"
        "${PROJECT_SOURCE_DIR}/../Model/Weapons/*.h"
        "${PROJECT_SOURCE_DIR}/../Model/Weapons/*.cpp"
        )

file(GLOB Common_SRCS
        "${PROJECT_SOURCE_DIR}/../Common/*cpp"
        "${PROJECT_SOURCE_DIR}/../Common/*h"
        )


add_executable(Client_Model
        ${all_SRCS}
        ${server_SRCS}
        ${Model_SRCS}
        ${Common_SRCS}
        )

find_package(yaml-cpp REQUIRED)
find_package(Qt5 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

find_package(SFML COMPONENTS system window graphics network audio)



target_link_libraries(Client_Model yaml-cpp)
target_link_libraries(Client_Model
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        )

target_link_libraries(Client_Model sfml-graphics sfml-window sfml-system sfml-audio)