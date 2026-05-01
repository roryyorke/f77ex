cmake_minimum_required(VERSION 3.17.2...3.29)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C Fortran)

set(F77EX_BUNDLE_OPENBLAS OFF CACHE BOOL "Bundle libraries from scipy-openblas32 in built wheel")

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(
  Python
  COMPONENTS Interpreter Development.Module NumPy
  REQUIRED)

# F2PY headers
execute_process(
  COMMAND "${PYTHON_EXECUTABLE}" -c
          "import numpy.f2py; print(numpy.f2py.get_include())"
  OUTPUT_VARIABLE F2PY_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE
  COMMAND_ERROR_IS_FATAL ANY)

cmake_path(CONVERT ${F2PY_INCLUDE_DIR} TO_CMAKE_PATH_LIST F2PY_INCLUDE_DIR)

message(STATUS "F2PY_INCLUDE_DIR: ${F2PY_INCLUDE_DIR}")

if(F77EX_BUNDLE_OPENBLAS)
  set(OPENBLAS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build-libs")

  find_library(
    OPENBLAS_LIBRARY_FILE
    NAMES libscipy_openblas.lib libscipy_openblas.dylib libscipy_openblas.so scipy_openblas.lib
    PATHS ${OPENBLAS_DIR}
    NO_DEFAULT_PATH
    REQUIRED)
else()
  find_package(LAPACK REQUIRED)
endif()

add_library(fortranobject OBJECT "${F2PY_INCLUDE_DIR}/fortranobject.c")
target_link_libraries(fortranobject PUBLIC Python::NumPy)
target_include_directories(fortranobject PUBLIC "${F2PY_INCLUDE_DIR}")
set_property(TARGET fortranobject PROPERTY POSITION_INDEPENDENT_CODE ON)

add_library(f77ex_fortran STATIC "${CMAKE_CURRENT_SOURCE_DIR}/f77ex/src/det77/mat_det.f")
set_property(TARGET f77ex_fortran PROPERTY POSITION_INDEPENDENT_CODE ON)
if(F77EX_BUNDLE_OPENBLAS)
  target_compile_options(f77ex_fortran
    PRIVATE
    @${CMAKE_CURRENT_SOURCE_DIR}/f77ex/scipy-openblas-symbols/scipy-openblas-symbols.def
    -ffixed-line-length-132)
endif()

set(F2PYSOURCE f77ex/src/mat_det.pyf)

add_custom_command(
  OUTPUT mat_detmodule.c mat_det-f2pywrappers.f
  DEPENDS ${F2PYSOURCE}
  VERBATIM
  COMMAND ${Python_EXECUTABLE} -m numpy.f2py --skip-empty-wrappers ${CMAKE_CURRENT_SOURCE_DIR}/${F2PYSOURCE}
)

python_add_library(
  mat_det MODULE
  "${CMAKE_CURRENT_BINARY_DIR}/mat_detmodule.c")

target_link_libraries(mat_det PRIVATE fortranobject)

if(F77EX_BUNDLE_OPENBLAS)
  target_link_libraries(mat_det PRIVATE f77ex_fortran ${OPENBLAS_LIBRARY_FILE})
  # (only?) needed for editable no-isolation builds
  set_target_properties(mat_det PROPERTIES INSTALL_RPATH ${OPENBLAS_DIR})
else()
  target_link_libraries(mat_det PRIVATE f77ex_fortran LAPACK::LAPACK)
endif()

install(TARGETS mat_det DESTINATION f77ex)
