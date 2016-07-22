program api
    use sqlite
    use api_errors
    use student_m
    use http_response_m
    implicit none

    type(SQLITE_DATABASE) :: db
    type(SQLITE_STATEMENT) :: stmt
    type(SQLITE_COLUMN), dimension(:), pointer :: column

    logical :: finished
    character(len=80) :: first_name
    character(len=80) :: last_name
    integer :: id, num_rows
    type(student_t), pointer :: the_student
    type(http_response_t) :: response
    character(len=80) :: object_name = "student"

    character(len=4096) :: path_info, request_method

    call get_environment_variable("PATH_INFO", path_info)
    call get_environment_variable("REQUEST_METHOD", request_method)

    call sqlite3_open ('students.db', db)
    if (sqlite3_error(db)) call database_error(db)

    allocate (column(1))

    call sqlite3_column_query (column(1), 'num_student', SQLITE_INT)
    if (sqlite3_error(db)) print *, sqlite3_error(db)

    call sqlite3_prepare (db, 'select count(*) as num_students from student;', &
        stmt, column)
    if (sqlite3_error(db)) print *, sqlite3_error(db)

    call sqlite3_next_row (stmt, column, finished)
    if (sqlite3_error(db)) print *, sqlite3_error(db)

    num_rows = 0
    if (.NOT. finished) call sqlite3_get_column(column(1), num_rows)
    if (sqlite3_error(db)) print *, sqlite3_error(db)

    deallocate(column)
    allocate (column(3))
    call sqlite3_column_query (column(1), 'first_name', SQLITE_CHAR)
    call sqlite3_column_query (column(2), 'last_name', SQLITE_CHAR)
    call sqlite3_column_query (column(3), 'id', SQLITE_INT)

    call sqlite3_prepare_select (db, 'student', column, stmt, '')
    if (sqlite3_error(db)) print *, sqlite3_error(db)

    call response%write_success_header(num_rows, object_name)
!    print '(a)', 'Content-Type: application/json'
!    print '(a)', 'Status: 200'
!    print '(a)', ''
!    print '(a)', '{'
!    print '(a)', '  "status": "success",'
!    print '(a, i5, a)', '  "count": ', num_rows, ','
!    print '(a)', '  "type": "student",'
!    print '(a)', '  "results": ['

    do
        call sqlite3_next_row (stmt, column, finished)
        if (sqlite3_error(db)) print *, sqlite3_error(db)
        
        if (finished) exit

        call sqlite3_get_column(column(1), first_name)
        call sqlite3_get_column(column(2), last_name)
        call sqlite3_get_column(column(3), id)

        if (associated(the_student)) deallocate(the_student)
        allocate(the_student)
        call the_student%initialize(first_name, last_name, id)
        call the_student%write_json(1)
        print '(a)', ','
    enddo
    if (associated(the_student)) deallocate(the_student)

    print '(a)', '  ]'
    call response%write_success_footer()

    call sqlite3_close (db)
end program api
