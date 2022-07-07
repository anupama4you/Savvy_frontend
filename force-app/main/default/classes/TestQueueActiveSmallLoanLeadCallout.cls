@isTest
public class TestQueueActiveSmallLoanLeadCallout {

  @isTest static void testActiveCampaign() {
    
    Parameters_Service__c ps = new Parameters_Service__c();
    ps.name = 'TransmitSMS_ListID';
    ps.value__c = 'xxx';
    insert ps;

    Test.startTest();

    SingleRequestMock fakeResponse = new SingleRequestMock(
      200,
      'OK',
      '{"subscriber_id":400486,"sendlast_should":0,"sendlast_did":0,"result_code":1,"result_message":"Contact added","result_output":"json"}',
      null
    );

    Test.setMock(HttpCalloutMock.class, fakeResponse);
    String sufix = String.valueOf(Datetime.now().millisecond());
    Lead__c lead = new Lead__c();
    lead.First_Name__c = 'Test+' + sufix;
    lead.Last_Name__c = 'Savvy+' + sufix;
    lead.Finance_Amount__c = 2300;
    lead.Mobile_Number__c = '0477000' + sufix;
    lead.Email_Address__c = 'test+' + sufix + '@savvy.com.au';
    lead.Status__c = 'New Lead';
    lead.Processor_Name__c = 'Money Spot';
    lead.Processor_Status__c = 'Success';
    lead.Processor_Response__c = 'Created Record Successfully';
    lead.Bucket_Type__c = 'Small Loans';
    lead.Loan_Type__c = 'Small Loan';
    lead.Status__c = 'New Lead';
    lead.Lead_Source__c = 'SPL';
    // insert lead;
    List<Lead__c> myLeads = new List<Lead__c>();
    myLeads.add(lead);
    System.enqueueJob(new queueActiveSmallLoanLeadCallout(myLeads));
    Test.stopTest();
  }
}