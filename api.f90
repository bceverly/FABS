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
    type(attribute_value_pair_t), dimension(:), pointer :: qs_variables
    character(len=80) :: msg
    character(len=4096) :: path
    character(len=4096) :: query_str

    if (request%get_http_accept() == 'application/xml') then
        response => xml_response
        call response%set_content_type(TYPE_XML)
    else
        response => json_response
        call response%set_content_type(TYPE_JSON)
    end if

    call request%get_path_elements(path_elements)
    call request%get_query_strings(qs_variables)

    if (path_elements(1) /= 'api') then
        call response%set_response_status(RESPONSE_NOT_FOUND)
        call response%write_error('Invalid API path - ' // path)

        call exit(0)
    end if

    select case(path_elements(2))
        case ('student')
            select case (trim(request%get_request_method()))
                case ('GET')
                    if (len_trim(query_str) == 0) then
                        call response%set_response_status(RESPONSE_OK)
                        call students%read_students()
                        call response%write_success(students)
                    else
                        if (qs_variables(1)%the_attribute /= 'id') then
                            call response%set_response_status( &
                                RESPONSE_NOT_FOUND)
                            call response%write_error( &
                                'Invalid object id name - ' &
                                // qs_variables(1)%the_attribute)
                        else
                            call str2int(qs_variables(1)%the_value, id, &
                                status_val)
                            if (status_val /= 0) then
                                call response%set_response_status( &
                                    RESPONSE_NOT_FOUND)
                                call response%write_error( &
                                    'Invalid object id - ' &
                                    // qs_variables(1)%the_value)
                            else
                                call students%read_student(id)
                                if (students%get_collection_size() == 1) then
                                    call response%set_response_status( &
                                        RESPONSE_OK)
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
                case ('POST')
                    call response%set_response_status(INTERNAL_SERVER_ERROR)
                    call response%write_error('Request body - ' &
                        // trim(request%get_request_body()))
                case ('DELETE')
                case ('PUT')
            end select
        case default
            call response%set_response_status(RESPONSE_NOT_FOUND)
            call response%write_error('Invalid API object - ' &
                // path_elements(2))
    end select
end program api
