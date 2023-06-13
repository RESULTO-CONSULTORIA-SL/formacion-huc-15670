CLASS zcl_im_huc_n1patorg_append DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_n1patorg_append .
  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_popup_position,
        start_column LIKE  sy-cucol,
        start_row    LIKE  sy-curow,
        end_column   LIKE  sy-cucol,
        end_row      LIKE  sy-curow,
      END OF ty_popup_position.

    METHODS display_services
      IMPORTING
        iv_institution_id TYPE einri
        iv_case_id        TYPE falnr
        io_patorg         TYPE REF TO cl_ishmed_patorg.

    CLASS-METHODS center_alv
      IMPORTING
        !iv_width          TYPE i
        !iv_height         TYPE i
      RETURNING
        VALUE(rs_position) TYPE ty_popup_position.

ENDCLASS.



CLASS zcl_im_huc_n1patorg_append IMPLEMENTATION.


  METHOD if_ex_n1patorg_append~execute_append.

    DATA:
      lb_badi TYPE REF TO cl_def_im_n1patorg_append.

    CREATE OBJECT lb_badi.

    CALL METHOD lb_badi->if_ex_n1patorg_append~execute_append
      EXPORTING
        i_vnlem         = i_vnlem
        i_nlei          = i_nlei
        i_nbew          = i_nbew
        i_ntmn          = i_ntmn
        i_ndoc          = i_ndoc
        i_ndia          = i_ndia
        i_n1anf         = i_n1anf
        i_nicp          = i_nicp
        i_n1corder      = i_n1corder
        i_n1vkg         = i_n1vkg
        i_n1meorder     = i_n1meorder
        i_n1strucmedrec = i_n1strucmedrec
        i_n2vdnote      = i_n2vdnote
        i_nldbc_005     = i_nldbc_005
        i_path          = i_path
        i_phyo          = i_phyo
        i_n1srv         = i_n1srv
        i_ucomm         = i_ucomm
        ir_patorg       = ir_patorg.

    CASE i_ucomm.
      WHEN 'ZTEST'.
        display_services( iv_institution_id = i_nbew-einri iv_case_id = i_nbew-falnr io_patorg = ir_patorg ).

    ENDCASE.

  ENDMETHOD.


  METHOD if_ex_n1patorg_append~fill_sort.

    DATA:
      lb_badi TYPE REF TO cl_def_im_n1patorg_append.
    FIELD-SYMBOLS:
      <ls_line> LIKE LINE OF ct_supply.

    CREATE OBJECT lb_badi.

    lb_badi->if_ex_n1patorg_append~fill_sort(
      EXPORTING
        i_viewid   = i_viewid
        i_wplaceid = i_wplaceid
        ir_patorg  = ir_patorg
      CHANGING
        ct_supply  = ct_supply ).

    LOOP AT ct_supply ASSIGNING <ls_line>.

      CASE <ls_line>-objecttype.
        WHEN 'PDS'.
          CALL FUNCTION 'ICON_CREATE'
            EXPORTING
              name   = icon_print
              text   = 'Nota'
              info   = 'Nota de evolución'
            IMPORTING
              result = <ls_line>-zz_test_icon
            EXCEPTIONS
              OTHERS = 0.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ex_n1patorg_append~select.
  ENDMETHOD.


  METHOD display_services.

    TYPES:
      BEGIN OF lty_service,
        service_id      TYPE lnrls,
        service_code    TYPE tarls,
        service_catalog TYPE tarid,
        service_name    TYPE ish_conc_ktxt,
      END OF lty_service,
      lty_services TYPE STANDARD TABLE OF lty_service WITH KEY service_id.

    DATA:
      lt_services_display TYPE lty_services,
      ls_service_display  LIKE LINE OF lt_services_display,
      lo_errorhandler     TYPE REF TO cl_ishmed_errorhandling.

    SELECT lnrls,leist,haust
      FROM nlei
      WHERE einri = @iv_institution_id
        AND falnr = @iv_case_id
      INTO TABLE @DATA(lt_services).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT lt_services ASSIGNING FIELD-SYMBOL(<ls_service>).
      CLEAR ls_service_display.

      ls_service_display-service_id      = <ls_service>-lnrls.
      ls_service_display-service_code    = <ls_service>-leist.
      ls_service_display-service_catalog = <ls_service>-haust.

      CALL FUNCTION 'ISH_READ_NTPT'
        EXPORTING
          einri     = iv_institution_id
          talst     = <ls_service>-leist
          tarif     = <ls_service>-haust
        IMPORTING
          ktxtconc  = ls_service_display-service_name
        EXCEPTIONS
          not_found = 1                " Service description not found
          OTHERS    = 2.
      IF sy-subrc <> 0.
        ls_service_display-service_name = 'No text found for service'(001).
      ENDIF.

      INSERT ls_service_display INTO TABLE lt_services_display.

    ENDLOOP.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table   = DATA(lo_salv_table)
          CHANGING
            t_table        = lt_services_display ).
      CATCH cx_salv_msg INTO DATA(lx_salv_message).

        cl_ish_utl_base=>collect_messages_by_exception(
          EXPORTING
            i_exceptions    = lx_salv_message
          CHANGING
            cr_errorhandler = lo_errorhandler ).

        lo_errorhandler->get_messages(
          IMPORTING
            t_extended_msg  = DATA(lt_messages) ).

        io_patorg->error_handling( t_messages = lt_messages ).

        RETURN.

    ENDTRY.

    DATA(ls_position) = center_alv( iv_width  = 90 iv_height = 10 ).

    lo_salv_table->set_screen_popup( start_column = ls_position-start_column
                                     end_column   = ls_position-end_column
                                     start_line   = ls_position-start_row
                                     end_line     = ls_position-end_row ).

    lo_salv_table->display( ).

  ENDMETHOD.


  METHOD center_alv.

    CONSTANTS:
      lc_min_size TYPE i VALUE 10,
      lc_min_pos  TYPE i VALUE 5.

    " Magic math to approximate starting position of popup
    IF sy-scols > lc_min_size AND iv_width > 0 AND sy-scols > iv_width.
      rs_position-start_column = nmax(
        val1 = ( sy-scols - iv_width ) / 2
        val2 = lc_min_pos ).
    ELSE.
      rs_position-start_column = lc_min_pos.
    ENDIF.

    IF sy-srows > lc_min_size AND iv_height > 0 AND sy-srows > iv_height.
      rs_position-start_row = nmax(
        val1 = ( sy-srows - iv_height ) / 2 - 1
        val2 = lc_min_pos ).
    ELSE.
      rs_position-start_row = lc_min_pos.
    ENDIF.

    rs_position-end_column = rs_position-start_column + iv_width.
    rs_position-end_row = rs_position-start_row + iv_height.

  ENDMETHOD.


ENDCLASS.
