set(XLW_PATH ${CMAKE_CURRENT_LIST_DIR})
message(STATUS "XLW_PATH=${XLW_PATH}")

macro(add_xll xllname api_file_name)
    message(STATUS "Add Xll: ${xllname}")
    message(STATUS "create wrapper xlw${api_file_name}.cpp")
    file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/xlw${api_file_name}.cpp)

    set(file_list "${ARGN}")
    list(APPEND file_list
	 ${CMAKE_CURRENT_SOURCE_DIR}/${api_file_name}.h
     ${CMAKE_CURRENT_SOURCE_DIR}/${api_file_name}.cpp
     ${CMAKE_CURRENT_SOURCE_DIR}/xlw${api_file_name}.cpp
    )
	
    add_library(${xllname} SHARED ${file_list})
    set_target_properties(${xllname} PROPERTIES SUFFIX ".xll")
    target_include_directories(${xllname} PUBLIC
        $<BUILD_INTERFACE:${XLW_PATH}/xlw/include>
        $<INSTALL_INTERFACE:${XLW_PATH}/xlw/include>		
    )
    target_link_libraries(${xllname}
        "$<$<CONFIG:Debug>:${XLW_PATH}/xlw/lib/xlw-vc140-mt-gd.lib>"
        "$<$<NOT:$<CONFIG:Debug>>:${XLW_PATH}/xlw/lib/xlw-vc140-mt.lib>"
    )
    
    add_custom_command(TARGET ${xllname}
                       PRE_BUILD
                       COMMAND ${XLW_PATH}/xlw/InterfaceGenerator.exe ${CMAKE_CURRENT_SOURCE_DIR}/${api_file_name}.h
                       WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )					   
    message(STATUS "Add Xll done")
endmacro()
