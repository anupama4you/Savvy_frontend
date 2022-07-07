/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuFinancier web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuFinancier {

    public static testMethod void servicesFComAuFinRetRespMthd(){
    
        servicesFastrComAuFinancier.RetrieveFinanciersResponse_element servFComAFinRetRespTestRec = new servicesFastrComAuFinancier.RetrieveFinanciersResponse_element(); 
        servicesFastrComAuFinancierData.RetrieveFinanciersResponse servFComAFinRetFinanceRespTestRec = new servicesFastrComAuFinancierData.RetrieveFinanciersResponse();   
        servFComAFinRetRespTestRec.RetrieveFinanciersResult = servFComAFinRetFinanceRespTestRec;
    
    }
    
     public static testMethod void servicesFComAuRetFinMthd(){
    
        servicesFastrComAuFinancier.RetrieveFinanciers_element servFComARetFinTestRec = new servicesFastrComAuFinancier.RetrieveFinanciers_element();
        servFComARetFinTestRec.apiKey = '1CFEC356-2259-4E1B-B3BE-FE000EFF0387';
    
    }
    
}