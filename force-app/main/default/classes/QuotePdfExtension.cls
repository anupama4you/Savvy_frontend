public with sharing class QuotePdfExtension {
    
    //public Custom_Opportunity__c Opp;
    //public String [] applicants;
    //public String applicant1;
    //public String applicant2;
    
    public String financedAmount {get;set;}
    public String clientRate {get;set;}
    public String residualValue {get;set;}
    public String monthlyPayment {get;set;}
    public String fortnightlyPayment {get;set;}
    public String weeklyPayment {get;set;}
    //public String termYear {get;set;}
    public String interestRate {get;set;}
    
    public QuotePdfExtension (ApexPages.StandardController controller) {
        //this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        financedAmount = System.currentPageReference().getParameters().get('Financed Amount');
        financedAmount = '$' + financedAmount;
        clientRate = System.currentPageReference().getParameters().get('Client Rate');
        clientRate = clientRate + '%';
        residualValue = System.currentPageReference().getParameters().get('Residual Value');
        residualValue = '$' + residualValue;
        monthlyPayment = System.currentPageReference().getParameters().get('Monthly Payment');
        monthlyPayment = '$' + monthlyPayment;
        fortnightlyPayment = System.currentPageReference().getParameters().get('Fortnightly Payment');
        fortnightlyPayment = '$' + fortnightlyPayment;
        weeklyPayment = System.currentPageReference().getParameters().get('Weekly Payment');
        weeklyPayment = '$' + weeklyPayment;
        interestRate = System.currentPageReference().getParameters().get('Interest Rate');
        interestRate = interestRate + '%';
    }
    
    /*private static String [] getApplicants (String oppName) {
        String [] Applicants = new List <String> ();
        return Applicants;
    }*/
}