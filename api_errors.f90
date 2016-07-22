module api_errors
    use sqlite

    implicit none
    private

    public :: open_database_error

contains
    subroutine open_database_error(db)
        type(SQLITE_DATABASE), intent(inout) :: db

        character(len=80) :: error_msg
        error_msg = sqlite3_errmsg(db)

        print '(a)', 'Content-Type: application/json'
        print '(a)', 'Status: 500'
        print '(a)', ''
        print '(a)', '{'
        print '(a)', '  "status": "', error_msg, '",'
        print '(a)', '  "count": 0,'
        print '(a)', '  "type": "error",'
        print '(a)', '  "results": [ {'
        print '(a)', '  }]'
        print '(a)', '}'
    end subroutine open_database_error

end module api_errors
