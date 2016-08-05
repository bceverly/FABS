module log_file_m
    implicit none
    private

    public :: log_append

contains
    subroutine log_append(filename, text)
        character(len=*), intent(in) :: filename
        character(len=*), intent(in) :: text

        logical :: does_exist
        integer, dimension(8) :: values

        inquire(file=filename, exist=does_exist)
        if (does_exist) then
            open(99, file=filename, status='old', position='append', &
                action='write')
        else
            open(99, file=filename, status='new', action='write')
        end if

        call date_and_time(VALUES=values)
        write(99, &
            '(i0.2, a, i0.2, a, i0.4, 1x, i0.2, a, i0.2, a, ' // &
            'i0.2, a, i0.3, a, a)', advance='no') &
            values(2), '/', values(3), '/', values(1), &
            values(5), ':', values(6), ':', values(7), '.', values(8), &
            ': ', trim(text)
        close(99)

    end subroutine log_append

end module log_file_m
