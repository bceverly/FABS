module http_request_m
    implicit none
    private

    type, public :: http_request_t
        private
            character(len=4096) :: auth_type_m = ''
            character(len=4096) :: content_length_m = ''
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
                                             get_http_accept

    end type http_request_t

contains
    character(len=4096) function get_auth_type(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%auth_type_m) == 0) then
            call get_environment_variable("AUTH_TYPE", this%auth_type_m)
        end if

        get_auth_type = this%auth_type_m
    end function get_auth_type

    character(len=4096) function get_content_length(this)
        class(http_request_t), intent(inout) :: this

        if (len_trim(this%content_length_m) == 0) then
            call get_environment_variable("CONTENT_LENGTH", &
                this%content_length_m)
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

end module http_request_m
