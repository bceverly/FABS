module http_request_m
    use attribute_value_pair_m
    use string_utils
    use url_helper

    implicit none
    private

    type, public :: http_request_t
        private
            character(len=4096) :: auth_type_m = ''
            integer :: content_length_m = 0
            character(len=4096) :: content_type_m = ''
            character(len=4096) :: gateway_interface_m = ''
            character(len=4096) :: path_info_m = ''
            character(len=4096) :: path_translated_m = ''
            character(len=4096) :: query_string_m = ''
            character(len=4096) :: remote_addr_m = ''
            character(len=4096) :: remote_host_m = ''
            character(len=4096) :: remote_ident_m = ''
            character(len=4096) :: remote_user_m = ''
            character(len=4096) :: request_method_m = ''
            character(len=4096) :: script_name_m = ''
            character(len=4096) :: server_name_m = ''
            character(len=4096) :: server_port_m = ''
            character(len=4096) :: server_protocol_m = ''
            character(len=4096) :: server_software_m = ''
            character(len=4096) :: http_accept_m = ''
            character(len=4096) :: request_body_m = ''
            character(len=80), dimension(:), pointer :: path_elements_m
            type(attribute_value_pair_t), dimension(:), pointer :: &
                query_strings_m

        contains
            procedure, public, pass(this) :: get_auth_type, &
                                             get_content_length, &
                                             get_content_type, &
                                             get_gateway_interface, &
                                             get_path_info, &
                                             get_path_translated, &
                                             get_query_string, &
                                             get_remote_addr, &
                                             get_remote_host, &
                                             get_remote_ident, &
                                             get_remote_user, &
                                             get_request_method, &
                                             get_script_name, &
                                             get_server_name, &
                                             get_server_port, &
                                             get_server_protocol, &
                                             get_server_software, &
                                             get_http_accept, &
                                             get_request_body, &
                                             get_path_elements, &
                                             get_query_strings

    end type http_request_t

