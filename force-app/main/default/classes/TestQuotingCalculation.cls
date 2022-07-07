@isTest(SeeAllData=true)
private class TestQuotingCalculation {
	
	@isTest static void testCalculate() {
		//Preparing data
		Test_DataGeneratorHelper.createQuoting();
		Id quotingId = Test_DataGeneratorHelper.quoting.Id;

		//ANZ Calculation
		List<Application_Quoting_Result__c> rLst = new List<Application_Quoting_Result__c>();
		QuotingCalculation.CalcParam param = getGenericParam('ANZ Consumer');

		Application_Quoting_Result__c qr = QuotingCalculation.calculate(param);
		if (qr != null) {
			qr.Result_Type__c = QuotingCalculation.CALC_QUOTING;
			rLst.add(qr);
		}
		param.term = 84;
		param.paymentType = 'Advance';
		param.lender = 'ANZ Commercial';
		qr = QuotingCalculation.calculate(param);
		if (qr != null) {
			qr.Result_Type__c = QuotingCalculation.CALC_QUOTING;
			rLst.add(qr);
		}
		QuotingCalculation.saveQuotingResults(quotingId, rLst);
		QuotingCalculation.getMapQuotingResultsByQuoId(quotingId);

		//ANZ Others
		param = getGenericParam('ANZ Others');
		param.brokeragePer = 4;
		qr = QuotingCalculation.calculate(param);
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);

