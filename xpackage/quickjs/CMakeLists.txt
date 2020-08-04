cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(XPACKAGE_NAME quickjs)
set(XPACKAGE_VERSION 20200705)
set(XPACKAGE_URL https://github.com/quickjs-zh/QuickJS/archive/v20200705.zip)
set(XPACKAGE_HASH SHA256=97cdfccdb86a8f9b53a5bf79883bf07b83016c8c03223b7dbc63a1632d37e397)

set(XPACKAGE_SOURCE_DIR QuickJS-${XPACKAGE_VERSION})
set(XPACKAGE_SOURCE_GLOB *.c)
set(XPACKAGE_SOURCE_EXCLUDES  .*tests/.*  .*examples/.*  jscompress.c qjs.c qjsc.c run-test262.c unicode_gen.c )
set(XPACKAGE_INCLUDES ${XPACKAGE_SOURCE_DIR})
set(XPACKAGE_FLAGS -DCONFIG_VERSION="${XPACKAGE_VERSION}")
set(XPACKAGE_DEPENDS )

set(XPACKAGE_EXPORT_INCLUDES ${XPACKAGE_SOURCE_DIR} )
set(XPACKAGE_EXPORT_FLAGS )
set(XPACKAGE_EXPORT_LIBS )

xpackage_init()
