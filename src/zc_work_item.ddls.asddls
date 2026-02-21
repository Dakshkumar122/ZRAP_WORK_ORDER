@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_WORK_ITEM as projection on ZI_WORK_ITEM
{
    key WorkorderId,
    key ItemNo,
          @ObjectModel.text: {
      element: [ 'Text' ],
      association: '_Material'
      }
    Material,
    _Material.Text as Text,
    @Semantics.quantity.unitOfMeasure : 'Unit'
    Quantity,
    Unit,
    @Semantics.amount.currencyCode : 'Currency'
    Price,
    @Semantics.amount.currencyCode : 'Currency'
    NetAmount,
    Currency,
    /* Associations */
    _WorkOrder: redirected to parent ZC_WORK_ORDER,
    _Material
}
