# Overview

Easy Doxygen integration with CMake.

Additionally this script make available next macros:

* @date - build date %Y.%m.%d
* @time - build time %H:%M:%S
* @now - build date and time %Y.%m.%d %H:%M:%S
* @startuml,@enduml - see [PlantUML](http://plantuml.com)

# Continuous Integration

- Travis CI [![build status](https://travis-ci.org/Oleh-Kravchenko/cmake-doxygen.svg)](https://travis-ci.org/Oleh-Kravchenko/cmake-doxygen)
- Coverage [![Coverage Status](https://coveralls.io/repos/github/Oleh-Kravchenko/cmake-doxygen/badge.svg?branch=master)](https://coveralls.io/github/Oleh-Kravchenko/cmake-doxygen?branch=master)

# Syntax

	FIND_PACKAGE(cmake-doxygen REQUIRED [COMPONENTS plantuml])

	DOXYGEN(TARGET name
	DOT_FONTSIZE integer
	DOT_IMAGE_FORMAT svg|png
	TAB_SIZE integer
	OUTPUT_DIRECTORY path
	USE_MDFILE_AS_MAINPAGE filename
	EXCLUDE_SYMBOLS
		symbols
	NO
		options
	PREDEFINED
		options
	SOURCES
		sources
	YES
		options)

# Example

	FIND_PACKAGE(cmake-doxygen REQUIRED COMPONENTS plantuml)

	DOXYGEN(TARGET "doc"
	OUTPUT_DIRECTORY
		"${CMAKE_CURRENT_BINARY_DIR}/doc"
	SOURCES
		include/config.h
		include/version.h
		source/config.c
		source/version.cpp
	NO
		GENERATE_LATEX
		VERBATIM_HEADERS
	YES
		CALL_GRAPH
		EXTRACT_ALL
		EXTRACT_STATIC
		GENERATE_TREEVIEW
		HAVE_DOT
		INTERACTIVE_SVG
		JAVADOC_AUTOBRIEF
		OPTIMIZE_OUTPUT_FOR_C
		QUIET
		RECURSIVE
		WARN_AS_ERROR
		WARN_NO_PARAMDOC
	PREDEFINED
		__DOXYGEN
	EXCLUDE_SYMBOLS
		__stringify_1
	TAB_SIZE 8
	DOT_FONTSIZE 12
	DOT_IMAGE_FORMAT svg
	USE_MDFILE_AS_MAINPAGE "README.md")

# Installation

## Gentoo Linux

	$ layman -S
	$ layman -a kaa
	$ emerge dev-util/cmake-doxygen -a

## Use as git submodule

Add submodule

	git submodule add https://github.com/Oleh-Kravchenko/cmake-doxygen.git 3rdparty/cmake-doxygen

Add into your CMakeLists.txt file

	INCLUDE(3rdparty/cmake-doxygen/cmake/cmake-doxygen.cmake)

	DOXYGEN(TARGET "doc"
	OUTPUT_DIRECTORY
		"${CMAKE_CURRENT_BINARY_DIR}/doc"
	SOURCES
		include/config.h
		include/version.h
		source/config.c
		source/version.cpp
	NO
		GENERATE_LATEX
		VERBATIM_HEADERS
	YES
		CALL_GRAPH
		EXTRACT_ALL
		EXTRACT_STATIC
		GENERATE_TREEVIEW
		HAVE_DOT
		INTERACTIVE_SVG
		JAVADOC_AUTOBRIEF
		OPTIMIZE_OUTPUT_FOR_C
		QUIET
		RECURSIVE
		WARN_AS_ERROR
		WARN_NO_PARAMDOC
	PREDEFINED
		__DOXYGEN
	EXCLUDE_SYMBOLS
		__stringify_1
	TAB_SIZE 8
	DOT_FONTSIZE 12
	DOT_IMAGE_FORMAT svg
	USE_MDFILE_AS_MAINPAGE "README.md")

## Install from sources

	$ git clone https://github.com/Oleh-Kravchenko/cmake-doxygen.git
	$ cd cmake-doxygen
	$ mkdir build
	$ cd build
	$ cmake -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local ..
	$ sudo make install

## Yocto

Please use recipe contrib/yocto/cmake-doxygen_git.bb
