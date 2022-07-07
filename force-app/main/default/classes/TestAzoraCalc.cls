@isTest(SeeAllData=true)
private class TestAzoraCalc {

	@isTest static void testCalculator() {
        
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.quote.LPI__c = 'CRDU';
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Azora Consumer';
        update Test_DataGeneratorHelper.quote;
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        ctr.reset();
        ctr.applicationFee = 1000;
        ctr.dof = 1000;
        ctr.productLoanType = 'Consumer Loan';
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.ppsr = 10.00;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.carPrice = 60000.00;
        ctr.clientRate = 30.00;
        ctr.term = 20;
        ctr.calculateValidation();
        ctr.baseRateCalc();
        
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 50000.00;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.riskFeeCalc();
        ctr.calculateValidation();
        ctr.calculate();
        ctr.savePreApproval();
        ctr.repaymentType = 'Monthly';
        ctr.calculate();
        ctr.saveQuoting();
        ctr.reset();
        
        // Correct calculation
        ctr.riskFee = 800;
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.repaymentType = 'Monthly';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
        ctr.saveQuoting();
    }


    @isTest static void testCalculator2() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        
        ctr.reset();
        ctr.productLoanType = 'Consumer Loan';
                
        // Correct calculation
        ctr.loanTypeDetail = '832 - 1200';
        ctr.riskFee = 800;
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.repaymentType = 'Monthly';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
                
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
        Test_DataGeneratorHelper.quoting.Name= 'Azora Consumer';
        update Test_DataGeneratorHelper.quoting;
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
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
        Test_DataGeneratorHelper.quote.Financier_Name__c = 'Azora Consumer';
        update Test_DataGeneratorHelper.quote;
        ctr = new AzoraCalcExtension(sc);
        ctr.carPrice = 1;
        ctr.netDeposit = 1;
        ctr.productLoanType = 'Consumer Loan';
        ctr.loanTypeDetail = '832 - 1200';
        ctr.riskFee = 9000;
        ctr.clientRate = 18;
        ctr.dof = 1;
        ctr.monthlyFee = 1;
        ctr.mvAcceptance = 'A';
        ctr.gapAcceptance = 'A';
        ctr.warrantyAcceptance = 'A';
        ctr.nwcAcceptance = 'A';
        ctr.cciAcceptance = 'A';
        
        ctr.repaymentType = 'Monthly';
        ctr.saveQuoting();
        ctr.savePreApproval();
        ctr.saveFormalApproval();        
        test.stopTest();
 	}
   
    @isTest static void testCalculator4() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Consumer Loan';
                
        // Correct calculation
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.repaymentType = 'Monthly';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
                
        ctr.savePreApproval();
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        
        ctr.getPresentationUrlCode();
        ctr.getCustomerPresentationStatusStyle();
        
        //Last part of this test
        ctr.productLoanType = null;
        ctr.productLoanType = 'Consumer Loan';
        ctr.productLoanType = 'Chatel';
    }

    @isTest static void testCalculator5() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Consumer Loan';
                
        // Correct calculation
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.repaymentType = 'Monthly';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
                
        ctr.savePreApproval();
        
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        
        ctr.getPresentationUrlCode();
        ctr.getCustomerPresentationStatusStyle();
        
        ctr.getLenderQuoting();
        
    }

    @isTest static void testCalculator6() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        ctr.reset();
        ctr.riskFee = 800;
        ctr.productLoanType = 'Consumer Loan';
                
        // Correct calculation
        ctr.loanTypeDetail = '832 - 1200';
        ctr.carPrice = 20000.00;
        ctr.deposit = 0.00;
        ctr.riskFeeCalc();
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
        ctr.repaymentType = 'Monthly';
        System.debug('clientRate >> ' + ctr.clientRate);
        System.debug('term >> ' + ctr.term);
        ctr.calculate();
        System.debug('clientRate >> ' + ctr.clientRate);
                
        ctr.calculate();
        ctr.riskFee = 800;
        ctr.gapLevel = 'Premier Cover 1';
        ctr.gap = 1000.00;
        ctr.gapIncome = 500.00;
        
        ctr.hasCalculationDone();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.sendCustomerEmail1();
        // ctr.sendCustomerEmail2();
        ctr.getInsuranceFailureReasons();
    }

    @isTest static void testCalcValidations() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference Azora = Page.AzoraCalc;
        Azora.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(Azora);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        ctr.reset();
        ctr.riskFee = 1996;
        ctr.calculate();
        ctr.riskFee = 800;
        ctr.calculate();
        ctr.riskFee = 0;
        ctr.calculate();
        ctr.riskFee = null;
        ctr.clientRate = 0.0;
        ctr.term = 0;
        ctr.calculate();
        
        ctr.loanTypeDetail = 'Economy';
        ctr.getIsBrokerPartnerUser();
    }

    @isTest static void testInsuranceProductSelected() {
        
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.AzoraCalc;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        AzoraCalcExtension ctr = new AzoraCalcExtension(sc);
        
        ctr.reset();
        ctr.loanTypeDetail = '832 - 1200';
        ctr.repaymentType = 'Monthly';
        //ctr.dto.productLoanType = 'Passenger and Commercial Vehicles';
        ctr.riskFee = 800;
        ctr.carPrice = 25000.00;
        ctr.term = 60;
        ctr.baseRateCalc();
        ctr.clientRate = 1;
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

    }
	
}