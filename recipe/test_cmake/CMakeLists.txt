cmake_minimum_required(VERSION 3.16)
project(geant4-conda-test LANGUAGES CXX)

# Exercises the exported Geant4Config.cmake, which unconditionally resolves
# CLHEP (with an EXACT version match), OpenGL, X11 and -- when built with the
# qt variant -- Qt6.
find_package(Geant4 REQUIRED)

add_executable(geant4-conda-test main.cc)
target_link_libraries(geant4-conda-test PRIVATE ${Geant4_LIBRARIES})
target_include_directories(geant4-conda-test PRIVATE ${Geant4_INCLUDE_DIRS})
