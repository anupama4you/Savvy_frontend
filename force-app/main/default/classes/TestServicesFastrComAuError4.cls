/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuError4 web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuError4 {

    public static testMethod void servicesFastrComAuError3Mthd(){
    
        servicesFastrComAuError4.FastrError servFComAErr4TestRec = new servicesFastrComAuError4.FastrError ();
        servFComAErr4TestRec.Reason = 'test';
    
    }
    
}