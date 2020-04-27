cmake_minimum_required(VERSION 3.10)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

set(USE_OPENSSL 1)

file(GLOB_RECURSE ALL_SRCS *.c *.cpp)
list(FILTER ALL_SRCS EXCLUDE REGEX "CMakeFiles")


add_executable(testmqtt ${ALL_SRCS})

include(xpackage.cmake)
xpackage_depends(testmqtt pahomqtt)

file(COPY CA.cer DESTINATION ${CMAKE_BINARY_DIR})

