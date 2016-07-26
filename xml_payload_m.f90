module xml_payload_m
    use http_response_m
    use persistent_collection_m
    use http_response_codes
    use http_content_types

    implicit none
    private

    type, public, extends(http_response_t) :: xml_payload_t
        private

        contains
            procedure, public, pass(this) :: write_success, &
                                             write_error, &
                                             write_body

    end type xml_payload_t

contains
    subroutine write_success(this, the_data)
        class(xml_payload_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

        call this%write_headers()

        print '(a)', '<?xml version="1.0" encoding="UTF-8"?>'
        print '(a)', '<response>'
        print '(a)', '<status>Success</status>'
        print '(a,i9,a)', '<count>', the_data%get_row_count(), '</count>'
        print '(a,a,a)', '<type>', trim(the_data%get_object_name()), '</type>'
        print '(a)', '<results>'

        call this%write_body(the_data)

        print '(a)', '</results>'
        print '(a)', '</response>'
    end subroutine write_success

    subroutine write_error(this, error_msg)
        class(xml_payload_t), intent(inout) :: this
        character(len=*), intent(in) :: error_msg

        call this%write_headers()

        print '(a)', '<?xml version="1.0" encoding="UTF-8"?>'
        print '(a)', '<response>'
        print '(a,a,a)', '<status>', error_msg, '</status>'
        print '(a)', '<count>0</count>'
        print '(a)', '<type>Error</type>'
        print '(a)', '<results></results>'
        print '(a)', '</response>'
    end subroutine write_error

    subroutine write_body(this, the_data)
        class(xml_payload_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

    end subroutine write_body

end module xml_payload_m
