/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuError web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuFinancierData {
    
    public static testMethod void ServicesFastrComAuFinancierDataMthd(){
    
        servicesFastrComAuFinancierData.RetrieveFinanciersResponse servFComAFinDataTestRec = new servicesFastrComAuFinancierData.RetrieveFinanciersResponse (); 
        servicesFastrComAuFinancierData.ArrayOfFinancier servFComAArrayOfFinTestRec = new servicesFastrComAuFinancierData.ArrayOfFinancier();   
        servFComAFinDataTestRec.Financiers = servFComAArrayOfFinTestRec;
         
        servicesFastrComAuFinancierData.Financier servFComAFinDataFinancrTestRec = new servicesFastrComAuFinancierData.Financier();
        servFComAFinDataFinancrTestRec.Id = 'test';
        servFComAFinDataFinancrTestRec.Name = 'test';
        
        servicesFastrComAuFinancierData.ArrayOfFinancier servFComAFinDataArryOfFinTestRec = new servicesFastrComAuFinancierData.ArrayOfFinancier();  
        servicesFastrComAuFinancierData.Financier[] servFComAFinancrTestRec = new servicesFastrComAuFinancierData.Financier[]{};  
        servFComAFinDataArryOfFinTestRec.Financier = servFComAFinancrTestRec; 

    }
    
}