FUNCTION ZHUC_NV2000_USER_SUBSCREEN.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SS_EINRI) TYPE  EINRI
*"     VALUE(SS_PATNR) TYPE  PATNR OPTIONAL
*"     VALUE(SS_FALNR) TYPE  FALNR
*"     VALUE(SS_LFDBEW) TYPE  LFDBEW OPTIONAL
*"     VALUE(SS_VCODE) TYPE  ISH_VCODE
*"     VALUE(SS_VCODE_NPAT) TYPE  ISH_VCODE OPTIONAL
*"     VALUE(SS_VCODE_NFAL) TYPE  ISH_VCODE OPTIONAL
*"     VALUE(SS_VCODE_NBEW) TYPE  ISH_VCODE OPTIONAL
*"     VALUE(SS_INFO) TYPE  ISH_ON_OFF OPTIONAL
*"  EXPORTING
*"     REFERENCE(SS_REPID) TYPE  SY-REPID
*"     REFERENCE(SS_DYNNR) TYPE  SY-DYNNR
*"     REFERENCE(SS_CURSOR) TYPE  ISH_CURSOR
*"     REFERENCE(SS_CURSOR_LIN) TYPE  SY-STEPL
*"     REFERENCE(SS_CURSOR_PRG) TYPE  SY-REPID
*"     REFERENCE(SS_CURSOR_DYN) TYPE  SY-DYNNR
*"  TABLES
*"      SS_INFO_TAB TYPE  NISH_SHORT_INFO_TAB OPTIONAL
*"  EXCEPTIONS
*"      ERROR
*"----------------------------------------------------------------------
  DATA:
    ls_patient TYPE npat.

  ss_repid      = sy-repid.
  ss_dynnr      = '0100'.
  ss_cursor     = 'RNPNT_UF-FELD1'.
  ss_cursor_lin = 0.

  IF gv_initialized = abap_true AND gv_processing_mode = ss_vcode.
    RETURN.
  ENDIF.

  gv_initialized = abap_true.

  gv_institution_id  = ss_einri.
  gv_patient_id      = ss_patnr.
  gv_processing_mode = ss_vcode.
  gv_change_allowed  = xsdbool( ss_vcode      <> if_ish_gui_view=>co_vcode_display
                            AND ss_vcode_npat <> if_ish_gui_view=>co_vcode_display ).

  CALL FUNCTION 'ISH_PATIENT_POOL_GET'
    EXPORTING
      ss_patnr     = gv_patient_id
      ss_einri     = gv_institution_id
    IMPORTING
      ss_npat_curr = ls_patient.

  gs_user_fields_db = CORRESPONDING #( ls_patient ).
  rnpnt_uf = gs_user_fields_db.

ENDFUNCTION.
