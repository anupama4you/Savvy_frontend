@isTest(SeeAllData=true)
public class TestWisrVLCalc {
  @isTest
  static void testCalculator() {
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.WisrVLCalc;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    Test.startTest();
    WisrVLCalcExtension ctr = new WisrVLCalcExtension(sc);
    
    ctr.reset();
    ctr.calculate();
    System.assert(ctr.rental == 0, 'Rental should be zero  :(');

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 15000.00;
    ctr.applicationFee = 475;
    ctr.dof = 900;
    ctr.term = 60;
    ctr.creditScore = 700;
    ctr.vehicleYear = Date.today().year();
    ctr.profile = getProfiles()[0];
    ctr.lvr = 110;
    ctr.baseRateCalc();    
    ctr.clientRate = ctr.maxRate;
    ctr.getClientRateoptions();
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, 'Rental should not be zero :(');

    // save a quote
    ctr.deposit = 0.0;
    ctr.tradeIn = 0.0;
    ctr.payoutOn = 0.0;
    ctr.saveQuoting();

    // Load quoting
    ctr = new WisrVLCalcExtension(sc);

    // Rates
    ctr.getRates();

    // calculate fees
    ctr.reset();
    ctr.carPrice = 45000.00;
    ctr.calculateFees();
    System.assert(ctr.maxAppFee > 0, 'Max. App Fee should not be zero :( for a naf of $' + ctr.getRealtimenafVal());
    ctr.carPrice = 25000.00;
    ctr.calculateFees();
    System.assert(ctr.maxAppFee > 0, 'Max. App Fee should not be zero :( for a naf of $' + ctr.getRealtimenafVal());
    ctr.carPrice = 15000.00;
    ctr.calculateFees();
    System.assert(ctr.maxAppFee > 0, 'Max. App Fee should not be zero :( for a naf of $' + ctr.getRealtimenafVal());
    ctr.carPrice = 8500.00;
    ctr.calculateFees();
    System.assert(ctr.maxAppFee > 0, 'Max. App Fee should not be zero :( for a naf of $' + ctr.getRealtimenafVal());
    ctr.carPrice = 6000.00;
    ctr.calculateFees();
    
    // Other methods
    ctr.getLenderQuoting();
    ctr.getVehicleYearOptions();
    ctr.getProfileOptions();
    
    ctr.carPrice = 10;
    ctr.applicationFee = 0;
    ctr.clientRate = 2;
    ctr.baseRate = 4;
    ctr.term = 0;
    ctr.isValidationOk();
    ctr.applicationFee =100;
    ctr.maxAppFee = 10;
    ctr.dof = 100;
    ctr.maxDof = 10;
    ctr.clientRate = 20;
    ctr.maxRate = 4;
    ctr.term = 84;
    ctr.creditscore = 100;
    ctr.carPrice = 100000;
    ctr.vehicleYear = 10;
    ctr.lvr = 200;
    ctr.isValidationOk();

    ctr.applicationFee = 0;
    ctr.appFeeOnChange();
    ctr.applicationFee = 100;
    ctr.appFeeOnChange();

    ctr.dof = 0.00;
    ctr.dofOnChange();
    ctr.dof = 100;
    ctr.dofOnChange();

    ctr.getIsBrokerPartnerUser();

    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();

