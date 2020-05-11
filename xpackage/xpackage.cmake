
#初始化XPACKAGE自身变量
#XPACKAGE_ROOT_DIR xpackage.cmake文件所在目录
#XPACKAGE_CACHE_DIR 包缓存目录

set(XPACKAGE_ROOT_DIR ${CMAKE_CURRENT_LIST_DIR})

if(${CMAKE_HOST_WIN32})				
	set(XPACKAGE_CACHE_W $ENV{USERPROFILE}/.xpackage)
	file(TO_CMAKE_PATH "${XPACKAGE_CACHE_W}" XPACKAGE_CACHE_DIR)
else()
	set(XPACKAGE_CACHE_DIR $ENV{HOME}/.xpackage) 
endif()
	



#引用包 (编译目标 包名)
macro(xpackage_depends target package)	
	if(NOT TARGET ${package})
		add_subdirectory(${XPACKAGE_ROOT_DIR}/${package} ${CMAKE_BINARY_DIR}/${target}_deps/${package})		
	endif()	
	get_target_property(imp_ ${target} IMPORTED) 
	add_dependencies(${target} ${package})
	include(${CMAKE_BINARY_DIR}/xpackage_${package}.cmake)	
	if(NOT ${imp_})
		target_link_libraries(${target} ${package})
		if(NOT "${XPACKAGE_SUB_DEPENDS}" STREQUAL "")
			target_link_libraries(${target} ${XPACKAGE_SUB_DEPENDS})
		endif()
		if(NOT "${XPACKAGE_LIBS}" STREQUAL "")
			target_link_libraries(${target} ${XPACKAGE_LIBS})
		endif()
		if(NOT "${XPACKAGE_FLAGS}" STREQUAL "")
			target_compile_options(${target} PUBLIC ${XPACKAGE_FLAGS})
		endif()		
	endif()
endmacro()



