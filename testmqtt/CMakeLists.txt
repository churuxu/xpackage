cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

set(USE_OPENSSL 1)

add_executable(testmqtt main.c)

include(xpackage.cmake)
xpackage_depends(testmqtt pahomqtt)

file(COPY CA.cer DESTINATION ${CMAKE_BINARY_DIR})

