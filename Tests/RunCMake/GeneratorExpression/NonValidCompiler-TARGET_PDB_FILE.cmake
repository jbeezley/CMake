
enable_language(C)

add_library(empty SHARED empty.c)

file(GENERATE
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/test.txt"
  CONTENT "$<TARGET_PDB_FILE:empty>"
)
