@isTest(SeeAllData=true)
private class TestCarStartFinanceCalc {
    @isTest static void testCalculator() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.CarStartFinanceCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        CarStartFinanceCalculatorExtension ctr = new CarStartFinanceCalculatorExtension(sc);
        
        ctr.calculate();
        ctr.dof = null;
        ctr.ppsr = null;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.term = null;
        ctr.calculate();
        ctr.reset();
        
        ctr.productLoanType = 'New';
        ctr.carPrice = 50000.00;
        ctr.deposit = 20000.00;
        ctr.ppsr = 10.00;
        ctr.residualValue = 10000.00;
        ctr.clientRate = 23.00;
        
        // test for baseRateCalc() and calculateValidation()
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.carPrice = 20000.00;
        ctr.term = 60;
        ctr.riskFee = 1;
        ctr.commission = 1;
        ctr.loanTypeDetail = 'Mid-Prime Finance Only';
        ctr.dof = 300;
        ctr.deposit = 0;
        ctr.tradeIn = 0;
        ctr.payoutOn = 0;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        System.debug('Start calculation >>>>>>>>>>>>>>>>>>>>>>>>>>');
        ctr.calculate();
        System.debug('End calculation >>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        ctr.nwcAcceptance = 'A';
        ctr.saveQuoting();
        
        // Insurance
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        
        test.stopTest();
    }
    
    @isTest static void testCalculator2() {
        test.startTest();
        Test_DataGeneratorHelper.createQuote();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        CarStartFinanceCalculatorExtension ctr = new CarStartFinanceCalculatorExtension(sc);
        
        ctr.reset();
        ctr.loanType = 'Purchase';
        ctr.productLoanType = 'Consumer Loan';
        ctr.carPrice = 35000.00;
        ctr.term = 72;
        ctr.loanTypeDetail = 'Sub-Prime Finance Only';
        ctr.deposit = 0;
        ctr.tradeIn = 0;
        ctr.payoutOn = 0;
        ctr.residualValue = 1000;
        ctr.dof = 900;
        ctr.commission = 1;
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.calculate();
        ctr.savePreApproval();
        
        String[] details = new String[]{'Mid-Prime Finance Only','Sub-Prime Finance Only','Sub-Prime Vend & Lend','Sub-Prime Lite (pensioners) Finance Only','Sub-Prime Lite (pensioners) Vend & Lend'};
            ctr.residualValue = 1000;
        for (Integer i = 1; i<=3;i++) {
            ctr.term = 12 * (i+2);
            for (String a : details) {
                ctr.loanTypeDetail = a;
                ctr.calculate();
            }
        }
        
        ctr.loanTypeDetail = 'Sub-Prime Finance Only';
        ctr.calculate();
        
        ctr.loanTypeDetail = 'Sub-Prime Finance Only';
        ctr.residualValue = ctr.carPrice * 0.6;
        ctr.calculate();        
        
        ctr.getTypeOfFinance();
        ctr.getProducts();
        details = new String[]{
          QuotingCalculation.CALC_QUOTING,
          InsuranceQuoteUtils.INS_PROD_MV,
          InsuranceQuoteUtils.INS_PROD_WARR,
          InsuranceQuoteUtils.INS_PROD_NWC
        };
        for (String a: details) {
          ctr.getTotalInsuranceType(a);
          ctr.getTotalInsuranceIncomeType(a);
        }
        
        ctr.getLenderQuoting();
        ctr.getIsBrokerPartnerUser();
        ctr.hasValidQuotation();
        ctr.calculateQuote();
        ctr.storeQuotingData();

        test.stopTest();
    }
    
}