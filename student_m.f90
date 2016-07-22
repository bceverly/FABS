module student_m
    use sqlite

    implicit none
    private

    type, public :: student_t
        private

        character(len=80) :: first_name_m
        character(len=80) :: last_name_m
        integer :: id_m
        type(SQLITE_COLUMN), dimension(:), pointer :: column_m
    contains
        procedure, public, pass(this) :: write_json, &
                                         initialize, &
                                         get_sqlite_columns
    end type student_t

contains
    subroutine initialize(this, first, last, id)
        class(student_t), intent(inout) :: this
        character(len=*), intent(in) :: first
        character(len=*), intent(in) :: last
        integer, intent(in) :: id

        this%first_name_m = first
        this%last_name_m = last
        this%id_m = id
    end subroutine initialize

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

    function get_sqlite_columns(this) result(column)
        class(student_t), intent(inout) :: this
        type(SQLITE_COLUMN), dimension(:), pointer :: column

        if (associated(this%column_m)) deallocate(this%column_m)
        allocate(this%column_m(3))
        call sqlite3_column_query(this%column_m(1), 'first_name', SQLITE_CHAR)
        call sqlite3_column_query(this%column_m(2), 'last_name', SQLITE_CHAR)
        call sqlite3_column_query(this%column_m(3), 'id', SQLITE_INT)

        column => this%column_m
    end function get_sqlite_columns

end module student_m