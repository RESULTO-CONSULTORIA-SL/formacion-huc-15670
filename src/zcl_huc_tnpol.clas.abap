CLASS zcl_huc_tnpol DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_huc_tnpol ALL METHODS ABSTRACT.

    METHODS constructor
      IMPORTING
        iv_institution_id TYPE einri
        iv_patient_id     TYPE patnr
        iv_case_id        TYPE falnr
        iv_movement_id    TYPE lfdbew
        iv_dialog         TYPE nxfeld
        iv_event          TYPE ish_pol_calup
        io_messages       TYPE REF TO cl_ishmed_errorhandling OPTIONAL.

  PROTECTED SECTION.
    METHODS get_institution_id FINAL
      RETURNING
        VALUE(rv_result) TYPE einri.

    METHODS get_patient_id FINAL
      RETURNING
        VALUE(rv_result) TYPE patnr.

    METHODS get_case_id FINAL
      RETURNING
        VALUE(rv_result) TYPE falnr.

    METHODS get_movement_id FINAL
      RETURNING
        VALUE(rv_result) TYPE lfdbew.

    METHODS get_dialog FINAL
      RETURNING
        VALUE(rv_result) TYPE nxfeld.

    METHODS get_event FINAL
      RETURNING
        VALUE(rv_result) TYPE ish_pol_calup.

    METHODS get_case FINAL
      RETURNING
        VALUE(rs_result) TYPE nfal.

    METHODS get_movement FINAL
      RETURNING
        VALUE(rs_result) TYPE nbew.

    METHODS is_visit FINAL
      RETURNING
        VALUE(rv_result) TYPE abap_bool.

    METHODS collect_message FINAL
      IMPORTING
        iv_type      TYPE sy-msgty DEFAULT 'E'
        iv_id        TYPE sy-msgid
        iv_number    TYPE sy-msgno
        iv_variable1 TYPE any OPTIONAL
        iv_variable2 TYPE any OPTIONAL
        iv_variable3 TYPE any OPTIONAL
        iv_variable4 TYPE any OPTIONAL
        iv_field     TYPE bapiret2-field OPTIONAL.

  PRIVATE SECTION.
    DATA:
      mv_institution_id TYPE einri,
      mv_patient_id     TYPE patnr,
      mv_case_id        TYPE falnr,
      mv_movement_id    TYPE lfdbew,
      mv_dialog         TYPE nxfeld,
      mv_event          TYPE ish_pol_calup,
      mo_messages       TYPE REF TO cl_ishmed_errorhandling.

ENDCLASS.



CLASS ZCL_HUC_TNPOL IMPLEMENTATION.


  METHOD collect_message.

    IF mo_messages IS NOT BOUND.
      RETURN.
    ENDIF.

    mo_messages->collect_messages(
        i_typ   = iv_type
        i_kla   = iv_id
        i_num   = iv_number
        i_mv1   = iv_variable1
        i_mv2   = iv_variable2
        i_mv3   = iv_variable3
        i_mv4   = iv_variable3
        i_fld   = iv_field
        i_einri = get_institution_id( ) ).

  ENDMETHOD.


  METHOD constructor.

    mv_institution_id = iv_institution_id.
    mv_patient_id     = iv_patient_id.
    mv_case_id        = iv_case_id.
    mv_movement_id    = iv_movement_id.
    mv_dialog         = iv_dialog.
    mv_event          = iv_event.
    mo_messages       = io_messages.

  ENDMETHOD.


  METHOD get_case.

    CALL FUNCTION 'ISH_CASE_POOL_GET'
      EXPORTING
        ss_falnr     = get_case_id( )
        ss_einri     = get_institution_id( )
      IMPORTING
        ss_nfal_curr = rs_result.

  ENDMETHOD.


  METHOD get_case_id.

    rv_result = mv_case_id.

  ENDMETHOD.


  METHOD get_dialog.

    rv_result = mv_dialog.

  ENDMETHOD.


  METHOD get_event.

    rv_result = mv_event.

  ENDMETHOD.


  METHOD get_institution_id.

    rv_result = mv_institution_id.

  ENDMETHOD.


  METHOD get_movement.

    CALL FUNCTION 'ISH_MOVEMENT_POOL_GET'
      EXPORTING
        ss_falnr     = get_case_id( )
        ss_einri     = get_institution_id( )
        ss_lfdnr     = get_movement_id( )
      IMPORTING
        ss_nbew_curr = rs_result.

  ENDMETHOD.


  METHOD get_movement_id.

    rv_result = mv_movement_id.

  ENDMETHOD.


  METHOD get_patient_id.

    rv_result = mv_patient_id.

  ENDMETHOD.


  METHOD is_visit.

    rv_result = xsdbool( get_movement( )-bewty = zif_huc_constants_movement=>gc_movement_category-visit ).

  ENDMETHOD.
ENDCLASS.
