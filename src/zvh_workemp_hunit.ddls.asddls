@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for hour unit'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVH_WORKEMP_HUNIT
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_WORKEMP_HUNIT' )
{
      @UI.hidden: true
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language  as Language,
      value_low as Value,
      @Semantics.text: true
      text      as Text
}
