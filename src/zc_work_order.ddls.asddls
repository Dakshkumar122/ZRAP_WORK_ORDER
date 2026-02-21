@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for work order'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_WORK_ORDER
  provider contract transactional_query
  as projection on ZI_WORK_ORDER
{
  key WorkorderId,
      Description,
      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text: {
          element: [ 'Text' ],
          association: '_Plant'
      }
      Plant,
      _Plant.Text     as Text,
      @ObjectModel.text: {
      element: [ 'OrderTypeText' ],
      association: '_OrderType'
      }
      Ordertype,
      _OrderType.Text as OrderTypeText,
      @ObjectModel.text: {
      element: [ 'PriorityText' ],
      association: '_Priority'
      }
      Priority,
      _Priority.Text  as PriorityText,
      @ObjectModel.text: {
      element: [ 'StatusText' ],
      association: '_Plant'
      }
      Status,
      _Status.Text    as StatusText,
      CreatedBy,
      CreatedAt,
      @Semantics.amount.currencyCode : 'Currency'
      @ObjectModel.text: {element:[ 'Currency' ]}
      TotalCost,
      Currency,
      ApprovedBy,
      ApprovedAt,
      /* Associations */
      _Employees : redirected to composition child ZC_WORK_EMP,
      _Items     : redirected to composition child ZC_WORK_ITEM,
      _Plant,
      _Status,
      _OrderType,
      _Priority
}
