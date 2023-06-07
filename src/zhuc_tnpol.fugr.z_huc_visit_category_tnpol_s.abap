FUNCTION z_huc_visit_category_tnpol_s.
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
    lt_movement      TYPE ish_t_nbew,
    ls_movement      TYPE nbew,
    ls_movement_curr TYPE nbew.

  CALL FUNCTION 'ISH_MOVEMENT_POOL_GET'
    EXPORTING
      ss_falnr     = ss_falnr
      ss_einri     = ss_einri
      ss_lfdnr     = ss_lfdnr
    IMPORTING
      ss_nbew_curr = ls_movement_curr.

  IF ls_movement_curr-bwart <> zif_huc_constants_movement=>gc_movement_type-visit-follow_up OR
     ls_movement_curr-bwgr1 IS NOT INITIAL.
    RETURN.
  ENDIF.

  CALL FUNCTION 'ISH_MOVEMENTTAB_POOL_GET'
    EXPORTING
      ss_falnr        = ss_falnr
      ss_einri        = ss_einri
    TABLES
      ss_nbewtab_curr = lt_movement.

  SORT lt_movement ASCENDING BY bwidt bwizt.

  READ TABLE lt_movement INTO ls_movement
    WITH KEY bewty = zif_huc_constants_movement=>gc_movement_category-visit
             bwart = zif_huc_constants_movement=>gc_movement_type-visit-initial.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  ls_movement_curr-bwgr1 = ls_movement-bwgr1.

  CALL FUNCTION 'ISH_MOVEMENT_POOL_SET'
    EXPORTING
      ss_falnr = ss_falnr
      ss_einri = ss_einri
      ss_lfdnr = ss_lfdnr
      ss_nbew  = ls_movement_curr.

ENDFUNCTION.
