module student_m
    use sqlite

    implicit none
    private

    type, public :: student_t
        private

        character(len=80) :: first_name_m
        character(len=80) :: last_name_m
        integer :: id_m
    contains
        procedure, public, pass(this) :: write_json, &
                                         write_xml, &
                                         load_data
    end type student_t

contains
    subroutine load_data(this, first, last, id)
        class(student_t), intent(inout) :: this
        character(len=*), intent(in) :: first
        character(len=*), intent(in) :: last
        integer, intent(in) :: id

        this%first_name_m = first
        this%last_name_m = last
        this%id_m = id
    end subroutine load_data

    subroutine write_json(this, indent_level)
        class(student_t), intent(in) :: this
        integer, intent(in) :: indent_level

        character(len=(2*indent_level)) :: indent_string
        indent_string = repeat(' ', 2 * indent_level)

        print '(a,a)', indent_string, '{'
        print '(a,a,a,a)', indent_string, '  "first_name": "', &
              trim(this%first_name_m), '",'
        print '(a,a,a,a)', indent_string, '  "last_name": "', &
              trim(this%last_name_m), '",'
        print '(a,a,i5)', indent_string, '  "id": ', this%id_m
        print '(a,a)', indent_string, '}'
    end subroutine

    subroutine write_xml(this, indent_level)
        class(student_t), intent(in) :: this
        integer, intent(in) :: indent_level

        character(len=(4*indent_level)) :: indent_string
        indent_string = repeat(' ', 4 * indent_level)

        print '(a,a)', indent_string, '<student>'
        print '(a,a,a,a)', indent_string, '    <first_name>', &
            this%first_name_m, '</first_name>'
        print '(a,a,a,a)', indent_string, '    <last_name>', &
            this%last_name_m, '</last_name>'
        print '(a,a,a,a)', indent_string, '    <id>', this%id_m, '</id>'
        print '(a,a)', indent_string, '</student>'
    end subroutine write_xml
end module student_m
