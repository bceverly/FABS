program api
    use student_collection_m
    use student_json_m
    use student_xml_m
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
    type(http_request_t) :: request
    integer :: num_elements, num_variables, i, id, status_val
    character(len=80), dimension(:), pointer :: path_elements
    type(query_string_variable_t), dimension(:), pointer :: qs_variables
    character(len=80) :: msg

    if (request%get_http_accept() == 'application/xml') then
        response => xml_response
        call response%set_content_type(TYPE_XML)
    else
        response => json_response
        call response%set_content_type(TYPE_JSON)
    end if

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
                num_variables = &
                    get_num_query_string_variables(request%get_query_string())
                allocate(qs_variables(num_variables))
                call get_query_string_variables(request%get_query_string(), &
                    qs_variables)
                if (qs_variables(1)%the_name /= 'id') then
                    call response%set_response_status(RESPONSE_NOT_FOUND)
                    call response%write_error('Invalid object id name - ' &
                        // qs_variables(1)%the_name)
                else
                    call str2int(qs_variables(1)%the_value, id, status_val)
                    if (status_val /= 0) then
                        call response%set_response_status(RESPONSE_NOT_FOUND)
                        call response%write_error('Invalid object id - ' &
                            // qs_variables(1)%the_value)
                    else
                        call students%read_student(id)
                        if (students%get_collection_size() == 1) then
                            call response%set_response_status(RESPONSE_OK)
                            call response%write_success(students)
                        else
                            call response%set_response_status( &
                                RESPONSE_NOT_FOUND)
                            call response%write_error('Object id ' &
                                // trim(qs_variables(1)%the_value) &
                                // ' not found')
                        end if
                    end if
                end if
            end if
        case default
            call response%set_response_status(RESPONSE_NOT_FOUND)
            call response%write_error('Invalid API object - ' &
                // path_elements(2))
    end select
end program api
