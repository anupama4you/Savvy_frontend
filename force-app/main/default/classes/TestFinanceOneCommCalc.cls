@isTest(SeeAllData=true)
private class TestFinanceOneCommCalc {
	
	@isTest static void testCalculator() {
        
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOne;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.riskFee = 800;
        ctr.reset();
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.loanType = 'Gold';
        ctr.productGoodsType = 'Car';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.ppsr = 10.00;
        ctr.residualValue = 10000.00;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.maxRate;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
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
        ctr.nwcParam.isManuallyNWCPrice = true;
        ctr.nwcParam.nwcPriceToCustomer = 14000;
        ctr.nwcParam.assetType = 'Car';
        ctr.nwcPlan = 'A';
        ctr.nwcTerm = '12';
        ctr.nwcParam.state = 'SA';
        //NWCCalculator HJ - F - 12-07-2018
        
        // test for baseRateCalc() and calculateValidation()
        ctr.carPrice = -1000.00;
        ctr.riskFeeCalc();
        ctr.dofCalc();
        ctr.carPrice = 10000.00;
        ctr.riskFeeCalc();
        ctr.carPrice = 20000.00;
        ctr.riskFeeCalc();
        ctr.carPrice = 60000.00;
        ctr.clientRate = 30.00;
        ctr.term = 20;
        ctr.calculateValidation();
        // ctr.loanTypeDetail = 'Silver';
        // ctr.calculateValidation();
        // ctr.baseRateCalc();
        // ctr.loanTypeDetail = 'Bronze';
        // ctr.calculateValidation();
        ctr.baseRateCalc();
        //ctr.loanTypeDetail = 'E-Motors';
        //ctr.term = 60;
        //ctr.applicationFeeCalc();
        //ctr.dofCalc();
        //ctr.calculateValidation();
        //ctr.baseRateCalc();
        //ctr.calculate();
        
        ctr.loanTypeDetail = 'Gold';
        ctr.carPrice = 50000.00;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.maxRate;
        ctr.riskFeeCalc();
        ctr.calculateValidation();
        ctr.applicationFeeCalc();
        ctr.dofCalc();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.saveQuoting();
        ctr.reset();
        //ctr.clientRate = ctr.maxRate;
        //ctr.riskFeeCalc();
        //ctr.calculateValidation();
        //ctr.applicationFeeCalc();
        //ctr.dofCalc();
        //ctr.calculate();
        //ctr.savePreApproval();
        
        // Correct calculation
        ctr.riskFee = 800;
        ctr.loanTypeDetail = 'Gold';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.paymentType = 'Arreas';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        ctr.saveQuoting();
        //ctr.savePreApproval();
        //ctr.saveAmendment();
        //ctr.saveFormalApproval();

        ctr.acceptQuoteMV();
        ctr.acceptQuoteGAP();
        ctr.acceptQuoteCCI();
        ctr.acceptQuoteWRR();
        ctr.acceptQuoteNWC();

        ctr.declineQuoteMV();
        ctr.declineQuoteGAP();
        ctr.declineQuoteCCI();
        ctr.declineQuoteWRR();
        ctr.declineQuoteNWC();

    }

