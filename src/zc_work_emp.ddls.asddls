@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection view for employe'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_WORK_EMP
  as projection on ZI_WORK_EMP
{
  key WorkorderId,
  key EmployeeId,
      @ObjectModel.text: {
      element: [ 'Text' ],
      association: '_Employeid'
      }
      EmployeeName,
      _Employeid.Text as Text,
      @ObjectModel.text: {
      element: [ 'HourText' ],
      association: '_HourUnit'
      }
      HourUnit,
      _HourUnit.Text as HourText,
      @Semantics.quantity.unitOfMeasure : 'HourUnit'
      HoursWorked,
      @Semantics.amount.currencyCode : 'Currency'
      HourRate,
      @Semantics.amount.currencyCode : 'Currency'
      Cost,
      Currency,
      /* Associations */
      _WorkOrder : redirected to parent ZC_WORK_ORDER,
      _HourUnit,
      _Employeid
}
