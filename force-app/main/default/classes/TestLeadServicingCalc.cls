@isTest
public class TestLeadServicingCalc {
	
    public static testMethod void testFrecuencyFactor(){
        Test_DataGeneratorHelper.createLead();
        
        PageReference pageRef = Page.LeadServicingCalc;
        pageRef.getParameters().put('id',Test_DataGeneratorHelper.tstLead.Id);
        Test.setCurrentPageReference(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead);
        LeadServicingCalcExtension ctr = new LeadServicingCalcExtension(sc);
        
        ctr.dto.lender = 'GEO';
        ctr.servCalculateLivingExpenses();
        ctr.dto.lender = 'ESA';
        ctr.dto.lenderName = 'Esanda';
        ctr.dto.maritalStatus = 'Single';
        ctr.dto.noDependents = 2;
        ctr.servCalculateLivingExpenses();
        ctr.dto.maritalStatus = 'De Facto';
        ctr.dto.splittingExpenses = 'Yes';
        ctr.dto.partnerIncome = 5000;
        ctr.dto.splitRentMortgage = false;
        ctr.dto.splitLivingExpenses = false;
		ctr.calculateSplitExpenses();
        ctr.ServicingPdf2();
        
        //Income
        ctr.dto.servCalcIncomePayFrecuency1 = 'Weekly';
        ctr.dto.servCalcIncomeAmount1 = 2500;
        ctr.dto.servCalcOtherIncomePayFrecuency1 = 'Weekly';
        ctr.dto.servCalcOtherIncomeType1 = 'Rental Income';
        ctr.dto.servCalcOtherIncomeAmount1 = 1000;
        
        ctr.dto.servCalcIncomePayFrecuency2 = 'Weekly';
        ctr.dto.servCalcIncomeAmount2 = 5500;
        ctr.dto.servCalcOtherIncomePayFrecuency2 = 'Weekly';
        ctr.dto.servCalcOtherIncomeType2 = 'Rental Income';
        ctr.dto.servCalcOtherIncomeAmount2 = 1000;
        
        ctr.dto.servCalcLoanType = 'type 1';
        ctr.dto.servCalcLoanType2 = 'type 2';
        ctr.dto.servCalcLoanType3 = 'type 3';
        ctr.dto.servCalcLoanType4 = 'type 4';
        ctr.ServicingPdf2();
        
        ctr.dto.servCalcLoanPayFrecuency = 'Weekly';
        ctr.dto.servCalcLoanPayFrecuency2 = 'Weekly';
        ctr.dto.servCalcLoanPayFrecuency3 = 'Weekly';
        ctr.dto.servCalcLoanPayFrecuency4 = 'Weekly';
        
        ctr.dto.servCalcLoanPayAmount = 1000;
        ctr.dto.servCalcLoanPayAmount2 = 1000;
        ctr.dto.servCalcLoanPayAmount3 = 1000;
        ctr.dto.servCalcLoanPayAmount4 = 1000;
        
        ctr.dto.servCalcRentPayFrecuency = 'Weekly';
        ctr.dto.servCalcRentPayAmount = 500;
        
        ctr.dto.servCalcCCardCreditLimit = null;
        ctr.servCalculateCreditCard();
        ctr.dto.servCalcCCardIssuer = 'ANZ';
        ctr.dto.servCalcCCardCreditLimit = 10000;
        ctr.dto.servCalcCCardAmountOwing = 600;
        
        
        ctr.dto.servCalcCLinkNetNonCentIncome = null;
        ctr.servCalculateCentreLink();
        ctr.dto.servCalcCLinkNetNonCentIncome = 10000;
        
        ctr.dto.splitRentMortgage = true;
        ctr.dto.splitLivingExpenses = true;
		
        
        //List
        ctr.getLenderSelectValues();
        ctr.getNoDependentsSelectOptions();
        ctr.getOtherIncomeTypeSelect();
        ctr.getLoanTypeSelect();
        
        //Actions
        ctr.servCalculateLivingExpenses();
        ctr.calculateSplitExpenses();
        ctr.servCalculateTotalNetMonthlyIncome();
        ctr.servCalculateLiabilities();
        ctr.servCalculateRentMtgePaid();
        ctr.servCalculateCreditCard();
        ctr.servCalculateCentreLink();
        
        ctr.ServicingPdf2();
        
        ctr.dto.getApplicantIncome1();
        ctr.dto.getApplicantIncome2();
        ctr.dto.getApplicantOtherIncome1();
        ctr.dto.getApplicantOtherIncome2();
        
        
        //Pdf
 		PageReference pageRef2 = Page.LeadServicingCalcPdf;
        pageRef2.getParameters().put('id',Test_DataGeneratorHelper.tstLead.Id);
        pageRef2.getParameters().put('OBJ_DATA', JSON.serialize(ctr.dto));
 		Test.setCurrentPageReference(pageRef2);       
        ApexPages.StandardController sc2 = new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead);
        LeadServicingCalcPdfExtension ctr2 = new LeadServicingCalcPdfExtension(sc2);
        
        pageRef2 = Page.LeadServicingCalcPdf;
        pageRef2.getParameters().put('id',Test_DataGeneratorHelper.tstLead.Id);
 		Test.setCurrentPageReference(pageRef2);       
        sc2 = new ApexPages.StandardController(Test_DataGeneratorHelper.tstLead);
        ctr2 = new LeadServicingCalcPdfExtension(sc2);
        
    }
    
    
    
}