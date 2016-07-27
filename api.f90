program api
    use student_collection_m
    use student_json_m
    use http_content_types
    implicit none

    type(student_json_t) :: response
    type(student_collection_t) :: students

    character(len=4096) :: path_info, request_method

    call response%set_content_type(TYPE_XML)
    call response%set_response_status(200)

    call get_environment_variable("PATH_INFO", path_info)
    call get_environment_variable("REQUEST_METHOD", request_method)

    call students%read_students()
    call response%write_success(students)
end program api
