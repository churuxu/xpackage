cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(XPACKAGE_NAME openssl)
set(XPACKAGE_VERSION 1.1.1c)
set(XPACKAGE_URL https://www.openssl.org/source/openssl-1.1.1c.tar.gz)
set(XPACKAGE_HASH SHA256=F6FB3079AD15076154EDA9413FED42877D668E7069D9B87396D0804FDB3F4C90)

set(XPACKAGE_SOURCE_DIR openssl-${XPACKAGE_VERSION})

list(APPEND EXLUDES ".*asm/.*")
list(APPEND EXLUDES ".*LPdir.*")
list(APPEND EXLUDES ".*ppccap.c")
list(APPEND EXLUDES ".*armcap.c")
list(APPEND EXLUDES ".*s390xcap.c")
list(APPEND EXLUDES ".*sparcv9cap.c")
list(APPEND EXLUDES ".*ecp_nistz256_table.c") 
list(APPEND EXLUDES ".*eng_devcrypto.c") 
list(APPEND EXLUDES ".*poly1305_base2_44.c") 
list(APPEND EXLUDES ".*poly1305_ieee754.c") 
list(APPEND EXLUDES ".*aes_x86core.c")
list(APPEND EXLUDES ".*apps/.*")
list(APPEND EXLUDES ".*demos/.*")
list(APPEND EXLUDES ".*engines/.*")
list(APPEND EXLUDES ".*external/.*")
list(APPEND EXLUDES ".*fuzz/.*")
list(APPEND EXLUDES ".*/ms/.*")
list(APPEND EXLUDES ".*test/.*")
list(APPEND EXLUDES ".*util/.*")

list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/include)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/crypto/include)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/crypto)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/crypto/modes)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/crypto/ec/curve448)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR}/crypto/ec/curve448/arch_32)
list(APPEND INCS ${XPACKAGE_SOURCE_DIR})


set(XPACKAGE_SOURCE_GLOB *.c)
set(XPACKAGE_SOURCE_EXCLUDES ${EXLUDES})
set(XPACKAGE_INCLUDES ${INCS})
set(XPACKAGE_FLAGS -DUNICODE -D_UNICODE -DWIN32_LEAN_AND_MEAN)
set(XPACKAGE_DEPENDS "")

set(XPACKAGE_EXPORT_INCLUDES ${XPACKAGE_SOURCE_DIR}/include)
set(XPACKAGE_EXPORT_FLAGS "")
if(${WIN32})
	set(XPACKAGE_EXPORT_LIBS ws2_32)
else()
	set(XPACKAGE_EXPORT_LIBS pthread)
endif()

xpackage_init()

