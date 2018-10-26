# This file is part of MXE. See LICENSE.md for licensing information.

# partial module - included by src/cmake/CMakeLists.txt

set(TGT test-${PKG}-cmake)

enable_language(CXX)
add_executable(${TGT} ${CMAKE_CURRENT_LIST_DIR}/${PKG}-test.cpp)

find_package(GTest ${PKG_VERSION} EXACT REQUIRED)
include_directories(${GOOGLETEST_INCLUDE_DIRS})
target_link_libraries(${TGT} ${GTEST_LIBRARIES})

install(TARGETS ${TGT} DESTINATION bin)
