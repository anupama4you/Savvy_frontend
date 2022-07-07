@isTest(SeeAllData=true)
private class TestLenderComparison {

	@isTest static void testComparisonEngine() {
		//Prepare data
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);

        //Search with blank parameters
        ctr.param.loanTerm = null;
        ctr.param.deposit = null;
        ctr.search();
		
        //Define parameters
        ctr.param.assetDetail = 'Car';
        ctr.param.employmentType = 'Full-Time';
        ctr.param.loanType = 'Consumer Loan';
        ctr.param.purchaseType = 'Dealer';
        ctr.param.creditHistory = 'Clean History';
        
        //Other parameters
        ctr.param.ageCar = '15';
        ctr.param.loanTerm = 60;
        ctr.param.residentialStatus = 'Property Owner';
        ctr.param.price = 15000;
        ctr.param.deposit = 1250;
        ctr.param.residual = 0;
        ctr.isLeadFlow = true;
        ctr.search();
        
        ctr.param.ageCar = '10';
		ctr.search();      
		ctr.openQuotingTool();
        
        ctr.param.ageCar = '0';
		ctr.search();  
		
		ctr.getIsLendersEnabledOnTheLeft();
		ctr.getIsLendersEnabledOnTheRight();

		LenderComparisonFilterExtension.calculateBaseRate(null, null, null);

		List<Lenders__c> lendersList = Lenders__c.getAll().values();
		for (Lenders__c l : lendersList) {
      if (l.Active__c) {
        LenderQuotingWrapperDTO lq = new LenderQuotingWrapperDTO(l);
        LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
      }
			/*
			ctr.param.loanTerm = 48;
			LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
			ctr.param.loanTerm = 36;
			LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
			ctr.param.loanTerm = 24;
			LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
			ctr.param.loanTerm = 12;
			if (l.Code__c == 'ACON' || l.Code__c == 'ACOM') {
				ctr.param.ageCar = '5';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.residentialStatus = 'Boarding';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.ageCar = '0';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.lenderSelected.Asset_Detail__c = 'Motorbike';
				ctr.param.residentialStatus = 'Property Owner';
				ctr.param.ageCar = '0';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.ageCar = '5';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.residentialStatus = 'Boarding';
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.lenderSelected.Credit_History__c = 'Default/s or Ex-Bankrupt with standard profile';
				ctr.param.ageCar = '0';
				ctr.param.loanTerm = 84;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.lenderSelected.Credit_History__c = 'Clean History';
				ctr.lenderSelected.Asset_Detail__c = 'Car';
				ctr.param.residentialStatus = 'Property Owner';
			} else if (l.Code__c == 'AOTH') {
				ctr.lenderSelected.Asset_Detail__c = 'Motorbike';
				ctr.param.ageCar = '0';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.param.ageCar = '3';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.param.ageCar = '6';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.lenderSelected.Asset_Detail__c = 'Truck';
				ctr.param.ageCar = '0';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 15000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 125000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 175000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.param.ageCar = '6';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 15000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 125000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 175000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.param.ageCar = '10';
				ctr.param.price = 5000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 15000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 25000;
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 75000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 125000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);
				ctr.param.price = 175000;	
				LenderComparisonFilterExtension.calculateBaseRate(lq, ctr.param, ctr.lenderSelected);

				ctr.param.price = 15000;
				ctr.param.ageCar = '0';
				ctr.lenderSelected.Asset_Detail__c = 'Car';
			}
			*/
		}

        ctr.param.tier = 'Tier 1';
        ctr.adjustBaseRate();  
        
        ctr.param.tier = 'Tier 2';
        ctr.adjustBaseRate();
        
        ctr.param.tier = 'Tier 3';
        ctr.adjustBaseRate();
        
