cmake_policy(SET CMP0054 OLD)

set(FOO "BAR")

if(NOT "FOO" STREQUAL "BAR")
  message(FATAL_ERROR "The given literals should match")
endif()

if(NOT FOO STREQUAL "BAR")
  message(FATAL_ERROR "The given literals should match")
endif()
