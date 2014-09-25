cmake_minimum_required(VERSION 2.8)
project(autorcc_depends)

set(CMAKE_AUTORCC ON)

if (QT_TEST_VERSION STREQUAL 4)
  find_package(Qt4 REQUIRED)
  set(QT_CORE_TARGET Qt4::QtCore)
else()
  if (NOT QT_TEST_VERSION STREQUAL 5)
    message(SEND_ERROR "Invalid Qt version specified.")
  endif()

  find_package(Qt5Core REQUIRED)
  set(QT_CORE_TARGET Qt5::Core)
endif()

add_executable(test_res1
  test_res1.cpp
  res1.qrc
)
target_link_libraries(test_res1 ${QT_CORE_TARGET})

file(GENERATE
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/info_file$<$<BOOL:$<CONFIG>>:_$<CONFIG>>.txt"
  CONTENT "$<TARGET_FILE:test_res1>\n"
)
