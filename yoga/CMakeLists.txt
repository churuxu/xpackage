cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(PACKAGE_NAME yoga)

set(PACKAGE_VERSION 1.14.0)

set(PACKAGE_URL https://github.com/facebook/yoga/archive/${PACKAGE_VERSION}.tar.gz)

set(SRC_DIR ${PACKAGE_NAME}-${PACKAGE_VERSION})

set(FLAGS )

set(EXLUDES )


xpackage_init(${PACKAGE_NAME} ${PACKAGE_VERSION} ${PACKAGE_URL} "${FLAGS}" SRC_ROOT BUILD_ROOT)

set(SOURCE_DIR "${SRC_ROOT}/${SRC_DIR}/yoga")
set(EXPORT_INCS "${SOURCE_DIR}")

xpackage_glob_src(SRCS ${SOURCE_DIR}/*.cpp  EXLUDES)

xpackage_build_target(${PACKAGE_NAME} ${BUILD_ROOT} SRCS EXPORT_INCS "")



