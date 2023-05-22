cmake_minimum_required(VERSION 3.18)

set(LPNG_SRC_DIR "${PROJECT_SOURCE_DIR}/engine/lib/lpng")

set(LPNG_SOURCE_FILES
        ${LPNG_SRC_DIR}/pngerror.c
        ${LPNG_SRC_DIR}/pngwrite.c
        ${LPNG_SRC_DIR}/pngread.c
        ${LPNG_SRC_DIR}/pngmem.c
        ${LPNG_SRC_DIR}/pngset.c
        ${LPNG_SRC_DIR}/pngwio.c
        ${LPNG_SRC_DIR}/pngrtran.c
        ${LPNG_SRC_DIR}/pngtrans.c
        ${LPNG_SRC_DIR}/pngrutil.c
        ${LPNG_SRC_DIR}/pngwtran.c
        ${LPNG_SRC_DIR}/png.c
        ${LPNG_SRC_DIR}/pngrio.c
        ${LPNG_SRC_DIR}/pngwutil.c
        ${LPNG_SRC_DIR}/pngget.c
        ${LPNG_SRC_DIR}/pngpread.c
)


add_library(lpng STATIC ${LPNG_SOURCE_FILES}
)

target_include_directories(lpng
    PRIVATE
        ${PROJECT_SOURCE_DIR}/engine/lib/lpng
)