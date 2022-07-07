@isTest(SeeAllData=true)
public class TestCalculators {
            
    public static testMethod void testCalculatorStGeorgeMV (){
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // St George MV
        PageReference StGeorgeMV = Page.StGeorgeMV;
        StGeorgeMV.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(StGeorgeMV);
        StGeorgeMVExtension StGeorgeMVCon = new StGeorgeMVExtension(sc);
        
        StGeorgeMVCon.productLoanType = 'Consumer Loan';
        StGeorgeMVCon.productGoodsType = 'Car';
        StGeorgeMVCon.carPrice = 50000.00;
        StGeorgeMVCon.deposit = 20000.00;
        StGeorgeMVCon.residualValue = 10000.00;
        StGeorgeMVCon.clientRate = 7.00;
        StGeorgeMVCon.loanType = 'Consumer';
        StGeorgeMVCon.paymentFrequency = 'Monthly';
        StGeorgeMVCon.carType ='New Cars';
        StGeorgeMVCon.gapLevel = 'Premier Cover 1';
        StGeorgeMVCon.gap = 1000.00;
        StGeorgeMVCon.gapIncome = 500.00;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.vehicleGroup = '';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.vehicleGroup = '4';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'WA';
        StGeorgeMVCon.warrantyLevel = 'Platinum - 24 months';
        StGeorgeMVCon.vehicleGroup = '2';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.vehicleGroup = '3';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.awd = 'Y';
        StGeorgeMVCon.turbo = 'Y';
        StGeorgeMVCon.diesel = 'Y';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = '';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'ACT';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'NSW';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'NT';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'VIC';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'TAS';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.state = 'QLD';
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.vehicleGroup = '1';
        StGeorgeMVCon.awd = 'N';
        StGeorgeMVCon.turbo = 'N';
        StGeorgeMVCon.diesel = 'N';
        
        StGeorgeMVCon.state = 'SA';
        StGeorgeMVCon.warrantyLevel = 'Platinum - 12 months';
        StGeorgeMVCon.warrantyPriceCalc();
        StGeorgeMVCon.warrantyIncomeCalc();
        StGeorgeMVCon.ltiLevel = 'Platinum Cover 1';
        StGeorgeMVCon.lti = 2000.00;
        StGeorgeMVCon.ltiIncome = 1000.00;
        StGeorgeMVCon.truckGapLevel = 'Cover 1';
        StGeorgeMVCon.truckGap = 3000.00;
        StGeorgeMVCon.truckGapIncome = 1500.00;
        StGeorgeMVCon.taiLevel = 'TAI Cover 1 ($5,000)';
        StGeorgeMVCon.tai = 4000.00;
        StGeorgeMVCon.taiIncome = 2000.00;
        StGeorgeMVCon.mvLevel = 'AIC/Eric';
        StGeorgeMVCon.mv = 5000.00;
        StGeorgeMVCon.mvIncome = 2500.00;
        StGeorgeMVCon.cci = 6000.00;
        StGeorgeMVCon.cciIncome = 3000.00;
        StGeorgeMVCon.nwc = 7000.00;
        StGeorgeMVCon.nwcIncome = 3500.00;
        
        // test for baseRateCalc()
        StGeorgeMVCon.carType = 'Used Cars to 3 years';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.term = 72;
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.term = 90;
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.term = 60;
        StGeorgeMVCon.carType = 'Used Cars 4-5 years';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.loanType = 'Commercial';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.loanType = '';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.loanType = 'Consumer';
        StGeorgeMVCon.carType = 'Used Cars 6+ years';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.carType = '';
        StGeorgeMVCon.baseRateCalc();
        
        StGeorgeMVCon.carType = 'New Cars';
        StGeorgeMVCon.baseRateCalc();
        StGeorgeMVCon.monthlyFeeCalc();
        StGeorgeMVCon.realtimeNafCalc();
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.savePreApproval();
        StGeorgeMVCon.paymentFrequency = 'Weekly';
        StGeorgeMVCon.monthlyFeeCalc();
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.paymentFrequency = 'Fortnightly';
        StGeorgeMVCon.monthlyFeeCalc();
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.paymentFrequency = 'Monthly';
        StGeorgeMVCon.paymentType = 'Advance';
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.clientRate = 1.00;
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.saveQuoting();
        StGeorgeMVCon.reset();
        StGeorgeMVCon.realtimeNafCalc();
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.savePreApproval();
        StGeorgeMVCon.clientRate = 1.00;
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.clientRate = 0.10;
        StGeorgeMVCon.baseRate = 1.00;
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.term = 0;
        StGeorgeMVCon.calculate();
        StGeorgeMVCon.saveQuoting();
        StGeorgeMVCon.rental = 0.00;
        StGeorgeMVCon.saveQuoting();
        StGeorgeMVCon.loanType = 'Commercial';
        StGeorgeMVCon.term = 72;
        StGeorgeMVCon.validation();
    }
    
