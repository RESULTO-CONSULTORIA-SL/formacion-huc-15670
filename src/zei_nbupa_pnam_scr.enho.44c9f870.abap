"Name: \PR:SAPLNBUPA_PNAM_SCR\FO:MODIFY_SCREEN\SE:END\EI
ENHANCEMENT 0 ZEI_NBUPA_PNAM_SCR.
  CALL METHOD zcl_huc_enh_nbupa_pnam_scr=>modify_screen
    EXPORTING
      iv_patient_id     = g_patnr
      iv_institution_id = g_instn.
ENDENHANCEMENT.
