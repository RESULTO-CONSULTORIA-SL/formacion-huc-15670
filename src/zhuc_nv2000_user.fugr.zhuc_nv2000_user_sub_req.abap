FUNCTION ZHUC_NV2000_USER_SUB_REQ.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_EINRI) TYPE  EINRI
*"     VALUE(I_PATNR) TYPE  PATNR
*"     VALUE(I_FALNR) TYPE  FALNR
*"     VALUE(I_LFDBEW) TYPE  LFDBEW
*"     VALUE(I_VCODE_NPAT) TYPE  ISH_VCODE
*"     VALUE(I_VCODE_NFAL) TYPE  ISH_VCODE
*"     VALUE(I_VCODE_NBEW) TYPE  ISH_VCODE
*"  TABLES
*"      ET_EMPTY_REQUIRED STRUCTURE  RNDYM_EMPTY_REQUIRED
*"----------------------------------------------------------------------
  DATA:
    lv_program_id    TYPE sy-repid,
    lv_dynpro_number TYPE sy-dynnr.

  " clear exporting
  REFRESH et_empty_required. CLEAR et_empty_required.

  " initialize screen data
  CALL FUNCTION 'ZHUC_NV2000_USER_SUBSCREEN'
    EXPORTING
      ss_einri  = i_einri
      ss_patnr  = i_patnr
      ss_falnr  = i_falnr
      ss_lfdbew = i_lfdbew
      ss_vcode  = gv_processing_mode
    IMPORTING
      ss_repid  = lv_program_id
      ss_dynnr  = lv_dynpro_number
    EXCEPTIONS
      error     = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  " check screen fields
  CALL FUNCTION 'ISH_DYNP_REQUIRED_FIELDS_CHECK'
    EXPORTING
      i_einri           = i_einri
      i_repid           = lv_program_id
      i_dynnr           = lv_dynpro_number
      i_vcode           = gv_processing_mode
    IMPORTING
      et_empty_required = et_empty_required[].

ENDFUNCTION.
