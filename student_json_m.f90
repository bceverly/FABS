module student_json_m
    use persistent_collection_m
    use json_payload_m

    implicit none
    private

    type, public, extends(json_payload_t) :: student_json_t
        private

        contains
            procedure, public, pass(this) :: write_body
    end type student_json_t

contains
    subroutine write_body(this, the_data)
        class(student_json_t), intent(inout) :: this
        class(persistent_collection_t), intent(inout) :: the_data

        call the_data%write_json()
    end subroutine write_body

end module student_json_m
