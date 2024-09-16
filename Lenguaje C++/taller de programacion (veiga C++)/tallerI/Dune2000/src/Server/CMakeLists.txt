cmake_minimum_required(VERSION 3.22)
project(Server)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -pthread")
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -pedantic -pedantic-errors")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")


set(COMMON_DIRPATH "../Common")
add_executable(Server main.cpp Server.cpp Server.h ${COMMON_DIRPATH}/SocketException.cpp ${COMMON_DIRPATH}/Sockets.cpp
        ${COMMON_DIRPATH}/SocketException.h ClientHandler.cpp ClientHandler.h Thread.cpp Thread.h GamesHandler.cpp GamesHandler.h Protocol.cpp Protocol.h
        MapLoader.cpp MapLoader.h)

find_package(yaml-cpp REQUIRED)
target_link_libraries(Server yaml-cpp)