program api
    use sqlite
    use api_errors
    implicit none

    type(SQLITE_DATABASE) :: db
    type(SQLITE_STATEMENT) :: stmt
    type(SQLITE_COLUMN), dimension(:), pointer :: column

    logical :: finished
    character(len=80) :: first_name
    character(len=80) :: last_name
    integer :: id, num_rows

    character(len=4096) :: path_info, request_method

    call get_environment_variable("PATH_INFO", path_info)
    call get_environment_variable("REQUEST_METHOD", request_method)

    call sqlite3_open ('students.db', db)
    if (sqlite3_error(db)) call open_database_error(db)

    allocate (column(1))
    call sqlite3_column_query (column(1), 'num_student', SQLITE_INT)
    if (sqlite3_error(db)) print *, sqlite3_error(db)
    call sqlite3_prepare (db, 'select count(*) as num_students from student;', &
        stmt, column)
    call sqlite3_next_row (stmt, column, finished)
    num_rows = 0
    if (.NOT. finished) call sqlite3_get_column(column(1), num_rows)

    deallocate(column)
    allocate (column(3))
    call sqlite3_column_query (column(1), 'first_name', SQLITE_CHAR)
    call sqlite3_column_query (column(2), 'last_name', SQLITE_CHAR)
    call sqlite3_column_query (column(3), 'id', SQLITE_INT)

    call sqlite3_prepare_select (db, 'student', column, stmt, '')

    print '(a)', 'Content-Type: application/json'
    print '(a)', 'Status: 200'
    print '(a)', ''
    print '(a)', '{'
    print '(a)', '  "status": "success",'
    print '(a, i5, a)', '  "count": ', num_rows, ','
    print '(a)', '  "type": "student",'
    print '(a)', '  "results": ['

    do
        call sqlite3_next_row (stmt, column, finished)
        
        if (finished) exit

        call sqlite3_get_column(column(1), first_name)
        call sqlite3_get_column(column(2), last_name)
        call sqlite3_get_column(column(3), id)

        print '(a)', '  {'
        print '(a,a,a)', '    "first_name": "', trim(first_name), '",'
        print '(a,a,a)', '    "last_name": "', trim(last_name), '",'
        print '(a,i5,a)', '    "id": ', id, ','
        print '(a)', '  },'

!    print '(a)', '    "first_name": "Joe",'
!    print '(a)', '    "last_name": "Smith",'
!    print '(a)', '    "id": 42'
    enddo

    print '(a)', '  ]'
    print '(a)', '}'

    call sqlite3_close (db)
end program api
