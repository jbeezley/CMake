include(RunCMake)

run_cmake(CommandConflict)
if("${RunCMake_GENERATOR}" MATCHES "Visual Studio|Xcode" AND NOT XCODE_BELOW_2)
  run_cmake(OutputConflict)
endif()
run_cmake(EmptyCondition1)
run_cmake(EmptyCondition2)
run_cmake(BadCondition)
run_cmake(DebugEvaluate)

set(timeformat "%Y%j%H%M%S")

file(REMOVE "${RunCMake_BINARY_DIR}/WriteIfDifferent-build/output_file.txt")
set(RunCMake_TEST_OPTIONS "-DTEST_FILE=WriteIfDifferent.cmake")
set(RunCMake_TEST_BINARY_DIR "${RunCMake_BINARY_DIR}/WriteIfDifferent-build")
run_cmake(WriteIfDifferent-prepare)
unset(RunCMake_TEST_OPTIONS)
unset(RunCMake_TEST_BINARY_DIR)
file(TIMESTAMP "${RunCMake_BINARY_DIR}/WriteIfDifferent-build/output_file.txt" timestamp ${timeformat})
if(NOT timestamp)
  message(SEND_ERROR "Could not get timestamp for \"${RunCMake_BINARY_DIR}/WriteIfDifferent-build/output_file.txt\"")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

set(RunCMake_TEST_NO_CLEAN ON)
run_cmake(WriteIfDifferent)
file(TIMESTAMP "${RunCMake_BINARY_DIR}/WriteIfDifferent-build/output_file.txt" timestamp_after ${timeformat})
if(NOT timestamp_after)
  message(SEND_ERROR "Could not get timestamp for \"${RunCMake_BINARY_DIR}/WriteIfDifferent-build/output_file.txt\"")
endif()
unset(RunCMake_TEST_NO_CLEAN)

if (NOT timestamp_after STREQUAL timestamp)
  message(SEND_ERROR "WriteIfDifferent changed output file.")
endif()

file(MAKE_DIRECTORY "${RunCMake_BINARY_DIR}/ReRunCMake-build/")
file(WRITE "${RunCMake_BINARY_DIR}/ReRunCMake-build/input_file.txt" "InitialContent\n")

set(RunCMake_TEST_NO_CLEAN ON)
run_cmake(ReRunCMake)
unset(RunCMake_TEST_NO_CLEAN)
file(TIMESTAMP "${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt" timestamp ${timeformat})
if(NOT timestamp)
  message(SEND_ERROR "Could not get timestamp for \"${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt\"")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)

file(WRITE "${RunCMake_BINARY_DIR}/ReRunCMake-build/input_file.txt" "ChangedContent\n")
execute_process(COMMAND ${CMAKE_COMMAND} --build "${RunCMake_BINARY_DIR}/ReRunCMake-build/")
file(READ "${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt" out_content)

if(NOT out_content STREQUAL "ChangedContent\n")
  message(SEND_ERROR "File did not change: \"${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt\"")
endif()


file(REMOVE "${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt")
execute_process(COMMAND ${CMAKE_COMMAND} --build "${RunCMake_BINARY_DIR}/ReRunCMake-build/")

if (NOT EXISTS "${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt")
  message(SEND_ERROR "File did not re-generate: \"${RunCMake_BINARY_DIR}/ReRunCMake-build/output_file.txt\"")
endif()
