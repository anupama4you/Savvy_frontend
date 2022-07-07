public with sharing class LenderComparisonHelper {

	public static final String TIER_1 = 'Tier 1';
	public static final String TIER_2 = 'Tier 2';
	public static final String TIER_3 = 'Tier 3';

	public static Boolean includeRateSetter(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if ('Car'.equals(param.assetDetail) && 'Clean History'.equals(param.creditHistory) && (param.loanTerm == 36 || param.loanTerm == 60 || param.loanTerm == 84) && param.getNetVehiclePrice() <= 100000 && param.residual == 0.00) {
            if ('Consumer Loan'.equals(param.loanType)) {
                if (('Dealer'.equals(param.purchaseType) || 'Private'.equals(param.purchaseType) || 'Refinance'.equals(param.purchaseType)) &&
				   ('Full-Time'.equals(param.employmentType) || 
				   	 'Permanent Part-Time'.equals(param.employmentType) || 
				   	 'Casual < 12 months'.equals(param.employmentType) || 
				   	 'Casual > 12 months'.equals(param.employmentType) || 
				   	 'Self employed (Full-Doc)'.equals(param.employmentType))) {
                        Integer age = Integer.valueOf(param.ageCar);
                            if (age < 8) {
                                if('525 - 599'.equals(param.creditScore) || '600 - 749'.equals(param.creditScore) || '750+'.equals(param.creditScore)){
                                    r = true;
                                }
                            }
				}
			}
		}
		return r;
	}

	public static Boolean includeFirstmac(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if ('Car'.equals(param.assetDetail) && 'Clean History'.equals(param.creditHistory) && '12 Years'.equals(param.termEnd) && (param.loanTerm == 36 || param.loanTerm == 48 || param.loanTerm == 60)) {
			if ('Dealer'.equals(param.purchaseType)) {
				if ('Consumer Loan'.equals(param.loanType) && 
				   ('Full-Time'.equals(param.employmentType) || 'Permanent Part-Time'.equals(param.employmentType) || 'Casual > 12 months'.equals(param.employmentType) || 'Self employed (Full-Doc)'.equals(param.employmentType))) {
					r = true;
				} else if ('Full-Doc Chattel Mortgage'.equals(param.loanType) && 'Self employed (Full-Doc)'.equals(param.employmentType)) {
					r = true;
				} else if ('Low-Doc Chattel Mortgage'.equals(param.loanType) && 'Self employed (Low-Doc)'.equals(param.employmentType)) {
					r = true;
				}
			} else if ('Refinance'.equals(param.purchaseType)) {
				if ('Consumer Loan'.equals(param.loanType) &&
				   ('Full-Time'.equals(param.employmentType) || 
				   	 'Permanent Part-Time'.equals(param.employmentType) || 
				   	 'Casual > 12 months'.equals(param.employmentType) || 
				   	 'Self employed (Full-Doc)'.equals(param.employmentType) ||
				   	 'Self employed (Low-Doc)'.equals(param.employmentType))) {
					r = true;
				} else if ('Full-Doc Chattel Mortgage'.equals(param.loanType) &&
				   ('Full-Time'.equals(param.employmentType) || 
				   	 'Permanent Part-Time'.equals(param.employmentType) || 
				   	 'Casual > 12 months'.equals(param.employmentType) || 
				   	 'Self employed (Full-Doc)'.equals(param.employmentType))) {
					r = true;
				} else if ('Low-Doc Chattel Mortgage'.equals(param.loanType) && 
				   ('Full-Time'.equals(param.employmentType) || 
				   	 'Permanent Part-Time'.equals(param.employmentType) || 
				   	 'Casual > 12 months'.equals(param.employmentType) || 
				   	 'Self employed (Low-Doc)'.equals(param.employmentType))) {
					r = true;
				}
			}
		}
        if(r){
            if(!((param.loanTerm == 36 || param.loanTerm == 48 || param.loanTerm == 60) && Integer.valueOf(param.ageCar) <= 7)){
                r = false;
            }
        }
		return r;
	}

	public static Boolean includeAFSConsumer(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) 
            return r;
		Integer vAge = Integer.valueOf(param.ageCar) + (param.loanTerm/12);
		if ((('Car'.equals(param.assetDetail) && '12 Years'.equals(param.termEnd)) || 
             'Boat'.equals(param.assetDetail) || 'Caravan'.equals(param.assetDetail) || 
             ('Motorbike'.equals(param.assetDetail) && 'Property Owner'.equals(param.residentialStatus)) && 'Clean History'.equals(param.creditHistory))) {
            
             if ('Consumer Loan'.equals(param.loanType) && ('Dealer'.equals(param.purchaseType) || 
                'Private'.equals(param.purchaseType))  && ('Full-Time'.equals(param.employmentType) || 
			   	 'Permanent Part-Time'.equals(param.employmentType) || 
			   	 'Casual < 12 months'.equals(param.employmentType) || 
			   	 'Casual > 12 months'.equals(param.employmentType) || 
			   	 'Self employed (Full-Doc)'.equals(param.employmentType))) {
					r = true;
			}
		}
		return r;
	}

	public static Boolean includeAFSCommercial(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if (('Car'.equals(param.assetDetail) || 'Motorbike'.equals(param.assetDetail)) && 'Clean History'.equals(param.creditHistory)) {
			if ('Full-Doc Chattel Mortgage'.equals(param.loanType) && ('Dealer'.equals(param.purchaseType) || 'Private'.equals(param.purchaseType)) 
                && 'Self employed (Full-Doc)'.equals(param.employmentType) && 'Property Owner'.equals(param.residentialStatus)) {
				r = true;
			}  else if ('Low-Doc Chattel Mortgage'.equals(param.loanType) && 'Dealer'.equals(param.purchaseType) &&
				   	   'Self employed (Low-Doc)'.equals(param.employmentType) && 'Property Owner'.equals(param.residentialStatus)) {
				r = true;
			}
		}
        
        if((param.loanTerm == 12 || param.loanTerm == 24 || param.loanTerm == 36 || 
           param.loanTerm == 48  || param.loanTerm == 60) && !'Consumer Loan'.equals(param.loanType)){
            r = true;    
        }else{
            r = false;
        }
        
		return r;
	}

	public static Boolean includeLatitude(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		Integer vAge = Integer.valueOf(param.ageCar) + (param.loanTerm/12);
		if ((('Car'.equals(param.assetDetail) && '12 Years'.equals(param.termEnd)) || 
		   ('Motorbike'.equals(param.assetDetail) || 'Boat'.equals(param.assetDetail) || 'Caravan'.equals(param.assetDetail))) && 
			 'Clean History'.equals(param.creditHistory) && 'Dealer'.equals(param.purchaseType)) {
			if ('Consumer Loan'.equals(param.loanType) && (('Dealer'.equals(param.purchaseType) && vAge <= 20) || ('Private'.equals(param.purchaseType) && vAge < 15))  &&
			   ('Full-Time'.equals(param.employmentType) || 
			   	 'Permanent Part-Time'.equals(param.employmentType) || 
			   	 'Casual > 12 months'.equals(param.employmentType) || 
			   	 'Self employed (Full-Doc)'.equals(param.employmentType))) {
				r = true;
			}
		}
		return r;
	}

	public static Boolean includePepper5Oh(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		Integer age = Integer.valueOf(param.ageCar);
		if ('Car'.equals(param.assetDetail) && 'Clean History'.equals(param.creditHistory) && 
			'Dealer'.equals(param.purchaseType) && 'Full-Time'.equals(param.employmentType) &&
			('Property Owner'.equals(param.residentialStatus) || param.residentialStatus.contains('Renting')) && age <= 5) {
			r = true;
		}
		return r;
	}

	public static Boolean includePepperMV(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		//Integer age = Integer.valueOf(param.ageCar);
		if (('Car'.equals(param.assetDetail) || 'Caravan'.equals(param.assetDetail)) && 'Clean History'.equals(param.creditHistory) && 
			('Dealer'.equals(param.purchaseType) || 'Private'.equals(param.purchaseType)) && 
            ('Full-Time'.equals(param.employmentType) || 'Permanent Part-Time'.equals(param.employmentType) || 'Self employed (Full-Doc)'.equals(param.employmentType))) {
				r = true;
		}
		//if ('Car'.equals(param.assetDetail) && 'Clean History'.equals(param.creditHistory) && age > 5 && 
		//	  'Dealer'.equals(param.purchaseType) && 'Full-Time'.equals(param.employmentType)) {
		//		r = true;
		//}
		return r;
	}

	public static Boolean includePepperLeisure(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) 
            return r;
		if (validateAssetDetailPepperLeisure(param.assetDetail) && 'Clean History'.equals(param.creditHistory) &&  
			validatePurchaseTypePepperLeisure(param.purchaseType) && validateLoanTypePepperLeisure(param.loanType) &&
			validateEmploymentTypePepperLeisure(param.employmentType)) {
			r = true;
		}
		return r;
	}

	public static Boolean includePepperSummer(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		Integer age = Integer.valueOf(param.ageCar);
		if (('Caravan'.equals(param.assetDetail) || 'Boat'.equals(param.assetDetail)) && 'Clean History'.equals(param.creditHistory) && age == 0 && 
			'Dealer'.equals(param.purchaseType) && 'Consumer Loan'.equals(param.loanType) &&
			('Full-Time'.equals(param.employmentType) || 
		   	 'Permanent Part-Time'.equals(param.employmentType) || 
		   	 'Casual > 12 months'.equals(param.employmentType) || 
		   	 'Self employed (Full-Doc)'.equals(param.employmentType))) {
			r = true;
		}
		return r;
	}

	public static Boolean includeLibertyDrive(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if ('Car'.equals(param.assetDetail) && 'Clean History'.equals(param.creditHistory) 
            && !'12 Years'.equals(param.termEnd) && 'Dealer'.equals(param.purchaseType) 
            && 'Property Owner'.equals(param.residentialStatus) && param.loanTerm >= 24) {
                if (String.isNotBlank(param.employmentType) && !param.employmentType.contains('Casual')) {
                    r = true;
                }
		}
		return r;
	}
	
	public static Set<String> includePaydayLoanLenders(LenderComparisonFilterExtension.FilterParams param) {
		Set<String> r = new Set<String>();
		if (param == null) return r;
		Integer age = Integer.valueOf(param.ageCar);
		if ('Y'.equals(param.hasPayday) && !'Personal Loan'.equals(param.loanType)) {
			if ('Clean History'.equals(param.creditHistory)) {
				if ('Motorbike'.equals(param.assetDetail)) {
                    if(includeYamaha(param)){
                    	r.add(YamahaMarineCalculatorExtension.LENDER_QUOTING);
                    }
					r.add(LatitudeCalculatorExtension.LENDER_QUOTING);
					if ('Consumer Loan'.equals(param.loanType)) {
						r.add(MacquarieConsumerExtension.LENDER_QUOTING);
					} else {
						r.add(MacquarieCommercialExtension.LENDER_QUOTING);
					}
				} else {
					r.add(LibertyDriveExtension.LENDER_QUOTING);
					//r.add(LibertyOptionsExtension.LENDER_QUOTING);
					if ((param.loanTerm == 36 || param.loanTerm == 60 || param.loanTerm == 84) && param.getNetVehiclePrice() <= 60000 && age < 8) {
                        if('525 - 599'.equals(param.creditScore) || '600 - 749'.equals(param.creditScore) || '750+'.equals(param.creditScore) || param.creditScore == null){
                        	r.add(RateSetterCalculatorExtension.LENDER_QUOTING);
                        }
					}
				}
                if(('Motorbike'.equals(param.assetDetail) && 'Property Owner'.equals(param.residentialStatus)) || 'Boat'.equals(param.assetDetail)){
                    if ('Consumer Loan'.equals(param.loanType)) {
						r.add(AfsCalculatorExtension.LENDER_QUOTING);
					} else {
                        if((param.loanTerm == 12 || param.loanTerm == 24 || param.loanTerm == 36 || 
           					param.loanTerm == 48  || param.loanTerm == 60) && !'Consumer Loan'.equals(param.loanType)){
                            r.add(AfsCommercialCalculatorExtension.LENDER_QUOTING);   
                        }
					}
                }
			}
            
            if('Motorbike'.equals(param.assetDetail)){
            	if(param.loanTerm >= 12 && param.loanTerm <= 48){
                	r.add(GreenLightCalculatorExtension.LENDER_QUOTING);
            	}	    
            }else{
                r.add(GreenLightCalculatorExtension.LENDER_QUOTING);
            }
            
			r.add(FinanceOneExtension.LENDER_QUOTING);
            param = getMoney3RiskGrade(param);
            if (includeMoney3(param)) {
                r.add(Money3CalculatorExtension.LENDER_QUOTING);
            }
		}
		return r;
	}

	public static Set<String> includePersonalLoans(LenderComparisonFilterExtension.FilterParams param) {
		Set<String> r = new Set<String>();
		if (param == null) return r;
		if ('Personal Loan'.equals(param.loanType)) {
			if ('Clean History'.equals(param.creditHistory)) {
                if (param.loanTerm >= 6 && param.loanTerm <= 60){
					r.add(RatesetterPLExtension.LENDER_QUOTING);
				}
				r.add(NowFinanceCalculatorExtension.LENDER_QUOTING);
				r.add(LatitudePersonalCalculatorExtension.LENDER_QUOTING);
				if (param.loanTerm == 36 || param.loanTerm == 60){
					r.add(WisrCalculatorExtension.LENDER_QUOTING);
				}
			} else {
                param = getMoney3RiskGrade(param);
				if (includeMoney3(param)) {
					r.add(Money3CalculatorExtension.LENDER_QUOTING);
				}
			}
		}
		return r;
	}

	public static Boolean includeMoney3(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
        Decimal loanAmount = param.price - param.deposit;
        
        if (param == null) 
            return r;
        if('Consumer Loan'.equals(param.loanType) && !'Personal'.equals(param.assetDetail)){
            if(loanAmount >= 2000 && loanAmount <= 8000 && 'Micro Motor'.equals(param.riskGrade)){
                if(param.loanTerm == 24 || param.loanTerm == 36){
                	r = true;        
                }
            }
            if(loanAmount >= 8001 && loanAmount <= 50000 && !'Micro Motor'.equals(param.riskGrade)){
                if(param.loanTerm == 36 || param.loanTerm == 48 || param.loanTerm == 60){
                	r = true;        
                }
            }
        }else if('Personal Loan'.equals(param.loanType)){
            if(loanAmount >= 2000 && loanAmount <= 5000 && 'Mini PL'.equals(param.riskGrade)){
                if(param.loanTerm == 12 || param.loanTerm == 24){
                	r = true;        
                }
            }
            if(loanAmount >= 5001 && loanAmount <= 12000 && !'Mini PL'.equals(param.riskGrade)){
                if(param.loanTerm == 24 || param.loanTerm == 36){
                	r = true;        
                }
            }
        }
		return r;
	}

	public static Set<String> includeTruckLenders(LenderComparisonFilterExtension.FilterParams param) {
		Set<String> r = new Set<String>();
		if (param == null) return r;
		if ('Truck'.equals(param.assetDetail) && 'Low-Doc Chattel Mortgage'.equals(param.loanType) && 
			'Self employed (Low-Doc)'.equals(param.employmentType)) {
			Integer age = Integer.valueOf(param.ageCar);
			if ('Clean History'.equals(param.creditHistory) && 'Dealer'.equals(param.purchaseType) && 
				age <= 7 && 'Property Owner'.equals(param.residentialStatus)) {
				r.add(EsandaCommercialExtension.LENDER_QUOTING);
				r.add(MacquarieCommercialExtension.LENDER_QUOTING);
				r.add(MetroCalculatorExtension.LENDER_QUOTING);
			}
			r.add(FinanceOneExtension.LENDER_QUOTING);
		} else if ('Truck'.equals(param.assetDetail) && 'Full-Doc Chattel Mortgage'.equals(param.loanType) && 
			'Self employed (Full-Doc)'.equals(param.employmentType)) {
			Integer age = Integer.valueOf(param.ageCar);
			if ('Clean History'.equals(param.creditHistory) && 'Dealer'.equals(param.purchaseType) && 
				age <= 7) {
				r.add(EsandaCommercialExtension.LENDER_QUOTING);
				r.add(MacquarieCommercialExtension.LENDER_QUOTING);
				r.add(MetroCalculatorExtension.LENDER_QUOTING);
			}
		}
		return r;
	}

	public static Boolean excludeLibertyDrive(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		/*if (!'Property Owner'.equals(param.residentialStatus) || (param.jobsLast3Years != null && param.jobsLast3Years > 2) ||
			'Y'.equals(param.hasEnquiries)) {
			r = true;
		}*/
        if(param.loanTerm <= 23 || 'Motorbike'.equals(param.assetDetail)){
            r = true;
        }
		return r;
	}

	public static Boolean excludeAnyPepper(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if ('Casual < 12 months'.equals(param.employmentType) || 'Y'.equals(param.hasPayday)) {
			r = true;
		}
        if ('Caravan'.equals(param.assetDetail) || 'Boat'.equals(param.assetDetail)) {
        	Integer age = Integer.valueOf(param.ageCar) + (param.loanTerm/12);
        	if (age > 15) {
        		r = true;		
        	}
        }
		return r;
	}

	public static Boolean excludeAnyMacquarie(LenderComparisonFilterExtension.FilterParams param) {
		Boolean r = false;
		if (param == null) return r;
		if ('Y'.equals(param.hasPayday) && !'Motorbike'.equals(param.assetDetail)) {
			r = true;
		}
        Integer year = Date.today().year() - Integer.valueOf(param.ageCar);
        if('Motorbike'.equals(param.assetDetail) && 'N'.equals(param.hasVerifiableCredit)){
            r = true;
        }
        if('Motorbike'.equals(param.assetDetail) && year <= (Date.today().year()-4)){
            r = true;
        }
		return r;
	}

	public static void calculatePricingStrategy(LenderComparisonFilterExtension.FilterParams param) {
		String tier = null;

		Integer age = Integer.valueOf(param.ageCar);
		Integer appAge = 0;
		if (param.applicantAge != null) {
			appAge = param.applicantAge;
		}
		if ('Clean History'.equals(param.creditHistory)) {
			// Tier 1: Platinum
			if ((appAge == 0 || appAge >= 27) && age <= 3) {
				if ((('Property Owner'.equals(param.residentialStatus) || (param.residentialStatus.contains('Renting') && !param.employmentType.contains('Self employed'))) || ('Property Owner'.equals(param.residentialStatus) && 'Self employed (Low-Doc)'.equals(param.employmentType)) && !param.employmentType.contains('Casual'))) {
					tier = TIER_1;
					//if (param.annualIncome > 0.00 && param.annualIncome < 65000) {
					//	tier = TIER_2;
					//}
					if (String.isNotBlank(param.creditScore) && !('600 - 749'.equals(param.creditScore) || '750+'.equals(param.creditScore))) {
						tier = TIER_2;
					}
					if (param.jobsLast3Years > 2) {
						tier = TIER_2;
					}
					if ('N'.equals(param.hasVerifiableCredit)) {
						tier = TIER_2;
					}
				} else {
					tier = TIER_2;
				}
			} else {
				// Tier 2: Gold
				tier = TIER_2;
			}
		} else {
			// Tier 3: Bronze
			tier = TIER_3;
		}
		param.tier = tier;
	}

    public static Boolean includeYamaha(LenderComparisonFilterExtension.FilterParams param){
        Boolean r = false;
        if(('Motorbike'.equals(param.assetDetail) || 'Boat'.equals(param.assetDetail)) && 'Property Owner'.equals(param.residentialStatus)){
            if(param.loanTerm >= 24 && param.loanTerm <= 72){
            	r = true;    
            }
        }
        return r;
    }
    
    public static Boolean excludeYamaha(LenderComparisonFilterExtension.FilterParams param){
        Boolean r = false;
        if('Motorbike'.equals(param.assetDetail) || 'Boat'.equals(param.assetDetail)){
            if('Property Owner'.equals(param.residentialStatus)){
                if(param.loanTerm < 24 || param.loanTerm > 72){
                    r = true;
                }    
            }else{
                r = true;
            }
        }
        return r;
    }
    
    public static Boolean includeMacquarie(LenderComparisonFilterExtension.FilterParams param){
        Boolean r = false;
        if ('Private'.equals(param.purchaseType) && ('Motorbike'.equals(param.assetDetail) || 'Caravan'.equals(param.assetDetail)) &&  
            ('Full-Time'.equals(param.employmentType) || 
             'Permanent Part-Time'.equals(param.employmentType) || 
             'Casual < 12 months'.equals(param.employmentType) || 
             'Casual > 12 months'.equals(param.employmentType) || 
             'Self employed (Full-Doc)'.equals(param.employmentType))) {
                 r = true;
             }
        return r;
    }
    
    //Yohan VillaLeal                            2019-08-06 
    public static Decimal getMoney3LoanAmount(LenderComparisonFilterExtension.FilterParams param) {
        Decimal r = 0.0;
        if (param.price != null) { 
            r += param.price;
        }
        if (!'Personal Loan'.equals(param.loanType)) {
            r -= param.deposit;
        }
        return r;
    }
    
    public static LenderComparisonFilterExtension.FilterParams getMoney3RiskGrade(LenderComparisonFilterExtension.FilterParams param){
        if(LenderComparisonHelper.TIER_1.equals(param.tier) || param.tier==null){
       		if('<400'.equals(param.creditScore) || '400 - 524'.equals(param.creditScore)){
                param.riskGrade = 'Bronze';
            }else if('525 - 599'.equals(param.creditScore)){
                param.riskGrade = 'Silver';
            }else if('600 - 749'.equals(param.creditScore)){
                param.riskGrade = 'Gold';
            }else if('750+'.equals(param.creditScore)){
                param.riskGrade = 'Platinum';
            }
        }else if(LenderComparisonHelper.TIER_2.equals(param.tier)){
            if('<400'.equals(param.creditScore) || '400 - 524'.equals(param.creditScore)){
                param.riskGrade = 'Bronze';
            }else if('525 - 599'.equals(param.creditScore)){
                param.riskGrade = 'Silver';
            }else if('600 - 749'.equals(param.creditScore) || '750+'.equals(param.creditScore)){
                param.riskGrade = 'Gold';
            }
        }else if(LenderComparisonHelper.TIER_3.equals(param.tier)){
            param.riskGrade = 'Bronze';
        }
        /*
        else if('Silver'.equals(param.riskGrade)){
            if('<400'.equals(param.creditScore) || '400 - 524'.equals(param.creditScore)){
                param.riskGrade = 'Bronze';
            }
        }   
        */
        Decimal term = Decimal.valueOf(param.loanTerm);
        Decimal totalAmount = getMoney3LoanAmount(param);

        if('Consumer Loan'.equals(param.loanType) && !'Personal'.equals(param.assetDetail)){
            if(totalAmount >= 2000 && totalAmount <= 8000){
                if(term >= 24 && term <= 36){ 
                    param.riskGrade = 'Micro Motor';
                }
            }
            param.customerProfile = 'Asset Finance';
        }else if('Personal Loan'.equals(param.loanType)){
            if(totalAmount >= 2000 && totalAmount <= 5000){
                if(term >= 12 && term <= 24){ 
                    param.riskGrade = 'Mini PL';
                }
            }
            param.customerProfile = 'Personal Finance';
        }
        return param;
    }
    // Yohan VillaLeal                                 2019-08-06
    //
    //Yohan VillaLeal                  2019-08-12
    public static Boolean validateLoanTypePepperLeisure(String loanType){
        if('Consumer Loan'.equals(loanType) || 
           'Full-Doc Chattel Mortgage'.equals(loanType) || 
           'Low-Doc Chattel Mortgage'.equals(loanType)){
            return true;
        }
        return false;
    }
    
    public static boolean validateEmploymentTypePepperLeisure(String employmentType){
        if('Full-Time'.equals(employmentType) || 
		   'Permanent Part-Time'.equals(employmentType) || 
		   'Casual > 12 months'.equals(employmentType) || 
           'Self employed (Full-Doc)'.equals(employmentType) ||
           'Self employed (Low-Doc)'.equals(employmentType)){
               return true;
           }
        return false;
    }
    
    public static boolean validatePurchaseTypePepperLeisure(String purchaseType){
        if('Dealer'.equals(purchaseType) || 'Private'.equals(purchaseType)){
      		return true;      
        }
        return false;
    }
    
    public static boolean validateAssetDetailPepperLeisure(String assetDetail){
        if('Boat'.equals(assetDetail) || 'Motorbike'.equals(assetDetail)){
            return true;
        }
        return false;
    }
    //-
}