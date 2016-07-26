module json_payload_m
    use http_response_m
    use persistent_collection_m
    use http_response_codes
    use http_content_types

    implicit none
    private

    type, public, extends(http_response_t) :: json_payload_t
        private

        contains
            procedure, public, pass(this) :: write_error, &
                                             write_success, &
                                             write_body

    end type json_payload_t

contains
    subroutine write_error(this, error_msg)
        class(json_payload_t), intent(inout) :: this
        character(len=*), intent(in) :: error_msg

        call this%write_headers()

        print '(a)', '{'
        print '(a,a,a)', '    "status": "', error_msg, '",'
        print '(a)', '    "count": 0,'
        print '(a)', '    "type": "error",'
        print '(a)', '    "results": []'
        print '(a)', '}'
    end subroutine write_error

    subroutine write_success(this, the_data)
        class(json_payload_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

        call this%write_headers()

        print '(a)', '{'
        print '(a)', '    "status": "success",'
        print '(a,i9,a)', '    "count": ', the_data%get_row_count(), ','
        print '(a,a,a)', '    "type": "', trim(the_data%get_object_name()), '",'
        print '(a)', '    "results": ['

        call this%write_body(the_data)

        print '(a)', '    ]'
        print '(a)', '}'
    end subroutine write_success

    subroutine write_body(this, the_data)
        class(json_payload_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

    end subroutine write_body

end module json_payload_m
