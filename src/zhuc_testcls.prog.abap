*&---------------------------------------------------------------------*
*&  Include           ZHUC_TESTCLS
*&---------------------------------------------------------------------*
INTERFACE lif_test.

  METHODS update_task.

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


ENDCLASS.               "lcl_test
