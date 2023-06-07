class ZCL_IM_ISH_NV2000_PBO definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ISH_NV2000_PBO .
protected section.
private section.

  methods PATIENT
    importing
      !I_INSTITUTION type EINRI
      !I_VCODE type TNDYM-VCODE
      !I_PATNR type PATNR
      !I_FALNR type FALNR
      !I_LFDNR type LFDBEW .
ENDCLASS.



CLASS ZCL_IM_ISH_NV2000_PBO IMPLEMENTATION.


  METHOD if_ex_ish_nv2000_pbo~modify_data.

    DATA:
      ls_patient TYPE npat.

    IF i_vcode = if_ish_gui_view=>co_vcode_display.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ISH_PATIENT_POOL_GET'
      EXPORTING
        ss_patnr     = i_patnr
        ss_einri     = i_institution
      IMPORTING
        ss_npat_curr = ls_patient.

    LOOP AT SCREEN.

*      IF screen-name CS 'SEX_SPECIAL' AND ls_patient-name2 = 'ASD'.
        screen-input = 0.
*      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.

*    CASE i_structure_name.
*      WHEN 'RNBADI_NAME'.
*    CALL METHOD patient
*      EXPORTING
*        i_institution = i_institution
*        i_vcode       = i_vcode
*        i_patnr       = i_patnr
*        i_falnr       = i_falnr
*        i_lfdnr       = i_lfdnr.
*
*    ENDCASE.

  ENDMETHOD.


  METHOD patient.

    DATA:
      ls_patient TYPE npat.

    IF i_vcode = if_ish_gui_view=>co_vcode_display.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ISH_PATIENT_POOL_GET'
      EXPORTING
        ss_patnr     = i_patnr
        ss_einri     = i_institution
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
