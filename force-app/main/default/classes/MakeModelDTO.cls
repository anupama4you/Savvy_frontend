public with sharing class MakeModelDTO {
    @AuraEnabled
    public Map<String, String> glassObj {get; set; }

    @AuraEnabled
    public Map<String, String> redObj {get; set; }
}