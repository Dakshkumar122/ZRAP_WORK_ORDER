@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for work order'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_WORK_ORDER
  as select from zwo_header
  composition [0..*] of ZI_WORK_ITEM           as _Items
  composition [0..*] of ZI_WORK_EMP            as _Employees

  //  association for status valuehelp
  association to ZVH_WORKORDER_STATUS   as _Status    on  $projection.Status = _Status.Value

  // association for plant valuehlep
  association  to ZVH_WORKORDER_PLANT    as _Plant     on  $projection.Plant = _Plant.Value
                                                     

  //  association for order type valuehlep
  association  to ZVH_WORKORDER_ORDERT   as _OrderType on  $projection.Ordertype = _OrderType.Value

  // association for priority valuehelp
  association  to ZVH_WORKORDER_PRIORITY as _Priority  on  $projection.Priority = _Priority.Value
{
  key workorder_id          as WorkorderId,
      description           as Description,
      plant                 as Plant,
      ordertype             as Ordertype,
      priority              as Priority,
      status                as Status,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      @Semantics.amount.currencyCode : 'Currency'
      total_cost            as TotalCost,
      currency              as Currency,
      approved_by           as ApprovedBy,
      approved_at           as ApprovedAt,
      last_changed_at       as LastChangedAt,
      last_changed_by       as LastChangedBy,
      local_last_changed_at as LocalLastChnagedAt,


      _Items,
      _Employees,
      // value help associtoin here
      _Status,
      _Plant,
      _OrderType,
      _Priority

}
