@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'valuehelp for emp id'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVH_WORKEMP_EMPID
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_WORKEMP_EMPID' )
{
      @UI.hidden: true
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language  as Language,
      @ObjectModel.text: {
        element: [ 'Text' ]
      }
      value_low as Value,
      @Semantics.text: true
      text      as Text
}
