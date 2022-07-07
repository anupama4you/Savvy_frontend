@isTest(SeeAllData=true)
public class TestYTDDetailsController {
    public static testMethod void TestYTDDetailsController(){
        YTDDetailsController o = new YTDDetailsController();
        Test_DataGeneratorHelper.createOpportunity();
        TestYTDCalculator.createIncomeYTD('Esanda');
        o.opportunityId = Test_DataGeneratorHelper.tstOpportunity.Id;
        o.getApp1();
        o.getApp2();
        o.getApp12ndJob();
        o.getApp22ndJob();
        o.getHasApplicant2();
        o.getHasSecondJob1();
        o.getHasSecondJob2();
        o = new YTDDetailsController();
        o.getHasApplicant2();
        o.getHasSecondJob1();
        o.getHasSecondJob2();
    }
}