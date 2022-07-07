/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuError web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuError {
    
    public static testMethod void servicesFastrComAuErrorMthd(){
    
        servicesFastrComAuError.FastrError servFComAErrFastrErrTestRec = new servicesFastrComAuError.FastrError();
        servFComAErrFastrErrTestRec.Reason = 'test';

    }
    
}