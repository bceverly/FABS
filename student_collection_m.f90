module student_collection_m
    use student_m
    use sqlite_store_m
    use sqlite

    implicit none
    private

    type, public :: student_collection_t
        private
            type(student_t), dimension(:), pointer :: students_m

        contains
            procedure, public, pass(this) :: read_students, &
                                             print_students, &
                                             get_count
    end type student_collection_t

contains
    integer function get_count(this)
        class(student_collection_t), intent(inout) :: this

        get_count = 0
        if (associated(this%students_m)) get_count = size(this%students_m)
    end function get_count

    subroutine read_students(this)
        class(student_collection_t), intent(inout) :: this

        type(SQLITE_DATABASE) :: db
        type(SQLITE_COLUMN), dimension(:), pointer :: column
        type(SQLITE_STATEMENT) :: stmt

        logical :: finished
        character(len=80) :: first_name
        character(len=80) :: last_name
        integer :: id, num_rows, i
        type(student_t) :: the_student
        type(sqlite_store_t) :: store
        character(len=80) :: db_name = 'students.db'
        character(len=80) :: table_name = 'student'

        store = sqlite_store_t(db_name)
        num_rows = store%get_row_count(table_name)
        
        if (associated(this%students_m)) deallocate(this%students_m)

        call sqlite3_open('students.db', db)

        allocate(this%students_m(num_rows))
        allocate(column(3))

        call sqlite3_column_query(column(1), 'first_name', SQLITE_CHAR)
        call sqlite3_column_query(column(2), 'last_name', SQLITE_CHAR)
        call sqlite3_column_query(column(3), 'id', SQLITE_INT)

        call sqlite3_prepare_select(db, 'student', column, stmt, '')

        i = 1
        do
            call sqlite3_next_row(stmt, column, finished)
            if (finished) exit

            call sqlite3_get_column(column(1), first_name)
            call sqlite3_get_column(column(2), last_name)
            call sqlite3_get_column(column(3), id)

            call this%students_m(i)%load_data(first_name, last_name, id)
            i = i + 1
        enddo

        deallocate(column)
    end subroutine read_students

    subroutine print_students(this)
        class(student_collection_t), intent(inout) :: this

        integer :: i

        do i=1, size(this%students_m)
            call this%students_m(i)%write_json(1)
        enddo
    end subroutine print_students

end module student_collection_m
