cmake_minimum_required(VERSION 3.16)
project(geant4-conda-prefix-test LANGUAGES CXX)

# Checks patch 0003: with the development files of the dependencies also in a
# system location searched before the environment (FAKE_SYSTEM_PREFIX, put first
# in CMAKE_SYSTEM_PREFIX_PATH by the test script), find_package(Geant4) must
# still take them from the environment.

# First make sure the fake location really is searched first, so the check
# below cannot pass for the wrong reason.
find_library(_probe_expat NAMES expat NO_CACHE)
if(NOT _probe_expat MATCHES "^${FAKE_SYSTEM_PREFIX}/")
  message(FATAL_ERROR "Test setup: expat found at '${_probe_expat}', not in ${FAKE_SYSTEM_PREFIX}")
endif()

find_package(Geant4 REQUIRED)

foreach(_var EXPAT_LIBRARY ZLIB_LIBRARY XercesC_LIBRARY FREETYPE_LIBRARY
             X11_X11_LIB OPENGL_opengl_LIBRARY OPENGL_gl_LIBRARY)
  message(STATUS "${_var}=${${_var}}")
  if("${${_var}}" MATCHES "^${FAKE_SYSTEM_PREFIX}/")
    message(FATAL_ERROR "${_var} was taken from the fake system location")
  endif()
endforeach()
foreach(_var EXPAT_LIBRARY ZLIB_LIBRARY XercesC_LIBRARY FREETYPE_LIBRARY)
  if(NOT ${_var})
    message(FATAL_ERROR "${_var} is not set")
  endif()
endforeach()
