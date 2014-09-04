cmake_policy(SET CMP0054 OLD)

set(FOO "BAR")

if(NOT "FOO" STREQUAL "BAR")
  message(FATAL_ERROR "The given literals should match")
endif()

if(NOT FOO STREQUAL "BAR")
  message(FATAL_ERROR "The given literals should match")
endif()

set(MYTRUE ON)

if(NOT MYTRUE)
  message(FATAL_ERROR "Expected MYTRUE to evaluate true")
endif()

if(NOT "MYTRUE")
  message(FATAL_ERROR "Expected quoted MYTRUE to evaluate true as well")
endif()
