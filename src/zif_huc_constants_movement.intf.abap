INTERFACE zif_huc_constants_movement
  PUBLIC.

  CONSTANTS:
    BEGIN OF gc_movement_category,
      visit TYPE bewty VALUE '4',
    END OF gc_movement_category.

  CONSTANTS:
    BEGIN OF gc_movement_type,
      BEGIN OF visit,
        initial   TYPE ish_bwart VALUE 'FV',
        follow_up TYPE ish_bwart VALUE 'FU',
      END OF visit,
    END OF gc_movement_type.

  CONSTANTS:
    BEGIN OF gc_visit_category,
      undefined TYPE ish_bt VALUE '',
      initial   TYPE ish_bt VALUE '1',
      follow_up TYPE ish_bt VALUE '2',
    END OF gc_visit_category.

  CONSTANTS:
    BEGIN OF gc_assingment_type,
      attending_physician TYPE falpertyp VALUE '6',
    END OF gc_assingment_type.

ENDINTERFACE.
