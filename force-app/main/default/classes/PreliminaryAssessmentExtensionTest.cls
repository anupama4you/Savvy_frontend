@isTest //THIS IS DRAFT TESTCLASS ONLY - Joy
public class PreliminaryAssessmentExtensionTest {
    static testMethod void PreliminaryAssessmentMethod() {
        
        User user1 = Test_DataGeneratorHelper.buildPartnerUser();
        Test.startTest();
        System.runAs(user1) {
          Application__c app = Test_DataGeneratorHelper.buildCarApp(true);
          Custom_Opportunity__c co = Test_DataGeneratorHelper.tstOpportunity;
          Test_DataGeneratorHelper.createQuoting();
          
          AppServicingCalculatorDTO serv = new AppServicingCalculatorDTO();
          ApplicationExtraDataHelper.upsertData(app.id, 'Servicing ', 'Servicing Calculation', serv);

          PageReference testPage = Page.PreliminaryAssessmentTmpl; 
          Test.setCurrentPage(testPage);
          testPage.getParameters().put('Id', String.valueOf(co.Id));
          
          ApexPages.StandardController sc = new  ApexPages.StandardController(co);     
          PreliminaryAssessmentExtension ext = new PreliminaryAssessmentExtension(sc);  
        
          Account returnAccountVar = ext.getAccountVar();
          // String returnContentDocId = ext.getContentDocId(portalAccount1.Id, 'Testname');
          String returnToday = ext.getToday();
          Decimal returnTotalSurplusDeficiency = ext.getTotalSurplusDeficiency();
          Decimal returnTotalExpenses = ext.getTotalExpenses();
        }
        Test.stopTest();
    }
}