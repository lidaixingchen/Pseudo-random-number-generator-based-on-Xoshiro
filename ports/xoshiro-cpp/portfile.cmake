vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lidaixingchen/Pseudo-random-number-generator-based-on-Xoshiro
    REF v${VERSION}
    SHA512 d211fa88e420dc086e8c5e19ccd59fc0d7ec264269da52bfd9383504f46b471b6eed26e66b5d436955b3189f97fb1e7fa27e60468cf8ec5b30db2b3d06f40fab
    HEAD_REF master
)

file(INSTALL "${SOURCE_PATH}/Random.hpp" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
file(INSTALL "${SOURCE_PATH}/XoshiroCpp.hpp" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
