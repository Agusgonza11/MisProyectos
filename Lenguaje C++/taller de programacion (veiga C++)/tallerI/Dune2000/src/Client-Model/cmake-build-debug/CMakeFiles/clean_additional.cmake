# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/Client_Model_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/Client_Model_autogen.dir/ParseCache.txt"
  "Client_Model_autogen"
  )
endif()
