/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-09 
* @description    Test class for testing servicesFastrComAuMotorData web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuMotorData {

    public static testMethod void servicesFastrComAuMotorDataTest(){
            
        servicesFastrComAuMotorData.Vehicle servFComMotorVehTestRec = new servicesFastrComAuMotorData.Vehicle(); 
        servFComMotorVehTestRec.AccessoriesModificationsValues = 1000.00;
        servFComMotorVehTestRec.DetailsofExistingDamage = 'test';
        servFComMotorVehTestRec.EngineNumber = 'test';
        servFComMotorVehTestRec.HasExistingDamage = false;
        servFComMotorVehTestRec.VehicleCondition = 'test';
    
        servicesFastrComAuMotorData.MotoringOffence servFComMotorOffTestRec = new servicesFastrComAuMotorData.MotoringOffence();
    
        servicesFastrComAuData3.Date_x servFComMotorOffIncDtTestRec = new servicesFastrComAuData3.Date_x();
        servFComMotorOffIncDtTestRec.Day = 1;
        servFComMotorOffIncDtTestRec.Month = 1;
        servFComMotorOffIncDtTestRec.Year = 2012;
    
        //servFComMotorOffTestRec.IncidentDate = servFComMotorOffIncDtTestRec;
    
        servFComMotorOffTestRec.IncidentDetails = 'test';
        
        servFComMotorOffTestRec.DemeritPoints = 1;
    
        servicesFastrComAuMotorData.ArrayOfMotoringOffence servFComArryMotorOffTestRec = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
        
        servicesFastrComAuMotorData.MotoringOffence[] servFComArryMotorOffListTestRec = new servicesFastrComAuMotorData.MotoringOffence[]{};
        
        servFComArryMotorOffTestRec.MotoringOffence = servFComArryMotorOffListTestRec;
    
        servicesFastrComAuMotorData.Accident servFComAccTestRec = new servicesFastrComAuMotorData.Accident();
        
        servicesFastrComAuData3.Date_x servFComAccIncDtTestRec = new servicesFastrComAuData3.Date_x();
        servFComAccIncDtTestRec.Day = 1;
        servFComAccIncDtTestRec.Month = 1;
        servFComAccIncDtTestRec.Year = 2012;
        
        //servFComAccTestRec.IncidentDate = servFComAccIncDtTestRec;
        
        servFComAccTestRec.IncidentDetails = 'test';
        
        servFComAccTestRec.AtFault = false;
        servFComAccTestRec.InsurerName = 'test';
        servFComAccTestRec.LossAmount = 1.0;
        servFComAccTestRec.TheftOrMaliciousDamage = false;
        
        servicesFastrComAuMotorData.ArrayOfDriver servFComArryDrvrTestRec = new servicesFastrComAuMotorData.ArrayOfDriver();
        
        servicesFastrComAuMotorData.Driver[] servFComArryDrvrListTestRec = new servicesFastrComAuMotorData.Driver[]{};
        
        servFComArryDrvrTestRec.Driver = servFComArryDrvrListTestRec;
        
        servicesFastrComAuMotorData.LicenseEndorsement servFComLicEndTestRec = new servicesFastrComAuMotorData.LicenseEndorsement();
        
        servicesFastrComAuData3.Date_x servFComIncDtTestRec = new servicesFastrComAuData3.Date_x(); 
        servFComIncDtTestRec.Day = 1;
        servFComIncDtTestRec.Month = 1;
        servFComIncDtTestRec.Year = 2012;
        
        //servFComLicEndTestRec.IncidentDate = servFComIncDtTestRec;
        
        servFComLicEndTestRec.IncidentDetails = 'test';
        
        servFComLicEndTestRec.SuspensionPeriodInMonths = 1;
        
        servicesFastrComAuMotorData.Driver servFComDrvrTestRec = new servicesFastrComAuMotorData.Driver();
        
        servicesFastrComAuMotorData.ArrayOfAccident servFComArryAccTestRec = new servicesFastrComAuMotorData.ArrayOfAccident();
        
        servFComDrvrTestRec.Accidents = servFComArryAccTestRec;
        
        servicesFastrComAuData3.Date_x servFComDtofBrthTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComDrvrTestRec.DateOfBirth = servFComDtofBrthTestRec;
        
        servFComDrvrTestRec.FirstName = 'test';
        servFComDrvrTestRec.Gender = 'test';
        servFComDrvrTestRec.IsHoldingInternationalLicence = false;
        
        servicesFastrComAuMotorData.ArrayOfLicenseEndorsement servFComDrvrLicEndTestRec = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
        
        servFComDrvrTestRec.LicenseEndorsements = servFComDrvrLicEndTestRec;
        
        servFComDrvrTestRec.LicenseNumber = 'test';
        
        servicesFastrComAuMotorData.ArrayOfMotoringOffence servFComDrvrMotOffTestRec = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
        
        servFComDrvrTestRec.MotoringOffences = servFComDrvrMotOffTestRec;
        
        servFComDrvrTestRec.Surname = 'test';
        servFComDrvrTestRec.Title = 'test';
        servFComDrvrTestRec.YearFirstLicensed = 2015;
        servFComDrvrTestRec.YearSinceLastAccident = 'test';
        
        servFComDrvrTestRec.RelationshipToInsured = 'test';
        
        servicesFastrComAuMotorData.OtherInformation servFComOtherInfTestRec = new servicesFastrComAuMotorData.OtherInformation();
        
        servFComOtherInfTestRec.CriminalConvictionDetails = 'test';
        servFComOtherInfTestRec.HadInsuranceRefused = false;
        servFComOtherInfTestRec.HasCriminalConviction = false;
        servFComOtherInfTestRec.InsuranceRefusedDetails = 'test';
        
        servicesFastrComAuMotorData.ArrayOfAccident servFComArryAcc1TestRec = new servicesFastrComAuMotorData.ArrayOfAccident();
        
        servicesFastrComAuMotorData.Accident[] servFComArryAccListTestRec = new servicesFastrComAuMotorData.Accident[]{};
        
        servFComArryAccTestRec.Accident = servFComArryAccListTestRec;
        
        servicesFastrComAuMotorData.ArrayOfLicenseEndorsement servFComArryLicEndTestRec = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
        
        servicesFastrComAuMotorData.LicenseEndorsement[] servFComArryLicEndListTestRec = new servicesFastrComAuMotorData.LicenseEndorsement[]{};
        
        servFComArryLicEndTestRec.LicenseEndorsement = servFComArryLicEndListTestRec;
    
    }  
    
}