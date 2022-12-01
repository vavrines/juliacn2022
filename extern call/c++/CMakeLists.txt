cmake_minimum_required(VERSION 2.8.12)
project(Kit)

#list(APPEND CMAKE_PREFIX_PATH "/home2/vavrines/.julia/artifacts/e74d2fd61bdd4d0ff365351ee632d660b2d43ec5")

# JlCxx
find_package(JlCxx REQUIRED)
get_target_property(JlCxx_location JlCxx::cxxwrap_julia LOCATION)
get_filename_component(JlCxx_location ${JlCxx_location} DIRECTORY)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib;${JlCxx_location}")
message(STATUS "Found JlCxx at ${JlCxx_location}")

# xtensor
find_package(xtensor REQUIRED)
find_package(xtensor-blas REQUIRED)
find_package(xtensor-julia REQUIRED)

add_library(kit SHARED kit.cpp)
target_link_libraries(kit JlCxx::cxxwrap_julia)

install(TARGETS
  kit
LIBRARY DESTINATION lib
ARCHIVE DESTINATION lib
RUNTIME DESTINATION lib)
