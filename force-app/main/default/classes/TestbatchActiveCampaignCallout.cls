@isTest Global class TestbatchActiveCampaignCallout{ 


    Static TestMethod void TestbatchActiveLeadCampaignCallout() {
        
        Test_DataGeneratorHelper.createLead();
        List<Id> ldIds= new List<Id>();
        List<String> emailAddrsLst=new List<String>();
        List<Lead__c> ldObjs=new List<Lead__c>();
        Map<id,string> mapIdToStrYes=new Map<Id,string>();
        Map<id,string> mapIdToStrNo=new Map<Id,string>();
                
        ldIds.add(Test_DataGeneratorHelper.tstLead.id);
        emailAddrsLst.add(Test_DataGeneratorHelper.tstLead.Email_Address__c);
        ldObjs.add(Test_DataGeneratorHelper.tstLead);
        mapIdToStrYes.put(Test_DataGeneratorHelper.tstLead.id,'Yes');
        mapIdToStrNo.put(Test_DataGeneratorHelper.tstLead.id,'No');
        
        Database.executeBatch(new batchActiveLeadCampaignCallout(ldIds,emailAddrsLst,'insUpd',ldObjs,mapIdToStrYes),1000);
         
        Database.executeBatch(new batchActiveLeadCampaignCallout(ldIds,emailAddrsLst,'insUpd',ldObjs,mapIdToStrNo),100);
        
        Database.executeBatch(new batchActiveLeadTagCallout(ldIds,emailAddrsLst,'insUpd',ldObjs,mapIdToStrYes),1000);

        Database.executeBatch(new batchActiveLeadCampaignCallout(ldIds,emailAddrsLst,'del',ldObjs,mapIdToStrYes),1000);
        
                
    }
    Static TestMethod void TestbatchActiveOpportunityCampaignCallout() {
        
        Test_DataGeneratorHelper.createOpportunity();
        List<Id> ldIds= new List<Id>();
        Map<id,string> mapIdToStrYes=new Map<Id,string>();
        Map<id,string> mapIdToStrNo=new Map<Id,string>();
                
        ldIds.add(Test_DataGeneratorHelper.tstOpportunity.id);
        mapIdToStrYes.put(Test_DataGeneratorHelper.tstOpportunity.id,'Yes');
        mapIdToStrNo.put(Test_DataGeneratorHelper.tstOpportunity.id,'No');
        
        Database.executeBatch(new batchActiveOppCampaignCallout(ldIds,'insUpd',mapIdToStrYes),1000);

        Database.executeBatch(new batchActiveOppCampaignCallout(ldIds,'insUpd',mapIdToStrNo),1000);
        
        Database.executeBatch(new batchActiveOppTagCallout(ldIds,'insUpd',mapIdToStrYes),1000);
        
        Database.executeBatch(new batchActiveOppCampaignCallout(ldIds,'del',mapIdToStrYes),1000);
            
    }
    
    
}