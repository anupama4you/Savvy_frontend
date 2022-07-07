@isTest(SeeAllData=true)
public class QuotingExtensionTest {
  
  @isTest static void testVariables() {
    Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    PageReference PepperMV = Page.PepperCalculatorMV;
    PepperMV.getParameters().put('id',o.Id);
    Test.setCurrentPageReference(PepperMV);
    Test.startTest();
    QuotingExtension qext = new PepperCalculatorMVExtension(sc);
    qext.resetQuote();
    qext.resetInsuranceAcceptance();
    qext.resetInsuranceProducts(true);
    qext.getPresentationUrlCode();
    qext.calculateQuote();
    qext.hasValidQuotation();
    QuotingExtension q2 = qext.quotingExt;


    // Calculated variables
    Boolean bln = false;
    bln = qext.presentationFinished;
    bln = qext.isInsProdReadonly;
    bln = qext.hasCustomerEmailSent;
    bln = qext.mvEditActive;
    bln = qext.gapEditActive;
    bln = qext.cciEditActive;
    bln = qext.warrantyEditActive;
    bln = qext.nwcEditActive;
    bln = qext.openPreviewPresentation;

    // Select Options
    List<SelectOption> opts = qext.paymentTypes;
    opts = qext.gapPayTypeOptions;
    opts = qext.cciPayTypeOptions;
    opts = qext.warrantyPayTypeOptions;
    opts = qext.nwcPayTypeOptions;
    opts = qext.cciTermOptions;
    
    opts = qext.yesNoOptions;

    qext = new QuotingExtension(sc);
    qext.getRealtimeNafVal();
    qext.getNetDepositVal();
    qext.calculateQuote();
    qext.hasValidQuotation();
    qext.storeQuotingData();
    
    qext = new QuotingExtension(sc, null);
    qext = new QuotingExtension(sc, new Set<String>{'OwnerId'});

    QuotingExtensionAbstract qea = qext.quotingExt;

    Test.stopTest();
  }

  @isTest static void testSavingInsProducts() {
    Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    PageReference PepperMV = Page.PepperCalculatorMV;
    PepperMV.getParameters().put('id',o.Id);
    Test.setCurrentPageReference(PepperMV);
    Test.startTest();
    QuotingExtension qext = new PepperCalculatorMVExtension(sc);
    qext.resetQuote();
    qext.resetInsuranceAcceptance();
    qext.resetInsuranceProducts(true);

    qext.deposit = 0;
    qext.tradeIn = 0;
    qext.payoutOn = 0;
    qext.netDepositCalc();
    PageReference rpt = qext.createPdf();
    qext.savePdfInCloud(rpt, 'APPROVAL');
    qext.savePdfInCloud(rpt, 'APPROVAL AMENDMENT');
    qext.savePdfInCloud(rpt, 'FORMAL_APPROVAL');

    // total amount
    qext.carPrice = 5000;
    
    // total insurances
    qext.gap = 100;
    qext.warranty = 100;
    qext.cci = 100;
    qext.nwc = 100;
    qext.gapIncome = 10;
    qext.warrantyIncome = 10;
    qext.cciIncome = 10;
    qext.nwcIncome = 10;

    qext.acceptQuoteMV();
    qext.acceptQuoteGAP();
    qext.acceptQuoteCCI();
    qext.acceptQuoteWRR();
    qext.acceptQuoteNWC();

    // Eric
    qext.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;

    qext.saveInsuranceProducts();
    rpt = qext.createPdf();
    
    // Liberty + Integrity
    qext.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;

    qext.saveInsuranceProducts();

    rpt = qext.createPdf();
    
    qext.gapLevel = 'Option 1 $20K';
    qext.calculateGAP();
    qext.calculateLPI();

    qext.previewCustomerPresentation();
    qext.processEmailPresentation();
    qext.sendCustomerPresentation();

    Test.stopTest();
  }

