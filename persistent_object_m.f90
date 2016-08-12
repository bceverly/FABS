module persistent_object_m
    use attribute_value_pair_m
    use sqlite

    implicit none
    private

    type, public :: persistent_object_t
        private
            type(SQLITE_DATABASE), public :: db_m
            character(len=80) :: db_name_m
            integer, public :: id_m

        contains
            procedure, public, pass(this) :: set_db_name, &
                                             open_database, &
                                             close_database, &
                                             create_new, &
                                             update_existing, &
                                             delete_existing, &
                                             delete_by_id, &
                                             map_from_data

    end type persistent_object_t

contains
    subroutine set_db_name(this, db_name)
        class(persistent_object_t), intent(inout) :: this
        character(len=*), intent(in) :: db_name

        this%db_name_m = db_name
    end subroutine set_db_name

    subroutine open_database(this)
        class(persistent_object_t), intent(inout) :: this

        call sqlite3_open(this%db_name_m, this%db_m)
    end subroutine open_database

    subroutine close_database(this)
        class(persistent_object_t), intent(inout) :: this

        call sqlite3_close(this%db_m)
    end subroutine close_database

    integer function create_new(this)
        class(persistent_object_t), intent(inout) :: this
    end function create_new

    subroutine update_existing(this)
        class(persistent_object_t), intent(inout) :: this
    end subroutine update_existing

    subroutine delete_existing(this)
        class(persistent_object_t), intent(inout) :: this
    end subroutine delete_existing

    subroutine delete_by_id(this, id)
        class(persistent_object_t), intent(inout) :: this
        integer, intent(in) :: id

        character(len=80) :: query

        write (query, '(a,i5,a)') 'delete from student where id=', id, ';'

        call this%set_db_name('../cgi-data/students.db')
        call this%open_database()
        call sqlite3_do(this%db_m, query)
        call this%close_database()
    end subroutine delete_by_id

    subroutine map_from_data(this, the_data)
        class(persistent_object_t), intent(inout) :: this
        class(attribute_value_pair_t), dimension(:), intent(in) :: the_data

    end subroutine map_from_data

end module persistent_object_m
