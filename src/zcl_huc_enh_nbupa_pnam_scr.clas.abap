class ZCL_HUC_ENH_NBUPA_PNAM_SCR definition
  public
  final
  create public .

public section.

  class-methods MODIFY_SCREEN
    importing
      !IV_PATIENT_ID type PATNR
      !IV_INSTITUTION_ID type EINRI .
protected section.
private section.
ENDCLASS.



CLASS ZCL_HUC_ENH_NBUPA_PNAM_SCR IMPLEMENTATION.


  METHOD modify_screen.

    DATA:
      ls_patient TYPE npat.

*    IF i_vcode = if_ish_gui_view=>co_vcode_display.
*      RETURN.
*    ENDIF.

    CALL FUNCTION 'ISH_PATIENT_POOL_GET'
      EXPORTING
        ss_patnr     = iv_patient_id
        ss_einri     = iv_institution_id
      IMPORTING
        ss_npat_curr = ls_patient.

    LOOP AT SCREEN.

      IF screen-name CS 'SEX_SPECIAL' AND ls_patient-name2 = 'ASD'.
        screen-input = 0.
      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
