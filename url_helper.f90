module url_helper
    implicit none
    private

    type, public :: query_string_variable_t
        character(len=80) :: the_name
        character(len=80) :: the_value
    end type query_string_variable_t

    public :: get_num_path_elements, &
              get_path_elements, &
              get_num_query_string_variables, &
              get_query_string_variables

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

    subroutine get_path_elements(url_str, elements)
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
    end subroutine get_path_elements

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
        type(query_string_variable_t), dimension(:), intent(out) :: results

        integer :: cur, start, pos, var
        character(len=4096) :: chunk

        start = 1
        pos = 1
        do cur=1,len_trim(query_str)
            if (query_str(cur:cur) == '&') then
                chunk = query_str(start:cur-1)
                start = cur + 1

                results(pos)%the_name = ''
                results(pos)%the_value = ''
                do var=1,len_trim(chunk)
                    if (chunk(var:var) == '=') then
                        results(pos)%the_name = chunk(1:var-1)
                        results(pos)%the_value = chunk(var+1:len_trim(chunk))
                    end if
                end do
                if (results(pos)%the_name == '') results(pos)%the_name = chunk
                pos = pos + 1
            end if
        end do

        results(pos)%the_name = ''
        results(pos)%the_value = ''
        chunk = query_str(start:cur)
        do var=1,len_trim(chunk)
            if (chunk(var:var) == '=') then
                results(pos)%the_name = chunk(1:var-1)
                results(pos)%the_value = chunk(var+1:len_trim(chunk))
            end if
        end do
        if (results(pos)%the_name == '') results(pos)%the_name = chunk
    end subroutine get_query_string_variables

end module url_helper