    public static testMethod void testCalculatorStGeorgeLeisure (){
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // St George Leisure
        PageReference StGeorgeLeisure = Page.StGeorgeLeisure;
        StGeorgeLeisure.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(StGeorgeLeisure);
        StGeorgeLeisureExtension StGeorgeLeisureCon = new StGeorgeLeisureExtension(sc);
        
        StGeorgeLeisureCon.productLoanType = 'Consumer Loan';
        StGeorgeLeisureCon.productGoodsType = 'Car';
        StGeorgeLeisureCon.carPrice = 50000.00;
        StGeorgeLeisureCon.deposit = 20000.00;
        StGeorgeLeisureCon.residualValue = 10000.00;
        StGeorgeLeisureCon.clientRate = 10.00;
        StGeorgeLeisureCon.loanType = 'Consumer';
        StGeorgeLeisureCon.paymentFrequency = 'Monthly';
        StGeorgeLeisureCon.carType ='New Leisure';
        StGeorgeLeisureCon.gapLevel = 'Premier Cover 1';
        StGeorgeLeisureCon.gap = 1000.00;
        StGeorgeLeisureCon.gapIncome = 500.00;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.vehicleGroup = '';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.vehicleGroup = '4';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'WA';
        StGeorgeLeisureCon.warrantyLevel = 'Platinum - 24 months';
        StGeorgeLeisureCon.vehicleGroup = '2';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.vehicleGroup = '3';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.awd = 'Y';
        StGeorgeLeisureCon.turbo = 'Y';
        StGeorgeLeisureCon.diesel = 'Y';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = '';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'ACT';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'NSW';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'NT';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'VIC';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'TAS';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.state = 'QLD';
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.vehicleGroup = '1';
        StGeorgeLeisureCon.awd = 'N';
        StGeorgeLeisureCon.turbo = 'N';
        StGeorgeLeisureCon.diesel = 'N';
        
        StGeorgeLeisureCon.state = 'SA';
        StGeorgeLeisureCon.warrantyLevel = 'Platinum - 12 months';
        StGeorgeLeisureCon.warrantyPriceCalc();
        StGeorgeLeisureCon.warrantyIncomeCalc();
        StGeorgeLeisureCon.ltiLevel = 'Platinum Cover 1';
        StGeorgeLeisureCon.lti = 2000.00;
        StGeorgeLeisureCon.ltiIncome = 1000.00;
        StGeorgeLeisureCon.truckGapLevel = 'Cover 1';
        StGeorgeLeisureCon.truckGap = 3000.00;
        StGeorgeLeisureCon.truckGapIncome = 1500.00;
        StGeorgeLeisureCon.taiLevel = 'TAI Cover 1 ($5,000)';
        StGeorgeLeisureCon.tai = 4000.00;
        StGeorgeLeisureCon.taiIncome = 2000.00;
        StGeorgeLeisureCon.mvLevel = 'AIC/Eric';
        StGeorgeLeisureCon.mv = 5000.00;
        StGeorgeLeisureCon.mvIncome = 2500.00;
        StGeorgeLeisureCon.cci = 6000.00;
        StGeorgeLeisureCon.cciIncome = 3000.00;
        StGeorgeLeisureCon.nwc = 7000.00;
        StGeorgeLeisureCon.nwcIncome = 3500.00;
        
        // test for baseRateCalc()
        StGeorgeLeisureCon.carType = 'Used Leisure to 3 years';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.term = 72;
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.term = 90;
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.term = 60;
        StGeorgeLeisureCon.carType = 'Used Leisure 4-5 years';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.loanType = 'Commercial';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.loanType = '';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.loanType = 'Consumer';
        StGeorgeLeisureCon.carType = 'Used Leisure 6+ years';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.carType = '';
        StGeorgeLeisureCon.baseRateCalc();
        
        StGeorgeLeisureCon.carType = 'New Leisure';
        StGeorgeLeisureCon.baseRateCalc();
        StGeorgeLeisureCon.monthlyFeeCalc();
        StGeorgeLeisureCon.realtimeNafCalc();
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.savePreApproval();
        StGeorgeLeisureCon.paymentFrequency = 'Weekly';
        StGeorgeLeisureCon.monthlyFeeCalc();
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.paymentFrequency = 'Fortnightly';
        StGeorgeLeisureCon.monthlyFeeCalc();
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.paymentFrequency = 'Monthly';
        StGeorgeLeisureCon.paymentType = 'Advance';
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.clientRate = 1.00;
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.saveQuoting();
        StGeorgeLeisureCon.reset();
        StGeorgeLeisureCon.realtimeNafCalc();
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.savePreApproval();
        StGeorgeLeisureCon.clientRate = 1.00;
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.clientRate = 0.10;
        StGeorgeLeisureCon.baseRate = 1.00;
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.term = 0;
        StGeorgeLeisureCon.calculate();
        StGeorgeLeisureCon.saveQuoting();
        StGeorgeLeisureCon.rental = 0.00;
        StGeorgeLeisureCon.saveQuoting();
        StGeorgeLeisureCon.loanType = 'Commercial';
        StGeorgeLeisureCon.term = 72;
        StGeorgeLeisureCon.validation();
    }
            
