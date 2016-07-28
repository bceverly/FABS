module url_helper
    implicit none

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
end module url_helper
