@isTest(SeeAllData = true)
private class TestQuoteClientPresentationExtension {
    
    @isTest static void testNoParam() {
        test.startTest();

        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        pRef = Page.QuoteClientPresentation;
        pRef.getParameters().put('P', 'XXXXXXX');
        Test.setCurrentPageReference(pRef);
        //Controller
        ctrl = new QuoteClientPresentationExtension();
        ctrl.getIsPageLoaded();
        ctrl.quote = null;
        ctrl.recordTypes = null;
        ctrl.quote = null;
    }
    
    @isTest static void testMethods() {
        test.startTest();
        //Quoting
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        update quoting;
        
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();
        
        ctrl.getFullyResult();
        ctrl.getStandardResult();
        ctrl.getBasicResult();
        ctrl.getHasFullyResult();
        ctrl.getHasStandardResult();
        ctrl.getHasBasicResult();
        ctrl.getHasMvInsProduct();
        ctrl.getHasGapInsProduct();
        ctrl.getHasTaiInsProduct();
        ctrl.getHasLtiInsProduct();
        ctrl.getHasWarrantyInsProduct();
        ctrl.getHasNwcInsProduct();
        
        ctrl.getIsPageLoaded();
        ctrl.confirmFullyInsProductChoice();
        ctrl.confirmStandardInsProductChoice();
        ctrl.confirmBasicInsProductChoice();
        ctrl.confirmBasicInsProductChoice();
        ctrl.confirmMVInsProductChoice();
        ctrl.confirmGAPInsProductChoice();
        ctrl.confirmTAIInsProductChoice();
        ctrl.confirmLTIInsProductChoice();
        ctrl.confirmWARRInsProductChoice();
        ctrl.confirmCCIInsProductChoice();
        ctrl.cancelFullyInsProductChoice();
        ctrl.cancelStandardInsProductChoice();
        ctrl.cancelBasicInsProductChoice();
        ctrl.cancelSingleInsProductChoice();
        ctrl.cancelMVInsProductChoice();
        ctrl.cancelGAPInsProductChoice();
        ctrl.cancelTAIInsProductChoice();
        ctrl.cancelLTIInsProductChoice();
        ctrl.cancelWARRInsProductChoice();
        ctrl.cancelNWCInsProductChoice();
        ctrl.cancelCCIInsProductChoice();
        ctrl.getHasFullyProtectedSelected();
        ctrl.getHasStandardSelected();
        ctrl.getHasBasicSelected();
        ctrl.getHasCustomSelected();
        ctrl.getHasMVSelected();
        ctrl.getHasGAPSelected();
        ctrl.getHasTAISelected();
        ctrl.getHasLTISelected();
        ctrl.getHasWARRSelected();
        ctrl.getHasNWCSelected();
        ctrl.getHasCCISelected();
        ctrl.getCustomResultWeeklyPayment();
        
        ctrl.getFullyWeeklyPayment();
        ctrl.getStandardWeeklyPayment();
        ctrl.getBasicWeeklyPayment();
        ctrl.getIsWarrantyDiamond();
        ctrl.getIsWarrantyPlatinum();
        ctrl.getIsGAPClassic1();
        ctrl.getIsGAPClassic2();
        ctrl.getIsGAPClassic3();
        ctrl.getIsGAPClassic4();
        ctrl.getIsLTIPlatinum1();
        ctrl.getIsLTIPlatinum2();
        ctrl.getIsLTIPlatinum3();
        ctrl.getIsLTIGold2();
        ctrl.getIsLTISilver1();
        ctrl.getIsWARRDiamond36();
        ctrl.getIsWARRDiamond60();
        ctrl.getIsWARRPlatinum36();
        
        ctrl.getIsWARRPlatinum60();
        ctrl.getIsTaiRequired();
        ctrl.getIsTaiCover1();
        ctrl.getIsTaiCover2();
        ctrl.getIsTaiCover3();
        ctrl.getIsPublicMode();
        ctrl.getIsNWCRequired();
        ctrl.getIsCCIRequired();
        
        //Lelo          2018-02-16
        ctrl.getDisplayPackageOptions();
        ctrl.getDisplayDeclaration();
        ctrl.getDisplayFullComprehensive();
        ctrl.getDisplayHealthInfo();
        ctrl.getDisplayProductsConfirmation();
        ctrl.confirmUnprotectedProductChoice();
        ctrl.cancelUnprotectedProductChoice();
        ctrl.getHasUnprotectedCSelected();
        
        ctrl.goProductOptions();
        ctrl.getDisplayGAPRTIDeclaration();
        ctrl.getDisplayLTIDeclaration();
        ctrl.getDisplayWarrantyDeclaration();
        
    }

