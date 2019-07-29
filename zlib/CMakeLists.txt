cmake_minimum_required(VERSION 3.10)

### cmake template for build package with remote source ### 

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)

set(A a b)


macro(showlist l)
	foreach(v IN LISTS ${l})
		message(${v})
	endforeach()
endmacro()

showlist(${A})


set(PACKAGE_NAME zlib)

set(PACKAGE_VERSION 1.2.11)

set(PACKAGE_URL https://downloads.sourceforge.net/project/libpng/zlib/${PACKAGE_VERSION}/zlib-${PACKAGE_VERSION}.tar.gz)

set(SRC_DIR zlib-${PACKAGE_VERSION})

set(FLAGS )

set(EXLUDES ".*contrib/.*" ".*examples/.*" ".*test/.*")


#include_directories(...)

xpackage_init(${PACKAGE_NAME} ${PACKAGE_VERSION} ${PACKAGE_URL} SRC_ROOT BUILD_ROOT)

set(EXPORT_INCS "${SRC_ROOT}/${SRC_DIR}")

xpackage_glob_src(SRCS ${SRC_ROOT}/${SRC_DIR}/*.c  EXLUDES)

xpackage_build_target(z ${BUILD_ROOT} "${SRCS}" EXPORT_INCS)



