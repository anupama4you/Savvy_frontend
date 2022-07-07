@isTest(SeeAllData=true)
public class TestNPSReports extends TestAPILenders{
    
    public static Custom_Opportunity__c opp;
    
    public static testMethod void testGeneral() {
        Test.startTest();
        opp = loadData();
        opp.Status__c = 'Settled';
        opp.Date_closed_or_settled__c = Date.today();
        opp.NPS__c = 9;
        update opp;
        NPSConsultantReportController npsRep = new NPSConsultantReportController();
        NPSReportController nps = new NPSReportController();
        nps.rangedate = '1';
        nps.executeReport();
        nps.executeReportConsultant();
        nps.getResultReportService();
        nps.getResultReportAdmin();
        
        nps.rangedate = '2';
        nps.datbeg = System.today() - 3000;
        nps.datend = System.today();
        nps.executeReport();
        nps.executeReportConsultant();
        nps.getResultReportService();
        nps.getResultReportAdmin();
        
        nps.getItems();
        nps.getUserId();
        
        nps.total.getNpsscore(3,1);
        nps.total.getPorcent (8,1);
        Test.stopTest();
    }
}