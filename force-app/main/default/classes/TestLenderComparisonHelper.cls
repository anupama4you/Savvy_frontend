@isTest
private class TestLenderComparisonHelper {
	
	@isTest static void testRateSetter() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
        param.employmentType = 'Full-Time';
        param.loanType = 'Consumer Loan';
        param.purchaseType = 'Dealer';
        param.creditHistory = 'Clean History';
        param.loanTerm = 60;
        System.assert(LenderComparisonHelper.includeRateSetter(param));

        param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeRateSetter(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeRateSetter(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includeRateSetter(param));
	}
	
	@isTest static void testFirstmac() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.creditHistory = 'Clean History';
		param.termEnd = '12 Years';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includeFirstmac(param));

        param.loanType = 'Full-Doc Chattel Mortgage';
		param.employmentType = 'Self employed (Full-Doc)';
		System.assert(LenderComparisonHelper.includeFirstmac(param));		
        
        param.loanType = 'Low-Doc Chattel Mortgage';
		param.employmentType = 'Self employed (Low-Doc)';
		System.assert(LenderComparisonHelper.includeFirstmac(param));		

		param.purchaseType = 'Refinance';
		param.loanType = 'Consumer Loan';
		param.employmentType = 'Full-Time';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
		param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Self employed (Low-Doc)';
        System.assert(LenderComparisonHelper.includeFirstmac(param));

		param.loanType = 'Full-Doc Chattel Mortgage';
		param.employmentType = 'Full-Time';
		System.assert(LenderComparisonHelper.includeFirstmac(param));
		param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includeFirstmac(param));

		param.loanType = 'Low-Doc Chattel Mortgage';
		param.employmentType = 'Full-Time';
		System.assert(LenderComparisonHelper.includeFirstmac(param));
		param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        param.employmentType = 'Self employed (Low-Doc)';
        System.assert(LenderComparisonHelper.includeFirstmac(param));
        
        param.loanTerm = 37;
        LenderComparisonHelper.includeFirstmac(param);
	}
	
	@isTest static void testAFSConsumer() {
		LenderComparisonFilterExtension.FilterParams paramet = new LenderComparisonFilterExtension.FilterParams();
		paramet = null;
        LenderComparisonHelper.includeAFSConsumer(paramet);
        
        LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.assetDetail = 'Car';
		param.creditHistory = 'Clean History';
		param.termEnd = '12 Years';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includeAFSConsumer(param));
        param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeAFSConsumer(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeAFSConsumer(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includeAFSConsumer(param));
	}	

	@isTest static void testAFSCommercial() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.creditHistory = 'Clean History';
		param.termEnd = '12 Years';
		param.loanType = 'Full-Doc Chattel Mortgage';
		param.purchaseType = 'Dealer';
        param.employmentType = 'Self employed (Full-Doc)';
        
        System.assert(LenderComparisonHelper.includeAFSCommercial(param));
        param.loanType = 'Low-Doc Chattel Mortgage';
        param.employmentType = 'Self employed (Low-Doc)';
        System.assert(LenderComparisonHelper.includeAFSCommercial(param));
        
        param.loanTerm = 14;
        LenderComparisonHelper.includeAFSCommercial(param);
	}

	@isTest static void testLatitude() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.creditHistory = 'Clean History';
		param.termEnd = '12 Years';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
        param.employmentType = 'Self employed (Full-Doc)';
        
        System.assert(LenderComparisonHelper.includeLatitude(param));
        param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includeLatitude(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includeLatitude(param));
        param.assetDetail = 'Motorbike';
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includeLatitude(param));
	}

	@isTest static void testPepper5Oh() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.ageCar = '0';
		param.creditHistory = 'Clean History';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
		param.residentialStatus = 'Property Owner';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includePepper5Oh(param));
	}

	@isTest static void testPepperMV() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.ageCar = '0';
		param.creditHistory = 'Clean History';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
		param.residentialStatus = 'Boarding';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includePepperMV(param));

        param.ageCar = '6';
        param.residentialStatus = 'Renting Real Estate';
        System.assert(LenderComparisonHelper.includePepperMV(param));

	}
    @isTest static void testPepperLeisure() {
        LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.assetDetail = 'Boat';
        param.ageCar = '0';
        param.creditHistory = 'Clean History';
        param.loanType = 'Consumer Loan';
        param.purchaseType = 'Dealer';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includePepperLeisure(param));

        param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includePepperLeisure(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includePepperLeisure(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includePepperLeisure(param));

    }

	@isTest static void testPepperSummer() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Caravan';
		param.ageCar = '0';
		param.creditHistory = 'Clean History';
		param.loanType = 'Consumer Loan';
		param.purchaseType = 'Dealer';
        param.employmentType = 'Full-Time';
        
        System.assert(LenderComparisonHelper.includePepperSummer(param));

        param.employmentType = 'Permanent Part-Time';
        System.assert(LenderComparisonHelper.includePepperSummer(param));
        param.employmentType = 'Casual > 12 months';
        System.assert(LenderComparisonHelper.includePepperSummer(param));
        param.employmentType = 'Self employed (Full-Doc)';
        System.assert(LenderComparisonHelper.includePepperSummer(param));

	}

	@isTest static void testLibertyDrive() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Car';
		param.termEnd = '15 Years';
		param.creditHistory = 'Clean History';
		param.purchaseType = 'Dealer';
		param.residentialStatus = 'Property Owner';
        
        System.assert(LenderComparisonHelper.includeLibertyDrive(param));
	}

	@isTest static void testPaydayLoanLenders() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.price = 20000;
        param.deposit = 11000;
        param.hasPayday = 'Y';
		param.loanType = 'Consumer Loan';
		param.creditHistory = 'Clean History';
		param.purchaseType = 'Personal Loan';
		param.residentialStatus = 'Property Owner';
        param.loanTerm = 60;
        param.ageCar = '6';
        Set<String> lenders = LenderComparisonHelper.includePaydayLoanLenders(param);
        System.assert(lenders.contains(LibertyDriveExtension.LENDER_QUOTING));
        System.assert(lenders.contains(RateSetterCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(GreenLightCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(FinanceOneExtension.LENDER_QUOTING));
        System.assert(lenders.contains(Money3CalculatorExtension.LENDER_QUOTING));

        param.loanTerm = 48;
        param.creditHistory = 'Defaults & or Previous Bankrupt';
        lenders = LenderComparisonHelper.includePaydayLoanLenders(param);
        System.assert(!lenders.contains(LibertyDriveExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(RateSetterCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(GreenLightCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(FinanceOneExtension.LENDER_QUOTING));
		System.assert(lenders.contains(Money3CalculatorExtension.LENDER_QUOTING));        

        param.assetDetail = 'Motorbike';
        param.loanType = 'Consumer Loan';
        param.creditHistory = 'Clean History';
        lenders = LenderComparisonHelper.includePaydayLoanLenders(param);
        System.assert(lenders.contains(YamahaMarineCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(LatitudeCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MacquarieConsumerExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(MacquarieCommercialExtension.LENDER_QUOTING));
        param.loanType = 'Full-Doc Chattel Mortgage';
        lenders = LenderComparisonHelper.includePaydayLoanLenders(param);
        System.assert(lenders.contains(YamahaMarineCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(LatitudeCalculatorExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(MacquarieConsumerExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MacquarieCommercialExtension.LENDER_QUOTING));
	}

	@isTest static void testPersonalLoans() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.price = 20000;
        param.deposit = 11000;
        param.loanType = 'Personal Loan';
		param.creditHistory = 'Clean History';
        param.loanTerm = 60;
        Set<String> lenders = LenderComparisonHelper.includePersonalLoans(param);
        System.assert(lenders.contains(RatesetterPLExtension.LENDER_QUOTING));
        System.assert(lenders.contains(NowFinanceCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(LatitudePersonalCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(WisrCalculatorExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(Money3CalculatorExtension.LENDER_QUOTING));

        param.loanTerm = 48;
        param.creditHistory = 'Defaults & or Previous Bankrupt';
        lenders = LenderComparisonHelper.includePersonalLoans(param);
        System.assert(!lenders.contains(RatesetterPLExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(NowFinanceCalculatorExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(LatitudePersonalCalculatorExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(WisrCalculatorExtension.LENDER_QUOTING));
        System.assert(!lenders.contains(Money3CalculatorExtension.LENDER_QUOTING));
	}

	@isTest static void testMoney3() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.price = 20000;
        param.deposit = 11000;
        param.loanTerm = 720;
        System.assert(!LenderComparisonHelper.includeMoney3(param));
        param.loanTerm = 60;
        System.assert(LenderComparisonHelper.includeMoney3(param));
        param.loanTerm = 48;
        System.assert(LenderComparisonHelper.includeMoney3(param));
	}

	@isTest static void testTruckLenders() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
		param.assetDetail = 'Truck';
		param.loanType = 'Low-Doc Chattel Mortgage';
		param.employmentType = 'Self employed (Low-Doc)';
		param.creditHistory = 'Clean History';
		param.purchaseType = 'Dealer';
		param.ageCar = '0';
        
        Set<String> lenders = LenderComparisonHelper.includeTruckLenders(param);
        System.assert(lenders.contains(EsandaCommercialExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MacquarieCommercialExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MetroCalculatorExtension.LENDER_QUOTING));
        System.assert(lenders.contains(FinanceOneExtension.LENDER_QUOTING));
        

        param.loanType = 'Full-Doc Chattel Mortgage';
		param.employmentType = 'Self employed (Full-Doc)';
        lenders = LenderComparisonHelper.includeTruckLenders(param);
        System.assert(lenders.contains(EsandaCommercialExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MacquarieCommercialExtension.LENDER_QUOTING));
        System.assert(lenders.contains(MetroCalculatorExtension.LENDER_QUOTING));
	}

	@isTest static void testExcludeLibertyDrive() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        /*param.residentialStatus = 'Renting Real Estate';
        param.jobsLast3Years = 3;
        param.hasEnquiries = 'Y';*/
        param.loanTerm = 23;
        //System.assert(LenderComparisonHelper.excludeLibertyDrive(param));
		LenderComparisonHelper.excludeLibertyDrive(param);
            
        /*param.residentialStatus = 'Property Owner';
        param.jobsLast3Years = 1;
        param.hasEnquiries = 'Y';*/
        param.loanTerm = 24;
        //System.assert(LenderComparisonHelper.excludeLibertyDrive(param));
        LenderComparisonHelper.excludeLibertyDrive(param);
	}

	@isTest static void testExcludeAnyPepper() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.employmentType = 'Casual < 12 months';
        param.hasEnquiries = 'Y';
        System.assert(LenderComparisonHelper.excludeAnyPepper(param));
        param.assetDetail = 'Caravan';
        param.loanTerm = 60;
        param.ageCar = '11';
        System.assert(LenderComparisonHelper.excludeAnyPepper(param));
	}

	@isTest static void testExcludeAnyMacquarie() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.hasPayday = 'Y';
        System.assert(LenderComparisonHelper.excludeAnyMacquarie(param));
        
        param.hasVerifiableCredit = 'N';
        param.assetDetail = 'Motorbike';
        param.ageCar = '6';
        System.assert(LenderComparisonHelper.excludeAnyMacquarie(param));
	}

	@isTest static void testCalculatePricingStrategy() {
		LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
        param.creditHistory = 'Clean History';
        param.applicantAge = 30;
        param.ageCar = '0';
        param.residentialStatus = 'Renting Real Estate';
        param.employmentType = 'Full-Time';
        param.annualIncome = 65000;
        param.jobsLast3Years = 1;
        param.hasVerifiableCredit= 'Y';
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_1.equals(param.tier));
		
        param.residentialStatus = 'Real Estate';
        LenderComparisonHelper.calculatePricingStrategy(param);
        
        param.residentialStatus = 'Property Owner';
        param.employmentType = 'Self employed (Low-Doc)';
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_1.equals(param.tier));

        param.creditScore = '400 - 524';
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_2.equals(param.tier));

        //param.annualIncome = 45000;
        param.jobsLast3Years = 3;
        param.hasVerifiableCredit= 'N';
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_2.equals(param.tier));

        param.employmentType = 'Casual > 12 months';
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_2.equals(param.tier));
        
        param.applicantAge = 25;
        LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_2.equals(param.tier));

 		param.creditHistory = 'Defaults & or Previous Bankrupt';
		LenderComparisonHelper.calculatePricingStrategy(param);
        System.assert(LenderComparisonHelper.TIER_3.equals(param.tier));
	}
    
    @isTest static void testExcludeYamaha() {
    	LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
    	param.assetDetail = 'Boat';
        param.residentialStatus = 'Property Owner';
        param.loanTerm = 12;
        LenderComparisonHelper.excludeYamaha(param);
        
        param.residentialStatus = 'Property';
        LenderComparisonHelper.excludeYamaha(param);
    }
    
    @isTest static void testincludeMacquarie() {
    	LenderComparisonFilterExtension.FilterParams param = new LenderComparisonFilterExtension.FilterParams();
    	param.assetDetail = 'Motorbike';
        param.purchaseType = 'Private';
        param.employmentType = 'Full-Time';
        param.employmentType = 'Casual < 12 months'; 
        param.employmentType = 'Casual > 12 months'; 
        param.employmentType = 'Self employed (Full-Doc)';
        param.residentialStatus = 'Property Owner';
        param.loanTerm = 12;
        LenderComparisonHelper.includeMacquarie(param);
    }
}