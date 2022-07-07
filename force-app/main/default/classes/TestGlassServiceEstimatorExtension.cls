@isTest
public class TestGlassServiceEstimatorExtension {
    public static testMethod void testSavePdf() {
        Test_DataGeneratorHelper.createApplication2();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = null;
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
        
        ctr.savePdf();
    }

    public static testMethod void testSavePdf2() {
        Test_DataGeneratorHelper.createApplication3();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = null;
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
        
        ctr.savePdf();
    }
    
    public static testMethod void testLoadSavedData() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='ANZ Consumer';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        insert a;
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
   
    public static testMethod void testLoadSavedData2() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Macquarie';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData3() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Pepper';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData4() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Liberty';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData5() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Finance 1';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData6() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Money 3';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData7() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Yamaha';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData8() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Metro';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData9() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Latitude';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData10() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='AFS';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData11() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData12() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='l';
        a.Loan_Product__c='Consumer Loan';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData13() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Lease';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData14() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testLoadSavedData15() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='A';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData16() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='A';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData17() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='A';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData18() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='A';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData19() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='A';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData20() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='A';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='U';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }

    public static testMethod void testLoadSavedData21() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Application_Quoting__c a = new Application_Quoting__c();
        
        a.Name='Green Light';
        a.Loan_Product__c='Chattel';
        a.Vehicle_Price__c=10000;
        a.Insurance_Warranty_Acceptance__c='U';
        a.Insurance_Warranty_Retail_Price__c=0;
        a.Insurance_NWC_Acceptance__c='U';
        a.Insurance_NWC_Retail_Price__c=0;
        a.Insurance_GAP_Acceptance__c='U';
        a.Insurance_GAP_Retail_Price__c=0;
        a.Insurance_VEI_Acceptance__c='U';
        a.Insurance_VEI_Retail_Price__c=0;
        a.Insurance_LTI_Acceptance__c='U';
        a.Insurance_LTI_Retail_Price__c=0;
        a.Insurance_LPI_Acceptance__c='U';
        a.Insurance_LPI_Retail_Price__c=0;
        a.Insurance_AIC_Acceptance__c='A';
        a.Insurance_AIC_Retail_Price__c=0;
        a.Application_Fee__c=0;
        a.Registration_Fee__c=0;
        a.Customer_Profile__c='c';
        a.DOF__c=0;
        a.PPSR__c=0;
        a.Opportunity__c=Test_DataGeneratorHelper.tstOpportunity.Id;
        
