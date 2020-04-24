cmake_minimum_required(VERSION 3.10)

add_executable(example main.cpp)

include(xpackage.cmake)
xpackage_depends(example json-parser)

