CLASS zcl_huc_tnpol_visit_category DEFINITION
  PUBLIC
  INHERITING FROM zcl_huc_tnpol
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CLASS-METHODS create
      IMPORTING
        iv_institution_id TYPE einri
        iv_patient_id     TYPE patnr
        iv_case_id        TYPE falnr
        iv_movement_id    TYPE lfdbew
        iv_dialog         TYPE nxfeld
        iv_event          TYPE ish_pol_calup
        io_messages       TYPE REF TO cl_ishmed_errorhandling OPTIONAL
      RETURNING
        VALUE(ri_result)  TYPE REF TO zif_huc_tnpol.

    METHODS zif_huc_tnpol~check REDEFINITION.
    METHODS zif_huc_tnpol~save REDEFINITION.
    METHODS zif_huc_tnpol~adjust REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS is_initial_visit
      RETURNING
        VALUE(rv_result) TYPE abap_bool.

    METHODS is_follow_up_visit
      RETURNING
        VALUE(rv_result) TYPE abap_bool.

ENDCLASS.



CLASS zcl_huc_tnpol_visit_category IMPLEMENTATION.


  METHOD create.

    ri_result =
        NEW zcl_huc_tnpol_visit_category(
          iv_institution_id = iv_institution_id
          iv_patient_id     = iv_patient_id
          iv_case_id        = iv_case_id
          iv_movement_id    = iv_movement_id
          iv_dialog         = iv_dialog
          iv_event          = iv_event
          io_messages       = io_messages ).

  ENDMETHOD.


  METHOD zif_huc_tnpol~check.

    DATA(ls_movement) = get_movement( ).

    IF is_initial_visit( ) = abap_false.
      RETURN.
    ENDIF.

    IF ls_movement-bwgr1 IS INITIAL.
      collect_message(
          iv_type   = 'E'
          iv_id     = zcx_huc=>movement_reason_empty_initial-msgid
          iv_number = zcx_huc=>movement_reason_empty_initial-msgno
          iv_field  = 'BWGR1' ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_huc_tnpol~save.

    DATA:
      lt_movements TYPE ish_t_nbew.

    IF is_follow_up_visit( ) = abap_false.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ISH_MOVEMENTTAB_POOL_GET'
      EXPORTING
        ss_falnr        = get_case_id( )
        ss_einri        = get_institution_id( )
      TABLES
        ss_nbewtab_curr = lt_movements.

    SORT lt_movements DESCENDING BY bwidt bwizt.

    TRY.
        DATA(ls_initial_visit) = lt_movements[ bewty = zif_huc_constants_movement=>gc_movement_category-visit
                                               bwart = zif_huc_constants_movement=>gc_movement_type-visit-initial ].
      CATCH cx_sy_itab_line_not_found.
        RETURN.
    ENDTRY.

    DATA(ls_movement) = get_movement( ).

    ls_movement-bwgr1 = ls_initial_visit-bwgr1.

    CALL FUNCTION 'ISH_MOVEMENT_POOL_SET'
      EXPORTING
        ss_falnr = ls_movement-falnr
        ss_einri = ls_movement-einri
        ss_lfdnr = ls_movement-lfdnr
        ss_nbew  = ls_movement.

  ENDMETHOD.


  METHOD zif_huc_tnpol~adjust.

    DATA:
      lt_assigned_persons TYPE ish_t_nfpz.

    IF is_follow_up_visit( ) = abap_false OR get_movement( )-bwgr1 IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ISH_CASE_TO_PERSON_POOL_GET'
      EXPORTING
        ss_falnr        = get_case_id( )
        ss_einri        = get_institution_id( )
      TABLES
        ss_nfpztab_curr = lt_assigned_persons.

    DELETE lt_assigned_persons WHERE lfdbw <> get_movement_id( )
                                 AND farzt <> zif_huc_constants_movement=>gc_assingment_type-attending_physician
                                 AND begdt  > get_movement( )-bwedt
                                 AND enddt  < get_movement( )-bwidt
                                 AND storn  = abap_true.

    IF lt_assigned_persons IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_assigned_persons INTO DATA(ls_attending_physician).

      cl_ish_dbr_gpa=>get_gpa_by_gpart(
        EXPORTING
          i_gpart = ls_attending_physician-pernr
        IMPORTING
          es_nadr = DATA(ls_address) ).

      IF ls_address-email IS INITIAL.
        CONTINUE.
      ENDIF.

      " Send email to ls_address-email

    ENDLOOP.

  ENDMETHOD.


  METHOD is_initial_visit.

    rv_result = xsdbool( is_visit( ) AND
                         get_movement( )-bwart = zif_huc_constants_movement=>gc_movement_type-visit-initial ).

  ENDMETHOD.


  METHOD is_follow_up_visit.

    rv_result = xsdbool( is_visit( ) AND
                         get_movement( )-bwart = zif_huc_constants_movement=>gc_movement_type-visit-follow_up ).

  ENDMETHOD.


ENDCLASS.
