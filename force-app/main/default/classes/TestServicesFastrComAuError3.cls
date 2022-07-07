/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing servicesFastrComAuError3 web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuError3 {

    public static testMethod void servicesFastrComAuError3Mthd(){
    
        servicesFastrComAuError3.FastrError servFComAErr3TestRec = new servicesFastrComAuError3.FastrError ();
        servFComAErr3TestRec.Reason = 'test';
    
    }
    
}