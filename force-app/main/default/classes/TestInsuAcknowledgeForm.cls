@isTest(SeeAllData=true)
private class TestInsuAcknowledgeForm {
  @isTest
  static void testDocument() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoteMainDriver();
    Test_DataGeneratorHelper.createQuoteAnnotations();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
    Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
    quoting.App_Insurance_Quote__c = quote.Id;

    quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;


    quoting.Insurance_GAP_Type__c = 'GAP';
    
    quoting.Insurance_AIC_Income__c = null;
    quoting.Insurance_Warranty_Type__c = 'WARR';
    quoting.Insurance_NWC_Plan__c = null;

    quoting.Insurance_MV_Retail_Price__c = 1000;
    quoting.Insurance_GAP_Retail_Price__c = 1000;
    quoting.Insurance_AIC_Retail_Price__c = 1000;
    quoting.Insurance_Warranty_Retail_Price__c = 1000;
    quoting.Insurance_NWC_Retail_Price__c = 1000;

    quoting.Insurance_GAP_Acceptance__c = 'A';
    quoting.Insurance_AIC_Acceptance__c = 'A';
    quoting.Insurance_Warranty_Acceptance__c = 'A';
    quoting.Insurance_NWC_Acceptance__c = 'A';

    update quoting;

    quote.MV_Declining_Notes__c = 'XXXXX';
    update quote;

    PageReference pageRef = Page.InsuranceAcknowledgementForm;
    pageRef.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    InsuranceAcknowledgementFormExtension ctr = new InsuranceAcknowledgementFormExtension(
      sc
    );
    ctr.getDisplayGAPRTI();
    ctr.getDisplayLTI();
    ctr.getDisplayLPI();
    ctr.getDisplayWARR();
    ctr.getAcceptedGAPRTI();
    ctr.getAcceptedLPI();
    ctr.getAcceptedWARR();

    ctr.getIsThereAdditionalInfo();
    ctr.getIsLTIAdditionalInfo();
    ctr.getIsMVAdditionalInfo();
    ctr.getIsMVExtraQuestions();
    ctr.getIsFailureReasons();

    ctr.quoting.Insurance_GAP_Acceptance__c = 'D';
    ctr.quoting.Insurance_TAI_Acceptance__c = 'D';
    ctr.quoting.Insurance_LTI_Acceptance__c = 'D';
    ctr.quoting.Insurance_AIC_Acceptance__c = 'D';
    ctr.quoting.Insurance_Warranty_Acceptance__c = 'D';
    ctr.quoting.Insurance_NWC_Acceptance__c = 'D';
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();

    quoting.Insurance_GAP_Type__c = null;
    quoting.Insurance_AIC_Income__c = 1500;
    quoting.Insurance_Warranty_Type__c = null;
    quoting.Insurance_NWC_Plan__c = 'A';

    update quoting;

    ctr = new InsuranceAcknowledgementFormExtension(sc);
    ctr.getDisplayMV();
    ctr.getDisplayGAPRTI();
    ctr.getDisplayLTI();
    ctr.getDisplayLPI();
    ctr.getDisplayWARR();

    ctr.getAcceptedMV();
    ctr.getAcceptedGAPRTI();
    ctr.getAcceptedLPI();
    ctr.getAcceptedWARR();

    ctr.getDeclinedMV();
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();

    ctr.quoting.Insurance_GAP_Acceptance__c = 'D';
    ctr.quoting.Insurance_TAI_Acceptance__c = 'D';
    ctr.quoting.Insurance_LTI_Acceptance__c = 'D';
    ctr.quoting.Insurance_AIC_Acceptance__c = 'D';
    ctr.quoting.Insurance_Warranty_Acceptance__c = 'D';
    ctr.quoting.Insurance_NWC_Acceptance__c = 'D';
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();

