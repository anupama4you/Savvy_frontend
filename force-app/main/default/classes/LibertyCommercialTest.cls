@isTest(SeeAllData=true)
private class LibertyCommercialTest {

	@isTest static void testDrive() {
		test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.reloadOpportunity();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    // Liberty Drive
    PageReference LibertyCommercial = Page.LibertyCommercial;
    LibertyCommercial.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(LibertyCommercial);
    LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
    ctr.getVehicleYearOptions();
    ctr.applicationFee = 2000;
    ctr.vehicleAge = 'New';
    ctr.vehicleYear = '2020';
    ctr.calculate();
    ctr.vehicleAge = '0-4 years';
    ctr.vehicleYear = '2017';
    ctr.calculate();
    ctr.carPrice = 10000;
    ctr.residualValue = 6000;
    ctr.creditScore = '750+';
    ctr.propertyOwner = 'Y';
    ctr.abnLength = '>36 mths';
    ctr.gstLength = '>36 mths';
    ctr.vehicleYear = '2019';
    ctr.calculate();
    ctr.vehicleYear = '2018';
    ctr.calculate();
    ctr.vehicleAge = '5-9 years';
    ctr.vehicleYear = '2017';
    ctr.calculate();
    ctr.vehicleYear = '2018';
    ctr.calculate();
    ctr.vehicleAge = '10+ years';
    ctr.vehicleYear = '2019';
    ctr.calculate();
    ctr.term = 72;
    ctr.abnLength = '>24 mths';
    ctr.creditScore = '400+';
    ctr.calculate();
    ctr.ltv = 1;
    ctr.propertyOwner = 'N';
    ctr.abnLength = '>24 mths';
    ctr.gstLength = '>24 mths';
    ctr.creditScore = '600+';
    ctr.calculate();
    ctr.gstLength = '>24 mths';
    ctr.creditScore = '500+';
    ctr.calculate();
    ctr.gstLength = 'No GST';
    ctr.calculate();
    ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 50000.00;
    ctr.deposit = 20000.00;
    ctr.residualValue = 10000.00;
    ctr.ltv = 80;
    ctr.creditScore = '600';

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
    
    ctr.baseRateCalc();
    ctr.ltv = 120;
    ctr.baseRateCalc();
    
    ctr.baseRateCalc();
    ctr.ltv = 150;
    ctr.baseRateCalc();
    
    ctr.baseRateCalc();
    
    
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
 

  @isTest static void testDriveInsuranceProductSelected() {
    test.startTest();
    Test_DataGeneratorHelper.createApplication();
    Test_DataGeneratorHelper.createAssetDetailLTV();
    ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
    
    PageReference calcRef = Page.LibertyCommercial;
    calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
    Test.setCurrentPageReference(calcRef);
    LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
    
    ctr.reset();
    ctr.loanType = 'Purchase';
    ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
    ctr.productGoodsType = 'Car';
    ctr.carPrice = 30000.00;
    ctr.deposit = 150.00;
    ctr.residualValue = 0.00;
    ctr.term = 60;
    ctr.ltv = 100;
    ctr.creditScore = '600+';
    ctr.paymentType = 'Arrears';
    ctr.propertyOwner = 'Y';
    ctr.checkRateTypeAndClientTier();
    ctr.vehicleAge = 'New';
    ctr.abnLength = '>12 mths';
    ctr.gstLength = '>12 mths';
    ctr.vehicleYear = '2022';
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
      
      PageReference calcRef = Page.LibertyCommercial;
      calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
      Test.setCurrentPageReference(calcRef);
      LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
      
      ctr.reset();
      ctr.loanType = 'Purchase';
      ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
      ctr.productGoodsType = 'Car';
      ctr.carPrice = 30000.00;
      ctr.deposit = 150.00;
      ctr.residualValue = 0.00;
      ctr.term = 60;
      ctr.ltv = 100;
      ctr.creditScore = '500+';
      ctr.paymentType = 'Arrears';
      ctr.propertyOwner = 'Y';
      ctr.checkRateTypeAndClientTier();
      ctr.vehicleAge = 'New';
      ctr.abnLength = '>12 mths';
      ctr.gstLength = '>12 mths';
      ctr.vehicleYear = '2022';
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

      ctr = new LibertyCommercialExtension(sc);
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
        
        PageReference calcRef = Page.LibertyCommercial;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        
        LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
        
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.carPrice = 30000.00;
        ctr.creditScore = '600';
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 2;
        ctr.calculate();
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
      PageReference LibertyCommercial = Page.LibertyCommercial;
      LibertyCommercial.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
      Test.setCurrentPageReference(LibertyCommercial);
      LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);

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
      ctr.clientTier = 'AAA';
      ctr.carPrice = 110000;
      ctr.propertyOwner = 'N';
      ctr.residualValue = 80000;
      ctr.vehicleAge = 'New';
      ctr.calculate();
      ctr.clientTier = 'B';
      ctr.calculate();
      ctr.productGoodsType = 'Caravan';
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
        
        PageReference calcRef = Page.LibertyCommercial;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
        ctr.libertyApplicationTest();
        ctr.libertyApplication();
    }
    
    @isTest static void testDriveSaveValidateOk_Commercial() {
        
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createAssetDetailLTV();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.LibertyCommercial;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 12;
        ctr.ltv = 100;
        ctr.creditScore = '400+';
        ctr.paymentType = 'Arrears';
        ctr.propertyOwner = 'Y';
        ctr.checkRateTypeAndClientTier();
        ctr.vehicleAge = 'New';
        ctr.abnLength = '>12 mths';
        ctr.gstLength = '>12 mths';
        ctr.vehicleYear = '2022';
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
        
        PageReference calcRef = Page.LibertyCommercial;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcRef.getParameters().put('preloadQuting', '1');
        Test.setCurrentPageReference(calcRef);
        LibertyCommercialExtension ctr = new LibertyCommercialExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 30000.00;
        ctr.deposit = 150.00;
        ctr.residualValue = 0.00;
        ctr.term = 12;
        ctr.ltv = 100;
        ctr.creditScore = '600+';
        ctr.paymentType = 'Arrears';
        ctr.propertyOwner = 'N';
        ctr.checkRateTypeAndClientTier();
        ctr.vehicleAge = 'New';
        ctr.abnLength = '>24 mths';
        ctr.gstLength = '>24 mths';
        ctr.vehicleYear = '2022';
        ctr.baseRateCalc();
        ctr.abnLength = '>24 mths';
        ctr.creditScore = '500+';
        ctr.baseRateCalc();
        ctr.abnLength = '>12 mths';
        ctr.creditScore = '400+';
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
        ctr.maxRate = ctr.clientRate + 15;
        
        Test_DataGeneratorHelper.quote.MV_Acceptance__c = 'A';
        
        Test.startTest();
        ctr.savePreApproval(); 
        ctr.getCustomerPresentationStatusStyle();
        ctr.getRates();
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.checkRateTypeAndClientTier();
        Test.stopTest();
    }

}