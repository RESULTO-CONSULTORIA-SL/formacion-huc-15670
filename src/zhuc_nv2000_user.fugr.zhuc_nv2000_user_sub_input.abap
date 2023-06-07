FUNCTION ZHUC_NV2000_USER_SUB_INPUT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(SS_EXIT) TYPE  ISH_ON_OFF DEFAULT ABAP_FALSE
*"  CHANGING
*"     REFERENCE(SS_OKCODE) TYPE  SY-UCOMM
*"----------------------------------------------------------------------
  PERFORM dynpro_to_pool.

ENDFUNCTION.
