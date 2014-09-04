cmake_policy(SET CMP0054 NEW)

set(FOO "BAR")

if("FOO" STREQUAL "BAR")
  message(FATAL_ERROR "The given literals should not match")
endif()

if(NOT FOO STREQUAL "BAR")
  message(FATAL_ERROR "The given variable should match the literal")
endif()

set(MYTRUE ON)

if(NOT MYTRUE)
  message(FATAL_ERROR "Expected MYTRUE to evaluate true")
endif()

if("MYTRUE")
  message(FATAL_ERROR "Expected quoted MYTRUE to evaluate false")
endif()
