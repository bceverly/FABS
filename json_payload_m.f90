module json_payload_m
    use http_response_m
    use http_response_codes
    use http_content_types

    implicit none
    private

    type, public, extends(http_response_t) :: json_payload_t
        private

        contains

    end type json_payload_t

contains

end module json_payload_m
