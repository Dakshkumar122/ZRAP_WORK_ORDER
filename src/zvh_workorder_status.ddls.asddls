@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for status'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVH_WORKORDER_STATUS
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_WORKORDER_STATUS' )
{
      @UI.hidden: true
  key domain_name,
      @Semantics.language: true
  key value_position,
  key language  as Language,
      value_low as Value,
      @Semantics.text: true
      text      as Text
}