    @isTest static void testCalculator2() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOneComm;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        
        // Correct calculation
        ctr.loanTypeDetail = 'Gold';
        ctr.riskFee = 800;
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.paymentType = 'Arreas';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        ctr.productGoodsSubType = 's';
        ctr.savePreApproval();
        ctr.saveAmendment();
        //ctr.saveFormalApproval();

        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        ctr.hasCalculationDone();
        
    }

    @isTest static void testCalculator3() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
		ctr.riskFee = 800;
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
        ctr.acceptQuoteNWC();
        ctr.nationalWarrantyCalc();

        ctr.mvAcceptance = 'D';
        ctr.declineQuoteMV();

        ctr.gapAcceptance = 'D';
        ctr.declineQuoteGAP();

        ctr.cciAcceptance = 'D';
        ctr.declineQuoteCCI();

        ctr.warrantyAcceptance = 'D';
        ctr.nwcAcceptance = 'D';
        ctr.declineQuoteWRR();

        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('isLiberty','true');
        calcPdf.getParameters().put('isFinanceOne','true');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        
        Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Finance One';
        update Test_DataGeneratorHelper.quote;
        ctr = new FinanceOneCommExtension(sc);
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.loanTypeDetail = 'Silver';
        ctr.riskFee = 9000;
        ctr.clientRate = 18;
        ctr.dof = 1;
        ctr.monthlyFee = 1;
        ctr.mvAcceptance = 'A';
        ctr.gapAcceptance = 'A';
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        ctr.saveQuoting();
        ctr.savePreApproval();
        ctr.carPrice = 14000;
        ctr.getRiskFeeCalc(QuotingCalculation.CALC_QUOTING, null);
        ctr.dofCalc(); 
        ctr.carPrice = 21000;
        ctr.getRiskFeeCalc(QuotingCalculation.CALC_QUOTING, null);       
        test.stopTest();
	}
    
    @isTest static void testCalculator4() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOneComm;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        
        // Correct calculation
        ctr.loanTypeDetail = 'Gold';
        ctr.carPrice = 80000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 72;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.paymentType = 'Arreas';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        System.debug('term >> ' + ctr.term);
        ctr.propertyOwner = 'N';
        ctr.getRealtimeNafVal();
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        
        ctr.savePreApproval();
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.getPresentationUrlCode();
        ctr.getCustomerPresentationStatusStyle();
        
        //Last part of this test
        ctr.productLoanType = null;
        ctr.getLoanTypes();
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.getLoanTypes();
        ctr.productLoanType = 'Chatel';
        ctr.getLoanTypes();
    }

    @isTest static void testCalculator5() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Application_Asset_Detail__c a = new Application_Asset_Detail__c();
        a.Year__c = 2010;
        a.Type__c = 'Car';
        a.Condition__c = 'used';
        insert a;
        Test_DataGeneratorHelper.tstOpportunity.Application_AssetDetail__c = a.Id;
        update Test_DataGeneratorHelper.tstOpportunity;
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOneComm;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        
        // Correct calculation
        ctr.loanTypeDetail = 'Gold';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 72;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.paymentType = 'Arreas';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        
        ctr.savePreApproval();
        
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        
        ctr.getPresentationUrlCode();
        ctr.getCustomerPresentationStatusStyle();
        
        ctr.getLenderQuoting();
        
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
        ctr.calculateNWC();
        //NWCCalculator HJ - F - 12-07-2018
        
    }

    @isTest static void testCalculator6() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOneComm;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productGoodsType = 'Car';
        
        // Correct calculation
        ctr.loanTypeDetail = 'Gold';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.paymentType = 'Arreas';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('baseRate >> ' + ctr.baseRate);
        
        ctr.calculate();
        ctr.riskFee = 800;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        ctr.getInsuranceFailureReasons();
        
        LenderAPIResponse__c l = new LenderAPIResponse__c();
        l.Application_ID__c = '1';
        l.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;
        l.Provider__c = 'Finance One';  
        insert l;
        ctr.application();
    }

    @isTest static void testCalcValidations() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference FinanceOne = Page.FinanceOneComm;
        FinanceOne.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(FinanceOne);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        ctr.reset();
        ctr.riskFee = 1996;
        ctr.calculate();
        ctr.riskFee = 800;
        ctr.calculate();
        ctr.riskFee = 0;
        ctr.calculate();
        ctr.riskFee = null;
        ctr.clientRate = 0.0;
        ctr.baseRate = 0;
        ctr.term = 0;
        ctr.residualValue = 1;
        ctr.calculate();
        FinanceOneApp__c f = new FinanceOneApp__c();
        f.Account_ID__c = '1';
        f.Opportunity__c = Test_DataGeneratorHelper.tstOpportunity.Id;  
        insert f;
        ctr.application();

        ctr.dto = new FinanceOneDTOs.IndividualApplication();
        ctr.apiUser = null;
        ctr.loanTypeDetail = 'Silver';
        ctr.updateApplicationFeeCalc();
        ctr.onChangeLoanTypeDetail();
        ctr.getIsBrokerPartnerUser();
        ctr.hasValidQuotation();
        ctr.calculateQuote();
        ctr.storeQuotingData();
    }

    @isTest static void testInsuranceProductSelected() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.FinanceOne;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        FinanceOneCommExtension ctr = new FinanceOneCommExtension(sc);
        
        ctr.reset();
        
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.riskFee = 800;
        ctr.carPrice = 25000.00;
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.productGoodsSubType = 's';
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

        ctr.productGoodsSubType = 's';
        ctr.save();
        ctr.getProductGoodsSubTypes();
    }	
}