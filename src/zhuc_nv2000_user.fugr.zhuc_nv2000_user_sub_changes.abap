FUNCTION zhuc_nv2000_user_sub_changes.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(SS_CHANGES) TYPE  ISH_TRUE_FALSE
*"----------------------------------------------------------------------
  ss_changes = xsdbool( gs_user_fields_db <> rnpnt_uf ).


ENDFUNCTION.
