cmake_minimum_required(VERSION 3.22)
project(Client)


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

add_executable(Client main.cpp Client.cpp firstwindow.cpp ui_firstwindow.h
        sockets.cpp SocketException.cpp loginscreen.cpp
        ui_loginscreen.h Button.cpp Button.h ConstructionMenu.cpp
        ConstructionMenu.h BuildingImageHandler.cpp BuildingImageHandler.h
        UnitImageHandler.cpp UnitImageHandler.h VehicleImageHandler.cpp VehicleImageHandler.h
        editormainwindow.h editormainwindow.cpp editormainwindow.ui UnitButton.cpp UnitButton.h)

find_package(yaml-cpp REQUIRED)
find_package(Qt5 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

find_package(SFML COMPONENTS system window graphics network audio)

find_package(Qt5Multimedia REQUIRED )
find_package(Qt5MultimediaWidgets REQUIRED)

target_link_libraries(Client yaml-cpp)
target_link_libraries(Client
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::Multimedia
        )

target_link_libraries(Client sfml-graphics sfml-window sfml-system sfml-audio)