    public static testMethod void testFinancialTaxCalculate (){
        FinancialUtilities.taxCalculate(10000);
        FinancialUtilities.taxCalculate(30000);
        FinancialUtilities.taxCalculate(70000);
        FinancialUtilities.taxCalculate(100000);
        FinancialUtilities.taxCalculate(200000);
    }
    
    public static testMethod void testGeneral (){
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.GeneralCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        GeneralCalculatorExtension calcCtrl = new GeneralCalculatorExtension(sc);
        
        calcCtrl.calculate();
        calcCtrl.dto.applicationFee = null;
        calcCtrl.dto.dof = null;
        calcCtrl.dto.ppsr = null;
        calcCtrl.dto.baseRate = null;
        calcCtrl.dto.clientRate = null;
        calcCtrl.dto.term = null;
        calcCtrl.calculate();
        calcCtrl.reset();
        
        calcCtrl.dto.carPrice = 50000.00;
        calcCtrl.dto.deposit = 2000.00;
        calcCtrl.dto.ppsr = 10.00;
        calcCtrl.dto.residualValue = 1000.00;
        calcCtrl.dto.clientRate = 15.00;
        calcCtrl.dto.gapLevel = 'Premier Cover 1';
        calcCtrl.dto.gap = 1000.00;
        calcCtrl.dto.gapIncome = 500.00;
        
        // test for WarrantyPriceCalc() and WarrantyIncomeCalc()
        calcCtrl.warrantyCalc();
        calcCtrl.dto.vehicleGroup = '';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.vehicleGroup = '4';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'WA';
        calcCtrl.dto.warrantyLevel = 'Platinum - 24 months';
        calcCtrl.dto.vehicleGroup = '2';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.vehicleGroup = '3';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.awd = 'Y';
        calcCtrl.dto.turbo = 'Y';
        calcCtrl.dto.diesel = 'Y';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = '';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'ACT';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'NSW';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'NT';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'VIC';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'TAS';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.state = 'QLD';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.vehicleGroup = '1';
        calcCtrl.dto.awd = 'N';
        calcCtrl.dto.turbo = 'N';
        calcCtrl.dto.diesel = 'N';
        
        calcCtrl.dto.state = 'SA';
        calcCtrl.dto.warrantyLevel = 'Platinum - 12 months';
        calcCtrl.warrantyCalc();
        calcCtrl.dto.ltiLevel = 'Platinum Cover 1';
        calcCtrl.dto.lti = 200.00;
        calcCtrl.dto.ltiIncome = 100.00;
        calcCtrl.dto.truckGapLevel = 'Cover 1';
        calcCtrl.dto.truckGap = 300.00;
        calcCtrl.dto.truckGapIncome = 150.00;
        calcCtrl.dto.taiLevel = 'TAI Cover 1 ($5,000)';
        calcCtrl.dto.tai = 400.00;
        calcCtrl.dto.taiIncome = 200.00;
        calcCtrl.dto.mvLevel = 'AIC/Eric';
        calcCtrl.dto.mv = 500.00;
        calcCtrl.dto.mvIncome = 250.00;
        calcCtrl.dto.cci = 600.00;
        calcCtrl.dto.cciIncome = 300.00;
        calcCtrl.dto.nwc = 700.00;
        calcCtrl.dto.nwcIncome = 350.00;
        
        // test for baseRateCalc() and calculateValidation()
        calcCtrl.dto.carPrice = 60000.00;
        calcCtrl.dto.brokeragePercentage = 5;
        calcCtrl.dto.term = 60;
        calcCtrl.calculate();
        calcCtrl.dto.term = 48;
        calcCtrl.dto.brokeragePercentage = 6;
        calcCtrl.calculate();
        calcCtrl.dto.term = 36;
        calcCtrl.dto.brokeragePercentage = 7;
        calcCtrl.calculate();
        calcCtrl.dto.term = 24;
        calcCtrl.dto.brokeragePercentage = 8;
        calcCtrl.calculate();
        
        calcCtrl.savePreApproval();
        calcCtrl.dto.paymentType = 'Advance';
        calcCtrl.calculate();
        
        calcCtrl.saveQuoting();
        
        calcCtrl.saveAmendment();
        calcCtrl.saveFormalApproval();
        calcCtrl.hasCalculationDone();
        calcCtrl.sendCustomerEmail1();
        calcCtrl.getProtectecResult();
        calcCtrl.getCoverOptionSelect();
        calcCtrl.ericLPICalculate();
        calcCtrl.getIsBrokerPartnerUser();
        
        test.stopTest();
    }
    
