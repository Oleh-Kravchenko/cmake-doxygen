IF(NOT Doxygen_FOUND)
	FIND_PACKAGE(Doxygen REQUIRED)
ENDIF()

FIND_PATH(PLANTUML_PATH "plantuml.jar"
PATHS
	"/usr"
	"/usr/local"
	"/usr/share"
PATH_SUFFIXES
	"bin"
	"lib"
	"share"
	"java"
	"plantuml"
DOC
	"PlantUML path (plantuml.jar)")

FUNCTION(DOXYGEN)
	# single value options
	SET(VAL_LIST
		IMAGE_PATH
		DOT_FONTSIZE
		DOT_IMAGE_FORMAT
		OUTPUT_DIRECTORY
		TAB_SIZE
		USE_MDFILE_AS_MAINPAGE
	)

	# multiple value options
	SET(VALS_LIST
		EXCLUDE_SYMBOLS
		PREDEFINED
	)

	# special options (processing this separately)
	SET(SPEC_LIST
		EXCLUDE_DIRS
		NO
		SOURCES
		TARGET
		YES
	)

	CMAKE_PARSE_ARGUMENTS(DOXY		# prefix
		""				# options
		"${VAL_LIST}"			# single value options
		"${SPEC_LIST};${VALS_LIST}"	# multiple value options
		${ARGN})

	# verify required arguments
	IF(NOT DEFINED DOXY_TARGET)
		MESSAGE(FATAL_ERROR "Please specify TARGET!")
	ENDIF()

	IF(NOT DEFINED DOXY_SOURCES)
		MESSAGE(FATAL_ERROR "Please specify SOURCES!")
	ENDIF()

	IF(NOT DEFINED DOXY_OUTPUT_DIRECTORY)
		MESSAGE(FATAL_ERROR "Please specify OUTPUT_DIRECTORY!")
	ENDIF()

	# fix sources, if mainpage in markdown
	IF(DEFINED DOXY_USE_MDFILE_AS_MAINPAGE)
		LIST(APPEND DOXY_SOURCES "${DOXY_USE_MDFILE_AS_MAINPAGE}")
	ENDIF()

	# common Doxygen settings
	SET(DOXYFILE "${DOXY_OUTPUT_DIRECTORY}.Doxyfile")
	FILE(WRITE "${DOXYFILE}" "PROJECT_NAME = ${PROJECT_NAME}\n")
	FILE(APPEND "${DOXYFILE}"
		"STRIP_FROM_INC_PATH = ${CMAKE_CURRENT_SOURCE_DIR}\n")
	FILE(APPEND "${DOXYFILE}"
		"STRIP_FROM_PATH = ${CMAKE_CURRENT_SOURCE_DIR}\n")

	IF(DEFINED PROJECT_VERSION)
		FILE(APPEND "${DOXYFILE}"
			"PROJECT_NUMBER = ${PROJECT_VERSION}\n")
	ENDIF()

	STRING(TIMESTAMP DATE "%Y.%m.%d" UTC)
	FILE(APPEND "${DOXYFILE}" "ALIASES += date=\"${DATE}\"\n")

	STRING(TIMESTAMP TIME "%H:%M:%S" UTC)
	FILE(APPEND "${DOXYFILE}" "ALIASES += time=\"${TIME}\"\n")

	STRING(TIMESTAMP NOW "%Y.%m.%d %H:%M:%S" UTC)
	FILE(APPEND "${DOXYFILE}" "ALIASES += now=\"${NOW}\"\n")

	IF(NOT PLANTUML_PATH STREQUAL "PLANTUML_PATH-NOTFOUND")
		FILE(APPEND "${DOXYFILE}"
			"PLANTUML_JAR_PATH = \"${PLANTUML_PATH}\"\n")
	ENDIF()

	FOREACH(OPT ${DOXY_YES})
		FILE(APPEND "${DOXYFILE}" "${OPT} = YES\n")
	ENDFOREACH()

	FOREACH(OPT ${DOXY_NO})
		FILE(APPEND "${DOXYFILE}" "${OPT} = NO\n")
	ENDFOREACH()

	IF(DEFINED DOXY_EXCLUDE_DIRS)
		FILE(APPEND "${DOXYFILE}" "EXCLUDE =")
		FOREACH(EXCLUDE ${DOXY_EXCLUDE_DIRS})
			FILE(APPEND "${DOXYFILE}" " \"${EXCLUDE}\"")
		ENDFOREACH()
		FILE(APPEND "${DOXYFILE}" "\n")
	ENDIF()

	FOREACH(OPT ${VAL_LIST})
		FILE(APPEND "${DOXYFILE}" "${OPT} = ${DOXY_${OPT}}\n")
	ENDFOREACH()

	FOREACH(OPT ${VALS_LIST})
		FILE(APPEND "${DOXYFILE}" "${OPT} =")

		# write values into single line
		FOREACH(VAL ${DOXY_${OPT}})
			FILE(APPEND "${DOXYFILE}" " ${VAL}")
		ENDFOREACH()

		FILE(APPEND "${DOXYFILE}" "\n")
	ENDFOREACH()

	FILE(APPEND "${DOXYFILE}" "INPUT =")
	FOREACH(SRC ${DOXY_SOURCES})
		# use absolute path for input files
		IF(NOT IS_ABSOLUTE ${SRC})
			GET_FILENAME_COMPONENT(SRC "${SRC}" ABSOLUTE)
		ENDIF()
		FILE(APPEND "${DOXYFILE}" " \"${SRC}\"")
	ENDFOREACH()
	FILE(APPEND "${DOXYFILE}" "\n")

	FILE(MAKE_DIRECTORY "${DOXY_OUTPUT_DIRECTORY}")

	ADD_CUSTOM_COMMAND(OUTPUT "${DOXY_OUTPUT_DIRECTORY}.chk"
	COMMAND
		"${DOXYGEN_EXECUTABLE}" "${DOXYFILE}"
	COMMAND
		"${CMAKE_COMMAND}" -E touch "${DOXY_OUTPUT_DIRECTORY}.chk"
	DEPENDS
		"${DOXYFILE}"
		${DOXY_SOURCES}
	COMMENT
		"Generating documentation for ${PROJECT_NAME}")

	ADD_CUSTOM_TARGET("${DOXY_TARGET}" ALL
	WORKING_DIRECTORY
		"${DOXY_OUTPUT_DIRECTORY}"
	COMMENT
		"Generating documentation for ${PROJECT_NAME}"
	SOURCES
		"${DOXY_OUTPUT_DIRECTORY}.chk"
	)

	# remove documentation directory on 'make clean'
	SET_PROPERTY(DIRECTORY APPEND PROPERTY
	ADDITIONAL_MAKE_CLEAN_FILES
		"${DOXY_OUTPUT_DIRECTORY}")
ENDFUNCTION()
