FUNCTION z_huc_visit_category_tnpol_c.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     REFERENCE(SS_EINRI) TYPE  EINRI
*"     REFERENCE(SS_PATNR) TYPE  PATNR
*"     REFERENCE(SS_FALNR) TYPE  FALNR
*"     REFERENCE(SS_LFDNR) TYPE  LFDBEW
*"     REFERENCE(SS_ACTION) TYPE  ISH_POL_ACTION
*"     REFERENCE(SS_DIALOG) TYPE  NXFELD
*"     REFERENCE(SS_CALUP) TYPE  ISH_POL_CALUP
*"  EXPORTING
*"     REFERENCE(SS_RETMAXTYPE) TYPE  ISH_BAPIRETMAXTY
*"  TABLES
*"      SS_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  DATA:
    ls_movement TYPE nbew,
    ls_message  LIKE LINE OF ss_return.

  CALL FUNCTION 'ISH_MOVEMENT_POOL_GET'
    EXPORTING
      ss_falnr     = ss_falnr
      ss_einri     = ss_einri
      ss_lfdnr     = ss_lfdnr
    IMPORTING
      ss_nbew_curr = ls_movement.

  IF ls_movement-bwart <> zif_huc_constants_movement=>gc_movement_type-visit-initial OR
     ls_movement-bwgr1 IS NOT INITIAL.
    RETURN.
  ENDIF.

  ss_retmaxtype = 'E'.

  ls_message-type   = 'E'.
  ls_message-id     = zcx_huc=>movement_reason_empty_initial-msgid.
  ls_message-number = zcx_huc=>movement_reason_empty_initial-msgno.
  ls_message-field  = 'BWGR1'.

  INSERT ls_message INTO TABLE ss_return.

ENDFUNCTION.
