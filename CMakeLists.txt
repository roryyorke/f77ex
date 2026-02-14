cmake_minimum_required(VERSION 3.17.2...3.29)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C Fortran)

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(
  Python
  COMPONENTS Interpreter Development.Module NumPy
  REQUIRED)

# f2py produces two output files as of version TBD
# version 1.22.4 (I think?) only one file, v2.x (recent as of 2025-08-17) two files
# actual switchover TBD!
if(${Python_NumPy_VERSION} VERSION_GREATER_EQUAL "2.0.0")
  set(TOY_CUSTOM_OUTPUTS "examplemodule.c;example-f2pywrappers.f")
  set(TOY_LIB_DEPS "${CMAKE_CURRENT_BINARY_DIR}/examplemodule.c;${CMAKE_CURRENT_BINARY_DIR}/example-f2pywrappers.f")
else()
  set(TOY_CUSTOM_OUTPUTS "examplemodule.c")
  set(TOY_LIB_DEPS "${CMAKE_CURRENT_BINARY_DIR}/examplemodule.c")
endif()


# F2PY headers
execute_process(
  COMMAND "${PYTHON_EXECUTABLE}" -c
          "import numpy.f2py; print(numpy.f2py.get_include())"
  OUTPUT_VARIABLE F2PY_INCLUDE_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND "${PYTHON_EXECUTABLE}" -c
          "import scipy_openblas32; import os.path; print(os.path.join(scipy_openblas32.get_lib_dir(), scipy_openblas32.get_library(fullname=True)))"
  OUTPUT_VARIABLE OPENBLAS_LIBRARY_FILE
  OUTPUT_STRIP_TRAILING_WHITESPACE)

execute_process(
  COMMAND "${PYTHON_EXECUTABLE}" -c
          "import scipy_openblas32; import os.path; print(scipy_openblas32.get_lib_dir())"
  OUTPUT_VARIABLE OPENBLAS_DIR
  OUTPUT_STRIP_TRAILING_WHITESPACE)


# execute_process(
#   COMMAND "${PYTHON_EXECUTABLE}" -c
#           "import scipy_openblas32; import os.path; print(os.path.join(scipy_openblas32.get_lib_dir(), 'libquadmath-96973f99.so.0.0.0'))"
#   OUTPUT_VARIABLE OPENBLAS_QUADMATH
#   OUTPUT_STRIP_TRAILING_WHITESPACE)

# execute_process(
#   COMMAND "${PYTHON_EXECUTABLE}" -c
#           "import scipy_openblas32; import os.path; print(os.path.join(scipy_openblas32.get_lib_dir(), 'libgfortran-040039e1.so.5.0.0'))"
#   OUTPUT_VARIABLE OPENBLAS_GFORTRAN
#   OUTPUT_STRIP_TRAILING_WHITESPACE)


message(STATUS "OpenBlas library file: ${OPENBLAS_LIBRARY_FILE}")


add_library(fortranobject OBJECT "${F2PY_INCLUDE_DIR}/fortranobject.c")
target_link_libraries(fortranobject PUBLIC Python::NumPy)
target_include_directories(fortranobject PUBLIC "${F2PY_INCLUDE_DIR}")
set_property(TARGET fortranobject PROPERTY POSITION_INDEPENDENT_CODE ON)


add_custom_command(
  OUTPUT examplemodule.c example-f2pywrappers.f
  DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/example.pyf"
  VERBATIM
  COMMAND "${Python_EXECUTABLE}" -m numpy.f2py
          "${CMAKE_CURRENT_SOURCE_DIR}/example.pyf" --lower)

python_add_library(
  example MODULE "${CMAKE_CURRENT_BINARY_DIR}/examplemodule.c"
  "${CMAKE_CURRENT_BINARY_DIR}/example-f2pywrappers.f"
  "${CMAKE_CURRENT_SOURCE_DIR}/example.f"
  WITH_SOABI)

target_compile_options(example PRIVATE -DDGETRF=SCIPY_DGETRF)
target_link_libraries(example PRIVATE fortranobject ${OPENBLAS_LIBRARY_FILE})
target_link_options(example PRIVATE -Wl,-rpath=${OPENBLAS_DIR})

install(TARGETS example DESTINATION .)
