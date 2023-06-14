*&---------------------------------------------------------------------*
*& Report ZHUC_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhuc_test.

INCLUDE zhuc_testcls.

START-OF-SELECTION.
  PERFORM start.

FORM start.

  DATA:
    li_test TYPE REF TO lif_test.

  li_test = lcl_test=>create( ).

  li_test->get_pmd_data( ).

ENDFORM.
