@isTest(SeeAllData=true)
private class TestNowFinanceCalc {
  @isTest
  static void testCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.NowFinanceCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    NowFinanceCalculatorExtension ctr = new NowFinanceCalculatorExtension(sc);

    ctr.calculate();
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    // test for baseRateCalc() and calculateValidation()
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.loanTypeDetail = 'Secured';
    ctr.dof = 300;
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    System.debug('Start calculation >>>>>>>>>>>>>>>>>>>>>>>>>>');
    ctr.calculate();
    System.debug('End calculation >>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    ctr.saveQuoting();

    //ctr.savePreApproval();
    //ctr.paymentType = 'Advance';
    //ctr.calculate();
    //ctr.clientRate = 1.00;
    //ctr.calculate();
    //ctr.saveQuoting();

    // Insurance
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.getLenderQuoting();
    
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr = new NowFinanceCalculatorExtension(sc);

    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 35000.00;
    ctr.term = 72;
    ctr.loanTypeDetail = 'Secured';
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.residualValue = 1000;
    ctr.baseRateCalc();
    ctr.calculate();

    String[] details = new List<String>{ 'Secured', 'Unsecured' };
    ctr.residualValue = 1000;
    for (Integer i = 1; i <= 3; i++) {
      ctr.term = 12 * (i + 2);
      for (String a : details) {
        ctr.loanTypeDetail = a;
        ctr.calculate();
      }
    }
    ctr.loanTypeDetail = 'Personal Sales';
    ctr.calculate();

    ctr.loanTypeDetail = 'Secured';
    ctr.residualValue = ctr.carPrice * 0.6;
    ctr.calculate();

    ctr.getMaxDOFRates();
    ctr.getSecuredRates();
    
    // Calculator PDF
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('lender', 'MONEY3 CALCULATION');
    Test.setCurrentPageReference(calcPdf);
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    calcPdfCon.getIsMoney3();
    test.stopTest();
  }

  @isTest
  static void testInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.NowFinanceCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    NowFinanceCalculatorExtension ctr = new NowFinanceCalculatorExtension(sc);

    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.loanTypeDetail = 'Secured';
    ctr.dof = 300;
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 1;
    ctr.calculate();
    System.debug('rental: ' + ctr.rental);
    System.assert(ctr.rental > 0);

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
    System.assert(ctr.hasValidQuotation());
    // GAP
    ctr.quoting.Insurance_Shortfall_Options__c = InsuranceQuoteUtils.INS_PROD_GAP_ERIC;
    ctr.gapLevel = 'GAP';
    ctr.gap = 1000;
    ctr.gapIncome = 100;
    ctr.gapTerm = String.valueOf(ctr.term);
    ctr.gapPayType = 'PBM';
    System.assert(!ctr.insuranceProductSelected());
    ctr.gapAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());
    System.assert(ctr.hasValidQuotation());
    // Warranty
    ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_ERIC;
    ctr.warrantyLevel = 'Warrlevel';
    ctr.warranty = 1000;
    ctr.warrantyIncome = 100.0;
    ctr.warrantyTerm = String.valueOf(ctr.term);
    ctr.warrantyPayType = 'PBM';
    System.assert(!ctr.insuranceProductSelected());
    ctr.warrantyAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());
    System.assert(ctr.hasValidQuotation());

    // lpi - cci
    System.debug('LPI tests...');
    ctr.quoting.Insurance_LPI_Options__c = InsuranceQuoteUtils.INS_PROD_LPI_ERIC;
    ctr.cciLevel = 'LPI Level';
    ctr.cci = 15000;
    ctr.cciIncome = 100;
    ctr.cciTerm = String.valueOf(ctr.term);
    ctr.cciPayType = 'PBM';
    System.assert(!ctr.insuranceProductSelected());
    ctr.cciAcceptance = 'A';
    System.assert(ctr.insuranceProductSelected());
    System.assert(ctr.hasValidQuotation());
    ctr.savePreApproval();

    // NWC
    ctr.quoting.Insurance_Warranty_Options__c = InsuranceQuoteUtils.INS_PROD_WARR_INTE;
    ctr.warrantyAcceptance = null;
    ctr.warrantyLevel = null;
    ctr.warranty = null;
    ctr.warrantyIncome = null;
    ctr.warrantyPayType = null;
    ctr.nwc = 15000;
    ctr.nwcPayType = 'Financed';
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
    System.assert(ctr.hasValidQuotation());
    ctr.savePreApproval();
  }
}