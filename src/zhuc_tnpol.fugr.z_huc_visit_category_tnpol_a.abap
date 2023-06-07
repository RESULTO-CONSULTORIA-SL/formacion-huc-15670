FUNCTION z_huc_visit_category_tnpol_a.
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

*  DATA:
*    ls_test TYPE zhuc_001.
*
*  ls_test-einri = ss_einri.
*  ls_test-falnr = ss_falnr.
*  ls_test-lfdbew = ss_lfdnr.
*  ls_test-texto = 'Ajuste'.
*
*  MODIFY zhuc_001 FROM ls_test.
*  COMMIT WORK AND WAIT.

  DATA:
    lt_movement TYPE ish_t_nbew,
    ls_movement TYPE nbew,
    lt_assign   TYPE ish_t_nfpz,
    ls_assign   LIKE LINE OF lt_assign,
    ls_address  TYPE nadr.

  CALL FUNCTION 'ISH_MOVEMENT_POOL_GET'
    EXPORTING
      ss_falnr     = ss_falnr
      ss_einri     = ss_einri
      ss_lfdnr     = ss_lfdnr
    IMPORTING
      ss_nbew_curr = ls_movement.

  IF ls_movement-bwart <> zif_huc_constants_movement=>gc_movement_type-visit-follow_up OR
     ls_movement-bwgr1 IS INITIAL.
    RETURN.
  ENDIF.

  CALL FUNCTION 'ISH_CASE_TO_PERSON_POOL_GET'
    EXPORTING
      ss_falnr        = ss_falnr
      ss_einri        = ss_einri
    TABLES
      ss_nfpztab_curr = lt_assign.

  DELETE lt_assign WHERE lfdbw <> ls_movement-lfdnr
                      OR farzt <> zif_huc_constants_movement=>gc_assingment_type-attending_physician.

  LOOP AT lt_assign INTO ls_assign.

    CALL METHOD cl_ish_dbr_gpa=>get_gpa_by_gpart
      EXPORTING
        i_gpart = ls_assign-pernr
      IMPORTING
        es_nadr = ls_address.

    IF ls_address-email IS INITIAL.
      CONTINUE.
    ENDIF.

    " Envío de email

  ENDLOOP.

ENDFUNCTION.
