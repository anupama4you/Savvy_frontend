@isTest(seeAlldata=true)
public class ActiveCampaignCalloutTest{

    static Map<id,string> mapId = new Map<id,string>();
    static List<Lead__c> listLead = new List<Lead__c>();
    static List<Custom_Opportunity__c> listOpp = new List<Custom_Opportunity__c>();
    static Lead__c lead = new Lead__c();
    static Custom_Opportunity__c opp = new Custom_Opportunity__c ();

    public static void init(){
        /*
        Map<String, Id> RecordTypes = new Map<String, Id>();
        for (RecordType rt : [SELECT Id,
                                     Name
                              FROM RecordType])
        {
            RecordTypes.put(rt.Name, rt.Id);
        }     
    
         Account TestAccount = new Account(RecordTypeId = recordTypes.get('Person Account'),
                                  FirstName = 'Test',
                                  LastName = 'Test',
                                  PersonMobilePhone = '0412345678',
                                  PersonEmail = 'test1@test.com',
                                  PersonOtherStreet = 'Test',
                                  PersonOtherCity = 'Test',
                                  PersonOtherState = 'Test',
                                  PersonOtherPostalCode = 'Test');
        insert TestAccount;        
        
        Account TestLeadConsultantDealer = new Account(RecordTypeId = recordTypes.get('Savvy Dealer'),
                                               Name = 'Test',
                                               BillingStreet = 'Test',
                                               BillingCity = 'Test',
                                               BillingState = 'Test',
                                               BillingPostalCode = 'Test',
                                               ShippingStreet = 'Test',
                                               ShippingCity = 'Test',
                                               ShippingState = 'Test',
                                               ShippingPostalCode = 'Test',
                                               Commission_Amount__c = 123);
        insert TestLeadConsultantDealer;
        
        Contact TestLeadConsultant = new Contact(AccountId = TestLeadConsultantDealer.Id,
                                         FirstName = 'Test',
                                         LastName = 'Test');
        insert TestLeadConsultant;                                       
        
        Lead__c TestLead = new Lead__c(Account__c = TestAccount.Id,
                               First_Name__c = 'Test',
                               Last_Name__c = 'Test',
                               Finance_Amount__c = 123,
                               Email_Address__c = 'test2@test.com',
                               Lead_Consultant__c = TestLeadConsultant.Id,
                               OwnerId = UserInfo.getUserId(),
                               Status__c = null);
        insert TestLead;         
        
        Custom_Opportunity__c TestOpportunity = new Custom_Opportunity__c(Account__c = TestAccount.Id,
                                             Lead__c = TestLead.Id,
                                             Status__c = null);
        insert TestOpportunity;  
        
        Product__c TestFinanceProduct = new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                                            Opportunity_Name__c = TestOpportunity.Id,
                                            End_of_Loan_Date__c = Date.today().addDays(60),                                            
                                            DOF__c = 1,
                                            Brokerage__c = 1);
        insert TestFinanceProduct;
        
        insert new Product__c(RecordTypeId = RecordTypes.get('Finance'),
                              Opportunity_Name__c = TestOpportunity.Id,
                              End_of_Loan_Date__c = Date.today().addMonths(3),                              
                              DOF__c = 1,
                              Brokerage__c = 1);
        
        Product__c TestInsuranceProduct = new Product__c(RecordTypeId = RecordTypes.get('Insurance'),
                                              Opportunity_Name__c = TestOpportunity .Id,                                              
                                              Insurance_Type__c = 'Gap Insurance');
                                              
                                                    
        insert TestInsuranceProduct; 

        update TestOpportunity;
        */  
        
        //lead = TestLead;
        //opp = TestOpportunity;
        
        lead = [
          SELECT Reason_for_closure__c, Status__c, First_Name__c, Loan_Type__c, Home_Phone__c, Mobile_Number__c, Suburb__c, 
                Date_of_Birth__c, Lead_Owner__c , Owner_Mobile__c, Owner_Email__c, Finance_Amount__c, Street_Address__c, Street_Type__c,
                Postcode__c, State__c, Owner_Phone__c, Last_Name__c, Email_Address__c, Credit_History__c 
          FROM Lead__c 
          WHERE Loan_Type__c != 'Small Loan' 
          AND Credit_History__c = 'Excellent' 
          AND Partner_Owner__c = null
          LIMIT 1
        ];
        opp = [
          SELECT 
            Reason_for_closure__c, Opp_Loan_Term__c, Owner_Name__c , Email_Address__c, Name,
            Owner_Email__c , Owner_Mobile__c, Owner_Phone__c, Account_First_Name__c, State__c, Opp_Loan_Type__c,
            Lead__c, Status__c, emailoptout__c 
          FROM Custom_Opportunity__c 
          WHERE Email_Address__c != null 
          AND Partner_Owner__c = null
          LIMIT 1
        ];
        
        if (lead != null){
            mapId.put(lead.Id, 'Yes');
            listLead.add(lead);
        }
        
        if (opp != null){
            mapId.put(opp.Id, 'Yes');
            listOpp.add(opp);
        }

        Parameters_Service__c param = Parameters_Service__c.getInstance(
          'ActiveCampaign_Status'
        );
        param.value__c = 'ON';
        update param;
    
    }

    public static testmethod void testLeadCallout() {                
    
        init();
    
        Test.startTest();         
        
         SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);

        Test.setMock(HttpCalloutMock.class, fakeResponse);
  
        
        System.enqueueJob(new queueActiveLeadCampaignCallout(listLead, mapId) );
        System.enqueueJob(new queueActiveLeadTagCallout(listLead, mapId) );
        
        string emailAd = string.valueOf(lead.Email_Address__c);
        List<String> emailList = new List<String>();
        emailList.add(emailAd);
        System.enqueueJob(new queueActiveLeadDeleteCallout(emailList) );          
        Test.stopTest();

    }
    
     public static testmethod void testOpportunityCallout() {                
    
        init();
    
        Test.startTest();           
        
            SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);

        Test.setMock(HttpCalloutMock.class, fakeResponse);
  
        
        System.enqueueJob(new queueActiveOppCampaignCallout(listOpp, mapId) );
        System.enqueueJob(new queueActiveOppTagCallout(listOpp, mapId) );
                 
        Test.stopTest();

    }
}