    public static testMethod void testLenderQuotingWrapperDTO (){
        test.startTest();
        List <Lenders__c> lenderList = Lenders__c.getAll().values();
        LenderQuotingWrapperDTO dto = new LenderQuotingWrapperDTO(lenderList.get(0));
        dto.baseRate = 0.0;
        dto.carPrice = 1000.0;
        dto.deposit = 500.0;
        dto.productLoanType = '';
        dto.productGoodsType = '';
        dto.term = 60;
        dto.customerProfile = '';
        dto.adverseCredit = '';
        dto.ltv = '';
        dto.goodsType = '';
        dto.vehiclesProfile = '';
        dto.carAge = 0;
        dto.privateSales = '';
        dto.motorCycles = '';
        dto.caravanCampervans = '';
        dto.loanType = '';
        dto.carType = '';
        dto.rateOption = '';
        dto.getCreditGuidelineList();

        dto = new LenderQuotingWrapperDTO();
        
        LenderQuotingWrapperDTO dto2 = new LenderQuotingWrapperDTO(lenderList.get(0));
        
        dto.compareTo(dto2);
        dto.baseRate = 0;
        dto.compareTo(dto2);
        dto.baseRate = null;
        dto2.baseRate = 0;
        dto.compareTo(dto2);
        dto.baseRate = 0;
        dto.compareTo(dto2);
        dto.baseRate = 1;
        dto.compareTo(dto2);
        dto2.baseRate = 3;
        dto.compareTo(dto2);
        dto.compareTo(null);
        test.stopTest();
    }

}