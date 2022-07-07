/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-29
* @description    Test class for testing servicesFastrComAuQuotationCciData web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuQuotationCciData {

    public static testMethod void servicesFastrComAuQuotationCciDataTest(){
        
        servicesFastrComAuQuotationCciData servFaComAuCCITestRec = new servicesFastrComAuQuotationCciData();
        
        String SERV_FASTR_URL = 'http://services.fastr.com.au/Quotation/Data';
        
        servicesFastrComAuQuotationCciData.SecondInsured servFaComAuCCISecInsure = new servicesFastrComAuQuotationCciData.SecondInsured();
        
        servFaComAuCCISecInsure.Accidents = new servicesFastrComAuMotorData.ArrayOfAccident();
        //servFaComAuCCISecInsure.DateOfBirth = new servicesFastrComAuData3.Date_x();
        servFaComAuCCISecInsure.FirstName = 'test';
        servFaComAuCCISecInsure.Gender = 'male';
        servFaComAuCCISecInsure.IsHoldingInternationalLicence = false;
        servFaComAuCCISecInsure.LicenseEndorsements = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
        servFaComAuCCISecInsure.LicenseNumber = 'test';
        servFaComAuCCISecInsure.MotoringOffences = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
        servFaComAuCCISecInsure.Surname = 'test';
        servFaComAuCCISecInsure.Title = 'Mr.';
        servFaComAuCCISecInsure.YearFirstLicensed = 2000;
        servFaComAuCCISecInsure.YearSinceLastAccident = 'NeverHadAnAccident';
        //servFaComAuCCISecInsure.RelationshipToInsured = 'test';

    }  
    
}