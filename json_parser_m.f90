module json_parser_m
    use object_parser_m

    implicit none
    private

    type, public, extends(object_parser_t) :: json_parser_t
        private

        contains
            procedure, public, pass(this) :: parse

    end type json_parser_t

contains
    subroutine parse(this, raw_data)
        class(json_parser_t), intent(inout) :: this
        character(len=*), intent(in) :: raw_data

        integer :: i, current_pos, str_pos

        this%error_m = .false.
        this%error_string_m = ''
        this%raw_data_m = raw_data
        this%parsing_attribute_value_pair_m = .false.
        this%parsing_attribute_m = .false.
        this%parsing_value_m = .false.
        this%object_depth_m = 0

        do i=1,len_trim(raw_data)
            if (raw_data(i:i) == '{') then
                this%object_depth_m = this%object_depth_m + 1
            else if (raw_data(i:i) == '}') then
                this%object_depth_m = this%object_depth_m - 1
                if (this%object_depth_m < 0) then
                    call this%process_error('Unbalanced curly braces')
                    exit
                end if
            else if (raw_data(i:i) == '"' .or. raw_data(i:i) == "'") then
                if (.not. this%parsing_attribute_m .and. &
                    .not. this%parsing_value_m .and. &
                    .not. this%parsing_attribute_value_pair_m) then
                    this%parsing_attribute_m = .true.
                    this%parsing_attribute_value_pair_m = .true.
                    str_pos = 0
                else if (this%parsing_attribute_m .and. &
                         .not. this%parsing_value_m .and. &
                         this%parsing_attribute_value_pair_m) then
                    this%parsing_attribute_m = .false.
                else if (.not. this%parsing_attribute_m .and. &
                         .not. this%parsing_value_m .and. &
                         this%parsing_attribute_value_pair_m) then
                    this%parsing_value_m = .true.
                    str_pos = 0
                else if (.not. this%parsing_attribute_m .and. &
                         this%parsing_value_m .and. &
                         this%parsing_attribute_value_pair_m) then
                    this%parsing_value_m = .false.
                    this%parsing_attribute_value_pair_m = .false.
                else
                    call this%process_error('Unablanced quotes')
                    exit
                end if
            else
                if (this%parsing_attribute_m) then
                    call this%add_attribute_value_pair()
                    current_pos = size(this%attribute_value_pairs_m)

                    this%attribute_value_pairs_m(current_pos)% &
                        the_attribute(str_pos:str_pos) = raw_data(i:i)
                    str_pos = str_pos + 1
                else if (this%parsing_value_m) then
                    current_pos = size(this%attribute_value_pairs_m)

                    this%attribute_value_pairs_m(current_pos)% &
                        the_value(str_pos:str_pos) = raw_data(i:i)
                    str_pos = str_pos + 1
                end if 
            end if
        end do
    end subroutine parse

end module json_parser_m
