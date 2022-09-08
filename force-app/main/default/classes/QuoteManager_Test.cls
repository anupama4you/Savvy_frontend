@isTest(SeeAllData=true)
public class QuoteManager_Test {
    @isTest static void testClass() {
        
        QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam();
        param.abnLength=null;
        param.adverseCredit=null;
        param.amountBaseComm=0.0;
        param.amountBasePmt=0.0; 
        param.applicationFee=499;
        param.assetAge=null;
        param.assetType='Car';
        param.bankrupt=null;
        param.baseRate=6.19;
        param.brokeragePer=0.0;
        param.carAge=0;
        param.clientRate=1;
        param.commBonus=0.0;
        param.commPayable=null;
        param.commRate=88;
        param.commType=null;
        param.companyScore=null;
        param.condition='new';
        param.creditScore=null;
        param.customerProfile='Property Owner';
        param.dateOfBirth=null;
        param.directorSoleTraderScore=null;
        param.docFees=0.0;
        param.dof=990;
        param.endOfTerm=null;
        param.equifaxScore=null;
        param.goodsSubType=null;
        param.goodsType=null;
        param.greenCar='Y';
        param.gst=null;
        param.gstLength=null;
        param.hasDefault=null;
        param.hasImports=null;
        param.hasMaxRate=null;
        param.interestType=null;
        param.loanType='Purchase';
        param.loanTypeDetail=null;
        param.lpiLevel=null;
        param.ltv=null;
        param.maritalStatus=null;
        param.maxRate=8.19;
        param.monthlyFee=9.9;
        param.nafCommission=0.0;
        param.netDeposit=44;
        param.noOfDependants=null;
        param.noOfPeople=null;
        param.paidDefault=null;
        param.paymentType='Arrears';
        param.privateSales='N';
        param.productLoanType=null;
        param.rental=0.0;
        param.repaymentType=null;
        param.residency=null;
        param.residualValue=0.0;
        param.riskFee=0.00;
        param.riskFeeBase=13000.0;
        param.riskGrade=null;
        param.saleBacksPurchased=null;
        param.state=null;
        param.term=60;
        param.tier='Tier 1'; 
        param.totalAmount=0.0;
        param.totalInsurance=0.0; 
        param.totalInsuranceIncome=0.0;
        param.vedascore=0; 
        param.vehiclePrice=55000; 
        param.vehicleYear='2022'; 
        param.vehiclesProfile='Property Owner';
        param.lender = 'Plenti Commercial';
        QuotingCalculation.CalcParam res = QuoteManager.getRateSetterRate(param);
        
        param.lender = 'RateSetter';
        Map<String, Decimal> baserate = QuoteManager.getBaseRates(param);
        param.lender = 'Money3';
        baserate = QuoteManager.getBaseRates(param);
        param.lender = 'Macquarie Consumer';
        param.assetType='Car';
        baserate = QuoteManager.getBaseRates(param);
        param.lender = 'Macquarie Commercial';
        baserate = QuoteManager.getBaseRates(param);
        
        param.lender = 'Plenti Commercial';
        baserate = QuoteManager.getBaseRatesManual(param, 10);
        
        QuoteManager.lenderSettingsWrapper lenderSettings = new QuoteManager.lenderSettingsWrapper();
        lenderSettings.applicationFee = 490;
        lenderSettings.dof = 990;
        param.lender = 'RateSetter PL';
        Map<String, Decimal> fees = QuoteManager.getFees(param, lenderSettings, false);
        param.lender = 'Money3';
        fees = QuoteManager.getFees(param, lenderSettings, false);
        
        QuoteController.QuotingDataParam param2 = new QuoteController.QuotingDataParam();
        param2.calcName = 'RateSetter';
        param2.oppId = [Select Id from Opportunity Limit 1].Id;
        param2.fields = new List<String> ();
        param2.fields.add('name');
        param2.rateSettings = new List<String> ();
        param2.rateSettings.add('setting1');
        param2.rateSettings.add('setting2');
        QuoteController.AppQuotingWraper quoteData = QuoteManager.getQuotingData(param2);
        param2.calcName = 'Plenti Commercial';
        quoteData = QuoteManager.getQuotingData(param2);
        param2.calcName = 'RateSetter PL';
        quoteData = QuoteManager.getQuotingData(param2);
        param2.calcName = 'Macquarie Consumer';
        quoteData = QuoteManager.getQuotingData(param2);
        param2.calcName = 'Macquarie Commercial';
        
        Lenders__c lenderres = QuoteManager.getLenderSetting('RateSetter');
        
        List<QuoteWrapper.Picklist>  pickVal = QuoteManager.getPickListValue('Macquarie Commercial', 'Goods Type');
        pickVal = QuoteManager.getPickListValue('Macquarie Commercial', 'Asset Year');
        
        List<QuoteWrapper.Picklist>  pickValDep = QuoteManager.getDependentPickListValue('Macquarie Commercial', 'Goods SubType','Chattel Mortgage-Full-Doc','LIFES' );
        pickValDep = QuoteManager.getDependentPickListValue('Macquarie Commercial', 'Loan Frequency','Chattel Mortgage-Full-Doc','' );
        pickValDep = QuoteManager.getDependentPickListValue('Macquarie Consumer', 'Goods Type','','' );
        
    }
}