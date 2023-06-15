*&---------------------------------------------------------------------*
*&  Include           ZHUC_TESTCLS
*&---------------------------------------------------------------------*
INTERFACE lif_test.

  METHODS update_task.

  METHODS get_pmd_data.

  METHODS display_alv.

  METHODS ish_ga_gv.

ENDINTERFACE.


CLASS lcl_test DEFINITION FINAL.

  PUBLIC SECTION.
    INTERFACES lif_test.

    CLASS-METHODS create
      RETURNING
        VALUE(ri_result) TYPE REF TO lif_test.

  PRIVATE SECTION.
    DATA:
      mo_salv_table TYPE REF TO cl_salv_table,
      mt_movements  TYPE ish_t_nbew.

    METHODS on_link_click
        FOR EVENT link_click OF cl_salv_events_table
      IMPORTING
        row
        column
        sender.

    METHODS on_user_command
        FOR EVENT added_function OF cl_salv_events
      IMPORTING
        e_salv_function
        sender.

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


  METHOD lif_test~display_alv.

    DATA:
      lo_column TYPE REF TO cl_salv_column_table.
    FIELD-SYMBOLS:
      <ls_column> TYPE salv_s_column_ref.

    SELECT *
      FROM nbew
      WHERE einri = 'RSLT'
        AND falnr = '1000000000'
      INTO TABLE @mt_movements.

    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = mo_salv_table
      CHANGING
        t_table      = mt_movements.

    mo_salv_table->set_screen_status(
        report   = sy-repid
        pfstatus = 'SALV_TABLE_STANDARD' ).

    DATA(lo_functions) = mo_salv_table->get_functions( ).

    lo_functions->set_all( ).

    DATA(lt_functions) = lo_functions->get_functions( ).

    LOOP AT lt_functions ASSIGNING FIELD-SYMBOL(<ls_function>).

      IF <ls_function>-r_function->get_name( ) = 'ZZ_TEST'.
        <ls_function>-r_function->set_visible( abap_false ).
      ENDIF.

    ENDLOOP.

    DATA(lo_columns) = mo_salv_table->get_columns( ).

    DATA(lt_columns) = lo_columns->get( ).

    LOOP AT lt_columns ASSIGNING <ls_column>.

      CASE <ls_column>-columnname.
        WHEN 'MANDT'.
          <ls_column>-r_column->set_technical( ).

        WHEN 'EINRI'.
          <ls_column>-r_column->set_short_text( 'CS' ).
          <ls_column>-r_column->set_medium_text( 'CenSan' ).
          <ls_column>-r_column->set_long_text( 'Centro Sanitario' ).

        WHEN 'FALNR'.
          <ls_column>-r_column->set_short_text( 'Ep' ).
          <ls_column>-r_column->set_medium_text( 'EPi' ).
          <ls_column>-r_column->set_long_text( 'Episodio' ).

        WHEN 'LFDNR'.
          <ls_column>-r_column->set_short_text( 'NºM' ).
          <ls_column>-r_column->set_medium_text( 'NºMov' ).
          <ls_column>-r_column->set_long_text( 'Número de movimiento' ).

          lo_column ?= <ls_column>-r_column.

          lo_column->set_cell_type( if_salv_c_cell_type=>hotspot ).

        WHEN OTHERS.
          <ls_column>-r_column->set_visible( if_salv_c_bool_sap=>false ).

      ENDCASE.

    ENDLOOP.

    DATA(lo_selections) = mo_salv_table->get_selections( ).

    lo_selections->set_selection_mode( if_salv_c_selection_mode=>multiple ).

    DATA(lo_events) = mo_salv_table->get_event( ).

    SET HANDLER on_link_click FOR lo_events.
    SET HANDLER on_user_command FOR lo_events.

    mo_salv_table->display( ).

  ENDMETHOD.


  METHOD on_link_click.

    READ TABLE mt_movements INDEX row INTO DATA(ls_movement).

  ENDMETHOD.


  METHOD on_user_command.

    DATA(lo_selections) = mo_salv_table->get_selections( ).

    DATA(lt_rows) = lo_selections->get_selected_rows( ).

  ENDMETHOD.


  METHOD lif_test~ish_ga_gv.

*    zcl_ish_ga_pat_case_list=>run_trx( ).

  ENDMETHOD.


ENDCLASS.               "lcl_test
