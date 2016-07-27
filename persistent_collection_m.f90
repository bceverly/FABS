module persistent_collection_m
    use sqlite

    implicit none
    private

    type, public :: persistent_collection_t
        private
            character(:), allocatable :: db_name_m
            character(:), allocatable :: table_name_m
            character(:), allocatable :: object_name_m
            type(SQLITE_COLUMN), dimension(:), pointer, public :: column_m

    contains
        procedure, public, pass(this) :: set_db_name, &
                                         set_table_name, &
                                         set_object_name, &
                                         add_db_column, &
                                         add_db_char_column, &
                                         add_db_int_column, &
                                         get_object_name, &
                                         get_row_count, &
                                         map_object, &
                                         read_all, &
                                         write_json, &
                                         write_xml

    end type persistent_collection_t

contains
    subroutine set_db_name(this, db_name)
        class(persistent_collection_t) :: this
        character(len=*) :: db_name

        this%db_name_m = db_name
    end subroutine set_db_name

    subroutine set_table_name(this, table_name)
        class(persistent_collection_t) :: this
        character(len=*) :: table_name

        this%table_name_m = table_name
    end subroutine set_table_name

    subroutine set_object_name(this, object_name)
        class(persistent_collection_t) :: this
        character(len=*) :: object_name

        this%object_name_m = object_name
    end subroutine set_object_name

    character(len=80) function get_object_name(this)
        class(persistent_collection_t) :: this

        character(len=80) :: temp_name
        
        temp_name = this%object_name_m
        get_object_name = temp_name
    end function get_object_name

    integer function get_row_count(this)
        class(persistent_collection_t) :: this
        character(len=80) :: table

        type(SQLITE_DATABASE) :: db
        type(SQLITE_COLUMN), dimension(:), pointer :: column
        type(SQLITE_STATEMENT) :: stmt

        logical :: finished
        character(len=80) :: query

        call sqlite3_open(this%db_name_m, db)

        query = 'select count(*) as the_count from ' // trim(this%table_name_m)
        allocate(column(1))

        call sqlite3_column_query(column(1), 'the_count', SQLITE_INT)
        call sqlite3_prepare(db, query, stmt, column)
        call sqlite3_next_row(stmt, column, finished)

        get_row_count = 0
        if (.NOT. finished) call sqlite3_get_column(column(1), get_row_count)

        deallocate(column)

        call sqlite3_close(db)
    end function get_row_count

    subroutine add_db_char_column(this, col_name)
        class(persistent_collection_t), intent(inout) :: this
        character(len=*) :: col_name

        call add_db_column(this, col_name, SQLITE_CHAR)
    end subroutine add_db_char_column

    subroutine add_db_int_column(this, col_name)
        class(persistent_collection_t), intent(inout) :: this
        character(len=*) :: col_name

        call add_db_column(this, col_name, SQLITE_INT)
    end subroutine add_db_int_column

    subroutine add_db_column(this, col_name, col_type)
        class(persistent_collection_t), intent(inout) :: this
        character(len=*) :: col_name
        integer :: col_type
        type(SQLITE_COLUMN), dimension(:), pointer :: temp_column

        if (associated(this%column_m)) then
            allocate(temp_column(size(this%column_m)+1))
            temp_column = this%column_m
            deallocate(this%column_m)
            allocate(this%column_m(size(temp_column)))
            this%column_m = temp_column
            deallocate(temp_column)
        else
            allocate(this%column_m(1))
        end if

        call sqlite3_column_query(this%column_m(size(this%column_m)), &
            trim(col_name), col_type)
    end subroutine add_db_column

    subroutine map_object(this)
        class(persistent_collection_t), intent(inout) :: this
    end subroutine map_object

    subroutine read_all(this)
        class(persistent_collection_t), intent(inout) :: this

        type(SQLITE_DATABASE) :: db
        type(SQLITE_STATEMENT) :: stmt
        logical :: finished

        call sqlite3_open(this%db_name_m, db)
        call sqlite3_prepare_select(db, this%table_name_m, this%column_m, stmt)

        do
            call sqlite3_next_row(stmt, this%column_m, finished)
            if (finished) exit
            call this%map_object
        enddo

        call sqlite3_close(db)
    end subroutine read_all

    subroutine write_json(this)
        class(persistent_collection_t), intent(inout) :: this

    end subroutine write_json

    subroutine write_xml(this)
        class(persistent_collection_t), intent(inout) :: this

    end subroutine write_xml

end module persistent_collection_m
