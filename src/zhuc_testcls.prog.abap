*&---------------------------------------------------------------------*
*&  Include           ZHUC_TESTCLS
*&---------------------------------------------------------------------*
INTERFACE lif_test.

  METHODS update_task.

  METHODS get_pmd_data.

ENDINTERFACE.


CLASS lcl_test DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES lif_test.

    CLASS-METHODS create
      RETURNING
        VALUE(ri_result) TYPE REF TO lif_test.

ENDCLASS.


*&---------------------------------------------------------------------*
*&       Class (Implementation)  lcl_test
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS lcl_test IMPLEMENTATION.


  METHOD create.

    ri_result = NEW lcl_test( ).

  ENDMETHOD.


  METHOD lif_test~update_task.

    DATA:
      ls_movement TYPE nbew.

    ls_movement-einri = 'RSLT'.

    CALL FUNCTION 'ZZ_HUC_UPDATE_TEST' IN UPDATE TASK
      EXPORTING
        is_movement = ls_movement.

    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD lif_test~get_pmd_data.

    DATA:
      ls_document_key TYPE rn2doc_key,
      lo_services     TYPE REF TO cl_ishmed_pmd_services,
      ls_data         TYPE zpmd_test0010000000000000.

    ls_document_key-dokar = 'CLI'.
    ls_document_key-doknr = '0000000000000010000000178'.
    ls_document_key-doktl = '000'.
    ls_document_key-dokvr = '00'.

    lo_services = cl_ishmed_pmd_services=>api__open( ls_document_key ).

    lo_services->api__set_procmode_display( ).

    lo_services->api__get_value(
      EXPORTING
        i_alias = ':CONTENT'
      IMPORTING
        e_value = ls_data ).

    lo_services->api__close( ).

  ENDMETHOD.


ENDCLASS.               "lcl_test
