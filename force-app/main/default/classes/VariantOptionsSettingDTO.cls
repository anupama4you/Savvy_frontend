public with sharing class VariantOptionsSettingDTO {
        @AuraEnabled
        public MAP<String, List<AssetOptionDTO>> assetOptionsData {get; set;}

        @AuraEnabled
        public Map<String, String> assetOptionsSelect {get; set;}

        @AuraEnabled
        public List <AssetOptionDTO> assetStandardFeautersData {get; set;}
}