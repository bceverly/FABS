program api
    use student_collection_m
    use http_response_m
    implicit none

    type(http_response_t) :: response
    type(student_collection_t) :: students

    character(len=80) :: object_name = "student"
    character(len=4096) :: path_info, request_method

    call get_environment_variable("PATH_INFO", path_info)
    call get_environment_variable("REQUEST_METHOD", request_method)

    call students%read_students()
    call response%write_success_header(students%get_row_count(), object_name)
    call students%print_students()

    print '(a)', '  ]'
    call response%write_success_footer()
end program api
