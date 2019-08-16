cmake_minimum_required(VERSION 3.10)

include(${CMAKE_CURRENT_LIST_DIR}/../xpackage.cmake)


set(PACKAGE_NAME stm32f1)

set(PACKAGE_VERSION 170)

set(SRC_DIR STM32Cube_FW_F1_V1.7.0)

set(PACKAGE_URL http://sw-center.st.com/packs/resource/firmware/stm32cube_fw_f1_v${PACKAGE_VERSION}.zip)

set(FLAGS "-DUSE_HAL_DRIVER -DSTM32F103xE -mcpu=cortex-m3")

set(EXCLUDES ".*_ll_.*" ".*Legacy/.*")



xpackage_init(${PACKAGE_NAME} ${PACKAGE_VERSION} ${PACKAGE_URL} "${FLAGS}" SRC_ROOT BUILD_ROOT)

set(HAL_DRIVER_DIR ${SRC_ROOT}/${SRC_DIR}/Drivers/STM32F1xx_HAL_Driver)
set(CMSIS_DIR ${SRC_ROOT}/${SRC_DIR}/Drivers/CMSIS)
set(CMSIS_ST_DIR ${SRC_ROOT}/${SRC_DIR}/Drivers/CMSIS/Device/ST/STM32F1xx)

if(NOT EXISTS ${HAL_DRIVER_DIR}/Inc/stm32f1xx_hal_conf.h)
	configure_file(${HAL_DRIVER_DIR}/Inc/stm32f1xx_hal_conf_template.h ${HAL_DRIVER_DIR}/Inc/stm32f1xx_hal_conf.h COPYONLY)
endif()

set(EXPORT_INCS ${HAL_DRIVER_DIR}/Inc ${CMSIS_ST_DIR}/Include ${CMSIS_DIR}/Include)

include_directories(${EXPORT_INCS})


xpackage_glob_src(SRCS ${HAL_DRIVER_DIR}/Src/*.c  EXCLUDES)

xpackage_build_target(${PACKAGE_NAME} ${BUILD_ROOT} SRCS EXPORT_INCS "")



