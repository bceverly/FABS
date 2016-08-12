program main
    use api_m
    use student_collection_m
    use student_json_m
    use student_xml_m
    use student_m
    use http_request_m
    use http_response_m
    use http_content_types
    use http_response_codes
    use url_helper
    use string_utils

    implicit none

    class(http_response_t), pointer :: response
    type(student_xml_t), target :: xml_response
    type(student_json_t), target :: json_response
    type(student_collection_t) :: students
    type(student_t) :: student
    type(http_request_t), pointer :: request
    character(len=80), dimension(:), pointer :: path_elements
    character(len=4096) :: path
    type(api_t) :: api_object

    students = student_collection_t()
    allocate(request)

    ! Are we outputting JSON or XML?
    if (request%get_http_accept() == 'application/xml') then
        response => xml_response
        call response%set_content_type(TYPE_XML)
    else
        response => json_response
        call response%set_content_type(TYPE_JSON)
    end if

    call api_object%set_request(request)
    call api_object%set_response(response)
    call request%get_path_elements(path_elements)

    if (path_elements(1) /= 'api') then
        call response%set_response_status(RESPONSE_NOT_FOUND)
        call response%write_error('Invalid API path - ' // path)

        call exit(0)
    end if

    select case(path_elements(2))
        case ('student')
            call api_object%set_collection(students)
            select case (trim(request%get_request_method()))
                case ('GET')
                    call api_object%get()
                case ('POST')
                    call api_object%post(student)
                case ('DELETE')
                    call api_object%delete()
                case ('PUT')
                    call api_object%put(student)
            end select
        case default
            call response%set_response_status(RESPONSE_NOT_FOUND)
            call response%write_error('Invalid API object - ' &
                // path_elements(2))
    end select
end program main
