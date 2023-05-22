cmake_minimum_required(VERSION 3.18)

#debug pre-processor definitions
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG -DTORQUE_DEBUG")

#libraries to build
include(libraries/libogg.cmake)
include(libraries/libvorbis.cmake)
include(libraries/ljpeg.cmake)
include(libraries/lpng.cmake)
include(libraries/zlib.cmake)

#macros
include(macros.cmake)

set(libDir        "${CMAKE_SOURCE_DIR}/engine/lib")
set(srcDir        "${CMAKE_SOURCE_DIR}/engine/source")
set(cmakeDir      "${CMAKE_SOURCE_DIR}/engine/compilers/CMake")

# the main engine
include(torque2d.cmake)
add_executable(${CMAKE_PROJECT_NAME} ${T2D_SOURCE_FILES})

set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

#built executable goes in project root folder
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}")

#additional pre-processor definitions
_process_defs()
set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY COMPILE_DEFINITIONS)

#include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${T2D_INCLUDE_PATHS})

#linkage - vorbis before ogg or you get strange link errors
target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC libvorbis libogg ljpeg lpng zlib openal dl Xext X11 Xft stdc++ pthread GL SDL rt m)

#put completed executable in project root folder
install(TARGETS ${CMAKE_PROJECT_NAME})