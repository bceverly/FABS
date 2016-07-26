module http_response_m
    use http_content_types
    use http_response_codes

    implicit none
    private

    type, public :: http_response_t
        private
            integer :: content_type_m = TYPE_HTML
            integer :: response_status_m = 500

        contains
        procedure, public, pass(this) :: set_content_type, &
                                         set_response_status, &
                                         write_content_type_header, &
                                         write_response_status, &
                                         write_headers, &
                                         write_error, &
                                         write_success_header, &
                                         write_success_footer
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
            case(TYPE_HTML)
                print '(a)', 'Content-Type: text/html'
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
        character(len=80), intent(in) :: error_msg

        this%content_type_m = TYPE_JSON
        this%response_status_m = 500

        call this%write_headers()

        print '(a)', '{'
        print '(a)', '  "status": "', error_msg, '",'
        print '(a)', '  "count": 0,'
        print '(a)', '  "type": "error",'
        print '(a)', '  "results": [ ]'
        print '(a)', '}'
    end subroutine write_error

    subroutine write_success_header(this, num_objects, object_type)
        class(http_response_t), intent(inout) :: this
        integer, intent(in) :: num_objects
        character(len=*), intent(in) :: object_type

        call this%write_headers()

        print '(a)', '{'
        print '(a)', '  "status": "success",'
        print '(a,i5,a)', '  "count": ', num_objects, ','
        print '(a,a,a)', '  "type": "', trim(object_type), '",'
        print '(a)', '  "results": ['
    end subroutine write_success_header

    subroutine write_success_footer(this)
        class(http_response_t), intent(inout) :: this
        print '(a)', '}'
    end subroutine write_success_footer

end module http_response_m
