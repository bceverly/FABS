module student_xml_m
    use persistent_collection_m
    use xml_payload_m

    implicit none
    private

    type, public, extends(xml_payload_t) :: student_xml_t
        private

        contains
            procedure, public, pass(this) :: write_body
    end type student_xml_t

contains
    subroutine write_body(this, the_data)
        class(student_xml_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

        call the_data%write_xml()
    end subroutine write_body

end module student_xml_m
