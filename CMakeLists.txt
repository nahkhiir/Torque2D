cmake_minimum_required (VERSION 3.18)

if (NOT UNIX)
	message(FATAL_ERROR "Configuration applicable to LINUX builds only")
endif ()

set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

#Set the name of the main executable
set(TORQUE_APP_NAME "Torque2D")

if("${TORQUE_APP_NAME}" STREQUAL "")
	message(FATAL_ERROR "Please set TORQUE_APP_NAME first")
endif()

project("${TORQUE_APP_NAME}" LANGUAGES CXX)

#set C++ language standard with no compiler specific extensions
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#gcc specific
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
endif()

#standard build flags
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

#append to executable name when debug build
set(CMAKE_DEBUG_POSTFIX _DEBUG)

add_subdirectory(engine/compilers/CMake)