        insert a;
        
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
    }
    
    public static testMethod void testSave() {
        Test_DataGeneratorHelper.createApplication4();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = null;
        Test_DataGeneratorHelper.reloadOpportunity();
        TestS3Utils.createAmazonS3ParametersService();
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
        
        ctr.carPrice=10000;
        ctr.assetType = 'Marine';
        ctr.makeOVehicle = 'Marine Make';
        ctr.modelOVehicle = 'Marine Model';
        ctr.variantOVehicle = 'Marine Variant';
        ctr.seriesOVehicle = 'Marine series';
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
    }
  
    public static testMethod void testGeneral() {
    	Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        
        //Application_Asset_Detail__c aad = new Application_Asset_Detail__c();
        //aad.Type__c = 'Car';
        //aad.Condition__c = 'new';
        //insert aad;
        //Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = aad.Id;

        //update Test_DataGeneratorHelper.tstOpportunity;

        //Custom_Opportunity__c opp = APIServiceManager.getCustomOpportunityForApplication(Test_DataGeneratorHelper.tstOpportunity);
        
        Test_DataGeneratorHelper.reloadOpportunity();
        
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        //ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
        
        //Variables
        ctr.assetType = 'Car';
        ctr.newUsed = 'new';
        
        ctr.isDetail = 0;
        ctr.loadNewUsedYearOptions();
        ctr.year = '2017';
        ctr.loadLenderMakeOptions();
        ctr.make = 'AUD';
        ctr.lender = 'Pepper';
        
        ctr.loadMakeModelOrFamilyOptions();
        ctr.make = 'AUD';
        ctr.loadMakeModelOrFamilyOptions();
        ctr.make = null;
        ctr.isDetail = 0;
        ctr.loadMakeModelOrFamilyOptions();
        ctr.model = 'A1';
        ctr.isDetail=0;
        ctr.loadModelVariantOptions();
        ctr.variant = '18d M-SPORT';
        ctr.isDetail = 0;
        ctr.loadVariantSeriesOptions();
        /*        
        ctr.makeObj = new Glass_Make__c();
        ctr.makeObj.Name = 'AUDI';
        ctr.modelObj = new Glass_Model__c();
        ctr.modelObj.Name = 'A1 SPORTBACK 1.2 TFSI ATTRACTION 8X MY12';
        ctr.modelObj.Type_Source__c = 'PVG';

        ctr.savePreApproval();
        */
        ctr.assetOptions = new List<String>{'RRRR'};
                
        AssetOptionDTO fo2 = new AssetOptionDTO('Optional','ACC',1200.0);
        fo2.value = 1000.0;
        ctr.assetOptionsData = new MAP<String, AssetOptionDTO>();
        ctr.assetOptionsData.put('RRRR', fo2);
        ctr.variantObj = new Glass_Variant__c();
        ctr.variantObj.Code__c = '23423R2D23E2';
        ctr.variantObj.Retail_Price__c = 900.0;
        ctr.variantObj.Trade_Low_Price__c = 250.0;
        ctr.variantObj.Trade_Price__c = 500.0;
        ctr.calculateFactoryOptions();
                
        ctr.getTradeLowAdjustedValue();
        ctr.getTradeAdjustedValue();
        ctr.getReatilAdjustedValue();
        ctr.getTradeLowGlassValue();
        ctr.getTradeGlassValue();
        ctr.getRetailGlassValue();
        ctr.variantObj=null;
        ctr.getRetailGlassValue();
        
        ctr.getLtvFeeValue();
        ctr.year = '2006';
        ctr.getLtvCarAge();
        ctr.getLtvNAFValue();
        ctr.newUsed = 'used';
        ctr.lender = 'ANZ';
        ctr.getLtvValueLabel();
        ctr.getLtvValue();
        ctr.lender = 'Liberty';
        ctr.getLtvValueLabel();
        ctr.getLtvValue();
        
        ctr.getLtvLvrLabel();
        ctr.lender = 'Pepper';
        ctr.getLtvLvrLabel();
        
        ctr.getLtvLvrValue();
		
        ctr.typeLoan = 'Consumer';
        ctr.carPrice = 25000.0;
        ctr.actualKms = 120000;
        ctr.fees = ctr.getLtvFeeValue();
        
        ctr.getAverageKM();
        ctr.putFeesValue();
        ctr.getCarLabel();
                
        //Pdf
        
        ctr.carPrice = 25000.0;
        ctr.savePdf();
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        
        //Other assert type
        /*
        ctr.assetType = 'Marine';
        ctr.makeOVehicle = 'Marine Make';
        ctr.modelOVehicle = 'Marine Model';
        ctr.variantOVehicle = 'Marine Variant';
        ctr.seriesOVehicle = 'Marine series';
        ctr.savePdf();
        */
        ctr.lender = 'St George';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'ANZ';
        ctr.typeLoan = 'Consumer';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();
        ctr.typeLoan = 'Commercial';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();
        ctr.typeLoan = 'Chattel Mortgage';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Money 3';
        ctr.typeLoan = 'Consumer';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Yamaha';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Metro';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Latitude';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'AFS';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Green Light';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Liberty';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Finance 1';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.lender = 'Macquarie';
        ctr.getLtvLvrLabel();
        ctr.getLtvLvrValue();

        ctr.getStreetTypeOptions();
        ctr.getIsUserSettlementTeam();
        ctr.goPrivateSaleTaxInvoice();
        ctr.Opp.Application__c=null;
        ctr.goPrivateSaleTaxInvoice();
        List<AssetOptionDTO> dtoList = AssetOptionDTO.build('Optional', 'A:12,B:34,D:E,ER,TY');
        
        ctr.variantObj = null;
        ctr.getTradeLowAdjustedValue();
        ctr.getTradeAdjustedValue();
        ctr.getReatilAdjustedValue();
        ctr.getTradeLowGlassValue();
        ctr.getTradeGlassValue();
        ctr.listCars();
        ctr.year = '2017';
        ctr.make = 'AUD';
        ctr.family = 'A1';
        ctr.variant = 'SPORTBACK 1.0 TFSI';
        ctr.series = '8X MY17';
        ctr.carID = 'UV017A';

        ctr.setParameters();
        ctr.getGlassVariantCar();
        
        ctr.getCarsSize();
        ctr.getCarsList();
        ctr.lender = 'Pepper';
        ctr.getDisplayRedbookForm();
        
        ctr.lender = null;
        ctr.savePdf();
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        
        ctr.assetType = null;
        ctr.makeOVehicle = null;
        ctr.modelOVehicle = null;
        ctr.variantOVehicle = null;
        ctr.seriesOVehicle = null;
        ctr.savePdf();
        ctr.savePreApproval();
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        
        ctr.year = null;
        ctr.savePdf();
                
        ctr.typeLoan = null;
        ctr.savePdf();
                
        ctr.actualKms = null;
        ctr.lender = 'Pepper';
        ctr.savePdf();
                
        ctr.lender='Pepper';
        ctr.getLtvNAFValue();
        ctr.fees=0;
        ctr.carPrice=null;
        ctr.deposit=null;
        ctr.warranty=null;
        ctr.gap=null;
        ctr.lpi=null;
        ctr.lti=null;
        
        ctr.savePdf();
                
        ctr.calculateFactoryOptions();
        ctr.variantObj = new Glass_Variant__c();
        ctr.variantObj.KM_Category__c = 'A';
        ctr.variantObj.Average_Kms__c = 40;
        ctr.actualKms = 90000;
        ctr.calculateKmsAdjustment();
        
        Glass_Make__c p = new Glass_Make__c();
        p.Name = 'MY MAKE';
        p.Code__c = 'll';
        insert p;
        Glass_Model__c m = new Glass_Model__c();
        m.Name = 'MY MODEL';
        m.Code__c = 'M123';
        m.Make__c = p.Id;
        insert m;
        Glass_Variant__c v = new Glass_Variant__c();
        v.Name = '2342342';
        v.Code__c = 'COV123';
        v.Model__c = m.id;
        v.New_Price__c = 77777.7;
        v.Trade_Low_Price__c = 1235.2;
        v.Trade_Price__c = 454.0;
        v.Retail_Price__c = 45454.0;
        v.Make__c = 'MMM';
        v.NVIC__c = 'UV017A';
        insert v;
        
        ctr.year = '2017';
        ctr.make = 'AUD';
        ctr.family = 'A1';
        ctr.variant = 'SPORTBACK 1.0 TFSI';
        ctr.series = '8X MY17';
        ctr.carID = 'UV017A';
        ctr.assetOptions = new List<String>{'RRRR'};
        ctr.assetOptionsData = new MAP<String, AssetOptionDTO>();
        AssetOptionDTO fo = new AssetOptionDTO('Optional','ACC',1200.0);
        fo.value = 1000.0;
        ctr.assetOptionsData.put('RRRR', fo);
        ctr.variantObj = new Glass_Variant__c();
        ctr.variantObj.Retail_Price__c = 900.0;
        ctr.variantNewPrice = 500.0;
        ctr.calculateFactoryOptions();
        ctr.loadVariantFactoryOptions();
    }
    
 	public static testMethod void testGeneratePdf() {   
 		Test_DataGeneratorHelper.createApplication();
        Glass_Make__c p = new Glass_Make__c();
        p.Name = 'MY MAKE';
        p.Code__c = 'll';
        insert p;
        Glass_Model__c m = new Glass_Model__c();
        m.Name = 'MY MODEL';
        m.Code__c = 'M123';
        m.Make__c = p.Id;
        insert m;
        Glass_Variant__c v = new Glass_Variant__c();
        v.Name = '2342342';
        v.Code__c = 'COV123';
        v.Model__c = m.id;
        v.New_Price__c = 77777.7;
        v.Trade_Low_Price__c = 1235.2;
        v.Trade_Price__c = 454.0;
        v.Retail_Price__c = 45454.0;
        insert v;
        
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        //Parameters
        pageRef.getParameters().put('VARIANT_CODE', v.Code__c);
        pageRef.getParameters().put('TYPE_SOURCE', '45646456');
        pageRef.getParameters().put('MAKE', '45646456');
        pageRef.getParameters().put('OPTIONS_CHECKED', '45646456');
        pageRef.getParameters().put('TOTAL_PRIECE_OPTIONS', '45646456');
        pageRef.getParameters().put('TOTAL_TRADE_LOW_OPTIONS', '45646456');
        pageRef.getParameters().put('TOTAL_TRADE_OPTIONS', '45646456');
        pageRef.getParameters().put('TOTAL_RETAIL_OPTIONS', '45646456');
        pageRef.getParameters().put('NEWUSED', '45646456');
        pageRef.getParameters().put('TYPE_LOAN', '45646456');
        pageRef.getParameters().put('CAR_PRICE', '45646456');
        pageRef.getParameters().put('DEPOSIT', '45646456');
        pageRef.getParameters().put('WARRANTY', '45646456');
        pageRef.getParameters().put('GAP', '45646456');
        pageRef.getParameters().put('LPI', '45646456');
        pageRef.getParameters().put('LTI', '45646456');
        pageRef.getParameters().put('CAR_AGE', '45646456');
        pageRef.getParameters().put('FEES', '45646456');
        pageRef.getParameters().put('LTV_LABEL', '45646456');
        pageRef.getParameters().put('LTV_VALUE', '45646456');
        pageRef.getParameters().put('NAF', '45646456');
        pageRef.getParameters().put('LVR_LABEL', '45646456');
        pageRef.getParameters().put('LVR_VALUE', '45646456');
        pageRef.getParameters().put('PURCHASE_TYPE', 'Dealer');
        
        pageRef.getParameters().put('ASSET_TYPE', 'Car');
        pageRef.getParameters().put('MAKE_OVHEICLE', 'dto.makeOVehicle');
        pageRef.getParameters().put('MODEL_OVEHICLE', 'dto.modelOVehicle');
        pageRef.getParameters().put('VARIANT_OVEHICLE', 'dto.variantOVehicle');
        pageRef.getParameters().put('SERIES_OVEHICLE', 'dto.seriesOVehicle');
        pageRef.getParameters().put('YEAR', 'dto.year');
        
        pageRef.getParameters().put('LVR_VALUE', 'N/A');
        pageRef.getParameters().put('LTV_VALUE', 'N/A');
        pageRef.getParameters().put('TOTAL_TRADE_LOW_KMS', '1200');
        pageRef.getParameters().put('TOTAL_TRADE_KMS', '1400');
        pageRef.getParameters().put('TOTAL_RETAIL_KMS', '1500');
                
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        GlassServicePdfExtension ctr = new GlassServicePdfExtension(sc);       
        
        ctr.getNewPriceValue();
        ctr.getTradeLowGlassValue();
        ctr.getTradeGlassValue();
        ctr.getRetailGlassValue();
        ctr.getNewPriceAdjustedValue();
        ctr.getTradeLowAdjustedValue();
        ctr.getTradeAdjustedValue();
        ctr.getReatilAdjustedValue();
        ctr.getCarLabel();
        ctr.getAverageKmValue();
        ctr.totalTradeLowPriceKms = 0;
        ctr.totalTradePriceKms = 0;
        ctr.totalRetailPriceKms = 0;
        ctr.variantObj = null;  //
        ctr.getNewPriceValue();
        ctr.getTradeLowGlassValue();
        ctr.getTradeGlassValue();
        ctr.getRetailGlassValue();
        ctr.getNewPriceAdjustedValue();
        ctr.getTradeLowAdjustedValue();
        ctr.getTradeAdjustedValue();
        ctr.getReatilAdjustedValue();
        ctr.getAverageKmValue();
        ctr.assetType = 'Caravan';
        ctr.getCarLabel();

        AssetDetailsDTO dto = new AssetDetailsDTO();
        dto.variantObj = v;
        dto.getNewPriceValue();
        dto.getTradeLowGlassValue();
        dto.getTradeGlassValue();
        dto.getRetailGlassValue();
        dto.getNewPriceAdjustedValue();
        dto.getTradeLowAdjustedValue();
        dto.getTradeAdjustedValue();
        dto.getReatilAdjustedValue();
        dto.getAverageKmValue();
        dto.getCarLabel();
        dto.assetStandardFeautersData = new List<Glass_Factory_Option__c>();
        dto.totalPriceOptions = null;
        dto.getNewPriceValue();

        ctr.getAccountVar();
    }

    public static testMethod void testPPSRCertificate() { 
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.tstOpportunity.Purchase_Type__c = 'Private';
        Test_DataGeneratorHelper.reloadOpportunity();
        
        PageReference pageRef = Page.GlassServiceEstimator;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        //ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        GlassServiceEstimatorExtension ctr = new GlassServiceEstimatorExtension(sc);
        ctr.lender = 'Pepper';
        ctr.family = 'A1';
        ctr.year = '2017';
        ctr.makeRedbook= '';
        ctr.loadFamilyBadgeOptions();
        ctr.loadRedbookVehicle('RedbookKey');
        Redbook_Vehicle__c r = new Redbook_Vehicle__c();
        r.Name = 'AUVNISS2015AEHK';
        r.Description__c = 'D23 RX Cab Chassis King Cab 4dr Man 6sp 4x2 1261kg 2.3DT';
        r.Badge_Description__c = 'RX';
        r.Year_Group__c = 2015;
        ctr.vehicleObj = r;
        ctr.badgeRedbook = ctr.vehicleObj.Badge_Description__c;
        ctr.loadBadgeVariantOptions();
        Application_Asset_Detail__c a = new Application_Asset_Detail__c();
        a.Redbook_Key__c = 'r';
        ctr.variantRedbook=a.Redbook_Key__c;
        ctr.getVehicleKey();

        ctr.saveAmendment();
        ctr.vin='JS1SP46A000504266';
        ctr.requestPPSRCertificate();
    }
}