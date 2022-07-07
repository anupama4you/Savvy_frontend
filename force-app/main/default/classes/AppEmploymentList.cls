public with sharing class AppEmploymentList {
	public String applicant {set;get;}
    public List<Application_Employment__c> data {set;get;}

    public AppEmploymentList() {
        data = new List<Application_Employment__c>();
    }
}