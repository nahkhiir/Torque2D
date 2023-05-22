cmake_minimum_required(VERSION 3.18)

set(LJPEG_SRC_DIR "${PROJECT_SOURCE_DIR}/engine/lib/ljpeg")

set(LJPEG_SOURCE_FILES
        ${LJPEG_SRC_DIR}/jidctint.c
        ${LJPEG_SRC_DIR}/jcmainct.c
        ${LJPEG_SRC_DIR}/jfdctfst.c
        ${LJPEG_SRC_DIR}/jdatadst.c
        ${LJPEG_SRC_DIR}/jdsample.c
        ${LJPEG_SRC_DIR}/jmemmgr.c
        ${LJPEG_SRC_DIR}/jidctred.c
        ${LJPEG_SRC_DIR}/jcphuff.c
        ${LJPEG_SRC_DIR}/jchuff.c
        ${LJPEG_SRC_DIR}/jdapistd.c
        ${LJPEG_SRC_DIR}/jdpostct.c
        ${LJPEG_SRC_DIR}/jquant2.c
        ${LJPEG_SRC_DIR}/jdmerge.c
        ${LJPEG_SRC_DIR}/jfdctflt.c
        ${LJPEG_SRC_DIR}/jcprepct.c
        ${LJPEG_SRC_DIR}/jccolor.c
        ${LJPEG_SRC_DIR}/jfdctint.c
        ${LJPEG_SRC_DIR}/jdhuff.c
        ${LJPEG_SRC_DIR}/jcomapi.c
        ${LJPEG_SRC_DIR}/jcinit.c
        ${LJPEG_SRC_DIR}/jccoefct.c
        ${LJPEG_SRC_DIR}/jdinput.c
        ${LJPEG_SRC_DIR}/jutils.c
        ${LJPEG_SRC_DIR}/jcapimin.c
        ${LJPEG_SRC_DIR}/jdcoefct.c
        ${LJPEG_SRC_DIR}/jidctflt.c
        ${LJPEG_SRC_DIR}/jcmaster.c
        ${LJPEG_SRC_DIR}/jddctmgr.c
        ${LJPEG_SRC_DIR}/jidctfst.c
        ${LJPEG_SRC_DIR}/jcparam.c
        ${LJPEG_SRC_DIR}/jcapistd.c
        ${LJPEG_SRC_DIR}/jdmaster.c
        ${LJPEG_SRC_DIR}/jcdctmgr.c
        ${LJPEG_SRC_DIR}/jctrans.c
        ${LJPEG_SRC_DIR}/jdmainct.c
        ${LJPEG_SRC_DIR}/jdtrans.c
        ${LJPEG_SRC_DIR}/jcsample.c
        ${LJPEG_SRC_DIR}/jdmarker.c
        ${LJPEG_SRC_DIR}/jdatasrc.c
        ${LJPEG_SRC_DIR}/jerror.c
        ${LJPEG_SRC_DIR}/jquant1.c
        ${LJPEG_SRC_DIR}/jdphuff.c
        ${LJPEG_SRC_DIR}/jcmarker.c
        ${LJPEG_SRC_DIR}/jdapimin.c
        ${LJPEG_SRC_DIR}/jdcolor.c
        ${LJPEG_SRC_DIR}/jmemnobs.c
)

add_library(ljpeg STATIC ${LJPEG_SOURCE_FILES}
)

target_include_directories(ljpeg
    PRIVATE
        ${PROJECT_SOURCE_DIR}/engine/lib/ljpeg
)