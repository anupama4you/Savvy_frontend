@isTest(SeeAllData=true)
private class TestFirstmatCalc {
  @isTest
  static void testCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    // Finance One
    PageReference calcRef = Page.FirstmacCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    FirstmacCalculatorExtension ctr = new FirstmacCalculatorExtension(sc);

    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.baseRate = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.clientRate = null;
    ctr.calculate();
    ctr.reset();

    ctr.productLoanType = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(0);
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 10;
    ctr.clientRate = 23.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.warrantyLevel = 'Platinum - 24 months';
    ctr.mvLevel = 'AIC/Eric';
    ctr.mv = 5000.00;
    ctr.mvIncome = 2500.00;
    ctr.cci = 6000.00;
    ctr.cciIncome = 3000.00;
    ctr.nwc = 7000.00;
    ctr.nwcIncome = 3500.00;

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

    // test for baseRateCalc() and calculateValidation()
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.carPrice = 35000.00;
    ctr.term = 60;
    ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(2);
    ctr.deposit = 0;
    ctr.tradeIn = 0;
    ctr.payoutOn = 0;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    ctr.saveQuoting();

    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.calculate();
    ctr.baseRate = 10;
    ctr.clientRate = 1.00;
    ctr.calculate();
    ctr.saveQuoting();

    // Insurance
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.acceptQuoteMV();
    ctr.acceptQuoteGAP();
    ctr.acceptQuoteCCI();
    ctr.acceptQuoteWRR();
    ctr.acceptQuoteNWC();

    ctr.calculate();
    ctr.saveQuoting();
    ctr.saveAmendment();

    ctr.declineQuoteMV();
    ctr.declineQuoteGAP();
    ctr.declineQuoteCCI();
    ctr.declineQuoteWRR();
    ctr.declineQuoteNWC();
    ctr.getPresentationUrlCode();

    ctr.getLenderQuoting();
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.calculateNWC();
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;
    ctr = new FirstmacCalculatorExtension(sc);

    ctr.mvAcceptance = 'A';
    ctr.acceptQuoteMV();
    ctr.gapAcceptance = 'A';
    ctr.acceptQuoteGAP();
    ctr.cciAcceptance = 'A';
    ctr.acceptQuoteCCI();
    ctr.warrantyAcceptance = 'A';
    ctr.acceptQuoteWRR();

    ctr.nwc = 100;
    ctr.acceptQuoteNWC();
    ctr.nwcPlan = 'A';
    ctr.acceptQuoteNWC();
    ctr.nwcIncome = 100;
    ctr.acceptQuoteNWC();
    ctr.nwcAcceptance = 'A';

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
    //NWCCalculator HJ - F - 12-07-2018

    ctr.acceptQuoteNWC();
    ctr.nationalWarrantyCalc();

    ctr.mvAcceptance = 'D';
    ctr.declineQuoteMV();

    ctr.gapAcceptance = 'D';
    ctr.declineQuoteGAP();

    ctr.cciAcceptance = 'D';
    ctr.declineQuoteCCI();

    ctr.nwcAcceptance = 'D';
    ctr.declineQuoteWRR();

    ctr.mv = 100;
    ctr.getCustomerPresentationStatusStyle();
    ctr.getInsuranceFailureReasons();
    //-

    ctr.reset();
    ctr.carPrice = 35000.00;
    ctr.term = 60;
    ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(2);
    ctr.category = 'Standard';
    ctr.interestType = 'Fixed';
    ctr.baseRateCalc();
    ctr.vehicleYear = String.valueOf(Date.today().year());
    ctr.clientRate = ctr.maxRate;
    ctr.calculate();
    System.assert(ctr.rental > 0, 'Rental should not be zero :(');

    String[] details = new List<String>{
      FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(2),
      'Used 6-7 years'
    };
    ctr.residualValue = 1000;
    for (Integer i = 1; i <= 3; i++) {
      ctr.term = 12 * (i + 2);
      for (String a : details) {
        ctr.loanTypeDetail = a;
        ctr.calculate();
        ctr.residualValue = ctr.carPrice * 0.6;
        ctr.calculate();
      }
    }
    //ctr.loanTypeDetail = 'Private Sale';
    //ctr.calculate();

    // ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(0);
    // ctr.residualValue = ctr.carPrice * 0.6;
    // ctr.calculate();

    details = new List<String>{
      QuotingCalculation.CALC_QUOTING,
      InsuranceQuoteUtils.INS_PROD_MV,
      InsuranceQuoteUtils.INS_PROD_GAP,
      InsuranceQuoteUtils.INS_PROD_TAI,
      InsuranceQuoteUtils.INS_PROD_LTI,
      InsuranceQuoteUtils.INS_PROD_WARR,
      InsuranceQuoteUtils.INS_PROD_NWC,
      InsuranceQuoteUtils.INS_PROD_CCI
    };
    for (String a : details) {
      ctr.getTotalInsuranceType(a);
      ctr.getTotalInsuranceIncomeType(a);
    }
    ctr.getRates();

    ctr.clientRate = ctr.baseRate - 1;
    ctr.calculate();
    ctr.clientRate = ctr.maxRate + 1;
    ctr.calculate();
    ctr.category = 'Edge';
    ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.size() - 1);
    ctr.vehicleYear = String.valueOf(Date.today().year()-20);
    ctr.calculate();

    ctr.vehicleYear = String.valueOf(Date.today().year());
    ctr.carPrice = 100000;
    ctr.calculate();
    ctr.vehicleYear = String.valueOf(Date.today().year()-8);
    ctr.calculate();
    ctr.category = 'Standard';
    ctr.loanTypeDetail = 'Used < 5 years';
    ctr.vehicleYear = String.valueOf(Date.today().year()-20);
    ctr.calculate();
    ctr.loanTypeDetail = 'Used 6-7 years';
    ctr.calculate();
    ctr.loanTypeDetail = 'Used 8-12 years';
    ctr.calculate();
    
    ctr.getIsBrokerPartnerUser();
    FirstmacCalculatorExtension.getSelectLoanTypeOptions();
    ctr.getVehicleYearOptions();

    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();

    ctr.getRates();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();
    ctr.residualValue = -1;
    ctr.isValidationOk();
    ctr.residualValue = 1;
    ctr.loanTypeDetail = 'Used < 5 years';
    ctr.vehicleYear = '2020';
    ctr.isValidationOk();
    ctr.term = 36;
    ctr.isValidationOk();
    ctr.term = 48;
    ctr.isValidationOk();
    ctr.interestType = 'Variable';
    ctr.residualValue = 1;
    ctr.isValidationOk();
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

    PageReference calcRef = Page.FirstmacCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    FirstmacCalculatorExtension ctr = new FirstmacCalculatorExtension(sc);

    ctr.reset();

    //ctr.productLoanType = 'Passenger and Commercial Vehicles';
    ctr.carPrice = 35000.00;
    ctr.term = 60;
    ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(2);
    ctr.category = 'Standard';
    ctr.interestType = 'Fixed';
    ctr.baseRateCalc();
    ctr.vehicleYear = String.valueOf(Date.today().year());
    ctr.clientRate = ctr.maxRate;
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

    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting();
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    Test_DataGeneratorHelper.quoting.Name = 'Firstmac';
    update Test_DataGeneratorHelper.quoting;
    Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
    Test_DataGeneratorHelper.quote.Financier_Name__c = 'Firstmac';
    update Test_DataGeneratorHelper.quote;
    ctr = new FirstmacCalculatorExtension(sc);

    ctr.applicationFee = 1000;
    ctr.dof = 1000;
    ctr.clientRate = 6;
    ctr.carPrice = 25000.00;
    ctr.monthlyFee = 1;
    ctr.nwcAcceptance = 'A';
    ctr.cciAcceptance = 'A';
    ctr.loanTypeDetail = FirstmacCalculatorExtension.LOAN_TYPE_OPTIONS.get(2);
    ctr.saveQuoting();
  }
}