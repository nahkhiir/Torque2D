cmake_minimum_required(VERSION 3.18)

set(LIBVORBIS_SRC_DIR "${PROJECT_SOURCE_DIR}/engine/lib/libvorbis")

set(LIBVORBIS_SOURCE_FILES
        ${LIBVORBIS_SRC_DIR}/analysis.c
        ${LIBVORBIS_SRC_DIR}/barkmel.c
        ${LIBVORBIS_SRC_DIR}/bitrate.c
        ${LIBVORBIS_SRC_DIR}/block.c
        ${LIBVORBIS_SRC_DIR}/codebook.c
        ${LIBVORBIS_SRC_DIR}/envelope.c
        ${LIBVORBIS_SRC_DIR}/floor0.c
        ${LIBVORBIS_SRC_DIR}/floor1.c
        ${LIBVORBIS_SRC_DIR}/info.c
        ${LIBVORBIS_SRC_DIR}/lookup.c
        ${LIBVORBIS_SRC_DIR}/lpc.c
        ${LIBVORBIS_SRC_DIR}/lsp.c
        ${LIBVORBIS_SRC_DIR}/mapping0.c
        ${LIBVORBIS_SRC_DIR}/mdct.c
        ${LIBVORBIS_SRC_DIR}/psy.c
        ${LIBVORBIS_SRC_DIR}/registry.c
        ${LIBVORBIS_SRC_DIR}/res0.c
        ${LIBVORBIS_SRC_DIR}/sharedbook.c
        ${LIBVORBIS_SRC_DIR}/smallft.c
        ${LIBVORBIS_SRC_DIR}/synthesis.c
        ${LIBVORBIS_SRC_DIR}/tone.c
        ${LIBVORBIS_SRC_DIR}/vorbisenc.c
        ${LIBVORBIS_SRC_DIR}/vorbisfile.c
        ${LIBVORBIS_SRC_DIR}/window.c
)

add_library(libvorbis STATIC ${LIBVORBIS_SOURCE_FILES}
)

target_include_directories(libvorbis
    PUBLIC
        ${PROJECT_SOURCE_DIR}/engine/lib/libvorbis
        ${PROJECT_SOURCE_DIR}/engine/lib/libvorbis/lib
        ${PROJECT_SOURCE_DIR}/engine/lib/libvorbis/include
        ${PROJECT_SOURCE_DIR}/engine/lib/libogg/include
)