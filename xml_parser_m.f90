module xml_parser_m
    use object_parser_m

    implicit none
    private

    type, public, extends(object_parser_t) :: xml_parser_t
        private

        contains
            procedure, public, pass(this) :: parse

    end type xml_parser_t

contains
    subroutine parse(this, raw_data)
        class(xml_parser_t), intent(inout) :: this
        character(len=*), intent(in) :: raw_data

        this%raw_data_m = raw_data
    end subroutine parse

end module xml_parser_m
