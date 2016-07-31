module xml_parser_m
    use object_parser_m

    implicit none
    private

    type, public, extends(object_parser_t) :: xml_parser_t
        private
            logical :: inside_header_m
            logical :: found_object_name_m
            logical :: parsing_object_name_m

        contains
            procedure, public, pass(this) :: parse

    end type xml_parser_t

contains
    subroutine parse(this, raw_data)
        class(xml_parser_t), intent(inout) :: this
        character(len=*), intent(in) :: raw_data

        integer :: i, str_pos, cur_pos

        this%raw_data_m = raw_data
        this%inside_header_m = .false.
        this%found_object_name_m = .false.
        this%parsing_object_name_m = .false.
        str_pos = 1

        do i=1,len_trim(raw_data)
            if (.not. this%found_object_name_m) then
                if (raw_data(i:i) == '<' .and. .not. this%inside_header_m) then
                    if (raw_data(i+1:i+1) == '?') then
                        this%inside_header_m = .true.
                    end if
                else if (raw_data(i:i) == '>' .and.  this%inside_header_m) then 
                    this%inside_header_m = .false.
                else if (this%inside_header_m) then
                    ! throw away characters
                else
                    if (.not. this%parsing_object_name_m) then
                        this%parsing_object_name_m = .true.
                    else if (this%parsing_object_name_m .and. &
                        raw_data(i:i) /= '>') then

                        ! Throw away characters
                    else
                        this%found_object_name_m = .true.
                        this%parsing_object_name_m = .false.
                    end if
                end if
            else
                ! We are parsing real data now
                if (raw_data(i:i) == '<' .and. &
                    .not. raw_data(i+1:i+1) == '/' .and. &
                    .not. this%parsing_attribute_value_pair_m) then

                    this%parsing_attribute_value_pair_m = .true.
                    this%parsing_attribute_m = .true.
                    str_pos = 1
                    call this%add_attribute_value_pair()
                else if (this%parsing_attribute_m .and. &
                    .not. this%parsing_value_m .and. &
                    .not. raw_data(i:i) == '>' .and. &
                    this%parsing_attribute_value_pair_m) then

                    ! We are collecting attribute name characters
                    cur_pos = size(this%attribute_value_pairs_m)
                    this%attribute_value_pairs_m(cur_pos) &
                        %the_attribute(str_pos:str_pos) = raw_data(i:i)
                    str_pos = str_pos + 1
                else if (raw_data(i:i) == '>' .and. &
                    this%parsing_attribute_m) then

                    this%parsing_attribute_m = .false.
                    this%parsing_value_m = .true.
                    str_pos = 1
                else if (this%parsing_attribute_value_pair_m .and. &
                    .not. raw_data(i:i) == '<' .and. &
                    .not. this%parsing_attribute_m) then

                    ! We are collecting value characters
                    this%attribute_value_pairs_m(cur_pos) &
                        %the_value(str_pos:str_pos) = raw_data(i:i)
                    str_pos = str_pos + 1
                else if (this%parsing_attribute_value_pair_m .and. &
                    raw_data(i:i) == '<' .and. &
                    this%parsing_value_m) then

                    this%parsing_value_m = .false.
                    this%parsing_attribute_value_pair_m = .false.
                    str_pos = 1
                end if
            end if
        end do
    end subroutine parse

end module xml_parser_m
