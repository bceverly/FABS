module http_response_codes
    integer, parameter :: RESPONSE_OK           = 200
    integer, parameter :: RESPONSE_CREATED      = 201
    integer, parameter :: RESPONSE_NO_CONTENT   = 204
    integer, parameter :: RESPONSE_UNAUTHORIZED = 401
    integer, parameter :: RESPONSE_FORBIDDEN    = 403
    integer, parameter :: RESPONSE_NOT_FOUND    = 404
    integer, parameter :: INTERNAL_SERVER_ERROR = 500
end module http_response_codes
