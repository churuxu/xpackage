cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(XPACKAGE_NAME zlib)
set(XPACKAGE_VERSION 1.2.11)
set(XPACKAGE_URL https://github.com/madler/zlib/archive/v1.2.11.zip)
set(XPACKAGE_HASH SHA256=F5CC4AB910DB99B2BDBBA39EBBDC225FFC2AA04B4057BC2817F1B94B6978CFC3)

set(XPACKAGE_SOURCE_DIR zlib-${XPACKAGE_VERSION})
set(XPACKAGE_SOURCE_GLOB *.c)
set(XPACKAGE_SOURCE_EXCLUDES testzlib* infback9* inflate86* masmx* iostream* untgz* minizip.c miniunz.c .*examples/.* .*test/.* )
set(XPACKAGE_INCLUDES ${XPACKAGE_SOURCE_DIR})
set(XPACKAGE_FLAGS )
set(XPACKAGE_DEPENDS )

set(XPACKAGE_EXPORT_INCLUDES ${XPACKAGE_SOURCE_DIR} ${XPACKAGE_SOURCE_DIR}/contrib/minizip)
set(XPACKAGE_EXPORT_FLAGS )
set(XPACKAGE_EXPORT_LIBS )

xpackage_init()
