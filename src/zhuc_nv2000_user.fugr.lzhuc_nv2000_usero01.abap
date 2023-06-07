*----------------------------------------------------------------------*
***INCLUDE LZHUC_NV2000_USERO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.

  CALL FUNCTION 'ISH_MODIFY_SCREEN'
    EXPORTING
      einri                 = gv_institution_id
      pname                 = sy-repid
      dynnr                 = sy-dynnr
      vcode                 = gv_processing_mode
      set_cursor            = abap_true
      no_tndym_cursor       = abap_true.

ENDMODULE.
