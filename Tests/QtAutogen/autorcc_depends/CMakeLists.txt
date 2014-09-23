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

add_custom_command(OUTPUT generated.txt
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_CURRENT_SOURCE_DIR}/res1_input.txt" "${CMAKE_CURRENT_BINARY_DIR}/generated.txt"
  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/res1_input.txt"
)

configure_file(res1.qrc.in res1_gen.qrc)

add_executable(test_res1
  test_res1.cpp
  ${CMAKE_CURRENT_BINARY_DIR}/res1_gen.qrc
)
target_link_libraries(test_res1 ${QT_CORE_TARGET})

add_executable(test_res2
  test_res2.cpp
  res2_gen.qrc
)
target_link_libraries(test_res2 ${QT_CORE_TARGET})

file(GENERATE
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/info_file$<$<CONFIG>>:_$<CONFIG>>.txt"
  CONTENT "$<TARGET_FILE:test_res1>\n$<TARGET_FILE:test_res2>\n"
)
