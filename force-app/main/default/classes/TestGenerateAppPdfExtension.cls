@isTest
public class TestGenerateAppPdfExtension {
    
  @isTest static void testExtension() {
    Test_DataGeneratorHelper.createApplication();
		Test_DataGeneratorHelper.createQuoting();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application__c app = Test_DataGeneratorHelper.tstApp;
    Test.startTest();
    PageReference pageRef = Page.GenerateAppPdf;
		pageRef.getParameters().put('id', opp.Id);
    pageRef.getParameters().put('IS_PREAPPROVAL', 'true');
		Test.setCurrentPageReference(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    GenerateAppPdfExtension ctr = new GenerateAppPdfExtension(sc);

    // Variables
    // ctr.ydtCalc = new YTDCalculatorDTO();
    ctr.servCalc = new AppServicingCalculatorDTO();
    ctr.assetDetail = new AssetDetailsDTO();
    ctr.otherAssetList = new  List<Application_Other_Asset__c>();
    ctr.propertyList = new  List<Application_Other_Asset__c>();
    ctr.vehicleList = new  List<Application_Other_Asset__c>();
    Double a = ctr.offset;

    // methods
    ctr.getNumberForNotes();
    ctr.getNumberForTypeAsset();
    ctr.getNumberForCompanyDetails();
    ctr.getNumberForApplicantDetails();
    ctr.getNumberForCurrentResidential();
    ctr.getNumberForPreviousResidential();
    ctr.getNumberForEmploymentIncome();
    ctr.getNumberForAssetDetailLTV();
    // ctr.getNumberForYTDCalculation();
    ctr.getNumberForOtherIncome();
    ctr.getNumberForServicingCalc();
    ctr.getNumberForFinanceDetailLivingExp();
    ctr.getNumberForFinanceDetailAssets();
    ctr.getNumberForPersonalReferences();
    ctr.getNumberForDeclaration();
    ctr.getPrevEmployApp1();
    ctr.getPrevEmployApp2();
    ctr.getHasAssetProperties();
    ctr.getHasAssetVehicles();
    ctr.getHasOtherLoans();
    ctr.getIncomesApp1();
    ctr.getIncomesApp2();
    ctr.getNumberForFinanceDetailLiabilities();
    ctr.getAccountVar();
    Test.stopTest();
  }

}