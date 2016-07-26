module html_payload_m
    use http_response_m
    use http_response_codes
    use http_content_types

    implicit none
    private

    type, public, extends(http_response_t) :: html_payload_t
        private

        contains
            procedure, public, pass(this) :: write_success, &
                                             write_error, &
                                             write_head, &
                                             write_body

    end type html_payload_t

contains
    subroutine write_success(this)
        class(html_payload_t), intent(inout) :: this

        print '(a)', '<html>'

        print '(a)', '<head>'
        call this%write_head()
        print '(a)', '</head>'

        print '(a)', '<body>'
        call this%write_body()
        print '(a)', '</body>'

        print '(a)', '</html>'

    end subroutine write_success

    subroutine write_error(this, error_msg)
        class(html_payload_t), intent(inout) :: this
        character(len=*), intent(in) :: error_msg

        print '(a)', '<html>'
        print '(a)', '<head>'
        print '(a)', '<title>Error</title>'
        print '(a)', '</head>'
        print '(a)', '<body>'
        print '(a,a,a)', '<h1>Error:', error_msg, '</h1>'
        print '(a)', '</body>'
        print '(a)', '</html>'

    end subroutine write_error

    subroutine write_head(this)
        class(html_payload_t), intent(inout) :: this

    end subroutine write_head

    subroutine write_body(this)
        class(html_payload_t), intent(inout) :: this

    end subroutine write_body

end module html_payload_m
