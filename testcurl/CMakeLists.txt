cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

set(USE_OPENSSL 1)

add_executable(testcurl main.c)

include(xpackage/xpackage.cmake)
xpackage_depends(testcurl curl)

file(COPY CA.cer DESTINATION ${CMAKE_BINARY_DIR})

