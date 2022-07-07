@isTest(SeeAllData=true)
private class TestBOQCalculator {
  static BOQCalculatorExtension headConsumerCalculator() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createQuote();
    Test_DataGeneratorHelper.createQuoting('BOQ');
    Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
    update Test_DataGeneratorHelper.quoting;

    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );

    PageReference calcRef = Page.BOQCalculator;
    calcRef.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);

    Test.setCurrentPageReference(calcRef);
    BOQCalculatorExtension ctr = new BOQCalculatorExtension(sc);

    ctr.quote = Test_DataGeneratorHelper.quote;

    ApexPages.currentPage().getParameters().put('LENDER_QUOTING', 'YTD');
    ApexPages.currentPage().getParameters().put('preloadQuting', '1');

    ctr.calculate();
    ctr.productGoodsType = null;
    ctr.applicationFee = null;
    ctr.dof = null;
    ctr.ppsr = null;
    ctr.clientRate = null;
    ctr.term = null;
    ctr.calculate();
    ctr.reset();

    ctr.productGoodsType = 'Car';
    ctr.productLoanType = 'Platinum';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 50000.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 10.00;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.LoanRatesByClientTier();
    ctr.getFullRatesGold();
    ctr.getFullRatesPlatinum();
    ctr.getFullRatesPlatinumPlus();
    ctr.calculate();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'Used';
    ctr.productLoanType = 'Gold';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.clientTier = 'Gold';
    ctr.carAge = '4';
    ctr.residency = 'Buyer';
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();
    ctr.savePreApproval();

    ctr.productLoanType = 'Platinum Plus';
    ctr.carPrice = 20000.00;
    ctr.term = 60;
    ctr.clientTier = 'Gold Club';
    ctr.carAge = '5';
    ctr.residency = 'Renting';
    ctr.baseRate = 2.00;
    ctr.clientRate = 2.00;
    ctr.rental = null;
    ctr.gapAcceptance = 'A';
    ctr.cciAcceptance = 'A';
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();
    ctr.savePreApproval();

    ctr.productGoodsType = 'Leisure';
    ctr.productLoanType = 'Gold';
    ctr.carPrice = 20000.00;
    ctr.term = 72;
    ctr.clientTier = 'Gold';
    ctr.carAge = '5';
    ctr.residency = 'Renting';
    ctr.baseRate = 2.00;
    ctr.clientRate = 2.00;
    ctr.rental = 0.0;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();
    ctr.getCommissionRate();

    return ctr;
  }

  @isTest
  static void testBOQCalc() {
    BOQCalculatorExtension ctr = headConsumerCalculator();

    ctr.getLenderQuoting();
    ctr.hasCalculationDone();
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();
  }

  @isTest
  static void isValidationOkCalculator() {
    BOQCalculatorExtension ctr = headConsumerCalculator();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'New';
    ctr.productLoanType = 'Platinum';
    ctr.carPrice = 500.00;
    ctr.dof = 995.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'Used';
    ctr.productLoanType = 'Platinum';
    ctr.carPrice = 500.00;
    ctr.dof = 990.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'New';
    ctr.clientTier = 'Platinum Plus';
    ctr.carPrice = 250000.00;
    ctr.dof = 990.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'New';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 250000.00;
    ctr.dof = 990.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Car';
    ctr.assetCondition = 'New';
    ctr.clientTier = 'Gold';
    ctr.carPrice = 250000.00;
    ctr.dof = 990.00;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Campertrailer';
    ctr.assetCondition = 'Used';
    ctr.carAge = '8';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 500.00;
    ctr.dof = 990.00;
    ctr.term = 90;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Motorhome';
    ctr.assetCondition = 'Used';
    ctr.carAge = '12';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 500.00;
    ctr.dof = 990.00;
    ctr.term = 90;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();

    ctr.productGoodsType = 'Marine';
    ctr.assetCondition = 'New';
    ctr.carAge = '15';
    ctr.residency = 'Owner';
    ctr.clientTier = 'Platinum';
    ctr.carPrice = 30.00;
    ctr.dof = 9.00;
    ctr.term = 90;
    ctr.deposit = 2.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.calculate();
    ctr.getBOQAssetType();
    ctr.getBOQAssetAge();
    ctr.getBOQTerm();
    ctr.getBOQAssetCondition();
    ctr.getBOQResidencyStatus();
    ctr.getBOQClientTier();
    ctr.getLoanCreditScoreOptions();
    ctr.saveQuoting();
    ctr.saveAmendment();
    ctr.saveFormalApproval();

    ctr.getIsBrokerPartnerUser();
    ctr.hasValidQuotation();
    ctr.calculateQuote();
    ctr.storeQuotingData();
  }

  @isTest
  static void sendCustomerEmail1() {
    BOQCalculatorExtension ctr = headConsumerCalculator();

    ctr.applicationFee = 200;
    ctr.productGoodsType = 'Marine';
    ctr.assetCondition = 'New';
    ctr.carAge = '5';
    ctr.clientTier = 'Platinum';
    ctr.baseRate = 4.8;
    ctr.clientRate = 4.8;
    ctr.carPrice = 35000.00;
    ctr.dof = 990.00;
    ctr.term = 24;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.sendCustomerEmail1();
    ctr.sendCustomerEmail2();
  }

  @isTest
  static void createQuote() {
    BOQCalculatorExtension ctr = headConsumerCalculator();

    ctr.applicationFee = 200;
    ctr.productGoodsType = 'Marine';
    ctr.assetCondition = 'New';
    ctr.carAge = '5';
    ctr.clientTier = 'Platinum';
    ctr.baseRate = 4.8;
    ctr.clientRate = 4.8;
    ctr.carPrice = 35000.00;
    ctr.dof = 990.00;
    ctr.term = 24;
    ctr.deposit = 2000.00;
    ctr.ppsr = 12.76;
    ctr.residualValue = 10000.00;
    ctr.baseRate = 5.00;
    ctr.clientRate = 5.00;
    ctr.gapLevel = 'Premier Cover 1';
    ctr.gap = 1000.00;
    ctr.gapIncome = 500.00;
    ctr.cciIncome = 200;
    ctr.cci = 20;
    ctr.privateSales = 'N';
    ctr.getTotalInsuranceType('CCI');
    ctr.getTotalInsuranceIncomeType('CCI');
  }
}