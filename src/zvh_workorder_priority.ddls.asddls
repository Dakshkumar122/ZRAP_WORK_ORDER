@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for priority'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVH_WORKORDER_PRIORITY
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_WORKORDER_PRIORITY' )
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
