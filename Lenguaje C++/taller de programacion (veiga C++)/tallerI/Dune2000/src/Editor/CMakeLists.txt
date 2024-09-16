cmake_minimum_required(VERSION 3.16)
project(Editor)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -pedantic -pedantic-errors")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")

find_package(SFML COMPONENTS system window graphics network audio)
add_executable(Editor main.cpp Button.cpp textBox.cpp textBox.h EditorMenu.cpp EditorMenu.h camera.cpp ground.cpp Editor.cpp Editor.h StateSaver.cpp StateSaver.h
        editormainwindow.cpp ui_editormainwindow.h editormainwindow.h MapLoader.cpp MapLoader.h ConstructionCenter.cpp ConstructionCenter.h ConstantGetter.cpp ConstantGetter.h EditorException.h)

find_package(yaml-cpp REQUIRED)
find_package(Qt5 COMPONENTS
        Core
        Gui
        Widgets
        REQUIRED)

find_package(SFML COMPONENTS system window graphics network audio)

find_package(Qt5Multimedia REQUIRED )
find_package(Qt5MultimediaWidgets REQUIRED)

target_link_libraries(Editor yaml-cpp)
target_link_libraries(Editor
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::Multimedia
        )

target_link_libraries(Editor sfml-graphics sfml-window sfml-system sfml-audio)