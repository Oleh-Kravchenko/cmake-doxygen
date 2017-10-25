SUMMARY = "Easy Doxygen integration with CMake"
SECTION = "devel"
HOMEPAGE = "https://github.com/Oleh-Kravchenko/cmake-doxygen"
BUGTRACKER = "https://github.com/Oleh-Kravchenko/cmake-doxygen/issues"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3f90634a51613ff34bf96d82d76160f6"

SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/Oleh-Kravchenko/cmake-doxygen.git;protocol=https"
S = "${WORKDIR}/git"

inherit allarch cmake

PACKAGES = "${PN}-dev"
RDEPENDS_${PN}-dev = "${PN}-dev"

FILES_${PN}-dev += " ${libdir}/cmake"
