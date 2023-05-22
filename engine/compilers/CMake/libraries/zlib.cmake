cmake_minimum_required(VERSION 3.18)

set(ZLIB_SRC_DIR "${PROJECT_SOURCE_DIR}/engine/lib/zlib")

set(ZLIB_SOURCE_FILES
        ${ZLIB_SRC_DIR}/adler32.c
        ${ZLIB_SRC_DIR}/zutil.c
        ${ZLIB_SRC_DIR}/crc32.c
        ${ZLIB_SRC_DIR}/trees.c
        ${ZLIB_SRC_DIR}/inflate.c
        ${ZLIB_SRC_DIR}/inftrees.c
        ${ZLIB_SRC_DIR}/gzclose.c
        ${ZLIB_SRC_DIR}/gzread.c
        ${ZLIB_SRC_DIR}/infback.c
        ${ZLIB_SRC_DIR}/uncompr.c
        ${ZLIB_SRC_DIR}/deflate.c
        ${ZLIB_SRC_DIR}/inffast.c
        ${ZLIB_SRC_DIR}/gzwrite.c
        ${ZLIB_SRC_DIR}/compress.c
        ${ZLIB_SRC_DIR}/gzlib.c
)

add_library(zlib STATIC ${ZLIB_SOURCE_FILES}
)

target_include_directories(zlib
    PRIVATE
        ${PROJECT_SOURCE_DIR}/engine/lib/zlib
)