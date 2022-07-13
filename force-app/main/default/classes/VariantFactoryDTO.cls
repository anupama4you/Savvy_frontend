public with sharing class VariantFactoryDTO {
    @AuraEnabled
    public Glass_Variant__c glassVariant {get; set; }

    @AuraEnabled
    public Map<String, List<AssetOptionDTO>> variantOptionsMap {get; set; }
    
    @AuraEnabled
    public Glass_Variant__c variantObj {get; set; }

    @AuraEnabled
    public VariantOptionsSettingDTO assetStandardFeautersData {get; set; }

    @AuraEnabled
    public String model {get; set; }
}