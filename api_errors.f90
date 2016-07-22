module api_errors
    use sqlite
    use http_response_m

    implicit none
    private

    public :: database_error

contains
    subroutine database_error(db)
        type(SQLITE_DATABASE), intent(inout) :: db
        type(http_response_t) :: response

        character(len=80) :: error_msg
        error_msg = sqlite3_errmsg(db)

        call response%write_error(error_msg)
    end subroutine database_error

end module api_errors