		//Pepper Calculation
		param = getGenericParam('Pepper MV');
    param.productLoanType = 'Consumer Loan';
		param.commRate = 4;
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Pepper Leisure';
		param.term = 12;
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Pepper 5Oh';
		param.term = 24;
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Pepper Summer';
		param.term = 36;
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);
		param.term = 48;
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);
        param = getGenericParam('Pepper Commercial');
        param.productLoanType = QuotingToolHelper.getLoanProductOptionsCommercial().get(0).getValue();
	    param.customerProfile = 'OTHER - Primary';
		qr = QuotingCalculation.calculate(param);
    
		//Liberty Others
		param = getGenericParam('Liberty Drive');
		param.commRate = 1.63;
		param.term = 12;
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Liberty Options';
		param.paymentType = 'Advance';
		param.residualValue = 100;
		param.term = 24;
		qr = QuotingCalculation.calculate(param);
		param.term = 36;
		qr = QuotingCalculation.calculate(param);
		param.term = 48;
		qr = QuotingCalculation.calculate(param);
		param.term = 84;
		qr = QuotingCalculation.calculate(param);
		param.term = 104;
		qr = QuotingCalculation.calculate(param);

		param.lender = 'Liberty Commercial';
		param.term = 60;
		param.clientTier = 'AA';
		qr = QuotingCalculation.calculate(param);
		param.clientTier = 'A';
		qr = QuotingCalculation.calculate(param);
		param.term = 24;
		qr = QuotingCalculation.calculate(param);
		param.term = 36;
		qr = QuotingCalculation.calculate(param);
		//Macquarie Calculation
		param = getGenericParam('Macquarie Consumer');
		param.brokeragePer = 4;
        param.amountBasePmt = param.totalAmount * 0.8;
        param.amountBaseComm = param.getNaf();
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Macquarie Commercial';
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);

		//Finance One Calculation
		param = getGenericParam('Finance One');
		param.productLoanType = 'Consumer Loan';
		param.loanTypeDetail = 'Platinum';
        param.nafCommission = param.getNaf();
		qr = QuotingCalculation.calculate(param);
		param.loanTypeDetail = 'Gold';
		qr = QuotingCalculation.calculate(param);
		param.loanTypeDetail = 'Silver';
		qr = QuotingCalculation.calculate(param);
		param.loanTypeDetail = 'Bronze';
		qr = QuotingCalculation.calculate(param);
		param.loanTypeDetail = 'Economy';
		qr = QuotingCalculation.calculate(param);
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);
		
		param.productLoanType = 'Consumer Loan';
		param.loanTypeDetail = 'Gold';
		QuotingCalculation.getFinanceOneApplicationFee(param);
		param.loanTypeDetail = 'Economy';
		QuotingCalculation.getFinanceOneApplicationFee(param);

		//Money 3 Calculation
		param = getGenericParam('Money3');
		qr = QuotingCalculation.calculate(param);
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);

		//Metro Calculation
		param = getGenericParam('Metro');
		param.brokeragePer = 4;
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Green Light';
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);

		//Metro Calculation
		param = getGenericParam('Metro');
		param.brokeragePer = 4;
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Green Light';
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);		
		param.lender = 'General';
		qr = QuotingCalculation.calculate(param);		

		//AFS and Latitude Calculation
		param = getGenericParam('AFS Consumer');
		param.commRate = 4;
		qr = QuotingCalculation.calculate(param);
		param.lender = 'AFS Commercial';
		param.paymentType = 'Advance';
		qr = QuotingCalculation.calculate(param);		
		param.lender = 'Latitude';
		qr = QuotingCalculation.calculate(param);

		//Yamaha Marine and Latitude Calculation
		param = getGenericParam('Yamaha Marine');
		qr = QuotingCalculation.calculate(param);
		param.lender = 'Yamaha Motorcycles';
		param.paymentType = 'Advance';
		param.term = 24;
		qr = QuotingCalculation.calculate(param);		
		param.term = 36;
		qr = QuotingCalculation.calculate(param);		
		param.term = 48;
		qr = QuotingCalculation.calculate(param);		
		param.term = 72;
		qr = QuotingCalculation.calculate(param);		
		param.lender = 'Yamaha Water';
		param.term = 84;
		qr = QuotingCalculation.calculate(param);
		param = getGenericParam('Yamaha Marine');
		param.loanTypeDetail = 'Commercial';
		param.term = 24;
		qr = QuotingCalculation.calculate(param);		
		param.term = 36;
		qr = QuotingCalculation.calculate(param);		
		param.term = 48;
		qr = QuotingCalculation.calculate(param);		
		param.term = 60;
		qr = QuotingCalculation.calculate(param);		
		param.term = 72;
		qr = QuotingCalculation.calculate(param);

		//Firstmac
		param = getGenericParam('Firstmac');
    param.baseRate = 8;
    param.maxRate = 10;
    param.clientRate = param.maxRate;
		qr = QuotingCalculation.calculate(param);

		//Wisr
		param = getGenericParam('Wisr');
		param.totalAmount = 40000;
        param.amountBaseComm = param.getNaf();
		qr = QuotingCalculation.calculate(param);

		//Money Place
		param = getGenericParam(MoneyPlaceExtension.LENDER_QUOTING);
		param.totalAmount = 25000;
        param.amountBaseComm = param.getNaf();
		qr = QuotingCalculation.calculate(param);

		// Generic Client Rate Calculation
		param = getGenericParam('My Lender');
		param.term = 60;
		param.baseRate = 8.5;
		param.amountBasePmt = 25000;
		param.paymentType = 'Arrears';
		param.residualValue = 0.0;
		System.assert(QuotingCalculation.getClientRateCalculation(param)>0);
		param.paymentType = 'Advance';
		System.assert(QuotingCalculation.getClientRateCalculation(param)>0);

		//Other methods
		QuotingCalculation.getProtectedPercentaje(40000.0);

    // Basic Rates
    String lender = 'Affordable';
    Map<String, BasicLenderRates__c> brates = QuotingCalculation.getBasicRates(lender);
    System.assertEquals(false, brates.isEmpty(), lender + 'rates not founbd');
    Set<String> profileList = QuotingCalculation.getBasicRateProfiles(lender);
    System.assertEquals(false, profileList.isEmpty(), lender + ' rates not founbd');

    lender = 'xxxxxx';
    brates = QuotingCalculation.getBasicRates(lender);
    System.assert(brates.isEmpty());
    profileList = QuotingCalculation.getBasicRateProfiles(lender);
    System.assert(profileList.isEmpty());
    param = getGenericParam(CarStartFinanceCalculatorExtension.LENDER_QUOTING);
    QuotingCalculation.calculate(param);
    param = getGenericParam(AzoraCalcExtension.LENDER_QUOTING);
    param.loanTypeDetail = '832 - 1200';
    QuotingCalculation.getAzora(param);
    QuotingCalculation.calculate(param);
	param = getGenericParam(WestpacExtension.LENDER_QUOTING);
    QuotingCalculation.calculate(param);
	  param = new QuotingCalculation.CalcParam('RateSetter');
    param.customerProfile = 'Property Owner';
    param.clientTier = 'Tier 1';
    param.vehicleYear = '2021';
    param.greenCar = 'Y';
	param.condition = 'new';
    QuotingCalculation.getRateSetterBaseRate(param, false);
	param = getGenericParam('Plenti Commercial');
	QuotingCalculation.calculate(param);
	param.customerProfile = 'Property Owner';
    param.clientTier = 'Tier 1';
    param.vehicleYear = '2021';
	param.brokeragePer = 5;
	QuotingCalculation.getBaseRate(param);
	param = getGenericParam('APF');
	QuotingCalculation.calculate(param);
    // New cal calculators
    List<String> lenderList = new List<String>{
      'BOQCommercial',
      'Shift Asset', 
      'Get Capital (ODR and Term Loan)',
      'Grow Asset',
      'Grow Business Loan',
      'Angle Finance',
      'Morris',
      'Selfco',
      'Silver Chef',
      'Capital Finance',
      'Fleet Partners',
      'Commercial Equity Group',
      'Group and General'
    };
    for (String len : lenderList) {
      param = new QuotingCalculation.CalcParam(len);
      param.totalAmount = 20000;
      param.totalInsuranceIncome = 500;
      param.dof = 990.00;
      param.monthlyFee = 15.00;

      param.amountBasePmt = param.getNaf();
      param.amountBaseComm = param.getNaf();
      
      param.term = 60;
      param.residualValue = 0.00;
      param.brokeragePer = 1.00;
      param.baseRate = 5.00;
	  param.clientRate = 1;
      QuotingCalculation.calculate(param);
    }

	}
	
	@isTest static void testBaseRate() {
		//Preparing data
		Test_DataGeneratorHelper.createQuoting();
		Id quotingId = Test_DataGeneratorHelper.quoting.Id;

		//ANZ Calculation
		List<Application_Quoting_Result__c> rLst = new List<Application_Quoting_Result__c>();
		QuotingCalculation.CalcParam param = getGenericParam('ANZ Consumer');

		param.ltv = 'OG1';
        param.customerProfile = 'Property Owner - New Car';
        param.term = 60;
        param.adverseCredit = 'N';
        param.baseRate = QuotingCalculation.getBaseRate(param);

        param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = 'OG2';
        param.customerProfile = 'Property Owner - New Car';
        param.term = 60;
        param.adverseCredit = 'N';
        param.baseRate = QuotingCalculation.getBaseRate(param);

        param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = '110';
		param.customerProfile = 'Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = '120';
		param.customerProfile = 'Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = '141';
		param.customerProfile = 'Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.term = 72;
        param.adverseCredit = 'Y';
		param.baseRate = QuotingCalculation.getBaseRate(param);



		param = getGenericParam('ANZ Commercial');
		param.ltv = 'OG';
        param.customerProfile = 'Property Owner - New Car';
        param.term = 60;
        param.adverseCredit = 'N';
        param.baseRate = QuotingCalculation.getBaseRate(param);

        param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = '120';
		param.customerProfile = 'Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		param.ltv = '141';
		param.customerProfile = 'Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Property Owner - Old Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - New Car';
		param.baseRate = QuotingCalculation.getBaseRate(param);
		param.customerProfile = 'Non Property Owner - Old Car';
		param.term = 72;
        param.adverseCredit = 'Y';
		param.baseRate = QuotingCalculation.getBaseRate(param);

		

		//ANZ Others
		param = new QuotingCalculation.CalcParam('ANZ Others');
		param.brokeragePer = 4;

		param.goodsType = 'chattel';
		List<String> profiles = new List<String>();
		profiles.add('New_3_years_old__c');
		profiles.add('X4_8_years_old__c');
		profiles.add('Over_8_years_old__c');

		List<Decimal> amoutns = new List<Decimal>();
		amoutns.add(155000.0);
		amoutns.add(120000.0);
		amoutns.add(70000.0);
		amoutns.add(30000.0);
		amoutns.add(15000.0);
		amoutns.add(5000.0);
	
		for (String p : profiles) {
			param.vehiclesProfile = p;
			for (Decimal a: amoutns) {
				param.totalAmount = a;
				QuotingCalculation.getBaseRate(param);	
			}
		}

		param.goodsType = 'equipment';
		profiles = new List<String>();
		profiles.add('New_Goods__c');
		profiles.add('Used_up_to_5_years_old__c');
		profiles.add('Over_5_years_old__c');

		amoutns = new List<Decimal>();
		amoutns.add(70000.0);
		amoutns.add(30000.0);
		amoutns.add(15000.0);
		amoutns.add(5000.0);
		for (String p : profiles) {
			param.vehiclesProfile = p;
			for (Decimal a: amoutns) {
				param.totalAmount = a;
				QuotingCalculation.getBaseRate(param);	
			}
		}
		
		param.goodsType = 'leisure';
		profiles = new List<String>();
		profiles.add('New_1_year_old__c');
		profiles.add('X2_5_years_old__c');
		profiles.add('Over_5_years_old__c');

		amoutns = new List<Decimal>();
		amoutns.add(70000.0);
		amoutns.add(30000.0);
		amoutns.add(15000.0);
		amoutns.add(5000.0);
		for (String p : profiles) {
			param.vehiclesProfile = p;
			for (Decimal a: amoutns) {
				param.totalAmount = a;
				QuotingCalculation.getBaseRate(param);	
			}
		}

		// New rates for ANZ Others 			2020-07-02
		param = new QuotingCalculation.CalcParam('ANZ Others');
		param.goodsType = 'chattel';
		param.vehiclesProfile = 'New';
		QuotingCalculation.getANZOthersRate(param);
		param.goodsType = 'any-good-type';
		param.vehiclesProfile = 'New';
		QuotingCalculation.getANZOthersRate(param);
		QuotingCalculation.getANZOthersRate(null);


		//Pepper MV
		param = new QuotingCalculation.CalcParam('Pepper MV');
		// Commercial
		param.customerProfile = 'MV';
		param.productLoanType = 'Chatel';
		param.clientTier = 'A';
		QuotingCalculation.getBaseRate(param);
		QuotingCalculation.getMaximunBaseRate(param);
		// Consumer
		param.customerProfile = 'MV';
		param.clientTier = 'A';
		param.productLoanType = 'Consumer Loan';
				
		profiles = new List<String>();
		profiles.add('New');
		profiles.add('Used 0-5 years');
		profiles.add('Used 6-9 years');
		profiles.add('Used 10+ years');
		
		for (String t: profiles) {
			param.vehicleYear = t;
			QuotingCalculation.getBaseRate(param);
			QuotingCalculation.getMaximunBaseRate(param);
		}

		//Pepper Leisure
		/*
		param = new QuotingCalculation.CalcParam('Pepper Leisure');
		clientTier = new List<String>();
		clientTier.add('A');
		clientTier.add('B');
		clientTier.add('C');

		for (String t: clientTier) {
			param.clientTier = t;
			QuotingCalculation.getBaseRate(param);
		}
		*/

		//Pepper 5Oh
		param = new QuotingCalculation.CalcParam('Pepper 5Oh');
		List<String> clientTier = new List<String>();
		clientTier.add('A');
		clientTier.add('B');

		for (String t: clientTier) {
			param.clientTier = t;
			QuotingCalculation.getBaseRate(param);
		}

		//Pepper Summer
		param = new QuotingCalculation.CalcParam('Pepper Summer');
		clientTier = new List<String>();
		clientTier.add('A');
		clientTier.add('B');

		for (String t: clientTier) {
			param.clientTier = t;
			QuotingCalculation.getBaseRate(param);
		}

		//Liberty 
		param = new QuotingCalculation.CalcParam('Liberty Drive');
		//Consumer
		param.productLoanType = 'Consumer Loan';
		param.vehicleYear = 'New';
		QuotingCalculation.getBaseRate(param);
		QuotingCalculation.getMaximunBaseRate(param);
		//Commercial
		param.productLoanType = 'Chatel...';
		param.vehicleYear = 'New';
		param.clientTier = 'AA';
		QuotingCalculation.getBaseRate(param);
		QuotingCalculation.getMaximunBaseRate(param);
		param.clientTier = 'B';
		QuotingCalculation.getBaseRate(param);
		QuotingCalculation.getMaximunBaseRate(param);

		/*
		//Liberty Drive
		param = new QuotingCalculation.CalcParam('Liberty Drive');
		param.residualValue = 100;

		List<String> ltvs = new List<String>();
		ltvs.add('90');
		ltvs.add('110');
		ltvs.add('140');

		List<String> loanDetails = new List<String>();
		loanDetails.add('Consumer');
		loanDetails.add('Commercial Star');
		loanDetails.add('Commercial Nova');

		for (String d : loanDetails) {
			param.loanTypeDetail = d;
			for (String l : ltvs) {
				param.ltv = l;		
				QuotingCalculation.getBaseRate(param);
			}
		}

		//Liberty Options
		param = new QuotingCalculation.CalcParam('Liberty Options');
		param.residualValue = 100;
		param.carAge = 6;

		loanDetails = new List<String>();
		loanDetails.add('Consumer');
		loanDetails.add('Commercial Star');
		loanDetails.add('Commercial Nova');

		clientTier = new List<String>();
		clientTier.add('AA');
		clientTier.add('A');
		clientTier.add('B');
		clientTier.add('C');

		for (String d : loanDetails) {
			param.loanTypeDetail = d;
			for (String t: clientTier) {
				param.clientTier = t;
				QuotingCalculation.getBaseRate(param);
			}
		}
		*/

		//Macquarie Consumer
		param = new QuotingCalculation.CalcParam('Macquarie Consumer');
		param.carAge = 4;
		param.privateSales = 'Y';
		param.ltv = '135';
		param.assetType = 'Motorbike';

		List<Decimal> brokerages = new List<Decimal>();
		brokerages.add(4.1);
		brokerages.add(5.1);
		brokerages.add(6.1);
		brokerages.add(7.1);


		List<Integer> terms = new List<Integer>();
		terms.add(12);
		terms.add(36);
		terms.add(84);
		
		amoutns = new List<Decimal>();
		amoutns.add(7000.0);
		amoutns.add(30000.0);
		amoutns.add(80000.0);
		amoutns.add(300000.0);

		for (Integer t : terms) {
			param.term = t;
			for (Decimal a: amoutns) {
				param.totalAmount = a;
				for (Decimal b: brokerages) {
					param.brokeragePer = b;
					QuotingCalculation.getBaseRate(param);
				}
			}
		}

		//Macquarie Commercial
		param = new QuotingCalculation.CalcParam('Macquarie Commercial');
		param.carAge = 5;
		param.privateSales = 'Y';

		terms = new List<Integer>();
		terms.add(12);
		terms.add(36);

		amoutns = new List<Decimal>();
		amoutns.add(7000.0);
		amoutns.add(10000.0);
		amoutns.add(19000.0);
		amoutns.add(70000.0);

		for (Integer t : terms) {
			param.term = t;
			for (Decimal a: amoutns) {
				param.totalAmount = a;
				for (Decimal b: brokerages) {
					param.brokeragePer = b;
					QuotingCalculation.getBaseRate(param);
				}
			}
		}


		//Finance One
		param = new QuotingCalculation.CalcParam('Finance One');
		List<String> loanDetails = new List<String>();
		loanDetails.add('Gold');
		loanDetails.add('Silver');
		loanDetails.add('Bronze');
		loanDetails.add('E-Motors');
		param.productLoanType = 'Chattel Mortgage-Full-Doc';
		for (String d : loanDetails) {
			param.loanTypeDetail = d;
			QuotingCalculation.getBaseRate(param);
		}
		

		//Metro
		param = new QuotingCalculation.CalcParam('Metro');
		
		loanDetails = new List<String>();
		loanDetails.add('Passenger and Commercial Vehicles');
		loanDetails.add('Heavy Commercial Vehicles');
		loanDetails.add('Wheeled Plant & Equipment');
		
		terms = new List<Integer>();
		terms.add(24);
		terms.add(36);
		terms.add(48);
		terms.add(60);

		amoutns = new List<Decimal>();
		amoutns.add(20000.0);
		amoutns.add(10000.0);
		amoutns.add(5000.0);
		
		brokerages = new List<Decimal>();
		brokerages.add(4.1);
		brokerages.add(5.1);
		brokerages.add(6.1);
		brokerages.add(7.1);

		param.carAge = 5;
		param.privateSales = 'Y';
		param.saleBacksPurchased = 'Y';

		for (String d : loanDetails) {
			param.loanTypeDetail = d;
			for (Integer t : terms) {
				param.term = t;
				for (Decimal a : amoutns) {
					param.totalAmount = a;
					for (Decimal b: brokerages) {
						param.brokeragePer = b;
						QuotingCalculation.getBaseRate(param);
					}
				}
			}
		}

		//Yamaha Marine
		param = new QuotingCalculation.CalcParam('Yamaha Marine');
		param.loanTypeDetail = 'Prime Plus';
		param.customerProfile = 'Used';
		param.totalAmount = 40000;
		QuotingCalculation.getBaseRate(param);

		param.totalAmount = 500000;
		QuotingCalculation.getBaseRate(param);

		param = new QuotingCalculation.CalcParam('Yamaha Motorcycles');
		param.loanTypeDetail = 'Prime Plus';
		param.customerProfile = 'Used';
		param.totalAmount = 40000;
		QuotingCalculation.getBaseRate(param);
		
		//Firstmac
		param = new QuotingCalculation.CalcParam('Firstmac');
		param.loanTypeDetail = 'New and used < 5 years';
    param.customerProfile = 'Standard';
    param.residency = 'Y';
    param.carAge = 6;
    param.greenCar = 'Y';
	param.interestType = 'Fixed';
    QuotingCalculation.getBaseRate(param);

    param.customerProfile = 'Edge';
    param.loanTypeDetail = 'Used 6-7 years';
    QuotingCalculation.getBaseRate(param);

    	//Wisr
		param = new QuotingCalculation.CalcParam('Wisr');
		param.vedascore = 500;
    param.term = 36;
    param.ltv = '85';
    QuotingCalculation.getBaseRate(param);
    param.vedascore = 900;
    param.term = 60;
    param.ltv = '105';
    QuotingCalculation.getBaseRate(param);
    
    //Wisr VL
		param = new QuotingCalculation.CalcParam('Wisr VL');
    param.vedascore = 730;
    param.vehicleYear = String.valueOf(Date.today().year());
    param.customerProfile = 'Home owner, Renter';
    QuotingCalculation.getBaseRate(param);
    param.vedascore = 900;
    QuotingCalculation.getBaseRate(param);
    param = new QuotingCalculation.CalcParam('CarStart');
    QuotingCalculation.getBaseRate(param);
    param.loanTypeDetail = 'Mid-Prime Finance Only';
    QuotingCalculation.getBaseRate(param);
  }

  @isTest static void testBaseRatePart2() {
		//Preparing data
		Test_DataGeneratorHelper.createQuoting();
		Id quotingId = Test_DataGeneratorHelper.quoting.Id;

		//Ratesetter / Plenti
		List<Application_Quoting_Result__c> rLst = new List<Application_Quoting_Result__c>();
		QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('RateSetter');
      param.customerProfile = 'Property Owner';
      param.clientTier = 'Tier 1';
      Integer y = Date.today().year();
    	List<String> loanDetails = new List<String>();
    	loanDetails.add(String.valueOf(y));
      loanDetails.add(String.valueOf(y-3));
      loanDetails.add(String.valueOf(y-5));
      loanDetails.add(String.valueOf(y-10));
    	for (String s : loanDetails) {
    		param.vehicleYear = s;
    		QuotingCalculation.getRateSetterBaseRate(param, true);
    	}

    	//Now Finance
    	param = new QuotingCalculation.CalcParam('Now Finance');
    	param.loanTypeDetail = 'Secured';
    	QuotingCalculation.getNowFinanceBaseRate(param);
    	param.loanTypeDetail = 'Unsecured';
    	QuotingCalculation.getNowFinanceBaseRate(param);

    	//AFS Consumer - OLD
    	param = new QuotingCalculation.CalcParam('AFS Consumer');
    List<String>	clientTier = new List<String>();
		clientTier.add('Gold Club');
		clientTier.add('Drive More Plus');
		clientTier.add('Drive More');
		clientTier.add('Autoline Plus');
		clientTier.add('Autoline');
		clientTier.add('Autoline (Credit Impaired)');
		param.clientRate = 50;
		for (String s : clientTier) {
			param.clientTier = s;
			QuotingCalculation.getAfsConsumerMinBaseRate(param);
			QuotingCalculation.getAfsConsumerMaxBaseRate(param);
			QuotingCalculation.getBaseRate(param);
			QuotingCalculation.getAfsConsumerCommission(param);
		}
    	
		//AFS Consumer - NEW RATES
		param = new QuotingCalculation.CalcParam('AFS Consumer');
		param.bankrupt = 'Y';
    param.vehiclePrice = 30000;
    param.vehicleYear = '0-3 years';
    param.riskGrade = 'Over 6 months ago';
    param.hasImports = 'Y';
    param.vehiclesProfile = '>200,000';
    param.term = 84;
    param.ltv = '130';
    param.customerProfile = 'Y';
    param.privateSales = 'Y';
    List<String> tmp1list = new List<String>{'Property Owner','Renting','Employer Accommodation'};
    List<String> tmp2list = new List<String>{'New/Demo','Used'};
    List<String> tmp3list = new List<String>{'Car','Bikes / Scooters','Boats / Personal Watercraft','Caravans / Motorhomes'};
    for (String a: tmp1list) {
      for (String b: tmp2list) {
        for (String c: tmp3list) {
          param.residency = a;
          param.condition = b;
          param.assetType = c;
          QuotingCalculation.getBaseRate(param);
          QuotingCalculation.getMaximunBaseRate(param);
        }
      }
    }		
		
    param = new QuotingCalculation.CalcParam('AFS Consumer');
    param.productLoanType = 'Gold Club - Non-Property';
    QuotingCalculation.getBaseRate(param);
    //AFS Commercial
    param = new QuotingCalculation.CalcParam('AFS Commercial');
    param.clientTier = '0-7 years';
    param.clientRate = 25;
    QuotingCalculation.getAfsCommercialMinBaseRate(param);
    QuotingCalculation.getAfsCommercialMaxBaseRate(param);
    QuotingCalculation.getAfsCommercialCommission(param);
    param.clientTier = '8 years +';
    QuotingCalculation.getAfsCommercialMinBaseRate(param);
    QuotingCalculation.getAfsCommercialMaxBaseRate(param);
    QuotingCalculation.getAfsCommercialCommission(param);

    //Latitude
    param = new QuotingCalculation.CalcParam('Latitude');
    loanDetails = new List<String>();
		loanDetails.add('Diamond Plus');
		loanDetails.add('Diamond');
		loanDetails.add('Sapphire');

		List<Integer> ageList = new List<Integer>();
		ageList.add(0);
		ageList.add(5);
		ageList.add(10);
		for (String a : loanDetails) {
			param.loanTypeDetail = a;
			for (Integer b : ageList) {
				param.carAge = b;
				QuotingCalculation.getBaseRate(param);
				QuotingCalculation.getMaximunBaseRate(param);
			}
		}

		//Latitude PL
    param = new QuotingCalculation.CalcParam(LatitudePersonalCalculatorExtension.LENDER_QUOTING);
    param.loanTypeDetail = 'AAA';
    param.customerProfile = 'Secured';
    QuotingCalculation.getBaseRate(param);
    QuotingCalculation.getMaximunBaseRate(param);
    param.customerProfile = 'Unsecured';
    QuotingCalculation.getBaseRate(param);
    QuotingCalculation.getMaximunBaseRate(param);

    //Green Ligth
    param = new QuotingCalculation.CalcParam(GreenLightCalculatorExtension.LENDER_QUOTING);
    param.clientTier = 'Platinum';
    param.assetType = 'Car';
    Integer cy = Date.today().year();
    param.vehicleYear = String.valueOf(cy);
    QuotingCalculation.getBaseRate(param);
		QuotingCalculation.getMaximunBaseRate(param);
    QuotingCalculation.getGreenLightProducts(param);

    param.vehicleYear = String.valueOf(cy-5);
    QuotingCalculation.getBaseRate(param);

    param.vehicleYear = String.valueOf(cy-10);
    QuotingCalculation.getBaseRate(param);
    
    param.assetType = 'Motorcycle';
    QuotingCalculation.getBaseRate(param);
    

		//Money 3
		param = new QuotingCalculation.CalcParam(Money3CalculatorExtension.LENDER_QUOTING);
		clientTier = new List<String>{'Platinum','Gold','Silver','Bronze','Micro Motor','Mini PL','Fake Grade'};
		for (String rg: clientTier) {
			param.riskGrade = rg;
			QuotingCalculation.getBaseRate(param);
		}

    // Affordable
		param = new QuotingCalculation.CalcParam('Affordable');
		//param.clientTier = 'Premium';
		param.creditScore = '500+';
    y = Date.today().year();
    loanDetails = new List<String>();
    loanDetails.add(String.valueOf(y));
    loanDetails.add(String.valueOf(y-3));
    loanDetails.add(String.valueOf(y-9));
    for (String s : loanDetails) {
      param.vehicleYear = s;
      QuotingCalculation.getBaseRate(param);
      QuotingCalculation.getMaximunBaseRate(param);
    }

    QuotingCalculation.getAffordableFees(10.00);

    // List basic rates
    QuotingCalculation.listBasicRates('Affordable');
	param.clientRate = 2;
	param.term = 1;
    QuotingCalculation.calculate(param);
	}

  @isTest static void testGetBaseRateNewCals() {
    //Shif Asset --> BaseRateCalc
    QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Shift Asset');
    param.totalAmount = 300000;
    param.assetAge = '5 - 10 years';
    param.customerProfile = 'Y';
    param.brokeragePer = 6;
    QuotingCalculation.getBaseRate(param);

    param.totalAmount = 20000;
    param.assetType = 'Secondary Assets';
    param.assetAge = '20+ years';
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'Tertiary Assets';
    param.assetAge = 'New to 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'Tertiary Assets';
    param.assetAge = '20+ years';
    param.loanType = 'Refinance';
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'Fitout Finance';
    param.customerProfile = 'N';
    param.privateSales = 'Y';
    param.loanType = 'Equity Raise';
    QuotingCalculation.getBaseRate(param);

    //Shif ODR --> BaseRateCalc
    param = new QuotingCalculation.CalcParam('Shift ODR');
    QuotingCalculation.getBaseRate(param);

    // Grow Asset Car
    param = new QuotingCalculation.CalcParam('Grow Asset');
    param.assetType = 'Tier 1 - Cars';
    param.abnLength = '> 12 months';
    param.assetAge = '1';
    param.customerProfile = 'Y';
	param.companyScore = '< 500';
	param.directorSoleTraderScore = '< 600';
	param.privateSales = 'Y';
	param.term = 72;
	param.paidDefault = 'Oth Default <$5K';
	param.brokeragePer = 6;
	QuotingCalculation.getBaseRate(param);
	param.term = 12;
	param.assetAge = '8';
	param.customerProfile = 'N';
	QuotingCalculation.getBaseRate(param);
	param.assetType = 'Tier 2 - Trucks yellow goods';
	param.assetAge = '16';
	QuotingCalculation.getBaseRate(param);
	param.assetType = 'Tier 3 - Specialised';
	param.condition = 'Used';
	QuotingCalculation.getBaseRate(param);
/*
    param.abnLength = '> 24 months';
    param.assetAge = '5';
    param.customerProfile = 'N';
    QuotingCalculation.getBaseRate(param);


    param.assetType = 'Auto';
    param.assetAge = '2';
    param.customerProfile = 'Y';
    QuotingCalculation.getBaseRate(param);
    param.assetAge = '12';
    QuotingCalculation.getBaseRate(param);
    param.assetAge = '22';
    param.customerProfile = 'N';
    param.privateSales = 'Y';
    param.equifaxScore = 400;
    param.abnLength = '> 12 months';
    QuotingCalculation.getBaseRate(param);
*/
    //Grow Business Loan
    param = new QuotingCalculation.CalcParam('Grow Business Loan');
    QuotingCalculation.getBaseRate(param);

    // Morris
    param = new QuotingCalculation.CalcParam('Morris');
    param.totalAmount = 120000;
    QuotingCalculation.getBaseRate(param);
    param.totalAmount = 60000;
    QuotingCalculation.getBaseRate(param);
    param.totalAmount = 30000;
    QuotingCalculation.getBaseRate(param);
    param.totalAmount = 3000000;
    QuotingCalculation.getBaseRate(param);

    // Angle Finance
    param = new QuotingCalculation.CalcParam('Angle Finance');
    param.assetAge = '2';
    param.assetType = 'Motor Vehicle';
    param.customerProfile = 'Y';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '8';
    param.endOfTerm = 5;
    param.abnLength = 'ABN 0-1';
    QuotingCalculation.getBaseRate(param);

    param.endOfTerm = 18;
    param.customerProfile = 'N';
    QuotingCalculation.getBaseRate(param);

    //Selfco
    param = new QuotingCalculation.CalcParam('Selfco');
    param.customerProfile = 'Y';
    param.tier = 'A';
    param.assetAge = '2';
    QuotingCalculation.getBaseRate(param);
    param.tier = 'B';
    QuotingCalculation.getBaseRate(param);
    param.tier = 'C';
    QuotingCalculation.getBaseRate(param);

    param.customerProfile = 'N';
    param.tier = 'A';
    QuotingCalculation.getBaseRate(param);
    param.tier = 'B';
    QuotingCalculation.getBaseRate(param);
    param.tier = 'C';
    param.privateSales = 'Y';
    param.totalAmount = 50000;
    param.loanType = 'Sale and Leaseback';
    param.assetAge = '22';
    QuotingCalculation.getBaseRate(param);

    // Capital finance
    param = new QuotingCalculation.CalcParam('Capital Finance');
    param.assetType = 'MV < 4.5T';
    param.totalAmount = 30000;
    param.term = 24;
    param.assetAge = 'New - 4 years';
    param.brokeragePer = 4;
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'Trucks/Agri/Yellow goods';
    param.totalAmount = 600000;
    param.assetAge = 'New - 4 years';
    QuotingCalculation.getBaseRate(param);

    param.totalAmount = 60000;
    QuotingCalculation.getBaseRate(param);

    param.totalAmount = 30000;
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 6 years';
    QuotingCalculation.getBaseRate(param);

    param.totalAmount = 15000;
    param.assetAge = 'New - 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 6 years';
    QuotingCalculation.getBaseRate(param);

    param.totalAmount = 8000;
    param.assetAge = 'New - 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetAge = '> 6 years';
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'MV < 4.5T';
    param.assetAge = '> 4 years';
    QuotingCalculation.getBaseRate(param);

    param.assetType = 'MV < 4.5T';
    param.assetAge = '> 6 years';
    QuotingCalculation.getBaseRate(param);



  }

	@isTest static void testCommissionsRates() {
		//Finance One
		QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('One');
		List<Decimal> nafComms = new List<Decimal>();
		nafComms.add(0.0);
		nafComms.add(5000.0);
		nafComms.add(18000.0);
		nafComms.add(30000.0);
		param.loanTypeDetail = 'E-Motors';
		param.nafCommission = 0;
		QuotingCalculation.getFinanceOneRiskFeeCalc(param);
		param.loanTypeDetail = 'ALL';
		for (Decimal c : nafComms) {
			param.nafCommission = c;
			QuotingCalculation.getFinanceOneRiskFeeCalc(param);
		}

		//Finance One Dofs
		param = new QuotingCalculation.CalcParam('One');
		param.loanTypeDetail = 'E-Motors';
		QuotingCalculation.getFinanceOneDofCalc(param);
		List<Decimal> amoutns = new List<Decimal>();
		amoutns.add(10000.0);
		amoutns.add(20000.0);
		param.loanTypeDetail = 'A';
		for (Decimal a : amoutns) {
			param.totalAmount = a;
			QuotingCalculation.getFinanceOneDofCalc(param);
		}

		//Latitude commissions
		param = new QuotingCalculation.CalcParam('One');
		//List<String> loanDetails = new List<String>();
		//loanDetails.add('');
		//loanDetails.add('Diamond');
		//loanDetails.add('Shapphire');
		//loanDetails.add('Ruby');
		//loanDetails.add('Emerald');
		
		List<Integer> ageList = new List<Integer>();
		ageList.add(0);
		ageList.add(5);
		ageList.add(9);
		param.loanTypeDetail = 'Diamond Plus';
		param.clientRate = 20;
		for (Integer l : ageList) {
			param.carAge = l;
			QuotingCalculation.getLatitudeRateCommission(param);
		}
		
		//Yamaha Commissions
		param = new QuotingCalculation.CalcParam('One');
		param.loanTypeDetail = 'Commercial';
		param.maxRate = 12.0;
		param.baseRate = 10.0;
		param.clientRate = 11.0;
		QuotingCalculation.getYamahaCommission(param);
		param.loanTypeDetail = 'Consumer';
		param.clientRate = param.baseRate;
		for (;param.clientRate <= param.maxRate;) {
			QuotingCalculation.getYamahaCommission(param);
			param.clientRate += 0.1;
		}

		//Anz rates
		param = new QuotingCalculation.CalcParam('test');
		List<String> profiles = new List<String>();
		profiles.add('Property Owner - New Car');
		profiles.add('Property Owner - Old Car');
		profiles.add('Non Property Owner - New Car');
		profiles.add('Non Property Owner_15-Older Car');
		profiles.add('Other Goods');
		profiles.add('Test Profile');
		List<Decimal> nafs = new List<Decimal>();
		nafs.add(60000);
		nafs.add(30000);
		nafs.add(20000);
		nafs.add(9000);
		param.baseRate = 6.99;
		param.clientRate = 6.99;
		for (String prof : profiles) {
			param.customerProfile = prof;
		    for (Decimal a : nafs) {
		    	param.totalAmount = a;    
		    	QuotingCalculation.getANZConsumerCommission(param);    
		    }
		}

		QuotingCalculation.getLenderSettings('ANZ Consumer');
		
		// Pepper Commission
		param = new QuotingCalculation.CalcParam('Pepper');
		param.clientTier = 'A';
		param.clientRate = 10.19;
		System.assert(QuotingCalculation.getPepperCommercialCommission(param)>0);
		param.clientTier = 'Z';
		System.assert(QuotingCalculation.getPepperCommercialCommission(param)==0);

		//Liberty commissions
		param = new QuotingCalculation.CalcParam('Liberty Drive');
		param.productLoanType = 'Consumer Loan';
		List<String> clientTierLst = new List<String>{'AAA','AA','A+','A','B+','B','C'};
		param.clientRate = 20;
		for (String cr : clientTierLst) {
			param.clientTier = cr;
			QuotingCalculation.getLibertyCommission(param);
		}
		param.productLoanType = 'Commercial';
		param.clientTier = 'AA';
		QuotingCalculation.getLibertyCommission(param);
	}

	@isTest static void testDOFCalculations() {
		// Yamaha
		List<Decimal> nafs = new List<Decimal>();
		nafs.add(1600);
		nafs.add(3500);
		nafs.add(5500);
		nafs.add(11000);
		nafs.add(21000);
		nafs.add(41000);

		List<String> lenders = new List<String>();
		lenders.add('Yamaha Any');
		lenders.add('Yamaha Marine');

		for (String lender: lenders) {
			for (Decimal base: nafs) {
				QuotingCalculation.getYamahaDOfCalculation(base, lender);
			}
		}

		// Liberty Option Risk fee
		QuotingCalculation.CalcParam param = getGenericParam('aaaa');
		List<String> tiers = new List<String>();
		tiers.add('AA');
		tiers.add('A');
		tiers.add('B');
		tiers.add('C');
		tiers.add('Z');
		param.riskFeeBase = 1;
		for (String t: tiers) {
			param.clientTier = t;
			QuotingCalculation.getLibertyOptionRiskFee(param);
		}
	}

	@isTest static void testMaximunBaseRates() {
		List<String> lenders = new List<String>();
		lenders.add('ANZ Consumer');
		lenders.add('ANZ Commercial');
		lenders.add('ANZ Others');
		lenders.add('Pepper MV');
		lenders.add('Pepper Leisure');
		lenders.add('Pepper 5Oh');
		lenders.add('Pepper Summer');
		lenders.add('Liberty Drive');
		lenders.add('Liberty Options');
		lenders.add('Macquarie Consumer');
		lenders.add('Macquarie Commercial');
		lenders.add('Finance One');
		lenders.add('Metro');
		lenders.add('Yamaha Marine');
		lenders.add('Yamaha Motorcycles');
		lenders.add('Yamaha Water');
        lenders.add('CarStart');

		QuotingCalculation.CalcParam param = null;
		for (String lender: lenders) {
			param = new QuotingCalculation.CalcParam(lender);
            if('CarStart'.equals(lender)){
                param.loanTypeDetail = 'Mid-Prime Finance Only'; 
            }
			QuotingCalculation.getMaximunBaseRate(param);
		}
        param = new QuotingCalculation.CalcParam('CarStart');
        QuotingCalculation.getMaximunBaseRate(param);
	}

	@isTest static void testLibertyInsuranceProducts() {
		QuotingCalculation.CalcParam param = new QuotingCalculation.CalcParam('Liberty Options');
		QuotingCalculation.calculateLibertyLPI(param);
		param.totalAmount = 20000;
		param.state = 'SA';
		param.dateofBirth = '01/01/1990';
		param.noOfPeople = 2;
		List<SelectOption> selOptions = QuotingToolHelper.getLibertyLPIOptions('ALL');
		List<String> levels = new List<String>();
		for (SelectOption o : selOptions) {
			levels.add(o.getValue());
		}
		Decimal[] terms = new Decimal[]{12,24,36,48,60,72,84};
		for (String a : levels) {
			param.lpiLevel = a;	
			for (Decimal b : terms) {
				param.term = b;
				QuotingCalculation.calculateLibertyLPI(param);
			}
		}
		
	}

	@isTest static void testMetroPlanoptions() {
		System.assert(!QuotingCalculation.getMetroPlanOptions().isEmpty());
	}

	@isTest static void testWisr() {
		QuotingCalculation.wisrApplicationFee(10000);
		QuotingCalculation.wisrMaxDOF(10000);
		QuotingCalculation.wisrMaxDOF(4000);
	}

	@isTest static void testMoney3() {
		QuotingCalculation.CalcParam r = new QuotingCalculation.CalcParam('Money3');
		r.customerProfile = 'Asset Finance';
		r.riskGrade = 'Micro Motor';
		List<Decimal> nafs = new List<Decimal>{2000.0,3000.0,6000.0,7000.0};
		for (Decimal a: nafs) {
			r.totalAmount = a;
			System.assert(QuotingCalculation.getMoney3maxDof(r)>0);
		}
		r.riskGrade = 'No Micro Motor';
		nafs = new List<Decimal>{8000.0,9000.0,10000.0,11000.0,12000.0,16000.0,8000.0,12000.0};
		for (Decimal a: nafs) {
			r.totalAmount = a;
			System.assert(QuotingCalculation.getMoney3maxDof(r)>0);
		}
		r.customerProfile = 'Personal Finance';
		r.riskGrade = 'Mini PL';
		nafs = new List<Decimal>{2000.0,3000.0,5000.0};
		for (Decimal a: nafs) {
			r.totalAmount = a;
			System.assert(QuotingCalculation.getMoney3maxDof(r)>0);
		}
		r.riskGrade = 'No Mini PL';
		nafs = new List<Decimal>{5000.0,6000.0,7000.0,8100.0,9000.0,10000.0,11000.0,12000.0};
		for (Decimal a: nafs) {
			r.totalAmount = a;
			System.assert(QuotingCalculation.getMoney3maxDof(r)>0);
		}
		// Commissions
		r.customerProfile = 'Asset Finance';
		r.amountBaseComm = 15000;
		List<String> rgs = new List<String>{'Platinum','Gold','Silver'};
		for (String rg: rgs) {
			r.riskGrade = rg;
			System.assert(QuotingCalculation.getMoney3CommPercentage(r)>0);
		}
		// Risk fees
		r.riskFeeBase = 25000;
		System.assert(QuotingCalculation.getMoney3RiskFee(r)>0);
	}
	
    @isTest
	static void deleteQuotingApplication() {
        Test_DataGeneratorHelper.applicationQuoting(true);
        Test_DataGeneratorHelper.reloadOpportunity();
        
        Test.startTest();
        	QuotingCalculation.deleteQuotingApplication(Test_DataGeneratorHelper.tstOpportunity);
        Test.stopTest();
	}



  //----------------------------------------------
  // AUXILIAR METHODS - Please leave it at the end
  //-----------------------------------------------
  private static QuotingCalculation.CalcParam getGenericParam(String lender) {
		QuotingCalculation.CalcParam r = new QuotingCalculation.CalcParam(lender);
		r.totalAmount = 20000;
    r.totalInsurance = 1000;
    r.totalInsuranceIncome = 250;
    r.clientRate = 7;
    r.baseRate = 5.5;
    r.paymentType = 'Arrears';
    r.term = 60;
    r.dof = 770;
    r.monthlyFee = 5;
    r.docFees = 0;
    r.residualValue = 0;
    return r;
	}

}