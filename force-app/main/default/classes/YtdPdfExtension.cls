public with sharing class YtdPdfExtension {
    
    //Esanda
    public String startDate {get;set;}
    public String endDate {get;set;}
    public String ytdWeeks {get;set;}
    public String ytdIncome {get;set;}
    public String baseIncome {get;set;}
    public String netMonIncome {get;set;}
    public String monDifference {get;set;}
    public String baseTax {get;set;}
    public String baseMedi {get;set;}
    public String ytdMonIncome {get;set;}
    
    //Macquarie
    /*
    public String ytdMacNetYtdSalary {get;set;}
    public String ytdMacPayPeriodNetSalary {get;set;}
    public String ytdMacPayPeriodDays {get;set;}
    public String ytdMacMonthlyNetYtdSalary {get;set;}
    public String ytdMacAnnuallyNetYtdSalary {get;set;}
    public String ytdMacMonthlyPayPeriodNetSalary {get;set;}
    public String ytdMacAnnuallyPayPeriodNetSalary {get;set;}
    public String ytdMacComments {get;set;}
    */
    //Others
    public String annualIncome {get;set;}
    public String ytdTax {get;set;}
    public String ytdMedi {get;set;}
    public String discDiff {get;set;}
    public String outAmount {get;set;}
    
    /*
    public String annualisedIncome {get;set;}
    public String ytdMonthlyIncome {get;set;}
    public String baseMonthlyIncome {get;set;}
    public String monthlyDifference {get;set;}
    public String discountedDifference {get;set;}
    public String outputAmount {get;set;}*/
    
    public YTDCalculatorDTO dto {get;set;}
    public String lender {get;set;}
    
    public YtdPdfExtension (ApexPages.StandardController controller) {
        
        String objData = System.currentPageReference().getParameters().get('OBJ_DATA');
        System.debug(objData);
        if (objData != null) {
            dto = (YTDCalculatorDTO)JSON.deserialize(objData, YTDCalculatorDTO.class);
            lender = dto.ytdLender;
        } else {
            lender = 'Others';
            //Common
            startDate = System.currentPageReference().getParameters().get('Start Date');
            endDate = System.currentPageReference().getParameters().get('End Date');
            //Esanda
            ytdWeeks = System.currentPageReference().getParameters().get('YTD Weeks');
            ytdIncome = System.currentPageReference().getParameters().get('YTD Income');
            ytdIncome = '$' + ytdIncome;
            baseIncome = System.currentPageReference().getParameters().get('Base Income');
            baseIncome = '$' + baseIncome;
            monDifference = System.currentPageReference().getParameters().get('Difference');
            monDifference = '$' + monDifference;
            baseTax = System.currentPageReference().getParameters().get('Tax');
            baseTax = '$' + baseTax;
            baseMedi = System.currentPageReference().getParameters().get('Medicare');
            baseMedi = '$' + baseMedi;
            ytdMonIncome = System.currentPageReference().getParameters().get('YTD Income Monthly');
            ytdMonIncome = '$' + ytdMonIncome;
            netMonIncome = System.currentPageReference().getParameters().get('Base Income Monthly');
            netMonIncome = '$' + netMonIncome;
            discDiff = System.currentPageReference().getParameters().get('Discounted by 50');
            discDiff = '$' + discDiff;
            outAmount = System.currentPageReference().getParameters().get('Outgo Amount');
            outAmount = '$' + outAmount;
            //Macquarie
            /*
            ytdMacNetYtdSalary = System.currentPageReference().getParameters().get('Net YTD Salary');
            ytdMacNetYtdSalary = '$' + ytdMacNetYtdSalary;
            ytdMacPayPeriodNetSalary = System.currentPageReference().getParameters().get('Pay Period Net Salary');
            ytdMacPayPeriodNetSalary = '$' + ytdMacPayPeriodNetSalary;
            ytdMacPayPeriodDays = System.currentPageReference().getParameters().get('Pay Period');
            
            ytdMacMonthlyNetYtdSalary = System.currentPageReference().getParameters().get('Net YTD Salary Monthly');
            ytdMacMonthlyNetYtdSalary = '$' + ytdMacMonthlyNetYtdSalary;
            ytdMacAnnuallyNetYtdSalary = System.currentPageReference().getParameters().get('Net YTD Salary Annually');
            ytdMacAnnuallyNetYtdSalary = '$' + ytdMacAnnuallyNetYtdSalary;
            
            ytdMacMonthlyPayPeriodNetSalary = System.currentPageReference().getParameters().get('Pay Period Net Salary Monthly');
            ytdMacMonthlyPayPeriodNetSalary = '$' + ytdMacMonthlyPayPeriodNetSalary;
            ytdMacAnnuallyPayPeriodNetSalary = System.currentPageReference().getParameters().get('Pay Period Net Salary Annually');
            ytdMacAnnuallyPayPeriodNetSalary = '$' + ytdMacAnnuallyPayPeriodNetSalary;
            
            ytdMacComments = System.currentPageReference().getParameters().get('Comments');
            */
            //Others
            annualIncome = System.currentPageReference().getParameters().get('Annualised Income');
            annualIncome = '$' + annualIncome;
            ytdTax = System.currentPageReference().getParameters().get('YTD Tax');
            ytdTax = '$' + ytdTax;
            ytdMedi = System.currentPageReference().getParameters().get('Medicare Levy');
            ytdMedi = '$' + ytdMedi;
            
            
        }
        /*
        ytdIncome = System.currentPageReference().getParameters().get('YTD Income');
        ytdIncome = '$' + ytdIncome;
        baseIncome = System.currentPageReference().getParameters().get('Base Income');
        baseIncome = '$' + baseIncome;
        annualisedIncome = System.currentPageReference().getParameters().get('Annualised Income');
        annualisedIncome = '$' + annualisedIncome;
        ytdMonthlyIncome = System.currentPageReference().getParameters().get('YTD Monthly Income');
        ytdMonthlyIncome = '$' + ytdMonthlyIncome;
        baseMonthlyIncome = System.currentPageReference().getParameters().get('Base Monthly Income');
        baseMonthlyIncome = '$' + baseMonthlyIncome;
        monthlyDifference = System.currentPageReference().getParameters().get('Monthly Difference');
        monthlyDifference = '$' + monthlyDifference;
        discountedDifference = System.currentPageReference().getParameters().get('Discounted Difference');
        discountedDifference = '$' + discountedDifference;
        outputAmount = System.currentPageReference().getParameters().get('Output Amount');
        outputAmount = '$' + outputAmount;
		*/
    }

}