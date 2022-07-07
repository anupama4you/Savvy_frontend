@isTest(SeeAllData=true)
public class TestGenerateProductInvoicesExtension
{
    /*
    public static testMethod void myUnitTest()
    {
        Test.starttest();
        Test_DataGeneratorHelper.createOpportunity();

        GenerateProductInvoicesExtension ext = new GenerateProductInvoicesExtension(new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity));
        ext.Generate();
        Test.StopTest();
    }
    */
    @isTest
	static void generateProductsInvoicesIsEmpty() {
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createProduct();
        
        Test.startTest();
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
        	crt.Generate();
		Test.stopTest();
	}
    
    @isTest
	static void generateProductsInvoicesNotEmpty() {
		TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
        
		List<Invoice__c> invoices = prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        
        Test.startTest();
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
        	crt.Generate();
		Test.stopTest();
	}
    
    @isTest
    static void dowloadInvoicesDocumentsPDF(){
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
        List<Invoice__c> invoices = new List<Invoice__c>();
            
		prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceFinanceData(Test_DataGeneratorHelper.tstInvoice);

        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
        	crt.getIsDisabled();
        	crt.GenerateMain();
           	crt.downloadXeroInvoicePdf();
		Test.stopTest();
    }
    
    @isTest
    static void dowloadInvoicesDocumentPDF(){
        TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
        List<Invoice__c> invoices = new List<Invoice__c>();
            
		prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        invoices.add(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceFinanceData(Test_DataGeneratorHelper.tstInvoice);

        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
        	crt.k = crt.invoices.size();
           	crt.downloadXeroInvoicePdf();
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
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
           	crt.updateInvoiceID = '565acaa9-e7f3-4fbf-80c3-16b081ddae12';
        	crt.updateXeroCommissionInvoice();
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
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
           	crt.updateInvoiceID = '565acaa9-e7f3-4fbf-80c3-16b081ddae10';
        	crt.updateXeroDOFInvoice();
		Test.stopTest();
    }
    
    @isTest
    static void refresh(){
		TestXeroSetup.setupTestData();
		getStaticResourceMultiMock();
        Test_DataGeneratorHelper.createApplication();
            
		prepareInvoice('Finance Invoice', 'Finance', 1, 1);
        
        TestXeroSetup.setupTestInvoiceFinanceData(Test_DataGeneratorHelper.tstInvoice);
        TestXeroSetup.setupTestInvoiceOnlineData();
        
        Test.startTest();
        	GenerateProductInvoicesExtension crt = generateProductInvoicesExtension();
        	crt.Refresh();
		Test.stopTest();
    }
    
    //////////////////////////////////////////////////TEST CONFIGURATIONS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    private static void getStaticResourceMultiMock(){
		MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('https://api.xero-test.com/Invoices', 'XeroInvoicesMock');
        multimock.setStaticResource('https://api.xero-test.com/TrackingCategories?TrackingCategoryID=fcfa4b51-5489-4347-ae47-5dea90f33c75', 'XeroTrackingCategoriesMock');
		multimock.setStaticResource('https://api.xero-test.com/TrackingCategories?TrackingCategoryID=fcfa4b51-5489-4347-ae47-5dea90f33c75/Options', 'XeroTrackingCategoriesMock');
        multimock.setStaticResource('https://test.xero.com/Invoices/DownloadPdf?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae10', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource('https://api.xero-test.com/Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae10/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource('https://api.xero-test.com/Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae11/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource('https://api.xero-test.com/Invoices?InvoiceID=565acaa9-e7f3-4fbf-80c3-16b081ddae12/OnlineInvoice', 'XeroOnlineInvoiceMock');
        multimock.setStaticResource('https://test.c.cs6.visual.force.com/apex/GenerateProductInvoices?id=a0EN000000FJpVy', 'XeroContactsMock');
        multimock.setStatusCode(200);
		multimock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, multimock);        
    }
    
    private static GenerateProductInvoicesExtension generateProductInvoicesExtension(){
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        // Finance One
        PageReference calcRef = Page.GenerateProductInvoices;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        GenerateProductInvoicesExtension ctr = new GenerateProductInvoicesExtension(sc);
        return ctr;
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