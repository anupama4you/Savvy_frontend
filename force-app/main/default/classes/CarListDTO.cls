public with sharing class CarListDTO {
    @AuraEnabled
    public Glass_Make__c glassMakeRec {get; set; }

    @AuraEnabled
    public List<Glass_Variant__c> glassVariantObj {get; set; }

    @AuraEnabled
    public Glass_Variant__c glassVariant {get; set; }
}