vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tensorflow/tensorflow
    REF v${VERSION}
    SHA512 c5e9a176027a00b5efb1343bee000330f56229a1a8559db2fb9e2c9388afaf8420d69b6fd6e7b85811272c110245315935232a859e9fd4106b29b226780c447e
    HEAD_REF master
    PATCHES
        0000-elementwise.patch
        0001-neon2sse.patch
        0003-remove-dtypes.patch
)

vcpkg_download_distfile(
    FARMHASH_ARCHIVE
    URLS https://github.com/google/farmhash/archive/0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz
    FILENAME farmhash-0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz
    SHA512 7bc14931e488464c1cedbc17551fb90a8cec494d0e0860db9df8efff09000fd8d91e01060dd5c5149b1104ac4ac8bf7eb57e5b156b05ef42636938edad1518f1
)

vcpkg_download_distfile(
    FFT2D_ARCHIVE
    URLS https://github.com/petewarden/OouraFFT/archive/c6fd2dd6d21397baa6653139d31d84540d5449a2.tar.gz
    FILENAME OouraFFT-c6fd2dd6d21397baa6653139d31d84540d5449a2.tar.gz
    SHA512 e6ee68df13f803707384856c5b02460826ba03710cde9c17e64469026993806305d89fff139e91d99fe655550ba7cc66d3d69e14a682bfd34951382f7a95ec92
)

vcpkg_extract_source_archive(
    FARMHASH_SOURCE_PATH
    ARCHIVE ${FARMHASH_ARCHIVE}
)

vcpkg_extract_source_archive(
    FFT2D_SOURCE_PATH
    ARCHIVE ${FFT2D_ARCHIVE}
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/tensorflow/lite"
    OPTIONS
        -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON

        -DSYSTEM_PTHREADPOOL=ON

        -DTFLITE_ENABLE_INSTALL=ON
        -DTFLITE_ENABLE_GPU=OFF
        -DTFLITE_ENABLE_NNAPI=OFF
        -DTFLITE_ENABLE_RESOURCE=ON
        -DTFLITE_ENABLE_RUY=ON
        -DTFLITE_ENABLE_XNNPACK=OFF

        -DOVERRIDABLE_FETCH_CONTENT_farmhash_GIT_REPOSITORY=
        -DOVERRIDABLE_FETCH_CONTENT_farmhash_URL=
        -Dfarmhash_SOURCE_DIR=${FARMHASH_SOURCE_PATH}
        -Dfarmhash_LICENSE_FILE=${FARMHASH_SOURCE_PATH}/COPYING
        -Dfarmhash_LICENSE_URL=
        -DFARMHASH_SOURCE_DIR=${FARMHASH_SOURCE_PATH}

        -DOVERRIDABLE_FETCH_CONTENT_fft2d_GIT_REPOSITORY=
        -DOVERRIDABLE_FETCH_CONTENT_fft2d_URL=
        -Dfft2d_SOURCE_DIR=${FFT2D_SOURCE_PATH}
        -Dfft2d_LICENSE_FILE=${FFT2D_SOURCE_PATH}/readme2d.txt
        -Dfft2d_LICENSE_URL=
        -DFFT2D_SOURCE_DIR=${FFT2D_SOURCE_PATH}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST ${SOURCE_PATH}/LICENSE)
