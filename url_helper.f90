module url_helper
    implicit none
    private

    type, public :: attribute_value_pair_t
        character(len=80) :: the_attribute
        character(len=80) :: the_value
    end type attribute_value_pair_t

    public :: get_num_path_elements, &
              split_path, &
              get_num_query_string_variables, &
              get_query_string_variables, &
              url_decode

contains
    integer function get_num_path_elements(url_str)
        character(len=*), intent(in) :: url_str

        integer :: i

        get_num_path_elements = 0
        do i=1,len_trim(url_str)
            if (url_str(i:i) == '/') then
                get_num_path_elements = get_num_path_elements + 1
            end if

            if (url_str(i:i) == '?') exit
        end do
    end function get_num_path_elements

    subroutine split_path(url_str, elements)
        character(len=*), intent(in) :: url_str
        character(len=*), dimension(:), intent(out) :: elements

        integer :: cur, start, element
        start = 1
        element = 1
        do cur=1,len_trim(url_str)
            if (url_str(cur:cur) == '/') then
                if (start /= 1) then
                    elements(element) = url_str(start:cur-1)
                    element = element + 1
                    start = cur + 1
                else
                    start = 2
                end if
            end if
        end do
        elements(element) = url_str(start:cur)
    end subroutine split_path

    integer function get_num_query_string_variables(query_str)
        character(len=*), intent(in) :: query_str

        integer :: i

        if (len_trim(query_str) > 0) then
            get_num_query_string_variables = 1
        else
            get_num_query_string_variables = 0
        end if

        do i=1,len_trim(query_str)
            if (query_str(i:i) == '&') then
                get_num_query_string_variables = &
                    get_num_query_string_variables + 1
            end if
        end do
    end function get_num_query_string_variables

    subroutine get_query_string_variables(query_str, results)
        character(len=*), intent(in) :: query_str
        type(attribute_value_pair_t), dimension(:), intent(out) :: results

        integer :: cur, start, pos, var
        character(len=4096) :: chunk

        start = 1
        pos = 1
        do cur=1,len_trim(query_str)
            if (query_str(cur:cur) == '&') then
                chunk = query_str(start:cur-1)
                start = cur + 1

                results(pos)%the_attribute = ''
                results(pos)%the_value = ''
                do var=1,len_trim(chunk)
                    if (chunk(var:var) == '=') then
                        results(pos)%the_attribute = chunk(1:var-1)
                        results(pos)%the_value = chunk(var+1:len_trim(chunk))
                    end if
                end do
                if (results(pos)%the_attribute == '') then
                    results(pos)%the_attribute = chunk
                end if    
                pos = pos + 1
            end if
        end do

        results(pos)%the_attribute = ''
        results(pos)%the_value = ''
        chunk = query_str(start:cur)
        do var=1,len_trim(chunk)
            if (chunk(var:var) == '=') then
                results(pos)%the_attribute = chunk(1:var-1)
                results(pos)%the_value = chunk(var+1:len_trim(chunk))
            end if
        end do
        if (results(pos)%the_attribute == '') results(pos)%the_attribute = chunk
    end subroutine get_query_string_variables

    character(len=80) function url_decode(input_string)
        character(len=*), intent(in) :: input_string

        character(len=80) :: in_str
        character(len=80) :: out_str = ''
        integer :: i, o
        integer :: the_value

        out_str = repeat(' ', 80)
        in_str = trim(input_string)
        i = 1
        o = 1

        do
            if (in_str(i:i) == '%') then
                the_value = 16 * hex_digit_to_int(in_str(i+1:i+1))
                the_value = the_value + hex_digit_to_int(in_str(i+2:i+2)) 
                out_str(o:o) = achar(the_value)
                o = o + 1
                i = i + 3
            else
                out_str(o:o) = in_str(i:i)
                o = o + 1
                i = i + 1
            end if

            if (i > len_trim(in_str)) exit
        end do

        url_decode = out_str
    end function url_decode

    integer function hex_digit_to_int(in_str)
        character(len=1), intent(in) :: in_str

        integer :: result_val = 0
        integer :: ascii_val

        ascii_val = iachar(in_str)

        if (ascii_val >= 48 .and. ascii_val <= 57) then
            result_val = ascii_val - 48
        else if (ascii_val >= 65 .and. ascii_val <= 70) then
            result_val = ascii_val - 55
        else
            result_val = ascii_val - 87
        end if
        hex_digit_to_int = result_val
    end function hex_digit_to_int

end module url_helper
