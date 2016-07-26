module xml_payload_m
    use http_response_m
    use http_response_codes
    use http_content_types

    implicit none
    private

    type, public, extends(http_response_t) :: xml_payload_t
        private

        contains

    end type xml_payload_t

contains

end module xml_payload_m
