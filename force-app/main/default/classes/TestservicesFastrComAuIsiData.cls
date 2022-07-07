/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuIsiData web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuIsiData {

    public static testMethod void servicesFastrComAuIsiData(){
    
        servicesFastrComAuIsiData.Employer servFComAuIsiEmpTestRec = new servicesFastrComAuIsiData.Employer();
       
            servFComAuIsiEmpTestRec.AddressLine = 'test';
            servFComAuIsiEmpTestRec.EmployerCode = 'test';
            servFComAuIsiEmpTestRec.EmployerName = 'test';
            servFComAuIsiEmpTestRec.Industry = 'test';
            servFComAuIsiEmpTestRec.IndustryCode = 'test';
            servFComAuIsiEmpTestRec.PostCode = 'test';
            servFComAuIsiEmpTestRec.State = 'test';
            servFComAuIsiEmpTestRec.Suburb = 'test'; 
    
    }
    
}