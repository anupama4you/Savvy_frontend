/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuData3 web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuData3 {

    public static testMethod void ServicesFastrComAuData3Test(){
    
        servicesFastrComAuData3 servFComADataTestRec = new servicesFastrComAuData3();
        
        servicesFastrComAuData3.FinanceDetails servFComADataFinanceDTestRec = new servicesFastrComAuData3.FinanceDetails();
            servFComADataFinanceDTestRec.AmountFinanced = 10000;
            servFComADataFinanceDTestRec.BallonAmount = 10000;
            servFComADataFinanceDTestRec.FinanceTerm = 1;
            servFComADataFinanceDTestRec.FinanceType = 'test';
            servFComADataFinanceDTestRec.FinancierId = 'e34e628b-22e3-4dd9-b890-cf577a345ed1'; 
            servFComADataFinanceDTestRec.FinancierName = 'Affordable Car Loans';

        servicesFastrComAuData3.Date_x servFComADataDateTestRec = new servicesFastrComAuData3.Date_x();
            servFComADataDateTestRec.Day = 1;
            servFComADataDateTestRec.Month = 1;
            servFComADataDateTestRec.Year = 2017;
    
    }
    
}