@isTest(SeeAllData=true)
private class TestLibertyCalcs {
	
	@isTest static void testDrive() {
		test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    // Liberty Drive
    PageReference LibertyDrive = Page.LibertyDrive;
    LibertyDrive.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(LibertyDrive);
    LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
    
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.residualValue = 10000.00;
    ctr.ltv = 80;
    ctr.creditScore = '600';
    ctr.enquiries = '5';
    
    ctr.mvLevel = 'AIC/Eric';
    ctr.mv = 5000.00;
    ctr.mvIncome = 2500.00;
    ctr.nwc = 7000.00;
    ctr.nwcIncome = 3500.00;
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
    //NWCCalculator HJ - F - 12-07-2018
    
    // test for baseRateCalc()
    ctr.ltv = 120;
    ctr.baseRateCalc();
    ctr.ltv = 140;
    ctr.baseRateCalc();
    ctr.ltv = 160;
    ctr.baseRateCalc();
    ctr.loanTypeDetail = 'Commercial Star';
    ctr.baseRateCalc();
    ctr.ltv = 120;
    ctr.baseRateCalc();
    ctr.loanTypeDetail = 'Commercial Nova';
    ctr.baseRateCalc();
    ctr.ltv = 150;
    ctr.baseRateCalc();
    ctr.loanTypeDetail = '';
    ctr.baseRateCalc();
    
    ctr.loanTypeDetail = 'Consumer';
    ctr.ltv = 80;
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.realtimeNafCalc();
    ctr.calculate();
    ctr.savePreApproval();
    ctr.paymentType = 'Advance';
    ctr.calculate();
    ctr.term = 0;
    ctr.calculate();
    ctr.term = 20;
    ctr.calculate();
    ctr.term = 30;
    ctr.calculate();
    ctr.term = 40;
    ctr.calculate();
    ctr.term = 90;
    ctr.calculate();
    ctr.term = 60;
    ctr.clientRate = 1.00;
    ctr.calculate();
    ctr.term = 12;
    ctr.saveQuoting();
    ctr.reset();
    ctr.realtimeNafCalc();
    ctr.calculate();
    ctr.savePreApproval();
    ctr.rental = 0.00;
    ctr.saveQuoting();

	}
	
	@isTest static void testOptions() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Liberty Options
        PageReference LibertyOptions = Page.LibertyOptions;
        LibertyOptions.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(LibertyOptions);
        LibertyOptionsExtension ctr = new LibertyOptionsExtension(sc);
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.residualValue = 10000.00;
        ctr.clientRate = 15.00;
        ctr.loanTypeDetail = 'Consumer';
        ctr.rateOption = 'AA';
        ctr.vehicleAge = 0;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '4';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.state = 'WA';
        ctr.warrantyLevel = 'Platinum - 24 months';
        ctr.vehicleGroup = '2';
        ctr.warrantyPriceCalc();
        ctr.vehicleGroup = '3';
        ctr.warrantyPriceCalc();
        ctr.awd = 'Y';
        ctr.turbo = 'Y';
        ctr.diesel = 'Y';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.state = '';
        ctr.warrantyIncomeCalc();
        ctr.state = 'ACT';
        ctr.warrantyIncomeCalc();
        ctr.state = 'NSW';
        ctr.warrantyIncomeCalc();
        ctr.state = 'NT';
        ctr.warrantyIncomeCalc();
        ctr.state = 'VIC';
        ctr.warrantyIncomeCalc();
        ctr.state = 'TAS';
        ctr.warrantyIncomeCalc();
        ctr.state = 'QLD';
        ctr.warrantyIncomeCalc();
        ctr.vehicleGroup = '1';
        ctr.awd = 'N';
        ctr.turbo = 'N';
        ctr.diesel = 'N';
        
        ctr.state = 'SA';
        ctr.warrantyLevel = 'Platinum - 12 months';
        ctr.warrantyPriceCalc();
        ctr.warrantyIncomeCalc();
        ctr.veiLevel = 'Option 1';
        ctr.vei = 2000.00;
        ctr.veiIncome = 1000.00;
        ctr.lpiLevel = 'Life Only';
        ctr.lpi = 3000.00;
        ctr.lpiIncome = 1500.00;
        ctr.mvLevel = 'AIC/Eric';
        ctr.mv = 5000.00;
        ctr.mvIncome = 2500.00;
        ctr.nwc = 7000.00;
        ctr.nwcIncome = 3500.00;
        
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
        //NWCCalculator HJ - F - 12-07-2018
        
