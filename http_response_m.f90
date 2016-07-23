module http_response_m
    use http_content_types
    use http_response_codes

    implicit none
    private

    type, public :: http_response_t
        private

        contains
        procedure, public, pass(this) :: write_error, &
                                         write_success_header, &
                                         write_success_footer
    end type http_response_t

contains
    subroutine write_error(this, error_msg)
        class(http_response_t), intent(inout) :: this
        character(len=80), intent(in) :: error_msg

        print '(a)', 'Content-Type: application/json'
        print '(a)', 'Status: 500'
        print '(a)', ''
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
        character(len=80), intent(in) :: object_type

        print '(a)', 'Content-Type: application/json'
        print '(a)', 'Status: 200'
        print '(a)', ''
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
