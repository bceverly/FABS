module persistent_collection_m
    use sqlite

    implicit none
    private

    type, public :: persistent_collection_t
        private
            type(SQLITE_DATABASE) :: db

    contains
        final :: destructor
        procedure, public, pass(this) :: get_row_count

    end type persistent_collection_t

    interface persistent_collection_t
        module procedure persistent_collection_t_constructor
    end interface persistent_collection_t
contains
    type (persistent_collection_t) function persistent_collection_t_constructor(dbname)
        character(len=80), intent(inout) :: dbname

        call sqlite3_open(dbname, persistent_collection_t_constructor%db)

    end function persistent_collection_t_constructor

    subroutine destructor(this)
        type(persistent_collection_t) :: this

        call sqlite3_close(this%db)
    end subroutine destructor

    integer function get_row_count(this, table)
        class(persistent_collection_t) :: this
        character(len=80) :: table

        type(SQLITE_COLUMN), dimension(:), pointer :: column
        type(SQLITE_STATEMENT) :: stmt

        logical :: finished
        character(len=80) :: query

        query = 'select count(*) as the_count from ' // trim(table)
        allocate(column(1))

        call sqlite3_column_query(column(1), 'the_count', SQLITE_INT)
        call sqlite3_prepare(this%db, query, stmt, column)
        call sqlite3_next_row(stmt, column, finished)

        get_row_count = 0
        if (.NOT. finished) call sqlite3_get_column(column(1), get_row_count)

        deallocate(column)
    end function get_row_count
end module persistent_collection_m
