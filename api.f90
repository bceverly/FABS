program api
    use student_collection_m
    use student_json_m
    use http_content_types
    use http_request_m
    implicit none

    type(student_json_t) :: response
    type(student_collection_t) :: students
    type(http_request_t) :: request

    call response%set_content_type(TYPE_XML)
    call response%set_response_status(200)
    call students%read_students()
    call response%write_success(students)
end program api
