/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuError2 web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuError2 {
    
    public static testMethod void servicesFastrComAuError2Mthd(){
    
        servicesFastrComAuError2.FastrError servFComAErrFastrErr2TestRec = new servicesFastrComAuError2.FastrError();
        servFComAErrFastrErr2TestRec.Reason = 'test';
        
    }
   
}