module object_parser_m
    use attribute_value_pair_m

    implicit none
    private

    type, public :: object_parser_t
        private
            character(len=4096), public :: raw_data_m
            integer, public :: object_depth_m = 0
            logical, public :: parsing_attribute_value_pair_m = .false.
            logical, public :: parsing_attribute_m = .false.
            logical, public :: parsing_value_m = .false.
            logical, public :: error_m = .false.
            character(len=4096), public :: error_string_m = ''
            type(attribute_value_pair_t), public, dimension(:), pointer :: &
                attribute_value_pairs_m

        contains
            procedure, public, pass(this) :: parse, &
                                             process_error, &
                                             add_attribute_value_pair

    end type object_parser_t

contains
    subroutine parse(this, raw_data)
        class(object_parser_t), intent(inout) :: this
        character(len=*), intent(in) :: raw_data

        this%error_m = .false.
        this%error_string_m = ''
        this%raw_data_m = raw_data
    end subroutine parse

    subroutine process_error(this, error_str)
        class(object_parser_t), intent(inout) :: this
        character(len=*), intent(in) :: error_str

        this%error_m = .true.
        this%error_string_m = error_str
    end subroutine process_error

    subroutine add_attribute_value_pair(this)
        class(object_parser_t), intent(inout) :: this

        type(attribute_value_pair_t), pointer, dimension(:) :: temp_array
        integer :: the_size

        if (.not. associated(this%attribute_value_pairs_m)) then
            ! adding first one
            allocate(this%attribute_value_pairs_m(1))
            this%attribute_value_pairs_m(1)%the_attribute = ''
            this%attribute_value_pairs_m(1)%the_value = ''
        else
            ! adding second or subsequent on
            the_size = size(this%attribute_value_pairs_m)
            allocate(temp_array(the_size+1))
            temp_array = this%attribute_value_pairs_m
            deallocate(this%attribute_value_pairs_m)
            allocate(this%attribute_value_pairs_m(the_size+1))
            this%attribute_value_pairs_m = temp_array
            deallocate(temp_array)

            this%attribute_value_pairs_m(the_size+1)%the_attribute = ''
            this%attribute_value_pairs_m(the_size+1)%the_value = ''
        end if
    end subroutine add_attribute_value_pair

end module object_parser_m
