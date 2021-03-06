#!/usr/bin/env bash

MASON_NAME=libzip
MASON_VERSION=1.0.1
MASON_LIB_FILE=lib/libzip.a
MASON_PKGCONFIG_FILE=lib/pkgconfig/libzip.pc

. ${MASON_DIR}/mason.sh

function mason_load_source {
    mason_download \
        https://www.nih.at/libzip/libzip-${MASON_VERSION}.tar.gz \
        b7761ee2ef581979df32f42637042f5663d766bf

    mason_extract_tar_gz

    export MASON_BUILD_PATH=${MASON_ROOT}/.build/libzip-${MASON_VERSION}
}

function mason_compile {
    ./configure \
        --prefix=${MASON_PREFIX} \
        ${MASON_HOST_ARG} \
        --enable-static \
        --disable-shared \
        --disable-dependency-tracking

    make install -j${MASON_CONCURRENCY}
}

function mason_strip_ldflags {
    shift # -L...
    shift # -lzip
    echo "$@"
}

function mason_ldflags {
    mason_strip_ldflags $(`mason_pkgconfig` --static --libs)
}

function mason_clean {
    make clean
}

mason_run "$@"
