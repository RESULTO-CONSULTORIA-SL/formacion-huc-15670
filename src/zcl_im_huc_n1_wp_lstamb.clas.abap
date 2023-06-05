CLASS zcl_im_huc_n1_wp_lstamb DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_ex_n1_wp_lstamb.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
      mo_environment TYPE REF TO cl_ish_environment.

    DATA:
      BEGIN OF gs_display,
        number_of_cases TYPE abap_bool,
      END OF gs_display.

    METHODS initialize.

    METHODS end.

    METHODS determine_display
      IMPORTING
        it_dispvar TYPE lvc_t_fcat.

    METHODS get_number_of_cases
      IMPORTING
        iv_institution_id TYPE einri
        iv_patient_id     TYPE falnr
      RETURNING
        VALUE(rv_result)  TYPE i.

ENDCLASS.



CLASS zcl_im_huc_n1_wp_lstamb IMPLEMENTATION.


  METHOD if_ex_n1_wp_lstamb~exit_display.

    initialize( ).

    determine_display( dispvar ).

    new_t_lststelle_list = old_t_lststelle_list.

    LOOP AT new_t_lststelle_list ASSIGNING FIELD-SYMBOL(<ls_list>).

      <ls_list>-zz_number_of_cases =
        get_number_of_cases(
            iv_institution_id = <ls_list>-einri
            iv_patient_id     = <ls_list>-patnr ).

    ENDLOOP.

    end( ).

    p_done = xsdbool( new_t_lststelle_list <> old_t_lststelle_list ).

  ENDMETHOD.


  METHOD if_ex_n1_wp_lstamb~exit_function.

    RAISE fcode_not_implemented.

  ENDMETHOD.


  METHOD initialize.

    cl_ish_fac_environment=>create( EXPORTING i_program_name = sy-repid
                                    IMPORTING e_instance     = mo_environment ).

    NEW lcl_adjust_view( )->/rslt/if_ish_cws_view_adjust~fieldcatalog( ).

  ENDMETHOD.


  METHOD end.

    IF mo_environment IS BOUND.
      mo_environment->destroy( ).
      CLEAR mo_environment.
    ENDIF.

  ENDMETHOD.


  METHOD determine_display.

    CLEAR gs_display.

    gs_display-number_of_cases =
        xsdbool( line_exists( it_dispvar[ fieldname = zif_huc_constants_cws=>gc_fieldname-number_of_cases
                                          no_out    = abap_false ] ) ).

  ENDMETHOD.


  METHOD get_number_of_cases.

    IF gs_display-number_of_cases = abap_false.
      RETURN.
    ENDIF.

    cl_ishmed_run_dp=>read_cases_for_patient( EXPORTING i_einri       = iv_institution_id
                                                        i_patnr       = iv_patient_id
                                                        i_environment = mo_environment
                                              IMPORTING et_nfal       = DATA(lt_cases) ).

    rv_result = lines( lt_cases ).

  ENDMETHOD.


ENDCLASS.
