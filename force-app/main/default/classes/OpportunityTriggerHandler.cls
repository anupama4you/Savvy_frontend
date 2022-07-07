public class OpportunityTriggerHandler extends TriggerOrderHandler {

  public override void onBeforeInsert(List<sObject> newRecords) {
    System.debug('Opportunyty onBeforeInsert...');
    List<Custom_Opportunity__c> newList = (List<Custom_Opportunity__c>) newRecords;
    // Partner portal
    PartnerCommunityController.dataCheckerOpps(newList);
    //Jesus Mora 2019-11-27 start
    OpportunityService.resetClonedDetails(newList);
    //Jesus Mora 2019-11-27 end
    OpportunityService.setConsultantDealer(newList);
    OpportunityService.copyPreviousSettledOppty(newList);
    OpportunityService.generateDoc(newList);
  }

  public override void onAfterInsert(
    List<sObject> newRecords,
    Map<ID, sObject> newRecordsMap
  ) {
    List<Custom_Opportunity__c> newList = (List<Custom_Opportunity__c>) newRecords;
    System.debug('Opportunyty onAfterInsert...');
    OpportunityService.acctAndLeadOwnerUpdate(newList);
    OpportunityService.cloneSettledWithMortgaged(newList);
    OpportunityService.productUpdate(newList);
    OpportunityService.opportunityMakeFeefoCallout(newList);
    OpportunityService.taskCreatorOnStatusChange(newList, null);
    //Lelo      2016-11-16
    //Active Campaign syncronization
    OpportunityService.enqueueActiveOpp(newList);
    //-
    //Lelo      2018-07-05
    //Automatic upload for application docs
    OpportunityService.uploadS3ApplicationDocs(newList, null);
    //-
    //Lelo      2019-11-06
    // OpportunityService.checkCallCenterNotification(newList);
    //-
  }

  public override void onBeforeUpdate(
    List<sObject> oldRecords,
    List<sObject> newRecords,
    Map<Id, sObject> oldRecordsMap,
    Map<Id, sObject> newRecordsMap
  ) {
    List<Custom_Opportunity__c> newList = (List<Custom_Opportunity__c>) newRecords;
    Map<Id, Custom_Opportunity__c> oldMap = (Map<Id, Custom_Opportunity__c>) oldRecordsMap;
    OpportunityService.setConsultantDealer(newList, oldMap);
    OpportunityService.updateOpptyAndRemoveAttachments(newList, oldMap);
    // OpportunityService.sendEmailTemplates(newList, oldMap);
    OpportunityService.vehiclesDirectWork(newList, oldMap);
    OpportunityService.checkPreApprovedStatusDate(newList, oldMap);
  }
  
  public override void onAfterUpdate(
    List<SObject> oldRecords,
    List<SObject> newRecords,
    Map<ID, SObject> oldRecordsMap,
    Map<ID, SObject> newRecordsMap
  ) {
    List<Custom_Opportunity__c> newList = (List<Custom_Opportunity__c>) newRecords;
    Map<Id, Custom_Opportunity__c> oldMap = (Map<Id, Custom_Opportunity__c>) oldRecordsMap;

    OpportunityService.acctAndLeadOwnerUpdate(newList, oldMap);
    OpportunityService.cloneSettledWithMortgaged(newList, oldMap);
    OpportunityService.tasksUpdateOnStatusChange(newList, oldMap);
    OpportunityService.productUpdate(newList, oldMap);
    OpportunityService.opportunityMakeFeefoCallout(newList, oldMap);
    OpportunityService.callRemindersToAddOrRemove(newList, oldMap);
    OpportunityService.taskCreatorOnStatusChange(newList, oldMap);
    //Lelo      2016-11-16
    //Active Campaign syncronization
    OpportunityService.enqueueActiveOpp(newList, oldMap);
    //-
    //Lelo      2017-10-10
    //Automatic upload for application docs
    OpportunityService.uploadS3ApplicationDocs(newList, oldMap);
    //-
    //HJ - Unresolved process - 14022019  - I
    OpportunityService.updateUnresolvedProcessByLastModified(newList, oldMap);
    //HJ - Unresolved process - 14022019  - F
    //Lelo      2019-11-06
    // OpportunityService.checkCallCenterNotification(newList);
    //-
  }
}