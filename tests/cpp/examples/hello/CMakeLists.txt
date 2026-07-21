cmake_minimum_required(VERSION 3.14)
project(cmake_test VERSION 0.0.1 LANGUAGES CXX)

# cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
# cmake --build build

set(GOOGLETEST_DIR ../../../../tools/cpp/gtest)


get_filename_component(MY_RESULT_ABSOLUTE_PATH_VAR
                       "${CMAKE_CURRENT_LIST_DIR}/${GOOGLETEST_DIR}/CMakeLists.txt"
                       ABSOLUTE)

if(NOT EXISTS ${MY_RESULT_ABSOLUTE_PATH_VAR})
  message(FATAL_ERROR "googletest not found at ${MY_RESULT_ABSOLUTE_PATH_VAR}")
endif()

add_subdirectory(${GOOGLETEST_DIR} ./g_build)

enable_testing()

add_executable(
  hello_test
  hello_test.cc
)

target_compile_features(hello_test PRIVATE cxx_std_17)

target_link_libraries(
  hello_test
  GTest::gtest_main
)

# Use the GoogleTest CMake module (provided after add_subdirectory)
include(GoogleTest)
gtest_discover_tests(hello_test)