module http_response_m
    use http_content_types
    use http_response_codes
    use persistent_collection_m

    implicit none
    private

    type, public :: http_response_t
        private
            integer :: content_type_m = TYPE_JSON
            integer :: response_status_m = 500

        contains
        procedure, public, pass(this) :: set_content_type, &
                                         set_response_status, &
                                         write_content_type_header, &
                                         write_response_status, &
                                         write_headers, &
                                         write_error, &
                                         write_success
    end type http_response_t

contains
    subroutine set_content_type(this, content_type)
        class(http_response_t), intent(inout) :: this
        integer, intent(in) :: content_type

        this%content_type_m = content_type
    end subroutine set_content_type

    subroutine set_response_status(this, response_status)
        class(http_response_t), intent(inout) :: this
        integer, intent(in) :: response_status

        this%response_status_m = response_status
    end subroutine set_response_status

    subroutine write_response_status(this)
        class(http_response_t), intent(inout) :: this

        print '(a,i3)', 'Status: ', this%response_status_m
    end subroutine write_response_status

    subroutine write_content_type_header(this)
        class(http_response_t), intent(inout) :: this

        select case (this%content_type_m)
            case(TYPE_JSON)
                print '(a)', 'Content-Type: application/json'
            case(TYPE_XML)
                print '(a)', 'Content-Type: application/xml'
            case default 
                print '(a)', 'Content-Type: text/plain'
        end select
    end subroutine write_content_type_header

    subroutine write_headers(this)
        class(http_response_t), intent(inout) :: this

        call this%write_content_type_header()
        call this%write_response_status()

        print '(a)', ''
    end subroutine write_headers

    subroutine write_error(this, error_msg)
        class(http_response_t), intent(inout) :: this
        character(len=*), intent(in) :: error_msg

    end subroutine write_error

    subroutine write_success(this, the_data)
        class(http_response_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

    end subroutine write_success

end module http_response_m