        // test for baseRateCalc()
        ctr.vehicleAge = 6;
        ctr.baseRateCalc();
        ctr.rateOption = 'A';
        ctr.baseRateCalc();
        ctr.vehicleAge = 0;
        ctr.baseRateCalc();
        ctr.rateOption = 'B';
        ctr.baseRateCalc();
        ctr.vehicleAge = 6;
        ctr.baseRateCalc();
        ctr.rateOption = 'C';
        ctr.baseRateCalc();
        ctr.vehicleAge = 0;
        ctr.baseRateCalc();
        ctr.rateOption = '';
        ctr.baseRateCalc();
        ctr.loanTypeDetail = 'Commercial Star';
        ctr.baseRateCalc();
        ctr.rateOption = 'AA';
        ctr.baseRateCalc();
        ctr.vehicleAge = 6;
        ctr.baseRateCalc();
        ctr.rateOption = 'A';
        ctr.baseRateCalc();
        ctr.vehicleAge = 0;
        ctr.baseRateCalc();
        ctr.rateOption = 'B';
        ctr.baseRateCalc();
        ctr.vehicleAge = 6;
        ctr.baseRateCalc();
        ctr.rateOption = 'C';
        ctr.baseRateCalc();
        ctr.vehicleAge = 0;
        ctr.baseRateCalc();
        ctr.loanTypeDetail = 'Commercial Nova';
        ctr.baseRateCalc();
        ctr.rateOption = 'AA';
        ctr.baseRateCalc();
        ctr.vehicleAge = 6;
        ctr.baseRateCalc();
        ctr.loanTypeDetail = '';
        ctr.baseRateCalc();
        
        ctr.loanTypeDetail = 'Consumer';
        ctr.rateOption = 'AA';
        ctr.vehicleAge = 0;
        ctr.baseRateCalc();
        ctr.riskFeeCalc();
        ctr.rateOption = 'A';
        ctr.riskFeeCalc();
        ctr.rateOption = 'B';
        ctr.riskFeeCalc();
        ctr.rateOption = 'C';
        ctr.riskFeeCalc();
        ctr.rateOption = '';
        ctr.riskFeeCalc();
        ctr.rateOption = 'AA';
        ctr.riskFeeCalc();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.term = 10;
        ctr.calculate();
        ctr.term = 20;
        ctr.calculate();
        ctr.term = 30;
        ctr.calculate();
        ctr.term = 40;
        ctr.calculate();
        ctr.term = 90;
        ctr.calculate();
        ctr.term = 60;
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.reset();
        ctr.realtimeNafCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.clientRate = 1.00;
        ctr.calculate();
        ctr.clientRate = 0.10;
        ctr.baseRate = 1.00;
        ctr.calculate();
        ctr.term = 0;
        ctr.calculate();
        ctr.saveQuoting();
        ctr.rental = 0.00;
        ctr.saveQuoting();
        ctr.clientRate = 30.00;
        ctr.validation();

        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 60;
        ctr.loanTypeDetail = 'Consumer';
        ctr.rateOption = 'AA';
        ctr.paymentType = 'Arrears';
        ctr.vehicleAge = 0;
        ctr.riskFeeCalc();
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 3;
        System.debug('clientRate >> ' + ctr.clientRate + ' | baseRate >> ' + ctr.baseRate);
        ctr.saveQuoting();


        ctr.saveAmendment();
        ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        //ctr.acceptQuoteGAP();
        //ctr.acceptQuoteTAS();
        //ctr.acceptQuoteLTI();
        //ctr.acceptQuoteCCI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();
        ctr.acceptQuoteVEI();
        ctr.acceptQuoteLPI();
        ctr.declineQuoteMV();
        //ctr.declineQuoteGAP();
        //ctr.declineQuoteTAS();
        //ctr.declineQuoteLTI();
        //ctr.declineQuoteCCI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();
        ctr.declineQuoteVEI();
        ctr.declineQuoteLPI();
        ctr.sendPresentationStep1();
        ctr.sendPresentationStep2();
        ctr.sendPresentationStep3();
        ctr.previewPresentation();
        ctr.isValidPresentation();
        ctr.getPresentationUrlCode();

