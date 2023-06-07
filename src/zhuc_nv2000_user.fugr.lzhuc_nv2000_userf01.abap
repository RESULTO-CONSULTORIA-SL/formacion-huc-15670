FORM pool_to_dynpro.

  DATA:
    ls_patient TYPE npat.

  CALL FUNCTION 'ISH_PATIENT_POOL_GET'
    EXPORTING
      ss_patnr     = gv_patient_id
      ss_einri     = gv_institution_id
    IMPORTING
      ss_npat_curr = ls_patient.

  rnpnt_uf = CORRESPONDING #( ls_patient ).

ENDFORM.


FORM dynpro_to_pool.

  IF gv_change_allowed = abap_false.
    RETURN.
  ENDIF.

ENDFORM.
