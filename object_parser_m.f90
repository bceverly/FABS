module object_parser_m
    implicit none
    private

    type, public :: object_parser_t
        private

        contains
            procedure, public, pass(this) :: parse, &
                                             process_object, &
                                             process_attribute_value_pair, &
                                             process_error

    end type object_parser_t

contains
    subroutine parse(this)
        class(object_parser_t), intent(inout) :: this
    end subroutine parse

    subroutine process_object(this)
        class(object_parser_t), intent(inout) :: this
    end subroutine process_object

    subroutine process_attribute_value_pair(this)
        class(object_parser_t), intent(inout) :: this
    end subroutine process_attribute_value_pair

    subroutine process_error(this)
        class(object_parser_t), intent(inout) :: this
    end subroutine process_error

end module object_parser_m
