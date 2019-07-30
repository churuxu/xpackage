cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(PACKAGE_NAME sqlite)

set(PACKAGE_VERSION 3290000)

set(PACKAGE_URL https://www.sqlite.org/2019/sqlite-amalgamation-${PACKAGE_VERSION}.zip)

set(SRC_DIR sqlite-amalgamation-${PACKAGE_VERSION})

set(FLAGS "-DSQLITE_TEMP_STORE=3")

set(EXLUDES ".*shell.c")



xpackage_init(${PACKAGE_NAME} ${PACKAGE_VERSION} ${PACKAGE_URL} "${FLAGS}" SRC_ROOT BUILD_ROOT)

set(EXPORT_INCS "${SRC_ROOT}/${SRC_DIR}")

xpackage_glob_src(SRCS ${SRC_ROOT}/${SRC_DIR}/*.c  EXLUDES)

xpackage_build_target(${PACKAGE_NAME} ${BUILD_ROOT} SRCS EXPORT_INCS "")