        ctr.createQuote();

        ctr.buyPolicy();
        ctr.isAnInsuranceProductAccepted();
        ctr.getLenderQuoting();
        ctr.getSimpleResult();
        ctr.getProFullyResult();
        ctr.getProStandardResult();
        ctr.getProBasicResult();


        ctr.getQuoteNumberOptions();
        ctr.importQuote();
        ctr.getHasUserMessages();
        ctr.getDisplayNwcInsurance();
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        ctr.getProtectecResult();

        //ctr.commsCalc();
        //ctr.privateSales = 'Y';
        //ctr.applicationFeefCalc();
        //ctr.privateSales = 'N';
        //ctr.applicationFeefCalc();

        //NWCCalculator HJ - I - 12-07-2018 - Car
        ctr.calculateNWC();
        ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018

        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new LibertyOptionsExtension(sc);

        ctr.mvAcceptance = 'A';
        ctr.acceptQuoteMV();
        //ctr.gapAcceptance = 'A';
        //ctr.acceptQuoteGAP();
        //ctr.taiAcceptance = 'A';
        //ctr.acceptQuoteTAS();
        //ctr.ltiAcceptance = 'A';
        //ctr.acceptQuoteLTI();
        //ctr.cciAcceptance = 'A';
        //ctr.acceptQuoteCCI();
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
        ctr.nwcParam.isManuallyNWCPrice = false;
        //ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.nwcPlan = 'A';
        ctr.nwcTerm = '12';
        ctr.nwcParam.state = 'SA'; 
         ctr.checkManuallyNWCPrice();
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
        ctr.acceptQuoteNWC();
        ctr.nationalWarrantyCalc();

        ctr.veiAcceptance  = 'A';
        ctr.acceptQuoteVEI();
        ctr.lpiAcceptance  = 'A';
        ctr.acceptQuoteLPI();

        ctr.mvAcceptance = 'D';
        ctr.declineQuoteMV();

        //ctr.gapAcceptance = 'D';
        //ctr.declineQuoteGAP();

        //ctr.taiAcceptance = 'D';
        //ctr.declineQuoteTAS();

        //ctr.ltiAcceptance = 'D';
        //ctr.declineQuoteLTI();

        //ctr.cciAcceptance = 'D';
        //ctr.declineQuoteCCI();

        ctr.warrantyAcceptance = 'D';
        //ctr.declineQuoteLTI();

        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        ctr.veiAcceptance  = 'D';
        ctr.declineQuoteVEI();
        ctr.lpiAcceptance  = 'D';
        ctr.declineQuoteLPI();

        ctr.mv = 100;
        ctr.hasQuotingInsProducts();

        ctr.quoteIdSelected = Test_DataGeneratorHelper.quote.Id;
        ctr.importQuote();

