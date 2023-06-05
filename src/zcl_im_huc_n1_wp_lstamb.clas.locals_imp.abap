CLASS lcl_adjust_view IMPLEMENTATION.


  METHOD adjust_view_field.

    super->adjust_view_field( CHANGING cs_field = cs_field ).

    CASE cs_field-fieldname.
      WHEN zif_huc_constants_cws=>gc_fieldname-number_of_cases.
        cs_field-hotspot = abap_false.


    ENDCASE.

  ENDMETHOD.


ENDCLASS.
