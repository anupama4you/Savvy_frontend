@isTest
private class TestUniversalCalculator {
  @isTest
  static void testCalculator() {
    Test_DataGeneratorHelper.createApplication();
    test.startTest();
    // Calculator PDF
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    //calcPdf.getParameters().put('lender', 'GENERAL CALCULATION');
    calcPdf.getParameters().put('state', 'SA');
    calcPdf.getParameters().put('vehicleGroup', 'A');
    calcPdf.getParameters().put('awd', 'A');
    calcPdf.getParameters().put('turbo', 'A');
    calcPdf.getParameters().put('diesel', 'A');

    calcPdf.getParameters().put('gapLevel', 'A');
    calcPdf.getParameters().put('gap', '1');
    calcPdf.getParameters().put('gapIncome', '1');

    calcPdf.getParameters().put('nwc', '1');
    calcPdf.getParameters().put('nwcIncome', '1');
    calcPdf.getParameters().put('nwcType_p', 'A');
    calcPdf.getParameters().put('nwcEngine', 'A');
    calcPdf.getParameters().put('nwcIsManuallyNWCPrice', 'A');
    calcPdf.getParameters().put('nwcTerm', 'A');
    calcPdf.getParameters().put('nwcPlan', 'A');
    calcPdf.getParameters().put('nwcAssetType', 'A');
    calcPdf.getParameters().put('nwcState', 'A');

    calcPdf.getParameters().put('warrantyLevel', 'A');
    calcPdf.getParameters().put('warranty', '1');
    calcPdf.getParameters().put('warrantyIncome', '1');

    calcPdf.getParameters().put('ltiLevel', 'A');
    calcPdf.getParameters().put('lti', '1');
    calcPdf.getParameters().put('ltiIncome', '1');

    calcPdf.getParameters().put('truckGapLevel', 'A');
    calcPdf.getParameters().put('truckGap', '1');
    calcPdf.getParameters().put('truckGapIncome', '1');

    calcPdf.getParameters().put('taiLevel', 'A');
    calcPdf.getParameters().put('tai', '1');
    calcPdf.getParameters().put('taiIncome', '1');

    calcPdf.getParameters().put('mvLevel', 'A');
    calcPdf.getParameters().put('mv', '1');
    calcPdf.getParameters().put('mvIncome', '1');

    calcPdf.getParameters().put('cciLevel', 'A');
    calcPdf.getParameters().put('cci', '1');
    calcPdf.getParameters().put('cciIncome', '1');

    calcPdf.getParameters().put('carPrice', '1');
    calcPdf.getParameters().put('applicationFee', '1');
    calcPdf.getParameters().put('dof', '1');
    calcPdf.getParameters().put('ppsr', '1');
    calcPdf.getParameters().put('residualValue', '1');
    calcPdf.getParameters().put('brokeragePercentage', '1');
    calcPdf.getParameters().put('baseRate', '1');
    calcPdf.getParameters().put('clientRate', '1');
    calcPdf.getParameters().put('maxRate', '1');
    calcPdf.getParameters().put('term', '1');
    calcPdf.getParameters().put('paymentType', '1');
    calcPdf.getParameters().put('estimatedCommission', '1');
    calcPdf.getParameters().put('insuranceIncome', '1');
    calcPdf.getParameters().put('dofResult', '1');
    calcPdf.getParameters().put('totalCommission', '1');
    calcPdf.getParameters().put('totalCommissionGst', '1');
    calcPdf.getParameters().put('naf', '1');
    calcPdf.getParameters().put('rental', '1');
    calcPdf.getParameters().put('monthlyFee', '1');
    calcPdf.getParameters().put('monthlyPayment', '1');
    calcPdf.getParameters().put('fortnightlyPayment', '1');
    calcPdf.getParameters().put('weeklyPayment', '1');
    calcPdf.getParameters().put('adverseCredit', 'A');
    calcPdf.getParameters().put('customerProfile', 'A');
    calcPdf.getParameters().put('recommendedRate', '1');
    calcPdf.getParameters().put('goodsType', 'A');
    calcPdf.getParameters().put('vehiclesProfile', 'A');
    calcPdf.getParameters().put('loanFacilityType', 'A');
    calcPdf.getParameters().put('brokerage', '1');
    calcPdf.getParameters().put('carAge', 'A');
    calcPdf.getParameters().put('motorCycles', 'A');
    calcPdf.getParameters().put('caravanCampervans', 'A');
    calcPdf.getParameters().put('privateSales', 'A');
    calcPdf.getParameters().put('registrationFee', '1');
    calcPdf.getParameters().put('clientTier', 'A');
    calcPdf.getParameters().put('loanType', 'A');
    calcPdf.getParameters().put('paymentFrequency', 'A');
    calcPdf.getParameters().put('carType', 'A');
    calcPdf.getParameters().put('lvr', 'A');
    calcPdf.getParameters().put('vehicleAge', 'A');
    calcPdf.getParameters().put('vehicleCondition', 'A');
    calcPdf.getParameters().put('greenCar', 'Y');
    calcPdf.getParameters().put('riskFee', '1');
    calcPdf.getParameters().put('rateOption', 'A');
    calcPdf.getParameters().put('isp', '1');
    calcPdf.getParameters().put('ispIncome', '1');
    calcPdf.getParameters().put('fpa', '1');
    calcPdf.getParameters().put('fpaIncome', '1');
    calcPdf.getParameters().put('veiLevel', 'A');
    calcPdf.getParameters().put('vei', '1');
    calcPdf.getParameters().put('veiIncome', '1');
    calcPdf.getParameters().put('lpiLevel', 'A');
    calcPdf.getParameters().put('lpi', '1');
    calcPdf.getParameters().put('lpiIncome', '1');
    calcPdf.getParameters().put('isLiberty', 'true');
    calcPdf.getParameters().put('isFinanceOne', 'true');
    calcPdf.getParameters().put('productLoanType', 'A');
    calcPdf.getParameters().put('productGoodsType', 'A');
    calcPdf.getParameters().put('productGoodsSubType', 'A');
    calcPdf.getParameters().put('loanFrequency', 'A');
    calcPdf.getParameters().put('saleBacksPurchased', 'A');
    calcPdf.getParameters().put('extraLabel1', 'A');
    calcPdf.getParameters().put('extraValue1', '1');
    calcPdf.getParameters().put('extraLabel2', 'A');
    calcPdf.getParameters().put('extraValue2', '1');
    calcPdf.getParameters().put('extraLabel3', 'A');
    calcPdf.getParameters().put('extraValue3', '1');
    calcPdf.getParameters().put('extraLabel4', 'A');
    calcPdf.getParameters().put('extraValue4', '1');
    calcPdf.getParameters().put('loanTypeDetail', '');
    calcPdf.getParameters().put('deposit', '1');
    calcPdf.getParameters().put('tradeIn', '1');
    calcPdf.getParameters().put('payoutOn', '1');
    calcPdf.getParameters().put('netDeposit', '1');
    calcPdf.getParameters().put('insuranceInputMode', '');
    calcPdf.getParameters().put('creditScore', 'A');
    calcPdf.getParameters().put('enquiries', 'A');
    calcPdf.getParameters().put('riskGrade', '');
    calcPdf.getParameters().put('bankrupt', '');
    calcPdf.getParameters().put('residency', '');
    calcPdf.getParameters().put('rateType', '');
    calcPdf.getParameters().put('ltv', '99');

    Test.setCurrentPageReference(calcPdf);
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    calcPdfCon.getIsGeneral();

    //// Empty fields
    //calcPdf = Page.UniversalCalculatorPdf;
    //calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    //calcPdf.getParameters().put('lender','GENERAL CALCULATION');
    //sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    //calcPdfCon = new CalculatorPdfExtension (sc);

    test.stopTest();
  }

