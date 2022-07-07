public with sharing class YTDDetailsController {
   
    public Id opportunityId {set;get;}
    //public Id applicationId {set;get;}
    public static final String APPTYPE_1 = 'Applicant 1';
    public static final String APPTYPE_1_2NDJOB = 'Applicant 1 Second Job';
    public static final String APPTYPE_2 = 'Applicant 2';
    public static final String APPTYPE_2_2NDJOB = 'Applicant 2 Second Job';
    private Map<String, YTD_Income__c> dataMap;
    private Map<String, Application_Employment__c> employmentMap;
    
    public YTDDetailsController(){
        
    }
    
    public YTD_Income__c getApp1() {
        return getApplicantType(APPTYPE_1);
    }
    
    public YTD_Income__c getApp2() {
        return getApplicantType(APPTYPE_2);
    }
    
    public YTD_Income__c getApp12ndJob() {
        return getApplicantType(APPTYPE_1_2NDJOB);
    }
    
    public YTD_Income__c getApp22ndJob() {
        return getApplicantType(APPTYPE_2_2NDJOB);
    }
    
    private YTD_Income__c getApplicantType(String appType) {
        data();
        return this.dataMap.get(appType);
    }
    
    private void data(){
        
        this.dataMap = new Map<String, YTD_Income__c>();
        // Load details
        List<YTD_Income__c> d = [Select Id, Annualised_Income__c, Applicant_Type__c, End_Date__c, Gross_Annual_Income__c,
                                 Gross_YTD_Income__c, Lender__c, Net_Monthly_Income__c, Opportunity__c, Start_Date__c,
                                 Type__c, Weeks__c, Gross_Net_Income__c, Last_Income_Frequency__c, Net_Annual_Income__c,
                                 Net_Income__c, Net_Last_Income__c, Net_Last_Monthly_Income__c, Comment__c, Employment_Start_Date__c,
                                 Net_YTD_Salary_Annually__c, Net_YTD_Salary_Monthly__c, Pay_Period_Annually__c,	Pay_Period_Monthly__c,
                                 Depreciation__c, Director_Salary__c, Interest__c, Net_Profit__c, Net_Profit_2__c, Sales__c,
                                 Self_Employed_Class__c, Self_Employed_Type__c, Trustees_Number__c, Net_Profit_Calc__c, Net_Profit_Calc_2__c,
                                 Net_Monthly_Income_2__c, Difference__c, Discounted__c, Monthly_Amount__c
                                 From YTD_Income__c Where Opportunity__c = :opportunityId];
        
        for (YTD_Income__c a : d) {
            this.dataMap.put(a.Applicant_Type__c, a);   
        }
        
    }
    
    public boolean getHasApplicant2(){
        /*
        List<Application__c> d = [Select No_of_People__c From Application__c Where Id = :applicationId];
        for (Application__c a : d) {
            if(a.No_of_People__c == 2){
                return true; 
            } 
        }
        return false;
        */
        data();
        if (this.dataMap.containsKey(APPTYPE_2)) {
            return true;
        }
        return false;
    }
    /*
    private void secondJob(){
        
        this.employmentMap = new Map<String, Application_Employment__c>();
        List<Application_Employment__c> d2 = [Select Applicant__c From Application_Employment__c 
                                              Where Application__c = :applicationId and Type__c = 'Second Job'];
        
        for (Application_Employment__c a : d2) {
            if(a.Applicant__c != null){
                if(a.Applicant__c.equals('1')){
                    this.employmentMap.put(APPTYPE_1_2NDJOB, a);
                }else{
                    this.employmentMap.put(APPTYPE_2_2NDJOB, a);
                }   
            }
        }
        
    }
    */
    
    public Boolean getHasSecondJob1(){
        /*
        secondJob();
        if (this.employmentMap.containsKey(APPTYPE_1_2NDJOB)) {
            return true;
        }
        return false;
        */
        data();
        if (this.dataMap.containsKey(APPTYPE_1_2NDJOB)) {
            return true;
        }
        return false;
    }
    
    public Boolean getHasSecondJob2(){
        /*
        secondJob();
        if (this.employmentMap.containsKey(APPTYPE_2_2NDJOB)) {
            return true;
        }
        return false;
        */
        data();
        if (this.dataMap.containsKey(APPTYPE_2_2NDJOB)) {
            return true;
        }
        return false;
    }
    
}