        ctr.getIsRTIRequired();
        ctr.getHasWarranty();
        ctr.getHasLti();
        ctr.calculateVEI();
        ctr.getLPIOptions();
	}
    
  @isTest static void testDriveInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.LibertyDrive;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
    
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Consumer Loan';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 30000.00;
    ctr.deposit = 150.00;
    ctr.residualValue = 0.00;
    ctr.term = 60;
    ctr.ltv = 100;
    ctr.creditScore = '600';
    ctr.enquiries = '0';
    ctr.paymentType = 'Arrears';
    ctr.propertyOwner = 'Y';
    ctr.checkRateTypeAndClientTier();
    ctr.vehicleAge = 'New';
    System.debug('Testing testDriveInsuranceProductSelected....');
    ctr.baseRateCalc();
    ctr.clientRate = ctr.baseRate + 2;
    ctr.calculate();

    System.debug('rental: ' + ctr.rental + '|clientRate: ' + ctr.clientRate + '|baseRate: ' + ctr.baseRate);
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

    //NWCCalculator HJ - I - 12-07-2018 - Car
    ctr.calculateNWC();
    ctr.checkManuallyNWCPrice();
    ctr.calculateNWC();
    //NWCCalculator HJ - F - 12-07-2018

  }	

    @isTest static void testDriveFormalApproval() {
      Test_DataGeneratorHelper.createApplication();
      Test_DataGeneratorHelper.createAssetDetailLTV();
      Application__c app = Test_DataGeneratorHelper.tstApp;
      
      Test.startTest();
      ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
      
      PageReference calcRef = Page.LibertyDrive;
      calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
      Test.setCurrentPageReference(calcRef);
      LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
      
      ctr.reset();
      ctr.loanType = 'Purchase';
      ctr.productLoanType = 'Consumer Loan';
      ctr.productGoodsType = 'Car';
      ctr.carPrice = 30000.00;
      ctr.deposit = 150.00;
      ctr.residualValue = 0.00;
      ctr.term = 60;
      ctr.ltv = 100;
      ctr.creditScore = '600';
      ctr.enquiries = '0';
      ctr.paymentType = 'Arrears';
      ctr.propertyOwner = 'Y';
      ctr.checkRateTypeAndClientTier();
      ctr.vehicleAge = 'New';
      System.debug('Testing testDriveInsuranceProductSelected....');
      ctr.baseRateCalc();
      ctr.clientRate = ctr.baseRate + 2;
      ctr.calculate();

      System.debug('rental: ' + ctr.rental + '|clientRate: ' + ctr.clientRate + '|baseRate: ' + ctr.baseRate);
      System.assert(ctr.rental > 0);
      
      ctr.saveAmendment();

      // no insurance products means TRUE
      System.assert(ctr.insuranceProductSelected());
      
      // Preare record for validations
      ctr.quoting.Application__c = app.Id;
      ctr.quoting.Presentation_Email_Date__c = Datetime.now();
      ctr.quoting.Insurance_Customer_Choice__c = 'PF';
      ctr.quoting.Presentation_Email_Date__c = Datetime.now();
      ctr.quoting.Insurance_Choice_Date__c = Datetime.now();
      ctr.quote.Customer_Choice__c = 'PF';
      ctr.quote.Customer_Choice_Status__c = 'FINI';
      
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
      
      ctr.saveFormalApproval();

      ctr = new LibertyDriveExtension(sc);
      System.assert(ctr.rental > 0);
      ctr.sendCustomerEmail1();
      ctr.sendCustomerEmail2();

      ctr.hasValidQuotation();
      ctr.calculateQuote();
      ctr.storeQuotingData();
    }
    
    @isTest static void testDriveFormalApproval2() {
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyDrive;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        
        LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.carPrice = 30000.00;
        ctr.creditScore = '600';
        ctr.enquiries = '0';
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 2;
        ctr.calculate();
    }

    @isTest static void testOptionsInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyOptions;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyOptionsExtension ctr = new LibertyOptionsExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 60;
        ctr.loanTypeDetail = 'Consumer';
        ctr.rateOption = 'AA';
        ctr.paymentType = 'Arrears';
        ctr.vehicleAge = 0;
        ctr.riskFeeCalc();
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 3;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental);
        System.assert(ctr.rental > 0);

        // no insurance products means TRUE
        System.assert(ctr.insuranceProductSelected());
        // Motor Vehicle
        ctr.mvLevel = 'MV';
        System.assert(!ctr.insuranceProductSelected());
        ctr.mvAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // GAP
        ctr.veiLevel = 'Option 1';
        System.assert(!ctr.insuranceProductSelected());
        ctr.veiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        ctr.veiLevel = null;
        ctr.veiAcceptance = null;
        // LPI
        ctr.lpiLevel = 'LPI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.lpiAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        ctr.lpiLevel = null;
        ctr.lpiAcceptance = null;
        // Warranty
        ctr.warrantyLevel = 'LTI';
        System.assert(!ctr.insuranceProductSelected());
        ctr.warrantyAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());
        // NWC
        ctr.warrantyLevel = null;
        ctr.warrantyAcceptance = null;
        ctr.nwc = 15000;
        System.assert(!ctr.insuranceProductSelected());
        ctr.nwcAcceptance = 'A';
        System.assert(ctr.insuranceProductSelected());

    }

    @isTest static void testDrive2() {
      Test_DataGeneratorHelper.createApplication();
      Test_DataGeneratorHelper.createQuote();
      Test_DataGeneratorHelper.createQuoting();
      Test_DataGeneratorHelper.createAssetDetailLTV();
      Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
      update Test_DataGeneratorHelper.quoting;
      Test_DataGeneratorHelper.reloadOpportunity();

      test.startTest();
      ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
      
      // Liberty Drive
      PageReference LibertyDrive = Page.LibertyDrive;
      LibertyDrive.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
      Test.setCurrentPageReference(LibertyDrive);
      LibertyDriveExtension ctr = new LibertyDriveExtension(sc);

      ctr = new LibertyDriveExtension(sc);

      ctr.mvAcceptance = 'A';
      ctr.acceptQuoteMV();
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
      ctr.nwcParam.isManuallyNWCPrice = false;
      //ctr.nwcParam.nwcPriceToCustomer = 14000;
      ctr.nwcParam.assetType = 'Car';
      ctr.nwcPlan = 'A';
      ctr.nwcTerm = '12';
      ctr.nwcParam.state = 'SA'; 
        ctr.checkManuallyNWCPrice();
      ctr.calculateNWC();
      //NWCCalculator HJ - F - 12-07-2018
      
      ctr.acceptQuoteNWC();
      ctr.nationalWarrantyCalc();

      ctr.reset();

      ctr.getPresentationUrlCode();
      ctr.getLenderQuoting();
      ctr.getIsBrokerPartnerUser();

      ctr.productLoanType = 'Chatel';
      //ctr.rateType = 'Star';
      ctr.clientTier = 'AAA';
      ctr.carPrice = 110000;
      ctr.propertyOwner = 'N';
      ctr.residualValue = 80000;
      ctr.vehicleAge = 'New';
      ctr.calculate();
      ctr.clientTier = 'B';
      ctr.calculate();
      ctr.productGoodsType = 'Caravan';
      //ctr.rateType = 'Nova';
      ctr.clientTier = 'AA';
      ctr.calculate();
      
      // Residuals
      ctr.clientTier = 'AAA';
      ctr.residualValue = 80000;
      ctr.vehicleAge = 'New';
      ctr.term = 36;
      ctr.calculate();
      ctr.vehicleAge = '3';
      ctr.calculate();
      ctr.term = 48;
      ctr.vehicleAge = '0';
      ctr.calculate();
      ctr.vehicleAge = '3';
      ctr.calculate();
      ctr.vehicleAge = '6';
      ctr.calculate();
      ctr.term = 36;
      ctr.calculate();
      ctr.term = 60;
      ctr.vehicleAge = '0';
      ctr.calculate();
      ctr.vehicleAge = '3';
      ctr.calculate();
      ctr.clientTier = 'B';
      ctr.calculate();

    }
    
    @isTest static void testLibertyServiceManagerAPI() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyDrive;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
        ctr.libertyApplicationTest();
        ctr.libertyApplication();
    }
    
    @isTest static void testDriveSaveValidateOk_Consumer() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyDrive;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 60;
        ctr.ltv = 100;
        ctr.creditScore = '600';
        ctr.enquiries = '0';
        ctr.paymentType = 'Arrears';
        ctr.propertyOwner = 'Y';
        ctr.checkRateTypeAndClientTier();
        ctr.vehicleAge = 'New';
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 2;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental + '|clientRate: ' + ctr.clientRate + '|baseRate: ' + ctr.baseRate);
        System.assert(ctr.rental > 0);
        
        Application_Asset_Detail__c aad = Test_DataGeneratorHelper.asset;
        aad.Year__c = 2016;
        ctr.maxRate = ctr.clientRate - 2;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.applicationFee = null;
        ctr.savePreApproval();
        List<Integer> terms = new List<Integer>{3*12, 4*12, 5*12};
        List<String> clientTiers = new List<String>{'AAA','AA', 'A', 'A-', 'B', 'B-', 'C'};
        List<Integer> years = new List<Integer>{2017,2016,2015,2014,2015};
        ctr.applicationFee = 1495;
        Decimal i = 0;
        Test.startTest();
        Decimal p = 10;
        while (i<= 100 ){
          ctr.residualValue = ctr.carPrice * i.divide(100, 2);
        	ctr.netDeposit = ctr.carPrice - (i*20);
          System.debug('::::::' + ' - CarPrice: ' + ctr.carPrice + ' -Residual: ' + ctr.residualValue + ' -NetDeposit: ' + ctr.netDeposit);
        	for (Integer term : terms){
            for (String clientTier : clientTiers){
              ctr.term = term;
              ctr.clientTier = clientTier;
              ctr.savePreApproval();
            }   
          }
          i = i + 30;
        }
        
        Test.stopTest();
    }
    
    @isTest static void testDriveSaveValidateOk_Commercial() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyDrive;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 12;
        ctr.ltv = 100;
        ctr.creditScore = '600';
        ctr.enquiries = '0';
        ctr.paymentType = 'Arrears';
        ctr.propertyOwner = 'Y';
        ctr.checkRateTypeAndClientTier();
        ctr.vehicleAge = 'New';
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 2;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental + '|clientRate: ' + ctr.clientRate + '|baseRate: ' + ctr.baseRate);
        System.assert(ctr.rental > 0);
        
        Application_Asset_Detail__c aad = Test_DataGeneratorHelper.asset;
        aad.Year__c = 2016;
        aad.Condition__c = 'new';
        update aad;
        ctr.maxRate = ctr.clientRate - 2;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.applicationFee = null;
        ctr.savePreApproval();
        List<Integer> terms = new List<Integer>{3*12, 4*12, 5*12};
        List<String> clientTiers = new List<String>{'AAA','AA', 'A', 'A-', 'B', 'B-', 'C'};
        List<Integer> years = new List<Integer>{2017,2016,2015,2014,2015};
        List<Integer> realTimes = new List<Integer>{100001,50001, 80001};
        ctr.applicationFee = 1495;
        
        //ctr.rateType = 'Star';
        Decimal i = 0;
        Integer r = 2;
        Test.startTest();
        Decimal p = 10;
        while (i<= 100 ){
            ctr.residualValue = ctr.carPrice * i.divide(100, 2);
        	ctr.netDeposit = ctr.carPrice - (i*20);
            if (r >= 0){
                ctr.realtimeNaf = realTimes.get(r);
            }
            System.debug('::::::' + ' - CarPrice: ' + ctr.carPrice + ' -Residual: ' + ctr.residualValue + ' -NetDeposit: ' + ctr.netDeposit);
        	for (Integer term : terms){
                for (String clientTier : clientTiers){
                    ctr.term = term;
                    ctr.clientTier = clientTier;
                    ctr.savePreApproval();
                }   
            }
            r = r - 1;
            i = i + 30;
        }
               
        Test.stopTest();
    }
    
    @isTest static void testDriveSaveValidateOk() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        Test_DataGeneratorHelper.createQuote();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyDrive;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcRef.getParameters().put('preloadQuting', '1');
        Test.setCurrentPageReference(calcRef);
        LibertyDriveExtension ctr = new LibertyDriveExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 12;
        ctr.ltv = 100;
        ctr.creditScore = '600';
        ctr.enquiries = '0';
        ctr.paymentType = 'Arrears';
        ctr.propertyOwner = 'Y';
        ctr.checkRateTypeAndClientTier();
        ctr.vehicleAge = 'New';
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 2;
        ctr.calculate();
        System.debug('rental: ' + ctr.rental + '|clientRate: ' + ctr.clientRate + '|baseRate: ' + ctr.baseRate);
        System.assert(ctr.rental > 0);
        
        Application_Asset_Detail__c aad = Test_DataGeneratorHelper.asset;
        aad.Year__c = 2016;
        aad.Condition__c = 'new';
        update aad;
        ctr.maxRate = ctr.clientRate - 2;
        ctr.baseRate = 7;
        ctr.clientRate = 15;
        ctr.applicationFee = 1495;
        ctr.term = 12;
        ctr.clientTier = 'AAA';
        ctr.netDeposit = 3000;
        ctr.residualValue = 6600;
        ctr.realtimeNaf = 5000;
        //ctr.rateType = 'Star';
        ctr.maxRate = ctr.clientRate + 15;
        
        Test_DataGeneratorHelper.quote.MV_Acceptance__c = 'A';
        
        Test.startTest();
        ctr.savePreApproval(); 
        ctr.getCustomerPresentationStatusStyle();
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.checkRateTypeAndClientTier();
        Test.stopTest();
    }
}