    @isTest static void testMethods2() {
        test.startTest();
        //Quoting
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        update quoting;
        
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();
        
        ctrl.declineGapPurchase();
        ctrl.declineLtiPurchase();
        ctrl.declineWarrantyPurchase();
        ctrl.declinePurchase();
        ctrl.acceptFullComprehensive();
        //ctrl.declineFullComprehensive();
        
        ctrl.getMnWeeklyAmount();
        
        ctrl.confirmAdditionalInformation();
        
        ctrl.getLTIAccepted();
        ctrl.getMVAccepted();
        ctrl.getQuestion1YesSelected();
        ctrl.getQuestion1NoSelected();
        ctrl.selectQuestion1Yes();
        ctrl.selectQuestion1No();
        ctrl.getQuestion2YesSelected();
        ctrl.getQuestion2NoSelected();
        ctrl.selectQuestion2Yes();
        ctrl.selectQuestion2No();
        ctrl.selectMVOffenceYes();
        ctrl.selectMVOffenceNo();
        ctrl.selectMVLicenceYes();
        ctrl.selectMVLicenceNo();
        ctrl.selectMVAccidentYes();
        ctrl.selectMVAccidentNo();
        ctrl.selectMVOther1Yes();
        ctrl.selectMVOther1No();
        ctrl.selectMVOther2Yes();
        ctrl.selectMVOther2No();
        
        // Lelo                 2019-12-04
        ctrl.quoting.Insurance_Warranty_Type__c = null;
        ctrl.quoting.Insurance_NWC_Retail_Price__c = 150;
        ctrl.quoting.Insurance_NWC_TypeP__c = 'Safeguard';
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWarrantyIntegrity();
        ctrl.quoting.Insurance_NWC_TypeP__c = 'Integrity';
        ctrl.getIsWarrantySafeguard();
        ctrl.quoting.Name = LibertyDriveExtension.LENDER_QUOTING;
        ctrl.confirmCCIInsProductChoice();
        ctrl.cancelCCIInsProductChoice();
        
        ctrl.quoting.Insurance_Customer_Choice__c = QuotingCalculation.PRO_CUSTOM;
        ctrl.quoting.Insurance_MV_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_MV);
        ctrl.quoting.Insurance_GAP_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_GAP);
        ctrl.quoting.Insurance_TAI_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_TAI);
        ctrl.quoting.Insurance_LTI_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_LTI);
        ctrl.quoting.Insurance_Warranty_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_WARR);
        ctrl.quoting.Insurance_NWC_Acceptance__c = 'A';
        ctrl.getHasProductSelected(InsuranceQuoteUtils.INS_PROD_NWC);
        ctrl.quoting.Insurance_Customer_Choice__c = null;
        ctrl.quoting.Insurance_MV_Acceptance__c = null;
        ctrl.quoting.Insurance_GAP_Acceptance__c = null;
        ctrl.quoting.Insurance_TAI_Acceptance__c = null;
        ctrl.quoting.Insurance_LTI_Acceptance__c = null;
        ctrl.quoting.Insurance_Warranty_Acceptance__c = null;
        ctrl.quoting.Insurance_NWC_Acceptance__c = null;
        ctrl.getIsLTICover1();
        ctrl.getIsLTICover2();
        ctrl.getIsLTICover3();
    }
    
    @isTest static void testMethods3() {
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Insurance_Gap_Type__c = 'Cover 2';
        quoting.Insurance_Gap_Retail_Price__c = 1;
        quoting.Insurance_AIC_Acceptance__c = 'A';
        update quoting;
        quote.LPI__c = 'CRDU';
        update quote;
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();
        ctrl.getLPIAccepted();
        ctrl.getIsGAPClassic2();
        
        quoting.Insurance_Gap_Type__c = 'Cover 3';
        quoting.Insurance_Gap_Retail_Price__c = 1;
        ctrl.getIsGAPClassic3();
        
        quoting.Insurance_Gap_Type__c = 'Cover 4';
        quoting.Insurance_Gap_Retail_Price__c = 1;
        ctrl.getIsGAPClassic4();
        
        quoting.Insurance_LTI_Type__c = 'Platinum Cover 1';
        quoting.Insurance_LTI_Retail_Price__c = 1;
        ctrl.getIsLTIPlatinum1();
        
        quoting.Insurance_LTI_Type__c = 'Platinum Cover 2';
        quoting.Insurance_LTI_Retail_Price__c = 1;
        ctrl.getIsLTIPlatinum2();
        
        quoting.Insurance_LTI_Type__c = 'Platinum Cover 3';
        quoting.Insurance_LTI_Retail_Price__c = 1;
        ctrl.getIsLTIPlatinum3();
        
        quoting.Insurance_LTI_Type__c = 'Gold Cover 2';
        quoting.Insurance_LTI_Retail_Price__c = 1;
        ctrl.getIsLTIGold2();
        
        quoting.Insurance_LTI_Type__c = 'Silver Cover 1';
        quoting.Insurance_LTI_Retail_Price__c = 1;
        ctrl.getIsLTISilver1();
        
        quoting.Insurance_Warranty_Type__c = 'Diamond - 36';
        quoting.Insurance_Warranty_Retail_Price__c = 1;        
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWARRDiamond36();
        
        quoting.Insurance_Warranty_Type__c = 'Diamond - 60';
        quoting.Insurance_Warranty_Retail_Price__c = 1;
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWARRDiamond60();
        
        quoting.Insurance_Warranty_Type__c = 'Platinum - 36';
        quoting.Insurance_Warranty_Retail_Price__c = 1;        
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWARRPlatinum36();
        
        quoting.Insurance_Warranty_Type__c = 'Platinum - 60';
        quoting.Insurance_Warranty_Retail_Price__c = 1;
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWARRPlatinum60();
        
        quoting.Insurance_TAI_Type__c = 'Cover 1';
        quoting.Insurance_TAI_Retail_Price__c = 1;
        ctrl.getIsTaiCover1();
        
        quoting.Insurance_TAI_Type__c = 'Cover 2';
        quoting.Insurance_TAI_Retail_Price__c = 1;
        ctrl.getIsTaiCover2();
        
        quoting.Insurance_TAI_Type__c = 'Cover 3';
        quoting.Insurance_TAI_Retail_Price__c = 1;
        ctrl.getIsTaiCover3();
        
        quoting.Insurance_LTI_Type__c = 'Cover 3';
		ctrl.getIsLTICover3();
        
        quoting.Insurance_Warranty_Type__c = 'Diamond';
        quoting.Insurance_Warranty_Retail_Price__c = 1;
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWarrantyDiamond();
        
        quoting.Insurance_Warranty_Type__c = 'Platinum';
        quoting.Insurance_Warranty_Retail_Price__c = 1;
        ctrl.quoting.recalculateFormulas();
        ctrl.getIsWarrantyPlatinum();
    }
      
    @isTest static void testExtraMethods() {
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        update quoting;
        
        initQuotingResults(quoting.Id);
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        ctrl.getDayOptions();
        ctrl.getYearOptions();

        ctrl.remMVOffence();
        ctrl.remMVLicence();
        ctrl.remMVAccident();
        
        ctrl.getFailedQuotation();
        ctrl.getHasFullCompConfirmVariation();

        ctrl.reProcessQuote();

        ctrl.declineFullComprehensive();

        ctrl.acceptMVVehicleUsage();
        ctrl.getMVVehicleUsageBtnNo();
        ctrl.declineMVVehicleUsage();
        ctrl.getMVVehicleUsageBtnYes();
        
        ctrl.acceptMVVehicleModified();
        ctrl.getMVVehicleModifiedBtnNo();
        ctrl.declineMVVehicleModified();
        ctrl.getMVVehicleModifiedBtnYes();

        ctrl.declineMVVehicleUsage();
        ctrl.declineMVVehicleModified();

        ctrl.acceptMVVehicleModified();
        ctrl.acceptMVVehicleUsage();

        ctrl.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_SELCOMPRE;
        ctrl.declineFullComprehensive();
        ctrl.quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
        ctrl.declineFullComprehensive();
        
        ctrl.getMVDecliningNotes();

        ctrl.getIsMVSuncorp();
        ctrl.getExcludeLTILPI();
        // Preparing LPI
        ctrl.quoting.Insurance_AIC_Type__c = 'X';
        ctrl.quoting.Insurance_AIC_Retail_Price__c = null;
        ctrl.getHasLpiInsProduct();
        ctrl.quoting.Insurance_AIC_Retail_Price__c = 1500.0;
        System.assert(ctrl.getHasLpiInsProduct(),'HasLpiInsProduct fail!');

        ctrl.reProcessQuoteRestService();

        ctrl.quoting.Name = LibertyDriveExtension.LENDER_QUOTING;
        ctrl.getCustomResultWeeklyPayment();
        
        quote.Is_Vehicle_Modified__c = 'N';
		    ctrl.getMVVehicleUsageBtnNo();
		
		    quote.Is_Vehicle_MV_Commercial__c = 'N';
		    ctrl.getMVVehicleModifiedBtnNo();
        
        quote.Is_Vehicle_MV_Commercial__c = 'Y';
        ctrl.getMVVehicleUsageBtnYes();
    }
    /*
    @isTest static void testBasic() {
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        update quoting;
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        // Preparing LPI
        ctrl.quoting.Insurance_AIC_Type__c = 'X';
        ctrl.quoting.Insurance_AIC_Retail_Price__c = null;
        ctrl.getHasLpiInsProduct();
        ctrl.quoting.Insurance_AIC_Type__c = 'X';
        ctrl.quoting.Insurance_AIC_Retail_Price__c = 1500;
        System.assert(ctrl.getHasLpiInsProduct(),'HasLpiInsProduct fail!');

    }
    */
   
    @isTest static void testConfirmAdditionalInfo() {
         test.startTest();
        //Quoting
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        
        update quoting;
        
        quote.Customer_Choice_Status__c = InsuranceQuoteUtils.CUSCHOICE_FILLINFO;
        quote.MV_Amount_Covered__c = 10000;
        quote.Motor_Vehicle__c = 'MVCMP';
        quote.MV_Basic_Excess_Options__c = '[400,500,600,700]';
        quote.MV_Amount_Covered_Min__c = 5000;
        quote.MV_Amount_Covered_Max__c = 15000;
        update quote;

        //View
        PageReference pRef = Page.QuoteClientPresentation;
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        //Validation fail
        //LTI
        ctrl.mainDriver.Health_Info_Question_1__c = 'Y';
        
        ctrl.confirmAdditionalInformation();

        //MV
        ctrl.offenceAnswer = 'Y';
        ctrl.licenceAnswer = 'Y';
        ctrl.accidentAnswer = 'Y';
        ctrl.otherInfoAnswer1 = 'Y';
        ctrl.otherInfoAnswer2 = 'Y';
        ctrl.confirmAdditionalInformation();

        ctrl.addMVOffence();
        ctrl.addMVLicence();
        ctrl.addMVAccident();
        ctrl.confirmAdditionalInformation();

        Test_DataGeneratorHelper.createQuoteAnnotations();
        Test_DataGeneratorHelper.createQuoteAdditionalDriver();
        ctrl = new QuoteClientPresentationExtension();
        ctrl.getDriverOptions();
        ctrl.remAnnotation = 1;
        ctrl.remMVOffence();

        //Motor Vehicle - Standard excess
        ctrl.getExcessOptions();
        ctrl.getMinAmountCovered();
        ctrl.getMaxAmountCovered();
        ctrl.applyMV();
        ctrl.mvAmountCovered = null;
        ctrl.applyMV();
        ctrl.mvAmountCovered = 25000;
        ctrl.applyMV();
        
        quote.Is_Vehicle_MV_Commercial__c = 'N';
        update quote;
        ctrl = new QuoteClientPresentationExtension();
        ctrl.getMVVehicleUsageBtnNo();
        
        quote.Is_Vehicle_Modified__c = 'Y';
        update quote;
        ctrl = new QuoteClientPresentationExtension();
        ctrl.getMVVehicleModifiedBtnYes();
        
        quoting.Insurance_Gap_Type__c = 'Cover 1';
        quoting.Insurance_Gap_Retail_Price__c = 1;
        update quoting;
        
        ctrl = new QuoteClientPresentationExtension();
        ctrl.getIsGAPClassic1();
    }

    @isTest static void testConfirmFully() {

        //Quoting
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;

        //Prepare results
        List < Application_Quoting_Result__c > rslts = new List < Application_Quoting_Result__c > ();
        List < String > cals = new List < String > ();
        cals.add(QuotingCalculation.CALC_QUOTING);
        cals.add(QuotingCalculation.CALC_SIMPLE);

        cals.add(QuotingCalculation.PRO_FULLY);
        cals.add(QuotingCalculation.PRO_STANDARD);
        cals.add(QuotingCalculation.PRO_BASIC);

        cals.add(InsuranceQuoteUtils.INS_PROD_MV);
        cals.add(InsuranceQuoteUtils.INS_PROD_GAP);
        cals.add(InsuranceQuoteUtils.INS_PROD_TAI);
        cals.add(InsuranceQuoteUtils.INS_PROD_LTI);
        cals.add(InsuranceQuoteUtils.INS_PROD_WARR);
        cals.add(InsuranceQuoteUtils.INS_PROD_NWC);

        for (String c: cals) {
            rslts.add(getFakeResult(c));
        }

        QuotingCalculation.saveQuotingResults(quoting.Id, rslts);

        quoting.Insurance_Customer_Choice__c = QuotingCalculation.PRO_CUSTOM;
        quoting.Insurance_GAP_Acceptance__c = 'A';
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_Warranty_Acceptance__c = 'A';
        quoting.Insurance_TAI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        quoting.Insurance_NWC_Acceptance__c = 'A';
        quoting.Insurance_LPI_Acceptance__c = 'A';
        
        quoting.Insurance_MV_Type__c = 'XXX';
        quoting.Insurance_MV_Retail_Price__c = 200;

        quoting.Insurance_GAP_Type__c = 'XXX';
        quoting.Insurance_GAP_Retail_Price__c = 200;

        quoting.Insurance_TAI_Type__c = 'XXX';
        quoting.Insurance_TAI_Retail_Price__c = 200;

        quoting.Insurance_LTI_Type__c = 'XXX';
        quoting.Insurance_LTI_Retail_Price__c = 200;

        quoting.Insurance_Warranty_Type__c = 'XXX';
        quoting.Insurance_Warranty_Retail_Price__c = 200;

        quoting.Insurance_NWC_Retail_Price__c = 200;

        update quoting;

        //View
        PageReference pRef = Page.QuoteClientPresentation;
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        ctrl.getHasMvInsProduct();
        ctrl.getHasGapInsProduct();
        ctrl.getHasTaiInsProduct();
        ctrl.getHasLtiInsProduct();
        ctrl.getHasWarrantyInsProduct();
        ctrl.getHasNWCInsProduct();

        ctrl.confirmSingleInsProductChoice();

        ctrl.confirmNWCInsProductChoice();
        ctrl.confirmSingleInsProductChoice();

        ctrl.getHasFullyProtectedSelected();
        ctrl.getHasCustomSelected();

        ctrl.getCustomResultWeeklyPayment();

    }

    private static Application_Quoting_Result__c getFakeResult(String typeRstl) {
        Application_Quoting_Result__c r = new Application_Quoting_Result__c();
        r.Result_Type__c = typeRstl;
        r.Monthly_Payment__c = 500;
        return r;
    }

    @isTest static void testLibertyProducts() {
        Test_DataGeneratorHelper.createQuoting();
        Test_DataGeneratorHelper.createQuote();
        Test_DataGeneratorHelper.createQuoteMainDriver();
        Application_Quoting__c quoting = Test_DataGeneratorHelper.quoting;
        Custom_Opportunity__c o = Test_DataGeneratorHelper.tstOpportunity;
        Application_InsuranceQuote__c quote = Test_DataGeneratorHelper.quote;
        quoting.App_Insurance_Quote__c = quote.Id;
        quoting.Name = 'Liberty Drive';
        quoting.Insurance_VEI_Type__c = 'Option 1';
        quoting.Insurance_VEI_Retail_Price__c = 1500;
        quoting.Insurance_VEI_Income__c = 350;
        quoting.Insurance_VEI_Acceptance__c = 'A';
        quoting.Insurance_Customer_Choice__c = QuotingCalculation.PRO_UNPROTECTED;
        quoting.Insurance_AIC_Acceptance__c = 'U';
        quoting.Insurance_LTI_Acceptance__c = 'A';
        quoting.Insurance_MV_Acceptance__c = 'A';
        update quoting;
        //View
        PageReference pRef = Page.QuoteClientPresentation;
        //pRef.getParameters().put('P', o.Id);
        pRef.getParameters().put('P', CryptoUtils.encrypt(o.Application__c));
        Test.setCurrentPageReference(pRef);
        //Controller
        QuoteClientPresentationExtension ctrl = new QuoteClientPresentationExtension();

        ctrl.getDisplayGAPRTIDeclaration();
        ctrl.getDisplayLTIDeclaration();
        ctrl.getDisplayWarrantyDeclaration();
        ctrl.getDisplayWarrantyDeclaration();
        List<String> ops = new List<String>();
        ops.add('Option 2');
        ops.add('Option 3');
        ops.add('Option 4');

        for (String opt : ops) {
            quoting.Insurance_VEI_Type__c = opt;
            update quoting;
            ctrl = new QuoteClientPresentationExtension();            
        }

        ctrl.quoting.Insurance_Customer_Choice__c = QuotingCalculation.PRO_CUSTOM;
        ctrl.quoting.Insurance_GAP_Acceptance__c = 'A';
        ctrl.quoting.Insurance_LTI_Acceptance__c = 'A';
        ctrl.quoting.Insurance_Warranty_Acceptance__c = 'A';
        ctrl.quoting.Insurance_AIC_Acceptance__c = 'U';
        ctrl.getDisplayGAPRTIDeclaration();
        ctrl.getDisplayLTIDeclaration();
        ctrl.getDisplayWarrantyDeclaration();


    }

    private static void initQuotingResults(Id quotingId) {
        List<Application_Quoting_Result__c> rls = new List<Application_Quoting_Result__c>();
        List<String> quoteTypes = new List<String>{
            QuotingCalculation.CALC_SIMPLE, QuotingCalculation.PRO_FULLY, QuotingCalculation.PRO_STANDARD,
            QuotingCalculation.PRO_BASIC, InsuranceQuoteUtils.INS_PROD_MV, InsuranceQuoteUtils.INS_PROD_GAP,
            InsuranceQuoteUtils.INS_PROD_TAI, InsuranceQuoteUtils.INS_PROD_LTI, InsuranceQuoteUtils.INS_PROD_WARR,
            InsuranceQuoteUtils.INS_PROD_NWC, InsuranceQuoteUtils.INS_PROD_CCI, InsuranceQuoteUtils.INS_PROD_LPI_2
        };
        for (String k : quoteTypes) {
            Application_Quoting_Result__c qr = new Application_Quoting_Result__c();
            qr.Result_Type__c = k;
            qr.NAF__c = 12000.0;
            qr.Rental__c = 99.0;
            qr.Estimated_Commission__c = 200.0;
            qr.DOF__c = 550.0;
            qr.Insurance_Income__c = 750.0;
            qr.Monthly_Payment__c = 100.0;
            qr.Application_Quoting__c = quotingId;
            rls.add(qr);
        }
        insert rls;
    }
}