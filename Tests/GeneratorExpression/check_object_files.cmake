
if (NOT EXISTS ${OBJLIB_LISTFILE})
  message(SEND_ERROR "Object listing file \"${OBJLIB_LISTFILE}\" not found!")
endif()

file(STRINGS ${OBJLIB_LISTFILE} objlib_files)

list(LENGTH objlib_files num_objectfiles)
if (NOT EXPECTED_NUM_OBJECTFILES EQUAL num_objectfiles)
  message(SEND_ERROR "Unexpected number of entries in object list file (${num_objectfiles} instead of ${EXPECTED_NUM_OBJECTFILES})")
endif()

foreach(objlib_file ${objlib_files})
  set(file_exists False)
  if (EXISTS ${objlib_file})
    set(file_exists True)
  endif()

  if (NOT file_exists)
    if (objlib_file MATCHES ".(CURRENT_ARCH)")
      string(REPLACE "$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)" "*" config_file "${objlib_file}")
      string(REPLACE "$(PROJECT_NAME)" "GeneratorExpression" config_file "${config_file}")
      string(REPLACE "$(CURRENT_ARCH)" "*" config_file "${config_file}")
      file(GLOB_RECURSE files "${config_file}")
      list(LENGTH files num_files)
      if (NOT num_files EQUAL 1)
        message(SEND_ERROR "Got wrong number of files for expression ${config_file}")
      endif()
      set(file_exists True)
    else()
      foreach(config_macro "$(Configuration)" "$(OutDir)" "$(IntDir)")
        string(REPLACE "${config_macro}" "${TEST_CONFIGURATION}" config_file "${config_file}")
        if (EXISTS ${config_file})
          set(file_exists True)
        endif()
      endforeach()
    endif()
  endif()

  if (NOT file_exists)
    message(SEND_ERROR "File \"${objlib_file}\" does not exist!")
  endif()
endforeach()
