FUNCTION z_huc_visit_category_tnpol.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SS_EINRI) TYPE  EINRI
*"     VALUE(SS_PATNR) TYPE  PATNR
*"     VALUE(SS_FALNR) TYPE  FALNR
*"     VALUE(SS_LFDNR) TYPE  LFDBEW
*"     VALUE(SS_ACTION) TYPE  ISH_POL_ACTION
*"     VALUE(SS_DIALOG) TYPE  NXFELD
*"     VALUE(SS_CALUP) TYPE  ISH_POL_CALUP
*"  EXPORTING
*"     REFERENCE(SS_RETMAXTYPE) TYPE  ISH_BAPIRETMAXTY
*"  TABLES
*"      SS_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
  DATA(lo_messages) = NEW cl_ishmed_errorhandling( ).

  DATA(li_pool) =
    zcl_huc_tnpol_visit_category=>create(
          iv_institution_id = ss_einri
          iv_patient_id     = ss_patnr
          iv_case_id        = ss_falnr
          iv_movement_id    = ss_lfdnr
          iv_dialog         = ss_dialog
          iv_event          = ss_calup
          io_messages       = lo_messages ).

  CASE ss_action.
    WHEN 'C'.
      li_pool->check( ).

    WHEN 'S'.
      li_pool->save( ).

    WHEN 'A'.
      li_pool->adjust( ).

  ENDCASE.

  IF lo_messages IS BOUND.
    lo_messages->get_messages(
      IMPORTING
        t_messages = ss_return[]
        e_maxty    = ss_retmaxtype ).
  ENDIF.

ENDFUNCTION.
