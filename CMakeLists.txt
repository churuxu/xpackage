cmake_minimum_required(VERSION 3.10)

#for build all packages

file(GLOB_RECURSE SUB_CMAKES */CMakeLists.txt)

foreach(CMAKEFILE IN LISTS SUB_CMAKES)
	get_filename_component(DIR ${CMAKEFILE} DIRECTORY)	
	add_subdirectory(${DIR})	
endforeach()
