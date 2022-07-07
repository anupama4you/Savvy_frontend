@isTest(SeeAllData=true)
public class TestXeroService {
	
    @isTest
	static void createInsuranceInvoiceWithInsurerNull() {
        TestXeroSetup.setupTestData();
        getStaticResourceMultiMock();
        List<Invoice__c> invoices = prepareInvoice('Insurance Invoice', 'Insurance', 1, 1);
        
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
		XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 3, 'RTS');
		Test.stopTest();
	}
    
    /**
	* 	@author Yohan VillaLeal
	*	@description This product has the Lender__c == null
	**/
    @isTest
	static void createDOFInvoiceWithLenderNull() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        
        List<Invoice__c> invoices = prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 2, 'RTS');
		Test.stopTest();
	}
    
    /**
	* 	@author Yohan VillaLeal
	*	@description This product has the DOF_2__c && DOF__c  == null
	**/
    @isTest
	static void createDOFInvoiceWithDofsNull() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
		List<Invoice__c> invoices = prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 2, 'RTS');
		Test.stopTest();
	}

	/**
	* 	@author Yohan VillaLeal
	*	@description This product has the Brokerage__c && Brokerage_GST_Inc__c  == null
	**/
    @isTest
	static void createDOFInvoiceWithCommissionsNull() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        List<Invoice__c> invoices = prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 1, 'RTS');
		Test.stopTest();
	}
    
    @isTest
	static void createInvoicesForAllRecordTypes() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();

        List<Invoice__c> invoices = new List<Invoice__c>();
        
        //First Invoice
        Test_DataGeneratorHelper.createInvoice('Finance Invoice', 'Finance', 1, 1);
        Test_DataGeneratorHelper.tstProduct.Brokerage__c = 2.3;
        Test_DataGeneratorHelper.tstProduct.DOF__c = 3.4;
        Test_DataGeneratorHelper.tstProduct.Lender__c = 'Metro';
        update Test_DataGeneratorHelper.tstProduct;
        
        Test_DataGeneratorHelper.tstOpportunity.Loan_Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.tstInvoice.Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        Test_DataGeneratorHelper.tstInvoice.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
		update Test_DataGeneratorHelper.tstInvoice;
        
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        //Second Invoice
        Test_DataGeneratorHelper.createInvoice('Insurance Invoice', 'Insurance', 1, 1);
        Test_DataGeneratorHelper.tstProduct.Insurance_Commission__c = 2.3;
		Test_DataGeneratorHelper.tstProduct.Insurer__c = 'Metro';        
        update Test_DataGeneratorHelper.tstProduct;
        
        Test_DataGeneratorHelper.tstOpportunity.Loan_Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.tstInvoice.Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        Test_DataGeneratorHelper.tstInvoice.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
		update Test_DataGeneratorHelper.tstInvoice;
        
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 2, 'RTS');
		Test.stopTest();
	}
    
    /**
	* 	@author Yohan VillaLeal
	*	@description This method is to test the brokerage with one invoice
	**/
	@isTest
	static void createInvoicesForBrokerage() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
		
        List<Invoice__c> invoices = new List<Invoice__c>();
        
        Test_DataGeneratorHelper.createInvoice('Finance Invoice', 'Finance', 1, 1);
        Test_DataGeneratorHelper.tstProduct.Brokerage__c = 2.3;
        Test_DataGeneratorHelper.tstProduct.DOF__c = 3.4;
        Test_DataGeneratorHelper.tstProduct.Lender__c = 'Metro';
        update Test_DataGeneratorHelper.tstProduct;
        
        Test_DataGeneratorHelper.tstOpportunity.Loan_Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.tstInvoice.Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        Test_DataGeneratorHelper.tstInvoice.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
		update Test_DataGeneratorHelper.tstInvoice;
            
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 1, 'RTS');
		Test.stopTest();
	}
    
    /**
	* 	@author Yohan VillaLeal
	*	@description This method is to test the DOF with one invoice
	**/
	@isTest
	static void createInvoicesForDOF() {
		TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        
        List<Invoice__c> invoices = new List<Invoice__c>();
        
        Test_DataGeneratorHelper.createInvoice('Finance Invoice', 'Finance', 1, 1);
        Test_DataGeneratorHelper.tstProduct.Brokerage__c = 2.3;
        Test_DataGeneratorHelper.tstProduct.DOF__c = 3.4;
        Test_DataGeneratorHelper.tstProduct.Lender__c = 'Metro';
        update Test_DataGeneratorHelper.tstProduct;
        
        Test_DataGeneratorHelper.tstOpportunity.Loan_Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        
        Test_DataGeneratorHelper.tstInvoice.Product__c = Test_DataGeneratorHelper.tstProduct.Id;
        Test_DataGeneratorHelper.tstInvoice.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
		update Test_DataGeneratorHelper.tstInvoice;
            
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
			XeroService.createInvoices(invoices, Test_DataGeneratorHelper.tstOpportunity, 3, 'RTS');
		Test.stopTest();
	}
    
    @isTest
    static void updateXeroCommissionInvoice(){
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
		
        prepareInvoice('Insurance Invoice', 'Finance', 1, 1);
        
        TestXeroSetup.setupTestInvoiceCommissionData(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	Invoice__c inv = XeroService.InvoiceUpdate('565acaa9-e7f3-4fbf-80c3-16b081ddae12', Test_DataGeneratorHelper.tstOpportunity, 1, 'SAVVYA');
        	XeroService.downloadInvoicePdf(inv, Test_DataGeneratorHelper.tstOpportunity, false);
		Test.stopTest();
    }
    
    @isTest
    static void updateXeroDOFInvoice(){
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
            
		prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        TestXeroSetup.setupTestInvoiceFinanceData(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	Invoice__c inv = XeroService.InvoiceUpdate('565acaa9-e7f3-4fbf-80c3-16b081ddae10', Test_DataGeneratorHelper.tstOpportunity, 2, 'SAVVYA');
        	XeroService.downloadInvoicePdf(inv, Test_DataGeneratorHelper.tstOpportunity, true);
		Test.stopTest();
    }
    
    @isTest
    static void updateXeroBrokerageInvoice(){
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
            
		prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        TestXeroSetup.setupTestInvoiceFinanceData(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	Invoice__c inv = XeroService.InvoiceUpdate('565acaa9-e7f3-4fbf-80c3-16b081ddae10', Test_DataGeneratorHelper.tstOpportunity, 2, 'SAVVYA');
        	XeroService.downloadInvoicePdf(inv, Test_DataGeneratorHelper.tstOpportunity, false);
		Test.stopTest();
    }
    
    private static void getStaticResourceMultiMock(){
      List<Xero_API_Setting__c> d = Xero_API_Setting__c.getAll().values();
      Xero_API_Setting__c s = d[0];      
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(s.Endpoint__c + 'Invoices', 'XeroInvoicesMock');
        multimock.setStaticResource(s.Endpoint__c + 'TrackingCategories?TrackingCategoryID=fcfa4b51-5489-4347-ae47-5dea90f33c75', 'XeroTrackingCategoriesMock');
		multimock.setStaticResource(s.Endpoint__c + 'TrackingCategories?TrackingCategoryID=fcfa4b51-5489-4347-ae47-5dea90f33c75/Options', 'XeroTrackingCategoriesMock');
        multimock.setStaticResource(s.Endpoint__c + 'Invoices/DownloadPdf?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae10', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource(s.Endpoint__c + 'Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae10/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource(s.Endpoint__c + 'Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae11/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource(s.Endpoint__c + 'Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae12/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource('https://test.c.cs6.visual.force.com/apex/GenerateProductInvoices?id=a0EN000000FJpVy', 'XeroContactsMock');
        multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, multimock);        
    }
    
    private static List<Invoice__c> prepareInvoice(String recordType, String recorType, Integer dofAmount, Integer brokAmount){
         List<Invoice__c> invoices = new List<Invoice__c>();
        
        Test_DataGeneratorHelper.createInvoice(recordType, recorType, dofAmount, brokAmount);
        Test_DataGeneratorHelper.tstProduct.Insurer__c = null;
        update Test_DataGeneratorHelper.tstProduct;
        
        Test_DataGeneratorHelper.tstInvoice.Product__c = Test_DataGeneratorHelper.tstProduct.Id;
		update Test_DataGeneratorHelper.tstInvoice;
        
        return invoices;
    }
}