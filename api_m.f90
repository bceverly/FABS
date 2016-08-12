module api_m
    use attribute_value_pair_m
    use http_request_m
    use http_response_m
    use http_response_codes
    use object_parser_m
    use json_parser_m
    use xml_parser_m
    use persistent_object_m
    use persistent_collection_m
    use string_utils

    implicit none
    private
        type(json_parser_t), target :: json_parser
        type(xml_parser_t), target :: xml_parser

    type, public :: api_t
        private
            type(http_request_t), pointer :: request_m
            class(http_response_t), pointer :: response_m
            class(object_parser_t), pointer :: parser_m
            class(persistent_object_t), pointer :: object_m
            class(persistent_collection_t), pointer :: collection_m

        contains
            procedure, public, pass(this) :: set_response, &
                                             set_request, &
                                             set_object, &
                                             set_collection, &
                                             get_valid_id, &
                                             parse_and_map, &
                                             get, &
                                             get_one, &
                                             get_all, &
                                             delete, &
                                             post, &
                                             put
    end type api_t
contains
   subroutine set_request(this, request)
        class(api_t), intent(inout) :: this
        type(http_request_t), pointer, intent(inout) :: request

        this%request_m => request
        if (request%get_content_type() == 'application/xml') then
            this%parser_m => xml_parser
        else
            this%parser_m => json_parser
        end if
    end subroutine set_request

    subroutine set_response(this, response)
        class(api_t), intent(inout) :: this
        class(http_response_t), target, intent(in) :: response

        this%response_m => response
    end subroutine set_response

    subroutine set_object(this, object)
        class(api_t), intent(inout) :: this
        class(persistent_object_t), target, intent(in) :: object

        this%object_m => object
    end subroutine set_object

    subroutine set_collection(this, collection)
        class(api_t), intent(inout) :: this
        class(persistent_collection_t), target, intent(in) :: collection

        this%collection_m => collection
    end subroutine set_collection

    subroutine get_valid_id(this, id, is_valid)
        class(api_t), intent(inout) :: this
        integer, intent(out) :: id
        logical, intent(out) :: is_valid

        type(attribute_value_pair_t), dimension(:), pointer :: qs
        integer :: status_val

        is_valid = .false.
        call this%request_m%get_query_strings(qs)

        if (size(qs) == 1) then
            if (qs(1)%the_attribute == 'id') then
                call str2int(qs(1)%the_value, id, status_val)
                if (status_val == 0) then
                    is_valid = .true.
                end if
            end if
        end if
    end subroutine get_valid_id

    subroutine parse_and_map(this, the_object, is_valid)
        class(api_t), intent(inout) :: this
        class(persistent_object_t), intent(inout) :: the_object
        logical, intent(out) :: is_valid

        integer :: i

        call this%parser_m%parse(this%request_m%get_request_body())
        if (this%parser_m%error_m) then
            is_valid = .false.
        else
            is_valid = .true.
            call the_object%map_from_data(this%parser_m%attribute_value_pairs_m)
        end if
    end subroutine parse_and_map

    subroutine get(this)
        class(api_t), intent(inout) :: this

        if (len_trim(this%request_m%get_query_string()) /= 0) then
            call this%get_one()
        else
            call this%get_all()
        end if
    end subroutine get

    subroutine get_one(this)
        class(api_t), intent(inout) :: this

        integer :: id
        logical :: is_valid

        call this%get_valid_id(id, is_valid)

        if (is_valid) then
            call this%collection_m%read_one(id)
            if (this%collection_m%get_collection_size() == 1) then
                call this%response_m%set_response_status(RESPONSE_OK)
                call this%response_m%write_success(this%collection_m)
                return
            end if
        end if
        call this%response_m%set_response_status(RESPONSE_NOT_FOUND)
        call this%response_m%write_error('Valid object ID required')
    end subroutine get_one

    subroutine get_all(this)
        class(api_t), intent(inout) :: this

        call this%response_m%set_response_status(RESPONSE_OK)
        call this%collection_m%read_all()
        call this%response_m%write_success(this%collection_m)
    end subroutine get_all

    subroutine delete(this)
        class(api_t), intent(inout) :: this

        integer :: id
        logical :: is_valid
        type(persistent_object_t) :: the_object

        call this%get_valid_id(id, is_valid)

        if (is_valid) then
            call this%collection_m%read_one(id)
            if (this%collection_m%get_collection_size() == 1) then
                call the_object%delete_by_id(id)
                call this%response_m%set_response_status(RESPONSE_OK)
                call this%response_m%write_success(this%collection_m)
                return
            end if
        end if
        call this%response_m%set_response_status(RESPONSE_NOT_FOUND)
        call this%response_m%write_error('Valid object ID required')
    end subroutine delete

    subroutine post(this, the_object)
        class(api_t), intent(inout) :: this
        class(persistent_object_t), intent(inout) :: the_object

        integer :: id
        logical :: is_valid

        call this%get_valid_id(id, is_valid)

        if (is_valid) then
            call this%parse_and_map(the_object, is_valid)

            if (is_valid) then
                the_object%id_m = id
                call the_object%update_existing()
                call this%collection_m%read_one(id)
                if (this%collection_m%get_collection_size() == 1) then
                    call this%response_m%set_response_status(RESPONSE_OK)
                    call this%response_m%write_success(this%collection_m)
                    return
                end if
            else
                call this%response_m%set_response_status( &
                    INTERNAL_SERVER_ERROR)
                call this%response_m%write_error('Invalid data')
                return
            end if
        end if
        call this%response_m%set_response_status(RESPONSE_NOT_FOUND)
        call this%response_m%write_error('Valid object ID required')
    end subroutine post

    subroutine put(this, the_object)
        class(api_t), intent(inout) :: this
        class(persistent_object_t), intent(inout) :: the_object

        integer :: id
        logical :: is_valid

        call this%parse_and_map(the_object, is_valid)

        if (is_valid) then
            id = the_object%create_new()
            call this%collection_m%read_one(id)
            if (this%collection_m%get_collection_size() == 1) then
                call this%response_m%set_response_status(RESPONSE_OK)
                call this%response_m%write_success(this%collection_m)
                return
            end if
        end if

        call this%response_m%set_response_status(INTERNAL_SERVER_ERROR)
        call this%response_m%write_error('Invalid data')
    end subroutine put

end module api_m
