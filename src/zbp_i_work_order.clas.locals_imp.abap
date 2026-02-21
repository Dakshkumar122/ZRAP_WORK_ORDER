CLASS lhc_employe DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateCost FOR DETERMINE ON MODIFY
      IMPORTING keys FOR employe~calculateCost.

ENDCLASS.

CLASS lhc_employe IMPLEMENTATION.



  METHOD calculatecost.


    READ ENTITIES OF zi_work_order IN LOCAL MODE
      ENTITY employe
      FIELDS ( HoursWorked HourRate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_emp).

    DATA lt_update TYPE TABLE FOR UPDATE zi_work_emp.

    LOOP AT lt_emp INTO DATA(ls_emp).

      " Ek hi line mein declare aur assign
      DATA(lv_cost) = CONV zwo_employe-cost( ls_emp-HoursWorked * ls_emp-HourRate ).

      APPEND VALUE #(
          %tky = ls_emp-%tky
          Cost = lv_cost   " Yahan lv_cost directly use karo, dobara assign mat karo
      ) TO lt_update.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_work_order IN LOCAL MODE
        ENTITY employe
        UPDATE FIELDS ( Cost )
        WITH lt_update.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
























CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setMaterialData FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~setMaterialData.

    METHODS calculateNetAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~calculateNetAmount.

    METHODS validateQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR item~validateQuantity.

    METHODS get_total_netamout
      IMPORTING iv_workorder_id TYPE zwo_header-workorder_id
      RETURNING VALUE(rv_total) TYPE zwo_header-total_cost.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.



  METHOD setMaterialData.
    READ ENTITIES OF zi_work_order IN LOCAL MODE
       ENTITY Item
       FIELDS ( Material )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      DATA(lv_unit) = ''.
      DATA(lv_price) = 0.

      CASE ls_item-Material.
        WHEN 'MAT2001'.
          lv_unit  = 'P'.
          lv_price = 15000.
        WHEN 'MAT2002'.
          lv_unit  = 'M'.
          lv_price = 90.
        WHEN 'MAT3001'.
          lv_unit  = 'K'.
          lv_price = 220.
      ENDCASE.

      MODIFY ENTITIES OF zi_work_order IN LOCAL MODE
        ENTITY Item
        UPDATE FIELDS ( Unit Price )
        WITH VALUE #(
          ( %tky     = ls_item-%tky
              Unit = lv_unit
            Price    = lv_price ) ).

    ENDLOOP.
  ENDMETHOD.



  METHOD calculateNetAmount.
    " Read items with Quantity and Price
    READ ENTITIES OF zi_work_order IN LOCAL MODE
      ENTITY Item
      FIELDS ( Quantity Price NetAmount WorkorderId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    DATA lt_update TYPE TABLE FOR UPDATE zi_work_item.

    LOOP AT lt_items INTO DATA(ls_item).
      " Direct calculation - Quantity * Price
      DATA(lv_netamount) = ls_item-Quantity * ls_item-Price.

      APPEND VALUE #( %tky      = ls_item-%tky
                      NetAmount = lv_netamount )
        TO lt_update.
    ENDLOOP.

    " Update net amounts
    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_work_order IN LOCAL MODE
        ENTITY Item
        UPDATE FIELDS ( NetAmount )
        WITH lt_update
        REPORTED DATA(lt_reported)
        FAILED DATA(lt_failed).
    ENDIF.

    " Abhi header update karte hain direct
    IF lt_items IS NOT INITIAL.
      " Pehle unique workorder IDs collect karo
      DATA lt_workorder_ids TYPE SORTED TABLE OF zwo_header-workorder_id
                            WITH UNIQUE KEY table_line.

      LOOP AT lt_items INTO DATA(ls_item2).
        COLLECT ls_item2-WorkorderId INTO lt_workorder_ids.
      ENDLOOP.

      " Har workorder ke liye total cost calculate karo
      LOOP AT lt_workorder_ids INTO DATA(lv_workorder_id).
        DATA(lv_total) = get_total_netamout( lv_workorder_id ).

        MODIFY ENTITIES OF zi_work_order IN LOCAL MODE
          ENTITY WorkOrder
          UPDATE FIELDS ( TotalCost )
          WITH VALUE #( ( %tky      = VALUE #( WorkorderId = lv_workorder_id )
                          TotalCost = lv_total ) ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.



  METHOD get_total_netamout.
    " Simple SUM query with proper numeric handling
    SELECT SINGLE SUM( net_amount )
      FROM zwo_item
      WHERE workorder_id = @iv_workorder_id
      INTO @rv_total.

    " Agar NULL hai toh 0 karo
    IF rv_total IS INITIAL.
      rv_total = 0.
    ENDIF.
  ENDMETHOD.




  METHOD validateQuantity.
    READ ENTITIES OF zi_work_order IN LOCAL MODE
     ENTITY Item
     FIELDS ( Quantity Material )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).
      IF ls_item-Quantity <= 0.
        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-item.

        APPEND VALUE #( %tky = ls_item-%tky
                        %state_area = 'VALIDATE_QUANTITY'
                        %msg = new_message(
                          id       = 'Z_WORK_ORDER'
                          number   = '001'
                          v1       = |Quantity must be greater than zero for material { ls_item-Material }|
                          severity = if_abap_behv_message=>severity-error )
                        %element-quantity = if_abap_behv=>mk-on )
        TO reported-item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.




ENDCLASS.





























CLASS lhc_WORKORDER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR workorder RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR workorder RESULT result.

ENDCLASS.

CLASS lhc_WORKORDER IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
