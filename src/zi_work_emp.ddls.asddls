@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for employe'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view entity ZI_WORK_EMP
  as select from zwo_employe
  association to parent ZI_WORK_ORDER as _WorkOrder on $projection.WorkorderId = _WorkOrder.WorkorderId
  
  //value help for hour unit 
  association  to ZVH_WORKEMP_HUNIT as _HourUnit on $projection.HourUnit =   _HourUnit.Value
  
  association  to ZVH_WORKEMP_EMPID as _Employeid on $projection.EmployeeName  =      _Employeid.Value
{
  key workorder_id          as WorkorderId,
  key employee_id           as EmployeeId,
      employee_name         as EmployeeName,
      hour_unit             as HourUnit,
      @Semantics.quantity.unitOfMeasure : 'HourUnit'
      hours_worked          as HoursWorked,
      @Semantics.amount.currencyCode : 'Currency'
      hour_rate             as HourRate,
      @Semantics.amount.currencyCode : 'Currency'
      cost                  as Cost,
      currency              as Currency,
      last_changed_at       as LastChangedAt,
      last_changed_by       as LastChangedBy,
      local_last_changed_at as LocalLastChnagedAt,
       
      _WorkOrder,
      
      //value help association
      _HourUnit,
      _Employeid
}