#计算编译输出hash值（输出变量）
macro(xpackage_calc_build_hash outvar)
	set(hash_str_ "")
	#追加编译信息
	xpackage_get_build_info(build_info_)
	string(MD5 info_hash_ "${build_info_}")	
	set(hash_str_ ${hash_str_} ${info_hash_})
	
	#追加当前CMakeLists.txt文件Hash
	set(cur_cmake_ ${CMAKE_PARENT_LIST_FILE})
	#file(MD5 ${cur_cmake_} file_hash_ )
	#set(hash_str_ ${hash_str_} ${file_hash_})
	
	#追加当前配置目录的多个文件Hash
	get_filename_component(dir_ ${cur_cmake_} DIRECTORY)
	file(GLOB_RECURSE files_ ${dir_}/config/*.*)
	foreach(f_ IN LISTS files_)
		#message(fff ${f_})
		file(MD5 ${f_} file_hash_)
		set(hash_str_ ${hash_str_} ${file_hash_})		
	endforeach()	
	#计算输出最终Hash
	string(MD5 f_hash_ "${hash_str_}")	
	set(${outvar} ${f_hash_})
endmacro()



#获取镜像站点地址 (输入单个地址，得到多个镜像站点地址)
macro(xpackage_get_mirror_urls url outurls)
	#github地址
	string(FIND ${url} "https://github.com/" index_)
	if("${index_}" STREQUAL "0")
		string(REPLACE "https://github.com/" "http://github.strcpy.cn/" newurl_ ${url})
		list(APPEND ${outurls} ${newurl_}) 
	endif()
	
	list(APPEND ${outurls} ${url}) 
endmacro()

#下载文件 (下载地址 保存文件名 文件HASH值)
macro(xpackage_download url localfile hashtype)
	set(status_file_ "${localfile}.d")
	if(NOT EXISTS ${status_file_})
		message("-- Download ${url} to ${localfile}")
		#获取多个镜像地址，依次尝试
		xpackage_get_mirror_urls(${url} urls)
		set(result_ -1)
		set(verify_ )
		if(NOT "${hashtype}" STREQUAL "")
			set(verify_ EXPECTED_HASH ${hashtype})		
		endif()
		foreach(murl IN ITEMS ${urls})
			file(DOWNLOAD ${murl} ${localfile} STATUS result_ ${verify_})
			if(0 IN_LIST result_)
				file(WRITE ${status_file_} 1)
				message("-- Download OK")
				break()
			endif()		
		endforeach()
		if(NOT 0 IN_LIST result_)
			message(FATAL_ERROR "Download Error: ${result_}")
		endif()
	endif()
endmacro()


#解压缩 (文件名 目录)
macro(xpackage_extract localfile dir)
	set(status_file_ "${localfile}.u")
	if(NOT EXISTS ${status_file_})
		message("-- Extract ${localfile}")
		file(MAKE_DIRECTORY ${dir})
		if(${localfile} MATCHES ".*.zip$")
			set(cmd_ unzip -q -o ${localfile} -d ${dir})
		elseif(${localfile} MATCHES ".*.tar.gz$")
			set(cmd_ tar -zxvf ${localfile} -C ${dir})
		elseif(${localfile} MATCHES ".*.tar.xz$")
			set(cmd_ tar -Jxvf ${localfile} -C ${dir})
		else()
			message(FATAL_ERROR "Not support file type")
		endif()		
		execute_process(RESULT_VARIABLE result_ COMMAND ${cmd_})
		if(0 EQUAL result_)
			file(WRITE ${status_file_} 1)
			message("-- Extract OK")
		else()		
			message(FATAL_ERROR "Extract Error")
		endif()		
	endif()
endmacro()

#获取CPU架构（输出变量）
macro(xpackage_get_arch outvar)
	if(DEFINED ARCH)
		set(${outvar} ${ARCH})
	else()
		if(${CMAKE_CROSSCOMPILING})
			if(NOT DEFINED ARCH)
				message(FATAL_ERROR "must define ARCH variable")		
			endif()
		else()
			if("${CMAKE_C_SIZEOF_DATA_PTR}" STREQUAL "4")
				set(${outvar} x86)
			else()
				set(${outvar} x86_64)
			endif()		
		endif()	
	endif()
endmacro()


#获取编译参数信息（输出变量）
macro(xpackage_get_build_info outvar)
	set(info_ "")
	set(info_ "${info_}os=${CMAKE_SYSTEM_NAME}\n")
	set(info_ "${info_}cc=${CMAKE_C_COMPILER}\n")
	set(info_ "${info_}cc.version=${CMAKE_C_COMPILER_VERSION}\n")
	set(info_ "${info_}cxx=${CMAKE_CXX_COMPILER}\n")
	set(info_ "${info_}cxx.version=${CMAKE_CXX_COMPILER_VERSION}\n")
	
	set(info_ "${info_}source=${XPACKAGE_SOURCE_DIR}\n")
	set(info_ "${info_}glob=${XPACKAGE_SOURCE_GLOB}\n")
	set(info_ "${info_}exludes=${XPACKAGE_SOURCE_EXCLUDES}\n")
	set(info_ "${info_}includes=${XPACKAGE_INCLUDES}\n")
	set(info_ "${info_}flags=${XPACKAGE_FLAGS}\n")
	set(info_ "${info_}depends=${XPACKAGE_DEPENDS}\n")
	
	if(NOT ${CMAKE_C_COMPILER_ID} STREQUAL MSVC)
		if("${CMAKE_BUILD_TYPE}" STREQUAL "")
			set(CMAKE_BUILD_TYPE Release)
		endif()
		set(info_ "${info_}build_type=${CMAKE_BUILD_TYPE}\n")
	endif()	
	if(DEFINED ARCH)
		set(info_ "${info_}arch=${ARCH}\n")
	endif()	
	set(${outvar} "${info_}")
endmacro()


#导出包含文件 (包含目录 编译选项 链接库)
#导出文件到当前编译输出目录，文件名为xpackage_${PACKAGE_NAME}.cmake 
macro(xpackage_export )	
	set(export_info_ "")	
	set(export_info_ "${export_info_}link_directories(${XPACKAGE_BUILD_DIR})\n")
	set(export_info_ "${export_info_}include_directories(${XPACKAGE_BUILD_DIR})\n")
	if(DEFINED XPACKAGE_EXPORT_INCLUDES)
		foreach(dir_ IN ITEMS ${XPACKAGE_EXPORT_INCLUDES})			
			set(export_info_ "${export_info_}include_directories(${XPACKAGE_SOURCE_BASE}/${dir_})\n")
		endforeach()
	endif()
	if(DEFINED XPACKAGE_EXPORT_FLAGS)
		set(export_info_ "${export_info_}set(XPACKAGE_FLAGS ${XPACKAGE_EXPORT_FLAGS})\n")	
	endif()
	if(DEFINED XPACKAGE_EXPORT_LIBS)
		set(export_info_ "${export_info_}set(XPACKAGE_LIBS ${XPACKAGE_EXPORT_LIBS})\n")	
	endif()
	if(DEFINED XPACKAGE_DEPENDS)
		if(NOT "${XPACKAGE_DEPENDS}" STREQUAL "")
			set(export_info_ "${export_info_}set(XPACKAGE_SUB_DEPENDS ${XPACKAGE_DEPENDS})\n")	
		endif()
	endif()	
	#set(export_info_ "${export_info_}set(XPACKAGE_LIBS ${XPACKAGE_EXPORT_LIBS})\n")
	set(export_file_ ${CMAKE_BINARY_DIR}/xpackage_${XPACKAGE_NAME}.cmake)
	if(EXISTS ${export_file_})
		file(READ ${export_file_} old_info_)
	endif()
	if(NOT "${old_info_}" STREQUAL "${export_info_}")
		file(WRITE ${export_file_} "${export_info_}")
	endif()
endmacro()




#使用给定的变量初始化包
macro(xpackage_init)
	message("-- Package: ${XPACKAGE_NAME} ${XPACKAGE_VERSION}")
	#按URL获取保存文件名
	if(${XPACKAGE_URL} MATCHES ".*.zip$")
		set(save_name_ "source.zip")
	elseif(${XPACKAGE_URL} MATCHES ".*.tar.gz$")
		set(save_name_ "source.tar.gz")
	elseif(${XPACKAGE_URL} MATCHES ".*.tar.xz$")
		set(save_name_ "source.tar.xz")
	else()
		message(FATAL_ERROR "Not support file type of ${url}")
	endif()	
	#下载文件
	set(local_file_ ${XPACKAGE_CACHE_DIR}/${XPACKAGE_NAME}/${XPACKAGE_VERSION}/${save_name_})
	xpackage_download(${XPACKAGE_URL} ${local_file_} ${XPACKAGE_HASH})
	#解压文件
	set(XPACKAGE_SOURCE_BASE ${XPACKAGE_CACHE_DIR}/${XPACKAGE_NAME}/${XPACKAGE_VERSION}/source)
	xpackage_extract(${local_file_} ${XPACKAGE_SOURCE_BASE})
		
	#获取编译Hash
	xpackage_calc_build_hash(build_hash_)
	
	#创建build输出目录
	set(XPACKAGE_BUILD_DIR ${XPACKAGE_CACHE_DIR}/${XPACKAGE_NAME}/${XPACKAGE_VERSION}/build/${build_hash_})
	file(MAKE_DIRECTORY ${XPACKAGE_BUILD_DIR})
	
	#编译信息写入build目录
	xpackage_get_build_info(build_info_)
	file(WRITE ${XPACKAGE_BUILD_DIR}/build_info.txt "${build_info_}")
	
	#配置文件拷贝到build目录
	set(cur_cmake_ ${CMAKE_PARENT_LIST_FILE})
	get_filename_component(dir_ ${cur_cmake_} DIRECTORY)
	if(EXISTS ${dir_}/config)
		file(COPY ${dir_}/config/ DESTINATION ${XPACKAGE_BUILD_DIR})
	endif()
		
	#获取源码
	set(globexp_ ${XPACKAGE_SOURCE_BASE}/${XPACKAGE_SOURCE_DIR}/${XPACKAGE_SOURCE_GLOB})	
	file(GLOB_RECURSE srcs_ ${globexp_})
	
	list(FILTER srcs_ EXCLUDE REGEX "CMakeFiles")
	foreach(exl IN ITEMS ${XPACKAGE_SOURCE_EXCLUDES}) 		
		list(FILTER srcs_ EXCLUDE REGEX ${exl})
	endforeach()	
	
	#设置编译选项
	include_directories(${XPACKAGE_BUILD_DIR})
	foreach(dir_ IN ITEMS ${XPACKAGE_INCLUDES})
		include_directories(${XPACKAGE_SOURCE_BASE}/${dir_})
	endforeach()
	add_compile_options(${XPACKAGE_FLAGS})
	
	#设置目标
	set(target_file_ ${XPACKAGE_BUILD_DIR}/lib${XPACKAGE_NAME}.a)
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${XPACKAGE_BUILD_DIR})
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${XPACKAGE_BUILD_DIR})
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${XPACKAGE_BUILD_DIR})	
	
	#编译或导入目标
	if(NOT TARGET ${XPACKAGE_NAME})
		if(EXISTS ${target_file_})
			message("-- Import ${target_file_}")
			add_library(${XPACKAGE_NAME} STATIC IMPORTED GLOBAL)
			set_target_properties(${XPACKAGE_NAME} PROPERTIES IMPORTED_LOCATION ${target_file_})
		else()
			message("-- Build ${target_file_}")			
			add_library(${XPACKAGE_NAME} ${srcs_})
		endif()		
	endif()

	#引入依赖包
	foreach(dep_ IN ITEMS ${XPACKAGE_DEPENDS}) 		
		xpackage_depends(${XPACKAGE_NAME} ${dep_})
	endforeach()	
	
	#导出编译选项
	xpackage_export()
endmacro()






