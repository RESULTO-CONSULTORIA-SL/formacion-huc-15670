CLASS zcx_huc DEFINITION
  PUBLIC
  INHERITING FROM cx_ish_static_handler
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    CONSTANTS:
      "! Movement reason cannot be empty for initial visits.
      BEGIN OF movement_reason_empty_initial,
        msgid TYPE symsgid VALUE 'ZHUC',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF movement_reason_empty_initial.

    DATA:
      text1 TYPE string READ-ONLY,
      text2 TYPE string READ-ONLY,
      text3 TYPE string READ-ONLY,
      text4 TYPE string READ-ONLY.

    "! <p class="shorttext synchronized" lang="en">CONSTRUCTOR</p>
    "!
    "! @parameter textid | <p class="shorttext synchronized" lang="en">Message Key (T100)</p>
    "! @parameter text1 | <p class="shorttext synchronized" lang="en">Text 1</p>
    "! @parameter text2 | <p class="shorttext synchronized" lang="en">Text 2</p>
    "! @parameter text3 | <p class="shorttext synchronized" lang="en">Text 3</p>
    "! @parameter text4 | <p class="shorttext synchronized" lang="en">Text 4</p>
    "! @parameter previous | <p class="shorttext synchronized" lang="en">Previous exception</p>
    "! @parameter gr_errorhandler | <p class="shorttext synchronized" lang="en">Error handling</p>
    "! @parameter gr_msgtyp | <p class="shorttext synchronized" lang="en">Message type</p>
    METHODS constructor
      IMPORTING
        textid       LIKE if_t100_message=>t100key OPTIONAL
        text1        TYPE string OPTIONAL
        text2        TYPE string OPTIONAL
        text3        TYPE string OPTIONAL
        text4        TYPE string OPTIONAL
        previous     LIKE previous OPTIONAL
        errorhandler TYPE REF TO cl_ishmed_errorhandling OPTIONAL
        message_type TYPE sy-msgty DEFAULT /rslt/if_bs_messages=>gc_msg_severity-error
          PREFERRED PARAMETER textid.

    METHODS get_text REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_text_from_errorhandler
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.



CLASS zcx_huc IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor(
        previous        = previous
        gr_errorhandler = errorhandler
        gr_msgtyp       = message_type ).

    CLEAR me->textid.

    if_t100_message~t100key =
        COND #(
            WHEN textid IS INITIAL
                THEN if_t100_message=>default_textid
                ELSE textid ).

    me->text1 = text1.
    me->text2 = text2.
    me->text3 = text3.
    me->text4 = text4.

  ENDMETHOD.


  METHOD get_text.

    result =
        COND #(
            WHEN if_t100_message~t100key = if_t100_message=>default_textid
                THEN get_text_from_errorhandler( )
                ELSE super->get_text( ) ).

  ENDMETHOD.


  METHOD get_text_from_errorhandler.

    get_errorhandler( IMPORTING er_errorhandler = DATA(lo_errorhandler) ).

    IF lo_errorhandler IS BOUND.
      lo_errorhandler->get_messages( IMPORTING t_messages = DATA(lt_messages) ).
    ENDIF.

    result = COND #( WHEN lines( lt_messages ) = 0                 THEN cl_message_helper=>get_text_for_message( me )
                     WHEN lines( lt_messages ) = 1                 THEN lt_messages[ 1 ]-message
                     WHEN line_exists( lt_messages[ type = `X` ] ) THEN lt_messages[ type = `X` ]-message
                     WHEN line_exists( lt_messages[ type = `A` ] ) THEN lt_messages[ type = `A` ]-message
                     WHEN line_exists( lt_messages[ type = `E` ] ) THEN lt_messages[ type = `E` ]-message
                     WHEN line_exists( lt_messages[ type = `W` ] ) THEN lt_messages[ type = `W` ]-message
                     WHEN line_exists( lt_messages[ type = `I` ] ) THEN lt_messages[ type = `I` ]-message
                                                                   ELSE lt_messages[ 1 ]-message ).

  ENDMETHOD.


ENDCLASS.