		ctr.ruleSelectedId = ctr.lenderSelected.Id;
		ctr.restart();
		Test.stopTest();
	}

    //Yohan Villamizar                      2019-07-03
    @isTest
    public static void testLibertyDriveNotAAA(){
    	//Prepare data
		Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Vehicle_Year__c = '2000';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Purchase_Price__c = 2000;
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Current_Residence_Status_1__c = 'Mortgage';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Length_of_Term__c = 2;
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Bike';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Full Time';
        update Test_DataGeneratorHelper.tstOpportunity;
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Caravan';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Current_Residence_Status_1__c = 'Renting(Agent)';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Part Time';
        update Test_DataGeneratorHelper.tstOpportunity;
        LenderComparisonFilterExtension ctro = new LenderComparisonFilterExtension(sc);
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Truck';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Current_Residence_Status_1__c = 'Renting(Private)';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Casual';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Date_Started_1__c = '23/05/2018';
        update Test_DataGeneratorHelper.tstOpportunity;
        LenderComparisonFilterExtension ctrol = new LenderComparisonFilterExtension(sc);
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Boat';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Self Employed';
        update Test_DataGeneratorHelper.tstOpportunity;
        LenderComparisonFilterExtension ctroll = new LenderComparisonFilterExtension(sc);
        
        //Define parameters
        ctr.param.assetDetail = 'Car';
        ctr.param.employmentType = 'Full-Time';
        ctr.param.loanType = 'Consumer Loan';
        ctr.param.purchaseType = 'Dealer';
        ctr.param.creditHistory = 'Clean History';
        
        //Other parameters
        ctr.param.ageCar = '3';
        ctr.param.loanTerm = 36;
        ctr.param.residentialStatus = 'Renting Real Estate';
        ctr.param.price = 30000;
        ctr.param.deposit = 0.0;
        ctr.param.residual = 0;
        ctr.param.jobsLast3Years = 2;
        ctr.param.creditScore = '750+';
        ctr.param.ltv = '90-99';
        ctr.search(); 
        ctr.restart();
		Test.stopTest();
    }
   
	public static testMethod void testLenderQuotingWrapperDTO (){
		Test.startTest();
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
        dto.clientTier = 'd';
        dto.additionalInfo = 'f';
        lenderList.get(0).Credit_Guidelines_2__c = 'r';
        lenderList.get(0).Credit_Guidelines_3__c = 'r';
        dto.getCreditGuidelineList();

        dto.getExtraInfo();
        lenderList.get(0).Code__c = 'PEMV';
        dto.getExtraInfo();

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
        Test.stopTest();
    }   

    private static void prepareDataForTesting() {

    }

    public static testMethod void testFlowClosingObjecting (){
    	//Prepare data
		Test_DataGeneratorHelper.createApplication();
        Test_DataGeneratorHelper.reloadOpportunity();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);

    	ctr.adjustDOFValue();
    	ctr.resetDOFValue();
    	ctr.goClosingNoProceed();
    	ctr.goClosingNoProceed2();
    	ctr.goSalesTool();
    	ctr.goSendEmail();
    	ctr.saveFlowComments();
    	ctr.customerNotInformation();
		Test.stopTest();
    }

	public static testMethod void saveOpinion() {
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);
		ctr.restart();
		ctr.search();
        
		System.assertNotEquals(null, ctr.lendersList);
		// Fail test
		ctr.opinionText = '';
		ctr.param.tier = 'Tier 1';
		ctr.saveOpinion();
		// Success test
		ctr.opinionText = 'Test message';
		ctr.saveOpinion();
		Test.stopTest();
	}

	public static testMethod void calculateCommissions() {
		System.debug('Test calculateCommissions...');
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);
		
		ctr.param = new LenderComparisonFilterExtension.FilterParams();
		ctr.param.price = 20000.0;
		System.debug('Test searching...');
		ctr.search();
		System.debug('Test evaluating result...');
		System.assertNotEquals(null, ctr.lendersList);
		ctr.param.targetCommission = 0.0;
		ctr.calculateTotalCommissions();
		ctr.calculateCommissions();
		System.debug('Test calculateCommissions... end.');
        ctr.lenderCodeSelected = 'LATI';
        ctr.openQuotingTool();
		Test.stopTest();
	}

	public static testMethod void adjustClientRate() {
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);
		
		ctr.search();
		ctr.param.rateValue = 0.0;
		ctr.adjustClientRate();
		Test.stopTest();
	}

    public static testMethod void tstPreloadFilterParam(){
    	Test_DataGeneratorHelper.createApplicationLoan();
        Test_DataGeneratorHelper.createAssetPropertie();
        Test_DataGeneratorHelper.reloadOpportunity();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Credit_History__c = 'Excellent';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Clean_Credit_History__c = 'Excellent';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'JetSki';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Bank_Value__c = 40000;
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Self Employed';
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension cntrolle = new LenderComparisonFilterExtension(sc);
        cntrolle.param = new LenderComparisonFilterExtension.FilterParams();
        cntrolle.param.ltv = '130';
        cntrolle.param.getLtvVal();
        
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Application_Type__c = 'Business';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Tax_Returns__c = 'N';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Clean_Credit_History__c = 'Y';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Credit_Enquiries__c = 'Y';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Jet';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Bank_Value__c = 90000;
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Self Employed';
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension cntroller = new LenderComparisonFilterExtension(sc);
        cntroller.param = new LenderComparisonFilterExtension.FilterParams();
        cntroller.param.ltv = '131+';
        cntroller.param.getLtvVal();
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Truck';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Current_Residence_Status_1__c = 'Renting(Private)';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Casual';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Date_Started_1__c = '23/05/2019';
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctrol = new LenderComparisonFilterExtension(sc);
        ctrol.param = new LenderComparisonFilterExtension.FilterParams();
        ctrol.param.ltv = '120–129';
        ctrol.param.getLtvVal();
        
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Tax_Returns__c = 'Y';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Business';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Bank_Value__c = 110000;
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctrolle = new LenderComparisonFilterExtension(sc);
        ctrolle.param = new LenderComparisonFilterExtension.FilterParams();
        ctrolle.param.ltv = '110–119';
        ctrolle.param.getLtvVal();
        
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Bad Credit';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Application_Type__c = 'Bad Credit';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Clean_Credit_History__c = 'No';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Credit_History__c = 'No';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Tax_Returns__c = 'N';
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctroller = new LenderComparisonFilterExtension(sc);
        ctroller.param = new LenderComparisonFilterExtension.FilterParams();
		ctroller.param.ltv = '100–109';
        ctroller.param.getLtvVal();
        
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Application_Type__c = 'Business';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Clean_Credit_History__c = 'No';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Credit_History__c = 'No';
        Test_DataGeneratorHelper.tstOpportunity.Lead__r.Has_Tax_Returns__c = 'Y';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Vehicle_Year__c = '2017';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Length_of_Term__c = 2;
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Type_of_Asset__c = 'Car';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Application_Type__c = 'Personal';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Mode_of_Employment_1__c = 'Casual';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Date_Started_1__c = '23/05/2019';
        Test_DataGeneratorHelper.tstOpportunity.Application__r.Purchase_Price__c = 20000;
        update Test_DataGeneratorHelper.tstOpportunity;
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension controller = new LenderComparisonFilterExtension(sc);
        controller.param = new LenderComparisonFilterExtension.FilterParams();
        controller.param.purchaseType = 'Private';
        controller.param.ltv = '<90';
        controller.param.getLtvVal();
        controller.param.getPrivateSales();
        controller.search();
        
        List<Lenders__c> lendersList = Lenders__c.getAll().values();
        List<LenderQuotingWrapperDTO> lenderList = new List<LenderQuotingWrapperDTO>();
		for (Lenders__c l : lendersList) {
			LenderQuotingWrapperDTO lq = new LenderQuotingWrapperDTO(l);
            lenderList.add(lq);
		}
        controller.lendersList = lenderList;
        
        for (LenderQuotingWrapperDTO x : lenderList) {
            controller.lenderCodeSelected = x.info.Code__c;
            controller.openQuotingTool();
        }
    }

    public static testMethod void tstPreloadFilterParam2(){
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.createAssetPropertie();
        Test_DataGeneratorHelper.reloadOpportunity();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension con = new LenderComparisonFilterExtension(sc);
    }
    
    public static testMethod void tstValidForSearch(){
        Test_DataGeneratorHelper.createOpportunity();
        Test_DataGeneratorHelper.reloadOpportunity();
		Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);
            PageReference pageRef = Page.LenderComparisonFilter;
            pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('P','LEADFLOW');
            LenderComparisonFilterExtension con = new LenderComparisonFilterExtension(sc);
        	con.search();
        Test.stopTest();
    }
    
    public static testMethod void tstValidAFSCalculator(){
        //Prepare data
		Test_DataGeneratorHelper.createApplication();
		Test.startTest();
		ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstOpportunity);

		PageReference pageRef = Page.LenderComparisonFilter;
		pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstOpportunity.Id);
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('P','LEADFLOW');
        LenderComparisonFilterExtension ctr = new LenderComparisonFilterExtension(sc);

        //Search with blank parameters
        ctr.param.loanTerm = null;
        ctr.param.deposit = null;
        ctr.search();
		
        //Define parameters
        ctr.param.assetDetail = 'Car';
        ctr.param.employmentType = 'Full-Time';
        ctr.param.loanType = 'Consumer Loan';
        ctr.param.purchaseType = 'Dealer';
        ctr.param.creditHistory = 'Clean History';
        
        //Other parameters
        ctr.param.ageCar = '25';
        ctr.param.loanTerm = 60;
        ctr.param.residentialStatus = 'Property Owner';
        ctr.param.price = 15000;
        ctr.param.deposit = 1250;
        ctr.param.residual = 0;
        ctr.isLeadFlow = true;
        ctr.param.ltv = '145';
        ctr.search();
        
        ctr.param.ageCar = '11';
        ctr.param.ltv = '125';
		ctr.search();  
        
        ctr.param.ageCar = '36';
        ctr.param.ltv = '125';
		ctr.search();  
        
        ctr.param.ageCar = '5';
		ctr.search();  
        
        //Define parameters
        ctr.param.assetDetail = 'Leisure';
        ctr.param.employmentType = 'Full-Time';
        ctr.param.loanType = 'Consumer Loan';
        ctr.param.purchaseType = 'Dealer';
        ctr.param.creditHistory = 'Clean History';
        
        //Other parameters
        ctr.param.ageCar = '25';
        ctr.param.loanTerm = 60;
        ctr.param.residentialStatus = 'Property Owner';
        ctr.param.price = 15000;
        ctr.param.deposit = 1250;
        ctr.param.residual = 0;
        ctr.isLeadFlow = true;
        ctr.param.ltv = '145';
        ctr.search();
        
        ctr.param.ageCar = '11';
        ctr.param.ltv = '125';
		ctr.search();  
        
        ctr.param.ageCar = '36';
        ctr.param.ltv = '125';
		ctr.search();  
        
        ctr.param.ageCar = '5';
		ctr.search();  
		ctr.openQuotingTool();
    }
}