program api
    use student_collection_m
    use student_json_m
    use http_request_m
    use http_content_types
    use http_response_codes
    use url_helper

    implicit none

    type(student_json_t) :: response
    type(student_collection_t) :: students
    type(http_request_t) :: request
    integer :: num_elements, i
    character(len=80), dimension(:), pointer :: path_elements

    call response%set_content_type(TYPE_JSON)

    num_elements = get_num_path_elements(request%get_path_info())
    allocate(path_elements(num_elements))
    call get_path_elements(request%get_path_info(), path_elements)

    if (path_elements(1) /= 'api') then
        call response%set_response_status(RESPONSE_NOT_FOUND)
        call response%write_error('Invalid API path - ' &
            // request%get_path_info())

        call exit(0)
    end if

    select case(path_elements(2))
        case ('person')
            if (len_trim(request%get_query_string()) == 0) then
                call response%set_response_status(RESPONSE_OK)
                call students%read_students()
                call response%write_success(students)
            else
            end if
        case default
            call response%set_response_status(RESPONSE_NOT_FOUND)
            call response%write_error('Invalid API object - ' &
                // path_elements(2))
    end select
end program api