  @isTest
  static void testEmptyCalculator() {
    Test_DataGeneratorHelper.createApplication();
    test.startTest();
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('greenCar', 'N');
    Test.setCurrentPageReference(calcPdf);
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension(sc);
    test.stopTest();
  }

  @isTest
  static void testOtherMethods() {
    Test_DataGeneratorHelper.createApplication();
    test.startTest();
    PageReference calcPdf = Page.UniversalCalculatorPdf;
    calcPdf.getParameters()
      .put('id', Test_DataGeneratorHelper.tstOpportunity.Id);
    calcPdf.getParameters().put('greenCar', 'N');
    Test.setCurrentPageReference(calcPdf);
    ApexPages.StandardController sc = new ApexPages.StandardController(
      Test_DataGeneratorHelper.tstOpportunity
    );
    CalculatorPdfExtension ctr = new CalculatorPdfExtension(sc);

    ctr.lender = 'MACQUARIE';
    System.assert(ctr.getIsMacquorie());

    ctr.lender = 'MACQUARIE CONSUMER';
    System.assert(ctr.getIsMacquorieConsumer());

    ctr.lender = 'MACQUARIE COMMERCIAL';
    System.assert(ctr.getIsMacquorieCommercial());

    ctr.lender = 'MONEY3';
    System.assert(ctr.getIsMoney3());

    ctr.lender = 'YAMAHA';
    System.assert(ctr.getIsYamahaMoto());

    ctr.lender = 'YAMAHA MARINE';
    System.assert(ctr.getIsYamahaMarine());

    ctr.lender = 'METRO';
    System.assert(ctr.getIsMetro());

    ctr.lender = 'LATITUDE';
    System.assert(ctr.getIsLatitude());

    ctr.lender = 'LATITUDE PERSONAL';
    System.assert(ctr.getIsLatitudePersonal());

    ctr.lender = 'GENERAL';
    System.assert(ctr.getIsGeneral());

    ctr.lender = 'ANZ OTHERS CALCULATION';
    System.assert(ctr.getIsANZOthers());

    ctr.lender = 'AFS CONSUMER';
    System.assert(ctr.getIsAfsConsumer());

    ctr.lender = 'AFS COMMERCIAL';
    System.assert(ctr.getIsAfsCommercial());

    ctr.lender = 'PEPPER SUMMER';
    System.assert(ctr.getIsPepperSummer());

    ctr.lender = 'PEPPER';
    System.assert(ctr.getIsPepper());

    ctr.lender = 'Pepper Commercial';
    System.assert(ctr.getIsPepperComm());

    ctr.lender = 'GREEN';
    System.assert(ctr.getIsGreenLight());

    ctr.lender = 'WISR';
    System.assert(ctr.getIsWisr());

    System.assert(!ctr.getIsWisrVL());
    ctr.lender = 'WISR CAR LOAN';
    System.assert(ctr.getIsWisrVL());

    ctr.lender = 'FIRSTMAC';
    System.assert(ctr.getIsFirstmac());

    ctr.lender = 'NOW FINANCE';
    System.assert(ctr.getIsNowFinance());

    ctr.lender = 'RATESETTER PERSONAL';
    System.assert(ctr.getIsRateSetterPL());

    ctr.lender = 'RATESETTER';
    System.assert(ctr.getIsRateSetter());
    ctr.lender = 'PLENTI CALCULATION';
    System.assert(ctr.getIsRateSetter());

    ctr.lender = 'BANK OF QUEENSLAND CALCULATION';
    System.assert(ctr.getIsBankOfQueensland());

    ctr.lender = 'BANK OF QUEENSLAND COMMERCIAL';
    System.assert(ctr.getIsBOQCommercial());

    ctr.lender = 'MONEY PLACE CALCULATION';
    System.assert(ctr.getIsMoneyPlace());

    System.assert(!ctr.getIsFinanceOne());
    ctr.lender = 'FINANCE ONE CALCULATION';
    System.assert(ctr.getIsFinanceOne());

    System.assert(!ctr.getIsFinanceOnePL());
    ctr.lender = 'FINANCE ONE PL CALCULATION';
    System.assert(ctr.getIsFinanceOnePL());

    System.assert(!ctr.getIsFinanceOneBusiness());
    ctr.lender = 'FINANCE ONE BUSINESS CALCULATION';
    System.assert(ctr.getIsFinanceOneBusiness());

    ctr.lender = 'CAR START FINANCE CALCULATION';
    System.assert(ctr.getIsCarStartFinance());

    ctr.lender = 'AFFORDABLE';
    System.assert(ctr.getIsAffordableCarLoan());

    ctr.lender = 'AZORA CONSUMER CALCULATION';
    System.assert(ctr.getIsAzora());
    System.assert(!ctr.getIsFinanceOneCommercial());
    ctr.lender = 'FINANCE ONE COMMERCIAL CALCULATION';
    System.assert(ctr.getIsFinanceOneCommercial());

    System.assert(!ctr.getIsPlentiCommercial());
    ctr.lender = 'PLENTI COMMERCIAL CALCULATION';
    System.assert(ctr.getIsPlentiCommercial());
    System.assert(!ctr.getIsLibertyCommercial());
    ctr.lender = 'LIBERTY COMMERCIAL CALCULATION';
    System.assert(ctr.getIsLibertyCommercial());
    ctr.lender = 'UME LOANS CALCULATION';
    System.assert(ctr.getIsUMELoans());
    ctr.lender = 'WESTPAC CALCULATION';
    System.assert(ctr.getIsWestpac());
    ctr.lender = 'SOCIETY ONE CALCULATION';
    System.assert(ctr.getIsSocietyOne());
    ctr.lender = 'APF CALCULATION';
    System.assert(ctr.getIsAPF());
    ctr.lender = 'GROW ASSET CAR CALCULATION';
    System.assert(ctr.getIsGrowAssetCar());
    ctr.lender = 'Grow Business Loan CALCULATION';
    System.assert(ctr.getIsGrowBusiLoan());

    ctr.lender = 'KRISP';
    System.assert(ctr.getIsKrisp());

    ctr.lender = 'RACV';
    System.assert(ctr.getIsRacv());

    ctr.extraLabel1 = 'extraLabel1';
    ctr.extraLabel2 = 'extraLabel2';
    ctr.extraLabel3 = 'extraLabel3';
    ctr.extraLabel4 = 'extraLabel4';

    ctr.extraValue1 = '1';
    ctr.extraValue2 = '1';
    ctr.extraValue3 = '1';
    ctr.extraValue4 = '1';
    ctr.getAdditionalDetails();

    ctr.extraLabel1 = null;
    ctr.extraLabel2 = null;
    ctr.extraLabel3 = null;
    ctr.extraLabel4 = null;
    ctr.getAdditionalDetails();

    ctr.getIsIntegrityProd();

    ctr.getAccountVar();

    test.stopTest();
  }

}