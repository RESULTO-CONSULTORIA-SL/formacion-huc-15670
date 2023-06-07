FUNCTION-POOL zhuc_nv2000_user.             "MESSAGE-ID ..

* INCLUDE LZHUC_NV2000_USERD...              " Local class definition

TABLES:
  rnpnt_uf.

DATA:
  gv_initialized     TYPE abap_bool,
  gv_processing_mode TYPE ish_vcode,
  gv_change_allowed  TYPE abap_bool,
  gv_institution_id  TYPE einri,
  gv_patient_id      TYPE patnr,
  gs_user_fields_db  TYPE rnpnt_uf.
