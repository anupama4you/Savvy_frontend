@isTest(SeeAllData=true)
public class TestFeefoCallout {
    
    static Set <id> settledIds = new Set <id> ();
    
    public static void init(){
        // settledOpps = [SELECT id,Name,Email_Address__c,Date_Closed_or_Settled__c,Opp_Loan_Type__c,Finance_Amount__c,Confirm_Settled__c 
        //                FROM Custom_Opportunity__c WHERE Confirm_Settled__c = 'Yes' 
        //                AND Date_Closed_or_Settled__c != null AND Email_Address__c != null LIMIT 1];
        // for (Custom_Opportunity__c settledOpp : settledOpps) {
        //     settledIds.add(settledOpp.id);
        // }

        Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
        o.Date_Closed_or_Settled__c = Datetime.now();
        o.Status__c = 'Closed Opportunity';
        o.Reason_for_Closure__c = 'Could not beat quote';
        o.Notes__c = '...';
        update o;
        settledIds.add(o.Id);
        
        Parameters_Service__c p = Parameters_Service__c.getInstance('Settled_Reviews_Distribution_Status');
        if (p != null) {
          p.value__c = 'OFF';
          update p;
        }

    }
    
    public static testmethod void testFeefoCallout() {
        init ();
        
        Test.startTest();
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);

        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        FeefoCallout.makeFeefoCallout(settledIds);
        
        Test.stopTest();
        
        
    }

    public static testmethod void testProductSearchCodeSelection() {
        Test.startTest();
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.createProduct();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Application_Asset_Detail__c a = Test_DataGeneratorHelper.asset;
        Custom_Opportunity__c o = refresOpportunity();
        String loanType = 'Bad Credit Car Loan';

        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Personal Loan';
        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Car Loan';
        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Chattel Mortgage';
        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Home Loan';
        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Leisure Loan';
        o.Lead__r.Loan_Type__c = loanType;
        update o.Lead__r;
        a.Type__c = 'Marine';
        update a;
        o = refresOpportunity();
        System.assertEquals('Boat Loan',FeefoCallout.getProductSearchCode(o));

        o.Lead__c = null;
        update o;
        o = refresOpportunity();
        System.assertEquals('Boat Loan',FeefoCallout.getProductSearchCode(o));

        loanType = 'Bike Loan';
        a.Type__c = 'Motorcycle';
        update a;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Caravan Loan';
        a.Type__c = 'Caravan';
        update a;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Truck Loan';
        a.Type__c = 'Truck';
        update a;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Equipment Loan';
        a.Type__c = 'Equipment';
        update a;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        loanType = 'Boat Loan';
        a.Type__c = 'Marine';
        update a;
        o = refresOpportunity();
        System.assertEquals(loanType,FeefoCallout.getProductSearchCode(o));

        Test.stopTest();
    }

    public static testmethod void testFeefoCalloutForSettledOpps() {
        
      Custom_Opportunity__c opp = Test_DataGeneratorHelper.buildOpp(true);
      
      Parameters_Service__c p = Parameters_Service__c.getInstance('Settled_Reviews_Distribution_Status');
      if (p != null) {
        p.value__c = 'ON';
        update p;
      }
      p = Parameters_Service__c.getInstance('Settled_Reviews_Distribution_Percen');
      if (p != null) {
        p.value__c = '50';
        update p;
      }
      
      Test.startTest();
      
      SingleRequestMock fakeResponse = new SingleRequestMock(
        200, 'Complete', '[{"Name": "sForceTest1"}]', null
      );

      Test.setMock(HttpCalloutMock.class, fakeResponse);
      
      FeefoCallout.distributeReview();
      FeefoCallout.createSMS(opp, 'Google');
      FeefoCallout.createTaskNotification(opp, 'Feefo');
      
      Test.stopTest();
        
        
    }

    public static Custom_Opportunity__c refresOpportunity() {
        return [SELECT Id, Loan_Product__c, Loan_Product__r.Loan_Type__c, Opp_Loan_Type__c,
                        Loan_Product__r.Quoting_Source__c, Opp_Asset_Type__c,
                         Lead__r.Loan_Type__c, Application__r.Type_Of_Asset__c,
                         Lead__r.Loan_For__c, Application__r.Loan_For__c
               FROM Custom_Opportunity__c 
               WHERE Id = :Test_DataGeneratorHelper.tstOpportunity.Id];
    }
}