@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for item'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view entity ZI_WORK_ITEM
  as select from zwo_item
  association to parent ZI_WORK_ORDER as _WorkOrder on $projection.WorkorderId = _WorkOrder.WorkorderId
  
  association  to ZVH_ITEM_MATERIAL as _Material on $projection.Material = _Material.Value

{
  key workorder_id          as WorkorderId,
  key item_no               as ItemNo,
      material              as Material,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      @ObjectModel.text: { element: [ 'Unit' ] }
      quantity              as Quantity,
      unit                  as Unit,
      @Semantics.amount.currencyCode : 'Currency'
      price                 as Price,
      @Semantics.amount.currencyCode : 'Currency'
      net_amount            as NetAmount,
      currency              as Currency,
      last_changed_at       as LastChangedAt,
      last_changed_by       as LastChangedBy,
      local_last_changed_at as LocalLastChnagedAt,

      _WorkOrder,
      _Material
}
