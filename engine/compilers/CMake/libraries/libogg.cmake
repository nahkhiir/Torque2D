cmake_minimum_required(VERSION 3.18)

set(LOGG_SRC_DIR "${PROJECT_SOURCE_DIR}/engine/lib/libogg/src")

set(LOGG_SOURCE_FILES
        ${LOGG_SRC_DIR}/bitwise.c
        ${LOGG_SRC_DIR}/framing.c
)

add_library(libogg STATIC ${LOGG_SOURCE_FILES}
)

target_include_directories(libogg
    PUBLIC
        ${PROJECT_SOURCE_DIR}/engine/lib/libogg/include
)