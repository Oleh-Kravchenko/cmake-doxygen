SUMMARY = "Easy Doxygen integration with CMake"
SECTION = "devel"
HOMEPAGE = "https://github.com/Oleh-Kravchenko/cmake-doxygen"
BUGTRACKER = "https://github.com/Oleh-Kravchenko/cmake-doxygen/issues"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=74d09aa8924451d2acd8715bdd5ce036"

PV = "git${SRCPV}"
SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/Oleh-Kravchenko/cmake-doxygen.git;protocol=https"
S = "${WORKDIR}/git"

inherit allarch cmake

PACKAGES = "${PN}-dev"
RDEPENDS_${PN}-dev = "${PN}-dev"

FILES_${PN}-dev += "${libdir}/cmake"