  @isTest static void testSimpleCalculations() {
    Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
    ApexPages.StandardController sc = new ApexPages.StandardController(o);
    PageReference PepperMV = Page.PepperCalculatorMV;
    PepperMV.getParameters().put('id',o.Id);
    Test.setCurrentPageReference(PepperMV);
    Test.startTest();
    QuotingExtension qext = new PepperCalculatorMVExtension(sc);
    qext.resetQuote();
    qext.resetInsuranceAcceptance();
    qext.resetInsuranceProducts(true);

    // total amount
    qext.carPrice = 5000;
    System.assert(qext.getTotalAmount(QuotingCalculation.CALC_QUOTING) > 0);
    System.assert(qext.getTotalAmount(QuotingCalculation.CALC_PROTECTED) > 0);

    // total insurances
    qext.mvLevel = 'Comp';
    qext.gapLevel = 'Gap';
    qext.cciLevel = 'Cci';
    qext.warrantyLevel = 'Warr';

    qext.gap = 100;
    qext.warranty = 100;
    qext.cci = 100;
    qext.nwc = 100;

    qext.gapIncome = 10;
    qext.warrantyIncome = 10;
    qext.cciIncome = 10;
    qext.nwcIncome = 10;

    qext.gapPayType = 'Financed';
    qext.warrantyPayType = 'Financed';
    qext.nwcPayType = 'Financed';
    qext.cciPayType = 'Financed';

    qext.acceptQuoteMV();
    qext.acceptQuoteGAP();
    qext.acceptQuoteCCI();
    qext.acceptQuoteWRR();
    qext.acceptQuoteNWC();

    qext.getTotalInsuranceType(QuotingCalculation.CALC_QUOTING);
    qext.getTotalInsuranceType(QuotingCalculation.PRO_FULLY);
    qext.getTotalInsuranceType(QuotingCalculation.PRO_STANDARD);
    qext.getTotalInsuranceType(QuotingCalculation.PRO_BASIC);
    qext.getTotalInsuranceType(InsuranceQuoteUtils.INS_PROD_GAP);
    qext.getTotalInsuranceType(InsuranceQuoteUtils.INS_PROD_WARR);
    qext.getTotalInsuranceType(InsuranceQuoteUtils.INS_PROD_NWC);
    qext.getTotalInsuranceType(InsuranceQuoteUtils.INS_PROD_CCI);

    // total insurances commissions
    qext.getTotalInsuranceIncomeType(QuotingCalculation.CALC_QUOTING);
    qext.getTotalInsuranceIncomeType(QuotingCalculation.PRO_FULLY);
    qext.getTotalInsuranceIncomeType(QuotingCalculation.PRO_STANDARD);
    qext.getTotalInsuranceIncomeType(QuotingCalculation.PRO_BASIC);
    qext.getTotalInsuranceIncomeType(InsuranceQuoteUtils.INS_PROD_GAP);
    qext.getTotalInsuranceIncomeType(InsuranceQuoteUtils.INS_PROD_WARR);
    qext.getTotalInsuranceIncomeType(InsuranceQuoteUtils.INS_PROD_NWC);
    qext.getTotalInsuranceIncomeType(InsuranceQuoteUtils.INS_PROD_CCI);
    
    qext.getLPITotalAmount();

    // Displaying products
    qext.getDisplayMVProduct();
    qext.getDisplayGAPProduct();
    qext.getDisplayLPIProduct();
    qext.getDisplayTyWhProduct();

    qext.getDisplayEricWARRProduct();
    qext.getDisplayIntegrityWARRProduct();

    // List options
    qext.getMVOptions();
    qext.getShortfallOptions();
    qext.getLPIOptions();
    qext.getWarrantyOptions();
    qext.getInsTermOptions();

    // product calculated
    qext.getIsGAPCalculated();
    qext.getIsLPICalculated();

    // Get Insurances payments
    qext.gapTerm = '12';
    qext.cciTerm = '12';
    qext.warrantyTerm = '12';
    qext.nwcTerm = '12';
    qext.getMVPayment();
    qext.getShortfallPayment();
    qext.getLPIPayment();
    qext.getWARRPayment();
    qext.getNWCPayment();

    // Accept / decline products
    qext.acceptQuoteMV();
    qext.declineQuoteMV();
    qext.acceptQuoteGAP();
    qext.declineQuoteGAP();
    qext.acceptQuoteCCI();
    qext.declineQuoteCCI();
    qext.acceptQuoteWRR();
    qext.declineQuoteWRR();
    qext.acceptQuoteNWC();
    qext.declineQuoteNWC();

    // Events
    qext.onChangeMV();
    qext.onChangeGAP();
    qext.onChangeLPI();
    qext.onChangeWARR();
    qext.checkManuallyNWCPrice();

    // External data
    qext.getAssetTypeOpp();
    // System.assert(String.isNotBlank(qext.getAssetTypeOpp()));

    // Updating quoting data - Eric
    qext.acceptQuoteMV();
    qext.acceptQuoteGAP();
    qext.acceptQuoteCCI();
    qext.acceptQuoteWRR();
    qext.acceptQuoteNWC();

    qext.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
    qext.getDisplayEricWARRProduct();
    qext.updateQuotingData();

    // loading quoting data
    qext.loadQuotingInsuranceData();

    // Updating quoting data - Liverty + Integrity
    qext.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    qext.getLPIPayment();
    qext.updateQuotingData();
    // loading quoting data
    qext.loadQuotingInsuranceData();

    // Loading quoting data
    qext.loadQuotingData();

    // Validation presentation
    qext.canPresentQuote();

    // Validations

    // MV
    qext.hasProductMV();
    // GAP
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    qext.hasProductGAP();
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
    qext.hasProductGAP();
    // LPI
    qext.hasProductLPI();
    // Warr
    qext.hasProductWARR();
    // Nwc
    qext.hasProductNWC();

    // Insurance validations
    qext.hasProductMVErrors();
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    qext.hasProductGAPErrors();
    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_LIBE;
    qext.hasProductGAPErrors();
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    qext.hasProductLPIErrors();
    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_LIBE;
    qext.hasProductLPIErrors();
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
    qext.hasProductWARRErrors();
    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    qext.hasProductWARRErrors();

    qext.isInsuranceValidationOK();

    // Re creating a quote
    qext.reCreateQuote();

    // 
    qext.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    qext.mvLevel = 'Comp';
    qext.mv = 100;
    qext.mvIncome = 10;
    qext.mvAcceptance = 'U';

    qext.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    qext.gapLevel = 'Gap';
    qext.gap = 100;
    qext.gapIncome = 10;
    qext.gapAcceptance = 'U';

    qext.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    qext.cciLevel = 'Cci';
    qext.cci = 100;
    qext.cciIncome = 10;
    qext.cciAcceptance = 'U';    

    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
    qext.warrantyLevel = 'Warr';
    qext.warranty = 100;
    qext.warrantyIncome = 10;
    qext.warrantyAcceptance = 'U';

    qext.insuranceProductSelected();

    qext.getCustomerPresentationStatusStyle();
    qext.processEmailPresentation();


    qext.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    qext.nwc = 100;
    qext.nwcIncome = 10;
    qext.nwcAcceptance = 'U';

    qext.insuranceProductSelected();


    qext.isInvalidInsuranceInfo('opt', 'level', 100, 10, false, '', false, null, false);

    qext.term = 24;
    qext.isInvalidInsuranceInfo('opt', 'level', 100, 10, false, '36', false, null, false);

    qext.isInvalidInsuranceInfo('opt', 'level', 100, 10, false, '36', true, null, false);

    qext.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
    qext.getCustomerPresentationStatusStyle();
    qext.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
    qext.getCustomerPresentationStatusStyle();

    qext.getInsuranceFailureReasons();
    
    Test.stopTest();
  }

}