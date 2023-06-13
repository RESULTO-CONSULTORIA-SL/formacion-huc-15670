CLASS zcl_im_huc_patorg_context DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_ishmed_patorg_context .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im_huc_patorg_context IMPLEMENTATION.


  METHOD if_ex_ishmed_patorg_context~change_context_menu.

    DATA:
      lt_functions TYPE ui_funcattr,
      lv_object    TYPE string,
      lv_function  TYPE string.
    FIELD-SYMBOLS:
      <ls_function> LIKE LINE OF lt_functions.

    cr_menu->add_separator( ).

    cr_menu->add_function(
        fcode = 'MOVEMENT ZTEST'
        text  = 'Mostrar prestaciones' ).

*    cr_menu->get_functions( IMPORTING fcodes = lt_functions ).
*
*    LOOP AT lt_functions ASSIGNING <ls_function>.
*
*      SPLIT <ls_function>-fcode AT ' ' INTO lv_object lv_function.
*
*      CASE lv_object.
*        WHEN 'MOVEMENT'.
*
*          CASE lv_function.
*            WHEN 'DELETE'.
*
**              cr_menu->disable_functions( fcodes =  ).
*
*          ENDCASE.
*
*      ENDCASE.
*
*    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
