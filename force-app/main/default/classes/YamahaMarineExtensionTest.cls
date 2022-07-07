@isTest(SeeAllData=true)
public class YamahaMarineExtensionTest {

	@isTest static void testMarineCalculator() {
		test.startTest();
        Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        // Finance One
        PageReference calcRef = Page.YamahaMarineCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaMarineCalculatorExtension ctr = new YamahaMarineCalculatorExtension(sc);
        
        ctr.calculate();
        ctr.applicationFee = null;
        ctr.dof = null;
        ctr.ppsr = null;
        ctr.baseRate = null;
        ctr.clientRate = null;
        ctr.term = null;
        ctr.calculate();
        ctr.reset();
        ctr.loanTypeDetail = 'Prime Plus';
        ctr.assetType = 'Boat';
        ctr.customerProfile = 'New';
        ctr.carPrice = 25000.00;
        ctr.deposit = 0.00;
        ctr.ppsr = 50.00;
        ctr.residualValue = 0.00;
        ctr.term = 60;
        ctr.calculateDOf();
        ctr.calculateDOf();
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 0.5;
        ctr.term = 60;
        ctr.calculate();
        
        ctr.savePreApproval();
        ctr.paymentType = 'Advance';
        ctr.calculate();
        ctr.saveQuoting();
        ctr.clientRate = ctr.baseRate + 1;
        ctr.calculate();
        ctr.saveQuoting();
        


        // Insurance
        ctr.saveAmendment();
        ctr.saveFormalApproval();
        
        ctr.hasCalculationDone();
        ctr.sendCustomerEmail1();
        ctr.sendCustomerEmail2();
        ctr.privateSales = 'Y';
        ctr.checkPrivateSales();
        
        ctr.reset();
        ctr.carPrice = 15000.00;
        ctr.dof = 0.0;
        ctr.customerProfile = 'Used';
        ctr.loanTypeDetail = 'Standard';
        ctr.hasValidQuotation();

        ctr.customerProfile = 'New';
        ctr.assetType = 'Boat';
        ctr.residualValue = 10000.00;
        ctr.term = 60;
        ctr.hasValidQuotation();
        ctr.customerProfile = 'Used';
        ctr.term = 48;
        ctr.hasValidQuotation();
        ctr.customerProfile = 'New';
        ctr.assetType = 'Motorcycle';
        ctr.term = 60;
        ctr.hasValidQuotation();
        ctr.customerProfile = 'Used';
        ctr.term = 48;
        ctr.hasValidQuotation();
        
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.quoting.App_Insurance_Quote__c = Test_DataGeneratorHelper.quote.Id;
        update Test_DataGeneratorHelper.quoting;
        ctr = new YamahaMarineCalculatorExtension(sc);
        
        ctr.getSelectLoanTypeMarineOptions();
        ctr.getSelectCustomerProfileOptions();
        
        // Calculator PDF
        PageReference calcPdf = Page.UniversalCalculatorPdf;
        calcPdf.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        calcPdf.getParameters().put('lender','MONEY3 CALCULATION');
        Test.setCurrentPageReference(calcPdf);
        CalculatorPdfExtension calcPdfCon = new CalculatorPdfExtension (sc);
        calcPdfCon.getIsYamahaMoto();
        test.stopTest();
	}
	
    @isTest static void testMarineInsuranceProductSelected() {
        test.startTest();
        Test_DataGeneratorHelper.createApplication();
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
        
        PageReference calcRef = Page.YamahaMarineCalculator;
        calcRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(calcRef);
        YamahaMarineCalculatorExtension ctr = new YamahaMarineCalculatorExtension(sc);
        
        ctr.reset();
        ctr.loanTypeDetail = 'Prime Plus';
        ctr.assetType = 'Boat';
        ctr.customerProfile = 'New';
        ctr.carPrice = 25000.00;
        ctr.deposit = 0.00;
        ctr.ppsr = 50.00;
        ctr.residualValue = 0.00;
        ctr.term = 60;
        ctr.calculateDOf();
        ctr.calculateDOf();
        ctr.baseRateCalc();
        ctr.clientRate = ctr.baseRate + 0.5;
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
        ctr.carPrice = 40000;
        ctr.term = 84;
        ctr.savePreApproval();
        
        ctr.productLoanType = 'Consumer Loan';
        ctr.productLoanTypeOnChange();
        ctr.productLoanType = 'Chattel Mortgage-Full-Doc';
        ctr.productLoanTypeOnChange();

        ctr = new YamahaMarineCalculatorExtension(sc);

        ctr.getAssetTypeOptions();
        ctr.getDOFBaseCalculation();
        ctr.getYamahaRatesV2();
        ctr.getIsBrokerPartnerUser();
        ctr.getIsBrokerPartnerUser();

        ctr.getIsBrokerPartnerUser();
        ctr.hasValidQuotation();
        ctr.calculateQuote();
        ctr.storeQuotingData();
    }

}