contains
    character(len=4096) function get_auth_type(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%auth_type_m) == 0) then
            call get_environment_variable("AUTH_TYPE", this%auth_type_m)
        end if

        get_auth_type = this%auth_type_m
    end function get_auth_type

    integer function get_content_length(this)
        class(http_request_t), intent(inout) :: this

        character(len=4096) :: temp_str
        integer :: result_val, status_val

        if (this%content_length_m == 0) then
            call get_environment_variable("CONTENT_LENGTH", temp_str)
            call str2int(temp_str, result_val, status_val)

            if (status_val /= 0) then
                this%content_length_m = 0
            else
                this%content_length_m = result_val
            end if
        end if

        get_content_length = this%content_length_m
    end function get_content_length

    character(len=4096) function get_content_type(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%content_type_m) == 0) then
            call get_environment_variable("CONTENT_TYPE", &
                this%content_type_m)
        end if

        get_content_type = this%content_type_m
    end function get_content_type

    character(len=4096) function get_gateway_interface(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%gateway_interface_m) == 0) then
            call get_environment_variable("GATEWAY_INTERFACE", &
                this%gateway_interface_m)
        end if

        get_gateway_interface = this%gateway_interface_m
    end function get_gateway_interface

    character(len=4096) function get_path_info(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%path_info_m) == 0) then
            call get_environment_variable("PATH_INFO", this%path_info_m)
        end if

        get_path_info = this%path_info_m
    end function get_path_info

    character(len=4096) function get_path_translated(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%path_translated_m) == 0) then
            call get_environment_variable("PATH_TRANSLATED", &
                this%path_translated_m)
        end if

        get_path_translated = this%path_translated_m
    end function get_path_translated

    character(len=4096) function get_query_string(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%query_string_m) == 0) then
            call get_environment_variable("QUERY_STRING", this%query_string_m)
        end if

        get_query_string = this%query_string_m
    end function get_query_string

    character(len=4096) function get_remote_addr(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%remote_addr_m) == 0) then
            call get_environment_variable("REMOTE_ADDR", this%remote_addr_m)
        end if

        get_remote_addr = this%remote_addr_m
    end function get_remote_addr

    character(len=4096) function get_remote_host(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%remote_host_m) == 0) then
            call get_environment_variable("REMOTE_HOST", this%remote_host_m)
        end if

        get_remote_host = this%remote_host_m
    end function get_remote_host

    character(len=4096) function get_remote_ident(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%remote_ident_m) == 0) then
            call get_environment_variable("REMOTE_IDENT", this%remote_ident_m)
        end if

        get_remote_ident = this%remote_ident_m
    end function get_remote_ident

    character(len=4096) function get_remote_user(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%remote_user_m) == 0) then
            call get_environment_variable("REMOTE_USER", this%remote_user_m)
        end if

        get_remote_user = this%remote_user_m
    end function get_remote_user

    character(len=4096) function get_request_method(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%request_method_m) == 0) then
            call get_environment_variable("REQUEST_METHOD", &
                this%request_method_m)
        end if

        get_request_method = this%request_method_m
    end function get_request_method

    character(len=4096) function get_script_name(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%script_name_m) == 0) then
            call get_environment_variable("SCRIPT_NAME", this%script_name_m)
        end if

        get_script_name = this%script_name_m
    end function get_script_name

    character(len=4096) function get_server_name(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%server_name_m) == 0) then
            call get_environment_variable("SERVER_NAME", this%server_name_m)
        end if

        get_server_name = this%server_name_m
    end function get_server_name

    character(len=4096) function get_server_port(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%server_port_m) == 0) then
            call get_environment_variable("SERVER_PORT", this%server_port_m)
        end if

        get_server_port = this%server_port_m
    end function get_server_port

    character(len=4096) function get_server_protocol(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%server_protocol_m) == 0) then
            call get_environment_variable("SERVER_PROTOCOL", &
                this%server_protocol_m)
        end if

        get_server_protocol = this%server_protocol_m
    end function get_server_protocol

    character(len=4096) function get_server_software(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%server_software_m) == 0) then
            call get_environment_variable("SERVER_SOFTWARE", &
                this%server_software_m)
        end if

        get_server_software = this%server_software_m
    end function get_server_software

    character(len=4096) function get_http_accept(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%http_accept_m) == 0) then
            call get_environment_variable("HTTP_ACCEPT", &
                this%http_accept_m)
        end if

        get_http_accept = this%http_accept_m
    end function get_http_accept

    character(len=4096) function get_request_body(this)
        class(http_request_t), intent(inout) :: this

        integer :: body_size, i, bytes_read
        character(len=1) :: in_char

        body_size = this%get_content_length()

        if (len_trim(this%request_body_m) == 0) then
            this%request_body_m = repeat(' ', 4096)
            do i=1,body_size
                bytes_read = 0
                read (5, '(a)', advance='no', size=body_size) in_char
                this%request_body_m(i:i) = in_char
            end do
        end if

        get_request_body = this%request_body_m
    end function get_request_body

    subroutine get_path_elements(this, path_elements)
        class(http_request_t), intent(inout) :: this
        character(len=80), dimension(:), pointer, intent(inout) :: &
            path_elements

        integer :: num_elements
        character(len=4096) :: path_str

        if (.not. associated(this%path_elements_m)) then
            path_str = url_decode(this%get_path_info())
            num_elements = get_num_uri_elements(path_str)
            allocate(this%path_elements_m(num_elements))
            call split_path(path_str, this%path_elements_m)
        end if

        path_elements => this%path_elements_m
    end subroutine get_path_elements

    subroutine get_query_strings(this, query_strings)
        class(http_request_t), intent(inout) :: this
        type(attribute_value_pair_t), dimension(:), pointer, intent(inout) ::&
            query_strings

        integer :: num_elements
        character(len=4096) :: query_str

        if (.not. associated(this%query_strings_m)) then
            query_str = url_decode(this%get_query_string())
            num_elements = get_num_attributes(query_str)
            allocate(this%query_strings_m(num_elements))
            call get_attribute_value_pairs(query_str, this%query_strings_m)
        end if

        query_strings => this%query_strings_m
    end subroutine get_query_strings

end module http_request_m
