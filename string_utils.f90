!
! String utility module
!
! This module contains helper functions that don't exist in the standard
! set of Fortran intrinsics.
!
module string_utils
    ! Set defaults for module
    implicit none
    private

    ! Declare the public functions exposed by this module
    public :: ucase
    public :: lcase
    public :: str2int

    ! Helper strings to aid in the converstion of upper to lower and
    ! vice-versa
    character (len=*), private, parameter :: LOWER_CASE = &
        'abcdefghijklmnopqrstuvwxyz'
    character (len=*), private, parameter :: UPPER_CASE = &
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

contains
    ! Convert string to all uppercase
    pure function ucase(Input_String) result(Output_String)
        character (len=*), intent (in) :: Input_String
        character (len(Input_String)) :: Output_String

        integer :: i,n

        Output_String = Input_String

        do i=1, len(Output_String)
            n = index(LOWER_CASE, Output_String(i:i))
            if (n /= 0) Output_String(i:i) = UPPER_CASE(n:n)
        end do
    end function ucase

    ! Convert string to all lowercase
    pure function lcase(Input_String) result(Output_String)
        character (len=*), intent (in) :: Input_String
        character (len(Input_String)) :: Output_String

        integer :: i,n

        Output_String = Input_String

        do i=1, len(Output_String)
            n = index(UPPER_CASE, Output_String(i:i))
            if (n /= 0) Output_String(i:i) = LOWER_CASE(n:n)
        end do
    end function lcase

    subroutine str2int(input_string, output_integer, status_result)
        character(len=*), intent(in) :: input_string
        integer, intent(out) :: output_integer
        integer, intent(out) :: status_result

        read(input_string,*,iostat=status_result) output_integer
    end subroutine str2int

end module string_utils
