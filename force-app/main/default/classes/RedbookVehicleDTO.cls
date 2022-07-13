public with sharing class RedbookVehicleDTO {
    @AuraEnabled
    public Redbook_Vehicle__c vehicleByCode {get; set;}

    @AuraEnabled
    public Redbook_Vehicle__c vehicleByRedbookKey {get; set;}
}