    // Integrity
    ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    ctr.quoting.Insurance_NWC_Acceptance__c = 'D';
    ctr.quoting.Insurance_NWC_Qualifying__c = 'Y|Y|Y|N|Y';
    ctr.getHasIntegrityAdditionalInfo();
    ctr.getIntegrityQ1();
    ctr.getIntegrityQ2();
    ctr.getIntegrityQ3();
    ctr.getIntegrityQ4();
    ctr.getIntegrityQ5();

    ctr.getIntegrityQ1Res();
    ctr.getIntegrityQ2Res();
    ctr.getIntegrityQ3Res();
    ctr.getIntegrityQ4Res();
    ctr.getIntegrityQ5Res();

    // Partner user methods
    ctr.getIsPartnerUser();
    ctr.getBusinessLogo();
    ctr.getBusinessABN();
    ctr.getBusinessACL();
    ctr.getBusinessACN();
    ctr.getBusinessName();
    ctr.getBusinessPhone();
    ctr.getBusinessFax();
    ctr.getBusinessAddress();
    ctr.getCustomeFullname();
    
  }

  @isTest
  static void testLibertyDocument() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createQuoting();
    Custom_Opportunity__c opp = Test_DataGeneratorHelper.tstOpportunity;
    Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;

    quoting.Name = 'Liberty Drive';
    quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
    quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
    quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;


    quoting.Insurance_GAP_Type__c = 'GAP';
    
    quoting.Insurance_AIC_Income__c = null;
    quoting.Insurance_Warranty_Type__c = 'WARR';
    quoting.Insurance_NWC_Plan__c = 'Integrity';

    quoting.Insurance_MV_Retail_Price__c = 1000;
    quoting.Insurance_GAP_Retail_Price__c = 1000;
    quoting.Insurance_AIC_Retail_Price__c = 1000;
    quoting.Insurance_NWC_Retail_Price__c = 1000;

    quoting.Insurance_GAP_Acceptance__c = 'A';
    quoting.Insurance_AIC_Acceptance__c = 'A';
    quoting.Insurance_NWC_Acceptance__c = 'A';

    update quoting;

    PageReference pageRef = Page.InsuranceAcknowledgementForm;
    pageRef.getParameters().put('id', opp.Id);
    Test.setCurrentPageReference(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    InsuranceAcknowledgementFormExtension ctr = new InsuranceAcknowledgementFormExtension(
      sc
    );
    ctr.getDisplayGAPRTI();
    ctr.getDisplayLTI();
    ctr.getDisplayLPI();
    ctr.getDisplayWARR();
    ctr.getAcceptedGAPRTI();
    ctr.getAcceptedLPI();
    ctr.getAcceptedWARR();

    ctr.quoting.Insurance_VEI_Acceptance__c = 'D';
    ctr.quoting.Insurance_LPI_Acceptance__c = 'D';
    ctr.quoting.Insurance_Warranty_Acceptance__c = 'D';
    ctr.quoting.Insurance_NWC_Acceptance__c = 'D';
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();

    quoting.Insurance_VEI_Type__c = null;
    quoting.Insurance_LPI_Type__c = null;
    quoting.Insurance_Warranty_Type__c = null;
    quoting.Insurance_NWC_Plan__c = 'A';

    update quoting;

    ctr = new InsuranceAcknowledgementFormExtension(sc);
    ctr.getDisplayGAPRTI();
    ctr.getDisplayLTI();
    ctr.getDisplayLPI();
    ctr.getDisplayWARR();
    ctr.getAcceptedGAPRTI();
    ctr.getAcceptedLPI();
    ctr.getAcceptedWARR();
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();

    ctr.quoting.Insurance_VEI_Acceptance__c = 'D';
    ctr.quoting.Insurance_LPI_Acceptance__c = 'D';
    ctr.quoting.Insurance_Warranty_Acceptance__c = 'D';
    ctr.quoting.Insurance_NWC_Acceptance__c = 'D';
    ctr.getDeclinedGAPRTI();
    ctr.getDeclinedLPI();
    ctr.getDeclinedWARR();
  }
}