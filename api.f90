program api
    character(len=4096) :: path_info, request_method

    call get_environment_variable("PATH_INFO", path_info)
    call get_environment_variable("REQUEST_METHOD", request_method)

    print '(a)', 'Content-type: application/json'
    print '(a)', 'Status: 200'
    print '(a)', ''
    print '(a)', '{'
    print '(a)', '  "status": "success",'
    print '(a)', '  "count": 1,'
    print '(a)', '  "type": "person",'
    print '(a)', '  "results": [ {'
    print '(a)', '    "first_name": "Joe",'
    print '(a)', '    "last_name": "Smith",'
    print '(a)', '    "age": 42'
    print '(a)', '  }]'
    print '(a)', '}'
end program api
