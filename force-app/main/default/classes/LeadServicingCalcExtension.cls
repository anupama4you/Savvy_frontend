public class LeadServicingCalcExtension {
	
    public ServicingCalculatorDTO dto {set;get;}
    private Lead__c record;
    
    public LeadServicingCalcExtension (ApexPages.StandardController controller) {
        record = (Lead__c)controller.getRecord();
        dto = new ServicingCalculatorDTO();
    }
    
    //Dropboxes Lenders
    public List<SelectOption> getLenderSelectValues() {
        List<SelectOption> r = new List<SelectOption>();
        for (String key: OppApplicationServCalculatorUtils.lenderMap.keySet()) {
            r.add(new SelectOption (key, OppApplicationServCalculatorUtils.lenderMap.get(key)));
        }
        return r;
    }
    //Dropboxes No Dependents
    public List<SelectOption> getNoDependentsSelectOptions() {
        List<SelectOption> r = new List<SelectOption>();
        Integer size = 6;
        //servCalcNoDependents = null;
        if ('GEO'.equals(dto.lender)) {
            size = 5;
        } else if ('MAC'.equals(dto.lender)) {
         	size = 3;   
        }
        r.add(new SelectOption ('', '--None--'));
        for (Integer i = 0; i <= size; i++) {
            r.add(new SelectOption (String.valueOf(i), String.valueOf(i)));
        }
        if (dto.noDependents != null) {
            if (dto.noDependents > size) {
                dto.noDependents = size;
            }
        }
        return r;
    }
    
    //Dropbox Other type income
    public List<SelectOption> getOtherIncomeTypeSelect() {
        List<SelectOption> r = new List<SelectOption>();
        List <String> values = new List<String> {
            'Rental Income', 'Child Support', 'Family part A & B', 'Rent Assistance', 
            'Parenting Payment single', 'Parenting Payment partnered', 'Newstart', 
            'Other'
        };
        r.add(new SelectOption ('', '--None--'));
        for (String v : values) {
            r.add(new SelectOption (v, v));
        }
        return r;
    }
    //Dropbox Loan Type Select
    public List<SelectOption> getLoanTypeSelect() {
        List<SelectOption> r = new List<SelectOption>();
        List <String> values = new List<String> {
            'Car Loan', 'Line of Credit', 'Mortgage', 'Payday Loan', 'Personal Loan'
        };
        r.add(new SelectOption ('', '--None--'));
        for (String v : values) {
            r.add(new SelectOption (v, v));
        }
        return r;
    }
    
    
    //Calculations:
    //Lender Living Expenses
    public PageReference servCalculateLivingExpenses () {
        servCalculateLivingExpenseValues();
        calculateSplitExpenses();
        return null;
    }
    
    private void servCalculateLivingExpenseValues() {
        //fillServCalcNoDependentsSelect();
        //System.debug(servCalcLender + '|' + servCalcType + '|' + servCalcNoDependents + '|' + servCalcState + '|' + servCalcArea);
        if (String.isBlank(dto.lender) || String.isBlank(dto.maritalStatus) || dto.noDependents == null) {
            dto.totLivingExpenses = 0.0;
        } else if ('GEO'.equals(dto.lender) && (String.isBlank(dto.state) || String.isBlank(dto.area))) {
            dto.totLivingExpenses = 0.0;
        } else {
            dto.totLivingExpenses = OppApplicationServCalculatorUtils.getLivingExpensesLender(dto);
            System.debug('totLivingExpenses >> ' + dto.totLivingExpenses);
        }
        
        servCalculateAmountAvalilableLoanPayment();
        servValidateMinRent();
		System.debug('servCalcTotLivingExpenses >> ' + dto.totLivingExpenses);
    }
    
    public PageReference calculateSplitExpenses() { 
        servCalculateTotalNetMonthlyIncome();
        return null;
    }
    
    public PageReference servCalculateTotalNetMonthlyIncome() {
        dto.totNetMonthlyIncome = 0;
        //Applicant 1
        if (dto.servCalcIncomePayFrecuency1 != null && dto.servCalcIncomeAmount1 != null) {
            dto.totNetMonthlyIncome = dto.servCalcIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcIncomePayFrecuency1);
        }
        if (dto.servCalcOtherIncomePayFrecuency1 != null && dto.servCalcOtherIncomeAmount1 != null) {
            dto.totNetMonthlyIncome += dto.servCalcOtherIncomeAmount1 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcOtherIncomePayFrecuency1);
        }
        
        //Applicant 2
        if (dto.servCalcIncomePayFrecuency2 != null && dto.servCalcIncomeAmount2 != null) {
            dto.totNetMonthlyIncome += dto.servCalcIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcIncomePayFrecuency2);
        }
        if (dto.servCalcOtherIncomePayFrecuency2 != null && dto.servCalcOtherIncomeAmount2 != null) {
            dto.totNetMonthlyIncome += dto.servCalcOtherIncomeAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcOtherIncomePayFrecuency2);
        }
        servCalculateAmountAvalilableLoanPayment();
        return null;
    }
 	
    private void servCalculateAmountAvalilableLoanPayment() {
        dto.totAmountLoanPayment = 0;
        if (dto.totNetMonthlyIncome != null) {
            dto.totAmountLoanPayment = dto.totNetMonthlyIncome;
        }
        if (dto.totLiabilities != null) {
            dto.totAmountLoanPayment -= dto.totLiabilities;
        }
        if (dto.totOtherDebts != null) {
            dto.totAmountLoanPayment -= dto.totOtherDebts;
        }
        calculateSplitExpensesTotals();
        if (dto.totRentMtgPaid != null) {
            dto.totAmountLoanPayment -= dto.splitRentMortgageTotal;
        }
        if (dto.totLivingExpenses != null) {
            dto.totAmountLoanPayment -= dto.splitLivingExpensesTotal;
            System.debug('servCalcSplitLivingExpensesTotal >> ' + dto.splitLivingExpensesTotal);
        }
        
    }
    
    private void calculateSplitExpensesTotals() {
        dto.splitNetPartIncomeTotal = 0.0;
        dto.splitRentMortgageTotal = dto.totRentMtgPaid;
        dto.splitLivingExpensesTotal = dto.totLivingExpenses;
        
        system.debug('calculateSplitExpensesTotals >> ' + dto.splittingExpenses + '|' + dto.getSingleJoint() + '|' + dto.splitLivingExpenses + '|' + dto.totLivingExpenses);
        
        if ('Yes'.equals(dto.splittingExpenses) && !'Single'.equalsIgnoreCase(dto.getSingleJoint())) {
            if (dto.partnerIncome != null) {
                //Net Partner's Income = Partner's income
                dto.splitNetPartIncomeTotal = dto.partnerIncome;
                Decimal tmp = 0.0;
                if (dto.splitRentMortgage) {
                    //Start with Rent/Mortgage
                    if (dto.totRentMtgPaid != null) {
                        tmp = dto.totRentMtgPaid/2;    
                    }
                    if (dto.splitNetPartIncomeTotal >= tmp) {
                        dto.splitRentMortgageTotal = tmp;
                        dto.splitNetPartIncomeTotal -= dto.splitRentMortgageTotal;
                    } else {
                        dto.splitRentMortgage = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Net Partner\'s Income isn\'t enough to split  Rent/Mortgage, please check that information and try again.'));
                    }
                }
                //Check for Living Expenses
                if (dto.splitLivingExpenses) {
                    tmp = 0.0;
                    Decimal tmpDiff = 0;
                    if (dto.totLivingExpenses != null && dto.noDependents != null) {
                        //tmp = ServCalcTotLivingExpenses/2;    
                        tmp = OppApplicationServCalculatorUtils.getLivingExpensesLender(
                              dto.lender, 'Single', dto.noDependents, dto.state, dto.area);
                        if (tmp > 0) {
                        	tmpDiff = dto.totLivingExpenses - tmp;
                            if (dto.splitNetPartIncomeTotal >= tmpDiff) {
                                dto.splitLivingExpensesTotal = tmp; 
                                dto.splitNetPartIncomeTotal -= tmpDiff;
                            } else {
                                dto.splitLivingExpenses = false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Net Partner\'s Income isn\'t enough to split  Living Expenses, please check that information and try again.'));
                            }
                        }
                    }
                    
                }
            }
        } else {
            dto.splitRentMortgage = false;
            dto.splitLivingExpenses = false;
            if (dto.partnerIncome != null) {
            	dto.splitNetPartIncomeTotal = dto.partnerIncome;
            }
        }
    }
    
    public PageReference servCalculateRentMtgePaid() {
        dto.totRentMtgPaid = 0;
        if (dto.servCalcRentPayFrecuency != null && dto.servCalcRentPayAmount != null) {
            dto.totRentMtgPaid = dto.servCalcRentPayAmount * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcRentPayFrecuency);
            servValidateMinRent();
        }
        servCalculateAmountAvalilableLoanPayment();
		return null;
    }
    
    public PageReference servCalculateLiabilities() {
        dto.totLiabilities = 0;
        if (dto.servCalcLoanPayFrecuency != null && dto.servCalcLoanPayAmount != null) {
            dto.totLiabilities = dto.servCalcLoanPayAmount * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcLoanPayFrecuency);
        }
        if (dto.servCalcLoanPayFrecuency2 != null && dto.servCalcLoanPayAmount2 != null) {
            dto.totLiabilities += dto.servCalcLoanPayAmount2 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcLoanPayFrecuency2);
        }
        if (dto.servCalcLoanPayFrecuency3 != null && dto.servCalcLoanPayAmount3 != null) {
            dto.totLiabilities += dto.servCalcLoanPayAmount3 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcLoanPayFrecuency3);
        }
        if (dto.servCalcLoanPayFrecuency4 != null && dto.servCalcLoanPayAmount4 != null) {
            dto.totLiabilities += dto.servCalcLoanPayAmount4 * OppApplicationServCalculatorUtils.getFrecuencyFactor(dto.servCalcLoanPayFrecuency4);
        }
        servCalculateAmountAvalilableLoanPayment();
		return null;
    }
    
    private void servValidateMinRent() {
            
        //Check Rent min
        Decimal min = OppApplicationServCalculatorUtils.getRentMinPerMonthLender(dto.lender, dto.getSingleJoint());
        if (min > 0.0 && dto.totRentMtgPaid > 0.0) {
            if (dto.totRentMtgPaid < min) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Minimum rent must be greater or equal to $' + min));
            }
        }
        
    }
    
    public PageReference servCalculateCentreLink () {
        
        if (dto.servCalcCLinkNetNonCentIncome != null) {
            dto.servCalcCLinkIncome = dto.servCalcCLinkNetNonCentIncome / 700 * 299;
            
            dto.servCalcCLinkTotalIncome = dto.servCalcCLinkNetNonCentIncome + dto.servCalcCLinkIncome;
            if (dto.servCalcCLinkTotalIncome > 0) {
                dto.servCalcCLinkIncomePercentage = dto.servCalcCLinkIncome / dto.servCalcCLinkTotalIncome * 100;
            } else {
                dto.servCalcCLinkIncomePercentage = null;
            }
            
            dto.servCalcCLinkAnnualToLoannet = dto.servCalcCLinkIncome * 12;
            
        } else {
            dto.servCalcCLinkTotalIncome = null;
            dto.servCalcCLinkIncomePercentage = null;
            dto.servCalcCLinkAnnualToLoannet = null;
        }
        
        return null;
    }
    
    private void servCalculateAllValues() {
        servCalculateCreditCard();
        servCalculateRentMtgePaid();
        servCalculateTotalNetMonthlyIncome();
        servCalculateLivingExpenseValues();
    }
    
    private boolean isServingCalculationDone() {
        servCalculateAllValues();
        Boolean r = true;
        if (dto.totNetMonthlyIncome == 0 || 
            dto.totAmountLoanPayment == 0 ||
            String.isBlank(dto.lender) ||
            String.isBlank(dto.maritalStatus) ||
           	dto.noDependents == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill mandatory fields before generating the Pdf.'));
            r = false;
        }
        //Validate Partner's income when  splitting expenses is Yes
        if ('Yes'.equalsIgnoreCase(dto.splittingExpenses) && (dto.partnerIncome == null || dto.partnerIncome <= 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill Partner\'s income.'));
            r = false;
        }
        //Validate Liabilities
        if (String.isNotBlank(dto.servCalcLoanType) && (String.isBlank(dto.servCalcLoanPayFrecuency) || dto.servCalcLoanPayAmount == null || dto.servCalcLoanPayAmount == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the first Loan Type: ' + dto.servCalcLoanType));
            r = false;
        } else if (String.isBlank(dto.servCalcLoanType) && (String.isNotBlank(dto.servCalcLoanPayFrecuency) || dto.servCalcLoanPayAmount > 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the first Loan Type and complete the liability'));
            r = false;
        }
        if (String.isNotBlank(dto.servCalcLoanType2) && (String.isBlank(dto.servCalcLoanPayFrecuency2) || dto.servCalcLoanPayAmount2 == null || dto.servCalcLoanPayAmount2 == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the second Loan Type: ' + dto.servCalcLoanType2));
            r = false;
        } else if (String.isBlank(dto.servCalcLoanType2) && (String.isNotBlank(dto.servCalcLoanPayFrecuency2) || dto.servCalcLoanPayAmount2 > 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the second Loan Type and complete the liability'));
            r = false;
        }
        if (String.isNotBlank(dto.servCalcLoanType3) && (String.isBlank(dto.servCalcLoanPayFrecuency3) || dto.servCalcLoanPayAmount3 == null || dto.servCalcLoanPayAmount3 == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the third Loan Type: ' + dto.servCalcLoanType3));
            r = false;
        } else if (String.isBlank(dto.servCalcLoanType3) && (String.isNotBlank(dto.servCalcLoanPayFrecuency3) || dto.servCalcLoanPayAmount3 > 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the third Loan Type and complete the liability'));
            r = false;
        }
        if (String.isNotBlank(dto.servCalcLoanType4) && (String.isBlank(dto.servCalcLoanPayFrecuency4) || dto.servCalcLoanPayAmount4 == null || dto.servCalcLoanPayAmount4 == 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill other fields to the fourth Loan Type: ' + dto.servCalcLoanType4));
            r = false;
        } else if (String.isBlank(dto.servCalcLoanType4) && (String.isNotBlank(dto.servCalcLoanPayFrecuency4) || dto.servCalcLoanPayAmount4 > 0)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a value to the fourth Loan Type and complete the liability'));
            r = false;
        }
        
        if ('GRE'.equals(dto.lender) && (dto.naf == null || dto.naf == 0)) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill a value for NAF field to estimate Living Expenses'));
            r = false;
        }

        return r;
    }
    
    public PageReference servCalculateCreditCard () {
        
        if (dto.servCalcCCardCreditLimit != null) {
            dto.servCalcCCardMonthlyPayment = dto.servCalcCCardCreditLimit * 0.03;
            dto.totOtherDebts = dto.servCalcCCardMonthlyPayment;
        } else {
            dto.servCalcCCardMonthlyPayment = null;
            dto.totOtherDebts = 0.0;
        }
        servCalculateAmountAvalilableLoanPayment();
        return null;
    }
 	
    
    public PageReference ServicingPdf2 () {
        
        if (!isServingCalculationDone()) {
            return null;
        }
        
        PageReference pdf = Page.LeadServicingCalcPdf;
        pdf.getParameters().put('id',record.Id);
        dto.lenderName = OppApplicationServCalculatorUtils.lenderMap.get(dto.lender);
        pdf.getParameters().put('OBJ_DATA', JSON.serialize(dto));
        
        QuotingToolHelper.attachPdfFile(record.Id, 'LeadServicingCal', pdf, false);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'The Pdf document has been generated.'));
     	return null;   
    }
    
}