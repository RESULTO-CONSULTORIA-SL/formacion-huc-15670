FUNCTION ZHUC_NV2000_USER_SUB_OUTPUT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(SS_CURSOR) TYPE  ISH_CURSOR
*"     VALUE(SS_CURSOR_OFF) TYPE  SY-CUCOL
*"     VALUE(SS_CURSOR_LIN) TYPE  SY-STEPL
*"     VALUE(SS_CURSOR_PRG) TYPE  SY-REPID
*"     VALUE(SS_CURSOR_DYN) TYPE  SY-DYNNR
*"     VALUE(SS_CURSOR_FORCE) TYPE  ISH_TRUE_FALSE
*"  CHANGING
*"     REFERENCE(SS_OKCODE) TYPE  SY-UCOMM OPTIONAL
*"----------------------------------------------------------------------
  PERFORM pool_to_dynpro.

ENDFUNCTION.
