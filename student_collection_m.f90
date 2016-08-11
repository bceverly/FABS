module student_collection_m
    use student_m
    use persistent_collection_m
    use sqlite

    implicit none
    private

    type, public, extends(persistent_collection_t) :: student_collection_t
        private
            type(student_t), dimension(:), pointer, public :: students_m => null()

        contains
            procedure, public, pass(this) :: read_students, &
                                             read_student, &
                                             write_json, &
                                             write_xml, &
                                             map_object, &
                                             get_collection_size
    end type student_collection_t

contains
    subroutine read_students(this)
        class(student_collection_t), intent(inout) :: this

        call this%set_db_name('../cgi-data/students.db')
        call this%set_table_name('student')
        call this%set_object_name('student')
        call this%add_db_char_column('first_name')
        call this%add_db_char_column('last_name')
        call this%add_db_int_column('id')
        call this%read_all()
    end subroutine read_students

    subroutine read_student(this, id)
        class(student_collection_t), intent(inout) :: this
        integer, intent(in) :: id

        call this%set_db_name('../cgi-data/students.db')
        call this%set_table_name('student')
        call this%set_object_name('student')
        call this%add_db_char_column('first_name')
        call this%add_db_char_column('last_name')
        call this%add_db_int_column('id')
        call this%read_one(id)
    end subroutine read_student

    subroutine write_json(this)
        class(student_collection_t), intent(inout) :: this

        integer :: i

        if (associated(this%students_m) .and. size(this%students_m) > 0) then
            do i=1, size(this%students_m)
                call this%students_m(i)%write_json(1)
            enddo
        end if
    end subroutine write_json

    subroutine write_xml(this)
        class(student_collection_t), intent(inout) :: this

        integer :: i

        do i=1, size(this%students_m)
            call this%students_m(i)%write_xml(1)
        enddo
    end subroutine write_xml

    subroutine map_object(this)
        class(student_collection_t), intent(inout) :: this

        character(len=80) :: first_name
        character(len=80) :: last_name
        integer :: id
        type(student_t) :: new_student
        type(student_t), dimension(:), pointer :: temp_student_array

        call sqlite3_get_column(this%column_m(1), first_name)
        call sqlite3_get_column(this%column_m(2), last_name)
        call sqlite3_get_column(this%column_m(3), id)

        call new_student%load_data(first_name, last_name, id)
        
        if (associated(this%students_m)) then
            allocate(temp_student_array(size(this%students_m)+1))
            temp_student_array = this%students_m
            deallocate(this%students_m)
            allocate(this%students_m(size(temp_student_array)))
            this%students_m = temp_student_array
            deallocate(temp_student_array)
        else
            allocate(this%students_m(1))
        end if

        this%students_m(size(this%students_m)) = new_student
    end subroutine map_object

    integer function get_collection_size(this)
        class(student_collection_t), intent(in) :: this

        if (associated(this%students_m)) then
            get_collection_size = size(this%students_m)
        else
            get_collection_size = 0
        end if
    end function get_collection_size

end module student_collection_m
