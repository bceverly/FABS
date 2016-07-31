module attribute_value_pair_m
    implicit none
    private

    type, public :: attribute_value_pair_t
        character(len=80) :: the_attribute
        character(len=80) :: the_value
    end type attribute_value_pair_t

contains

end module attribute_value_pair_m