    Test.stopTest();
  }

  @isTest
  static void testInsuranceProducts() {
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.WisrVLCalc;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    Test.startTest();
    WisrVLCalcExtension ctr = new WisrVLCalcExtension(sc);
    
    ctr.reset();
    ctr.calculate();
    System.assert(ctr.rental == 0, 'Rental should be zero  :(');
    ctr.savePreApproval();    // Validation should fail

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 15000.00;
    ctr.applicationFee = 475;
    ctr.dof = 900;
    ctr.term = 60;
    ctr.creditScore = 700;
    ctr.vehicleYear = Date.today().year();
    ctr.profile = getProfiles()[0];
    ctr.lvr = 110;
    ctr.baseRateCalc();    
    ctr.clientRate = ctr.maxRate;
    ctr.getClientRateoptions();
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, 'Rental should not be zero :(');

    // no insurance products means TRUE
    System.assert(ctr.insuranceProductSelected());
    // Motor Vehicle
    ctr.quoting.Insurance_MV_Options__c = InsuranceQuoteUtils.INS_PROD_MV_ERIC;
    ctr.mvLevel = 'MV';
    ctr.mv = 1000.0;
    ctr.mvIncome = 100.0;
    System.assert(!ctr.insuranceProductSelected());
    ctr.mvAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());
    // GAP
    ctr.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    ctr.gapLevel = 'GAP';
    ctr.gap = 1000;
    ctr.gapIncome = 100;
    ctr.gapTerm = String.valueOf(ctr.term);
    System.assert(!ctr.insuranceProductSelected());
    ctr.gapAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());
    // Warranty
    ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
    ctr.warrantyLevel = 'Warrlevel';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100.0;
    ctr.warrantyTerm = String.valueOf(ctr.term);
    System.assert(!ctr.insuranceProductSelected());
    ctr.warrantyAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());

    // lpi - cci
    System.debug('LPI tests...');
    ctr.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    ctr.cciLevel = 'LPI Level';
    ctr.cci = 15000;
    ctr.cciIncome = 100;
    ctr.cciTerm = String.valueOf(ctr.term);
    System.assert(!ctr.insuranceProductSelected());
    ctr.cciAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());

    ctr.savePreApproval();
    ctr.saveAmendment();

    // NWC
    ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    ctr.warrantyAcceptance = null;
    ctr.warrantyLevel = null;
    ctr.warranty = null;
    ctr.warrantyIncome = null;
    ctr.nwc = 15000;

    System.assert(!ctr.insuranceProductSelected());
    ctr.nwcAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());

    ctr.checkManuallyNWCPrice();
    // NWC
    ctr.nwcPlan = 'Bronze';
    ctr.nwcTerm = '36';
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcParam.type_p = 'Safeguard';
    ctr.nwcParam.vehicleAgeYears = 30;
    ctr.nwcParam.actualKm = 400000;
    ctr.calculateNWC();
    ctr.nwcPlan = 'Silver';
    ctr.calculateNWC();
    ctr.nwcPlan = 'Gold';
    ctr.calculateNWC();
    ctr.nwcPlan = 'Platinum';
    ctr.calculateNWC();
    ctr.nwcPlan = 'A';
    ctr.nwcParam.type_p = 'Integrity';
    ctr.calculateNWC();

    ctr.priceCustomer = 1000.20;
    ctr.nwcParam.isManuallyNWCPrice = true;
    ctr.nwcParam.nwcPriceToCustomer = null;
    ctr.checkManuallyNWCPrice();
    ctr.nwcParam.isManuallyNWCPrice = true;
    ctr.nwcParam.nwcPriceToCustomer = 1200;
    ctr.checkManuallyNWCPrice();
    ctr.nwcParam.isManuallyNWCPrice = true;
    ctr.priceCustomer = null;
    ctr.checkManuallyNWCPrice();
    ctr.nwcAcceptance = 'A';
    ctr.nwcParam.type_p = 'Other';
    ctr.nwc = 1000.0;
    ctr.nwcIncome = 100.0;
    ctr.isNWCValidationOk = true;

    ctr.savePreApproval();
    ctr.saveFormalApproval();   

    // Load quoting
    ctr = new WisrVLCalcExtension(sc);

    Test.stopTest();
  }
  
  @isTest
  static void testAssetDetailValidation() {
    Test_DataGeneratorHelper.createOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.WisrVLCalc;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);

    Test.setCurrentPageReference(calcRef);
    Test.startTest();

    WisrVLCalcExtension ctr = getBasicQuotation(sc);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, '[A] Rental should not be zero :(');
    // Not Application
    System.debug('testCreateQuote >> ' + ctr.opp.Application__c);
        // Application not finished
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    ctr = getBasicQuotation(sc);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, '[B] Rental should not be zero :(');

    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.reloadOpportunity();
    sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    ctr = getBasicQuotation(sc);
    
    ctr.isValidAssetDetails();

    Test.stopTest();
  }

  @isTest
  static void testNWCProduct() {
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.WisrVLCalc;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    Test.startTest();

    WisrVLCalcExtension ctr = getBasicQuotation(sc);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, '[A] Rental should not be zero :(');
    
    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.nwcParam.awd4wd = 'No';
    ctr.nwcParam.luxuryCar = 'Yes';
    ctr.nwcParam.type_p = 'NWC';
    ctr.nwcParam.isManuallyNWCPrice = false;
    //ctr.nwcParam.nwcPriceToCustomer = 14000;
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcPlan = 'A';
    ctr.nwcTerm = '12';
    ctr.nwcParam.state = 'SA';
    //NWCCalculator HJ - F - 12-07-2018

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.calculateNWC();
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.nwcParam.awd4wd = 'No';
    ctr.nwcParam.luxuryCar = 'Yes';
    ctr.nwcParam.type_p = 'NWC';
    ctr.nwcParam.isManuallyNWCPrice = true;
    ctr.nwcParam.nwcPriceToCustomer = 14000;
    ctr.nwcParam.assetType = 'Car';
    ctr.nwcPlan = 'A';
    ctr.nwcTerm = '12';
    ctr.nwcParam.state = 'SA'; 
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    ctr.nationalWarrantyCalc();
    //NWCCalculator HJ - F - 12-07-2018
    Test.stopTest();
  }

  @isTest
  static void testPresentation() {
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.WisrVLCalc;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);

    Test.setCurrentPageReference(calcRef);
    Test.startTest();

    WisrVLCalcExtension ctr = getBasicQuotation(sc);
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0, '[A] Rental should not be zero :(');
    ctr.savePreApproval();
    System.assert(ctr.quoting.Id != null, '[B] Saving for PreApproval fail :(');
    // Preparing quote data
    Test_DataGeneratorHelper.quote.Financier_Name__c = WisrVLCalcExtension.LENDER_QUOTING;
    update Test_DataGeneratorHelper.quote;
    

    ctr.Opp.Application__c = null;
    ctr.sendCustomerEmail1();

    ctr.Opp.Application__c = Test_DataGeneratorHelper.tstApp.Id;
    // MV
    ctr.mvAcceptance = 'U';
    ctr.mvLevel = 'Comp';
    ctr.mv = 1000.0;
    ctr.mvIncome = 100.0;
    // Warranty
    ctr.warrantyAcceptance = 'U';
    ctr.warrantyLevel = 'Warrlevel';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100.0;
    System.assert(ctr.isValidationOk(), 'Saving MV (no income value) and Warranty fail:(');
    
    ctr.savePreApproval();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    ctr.mvAcceptance = 'A';
    ctr.warrantyAcceptance = 'A';
    ctr.quote.MV_Acceptance__c = 'A';
    ctr.quote.WRR_Acceptance__c = 'A';
    ctr.saveFormalApproval();

    ctr.getInsuranceFailureReasons();

    System.assert(ctr.isValidationOk(), 'Buying policy, Calculate Validation fail :(');


    ctr.getCustomerPresentationStatusStyle();
    ctr.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_DECIDING;
    ctr.getCustomerPresentationStatusStyle();
    ctr.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_DECLARING;
    ctr.getCustomerPresentationStatusStyle();
    ctr.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE;
    ctr.getCustomerPresentationStatusStyle();
    ctr.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
    ctr.getCustomerPresentationStatusStyle();
    ctr.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FINISHED;
    ctr.getCustomerPresentationStatusStyle();
    
    Test.stopTest();
  }

  private static WisrVLCalcExtension getBasicQuotation(ApexPages.StandardController sc) {
    WisrVLCalcExtension r = new WisrVLCalcExtension(sc);
    r.carPrice = 15000.00;
    r.applicationFee = 475;
    r.dof = 900;
    r.term = 60;
    r.creditScore = 700;
    r.vehicleYear = Date.today().year();
    r.profile = getProfiles()[0];
    r.lvr = 110;
    r.baseRateCalc();    
    r.clientRate = r.maxRate;
    r.getClientRateoptions();
    return r;
  }

  private static List<String> getProfiles() {
    List<String> r = new List<String>();
    List<AggregateResult> d = [
      SELECT Profile__c
      FROM WisrVL_Rates__c
      GROUP BY Profile__c
      ORDER BY Profile__c DESC
    ];
    for (AggregateResult a : d) {
      r.add((String)a.get('Profile__c'));
    }
    return r;
  }

}