module persistent_object_m
    use sqlite

    implicit none
    private

    type, public :: persistent_object_t
        private
            type(SQLITE_DATABASE), public :: db_m
            character(len=80) :: db_name_m

        contains
            procedure, public, pass(this) :: set_db_name, &
                                             open_database, &
                                             close_database, &
                                             create_new, &
                                             update_existing, &
                                             delete_existing

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

    subroutine create_new(this)
        class(persistent_object_t), intent(inout) :: this
    end subroutine create_new

    subroutine update_existing(this)
        class(persistent_object_t), intent(inout) :: this
    end subroutine update_existing

    subroutine delete_existing(this)
        class(persistent_object_t), intent(inout) :: this
    end subroutine delete_existing

end module persistent_object_m
