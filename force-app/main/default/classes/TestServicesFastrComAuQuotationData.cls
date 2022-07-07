/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-06 
* @description    Test class for testing ServicesFastrComAuQuotationData web service apex class
*/

@isTest(SeeAllData=true)
public class TestServicesFastrComAuQuotationData {
    
    public static testMethod void ServicesFastrComAuQuotationDataMthd(){
    
        //CCI Quotation Item 
        servicesFastrComAuQuotationData.CciQuotationItem servFComACCIQuotTestRec = new servicesFastrComAuQuotationData.CciQuotationItem();
        
        //Create test data for CCI date
        servicesFastrComAuData3.Date_x servFComACCIQuotDateTestRec = new servicesFastrComAuData3.Date_x();
        servFComACCIQuotDateTestRec.Day = 1;
        servFComACCIQuotDateTestRec.Month = 1;
        servFComACCIQuotDateTestRec.Year = 2017;
        
        //servFComACCIQuotTestRec.CoverEndDate = servFComACCIQuotDateTestRec;
        servFComACCIQuotTestRec.CoverTypeCode = 'test';
        servFComACCIQuotTestRec.DealerPolicyReference = 'test';
        
        servFComACCIQuotTestRec.BalloonAmount = 1.0;
        servFComACCIQuotTestRec.BalloonCoverRequired = false;
           
        //Create test data for CCI Question 
        schemasDatacontractOrg200407Fortron.CciQuotationQuestions servFComACCIQuotQuestionsDateTestRec = new schemasDatacontractOrg200407Fortron.CciQuotationQuestions(); 
        servFComACCIQuotQuestionsDateTestRec.CasuallyEmployed = false;
        servFComACCIQuotQuestionsDateTestRec.ContinuouslyEmployed = false;
        servFComACCIQuotQuestionsDateTestRec.CurrentlyEmployed = false;
        servFComACCIQuotQuestionsDateTestRec.PermanentlyEmployed = false;
        servFComACCIQuotQuestionsDateTestRec.SelfEmployed = false;
        
        servFComACCIQuotTestRec.CciQuotationQuestions = servFComACCIQuotQuestionsDateTestRec;
        
        servFComACCIQuotTestRec.FinanceType = 'test';
        servFComACCIQuotTestRec.RegularMonthlyPayment = 1.0;
        
        servicesFastrComAuQuotationCciData.SecondInsured servFComACCIDataSecInsurdTestRec = new servicesFastrComAuQuotationCciData.SecondInsured();
        servFComACCIDataSecInsurdTestRec.FirstName = 'test';
 
        servFComACCIQuotTestRec.SecondInsured = servFComACCIDataSecInsurdTestRec;
        servFComACCIQuotTestRec.SecondInsuredRequired = false;
         
        //Motor vehicle quotation item
        servicesFastrComAuQuotationData.MotorVehicleQuotationItemPremium servFComAQuotDataMVTestRec = new servicesFastrComAuQuotationData.MotorVehicleQuotationItemPremium();
        
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAQuotDataArryPmntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
        
        servFComAQuotDataMVTestRec.AvailablePaymentMethods = servFComAQuotDataArryPmntMthdTestRec;
        
        servFComAQuotDataMVTestRec.CostExGst = 1.0;
        servFComAQuotDataMVTestRec.CoverTypeCode = 'test';
        servFComAQuotDataMVTestRec.EstablishmentFee = 1.0;
        servFComAQuotDataMVTestRec.Gst = 1.0;
        servFComAQuotDataMVTestRec.Premium = 1.0;
        servFComAQuotDataMVTestRec.StampDuty = 1.0;
        
        servFComAQuotDataMVTestRec.AmountCovered = 1.0;
        servFComAQuotDataMVTestRec.AmountCoveredMaximum = 1.0;
        servFComAQuotDataMVTestRec.AmountCoveredMinimum = 1.0;
        servFComAQuotDataMVTestRec.BasicExcess = 1.0;
        
        //Service contract quotation item 
        servicesFastrComAuQuotationData.ServiceContractQuotationItemPremium servFComAQuotDataServiceConTestRec = new servicesFastrComAuQuotationData.ServiceContractQuotationItemPremium();
         
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAQuotDataArryPmntMthdTestRec1 = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod(); 
         
        servFComAQuotDataServiceConTestRec.AvailablePaymentMethods = servFComAQuotDataArryPmntMthdTestRec1;
        
        servFComAQuotDataServiceConTestRec.CostExGst = 1.0;
        servFComAQuotDataServiceConTestRec.CoverTypeCode = 'test';
        servFComAQuotDataServiceConTestRec.EstablishmentFee = 1.0;
        servFComAQuotDataServiceConTestRec.Gst = 1.0;
        servFComAQuotDataServiceConTestRec.Premium = 1.0;
        servFComAQuotDataServiceConTestRec.StampDuty = 1.0;
        
        //CCI Quotation item premium
        servicesFastrComAuQuotationData.CCIQuotationItemPremium servFComAQuotItemPremTestRec = new servicesFastrComAuQuotationData.CCIQuotationItemPremium();
        
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAQuotDataArryPmntMthdTestRec2 = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();

        servFComAQuotItemPremTestRec.AvailablePaymentMethods = servFComAQuotDataArryPmntMthdTestRec2;

        servFComAQuotItemPremTestRec.CostExGSt = 1.0;
        servFComAQuotItemPremTestRec.CoverTypeCode = 'test';
        servFComAQuotItemPremTestRec.EstablishmentFee = 1.0;
        servFComAQuotItemPremTestRec.Gst = 1.0;
        servFComAQuotItemPremTestRec.Premium = 1.0;
        servFComAQuotItemPremTestRec.StampDuty = 1.0;

        //Tyre and Wheel quotation item premium
        //servicesFastrComAuQuotationData.TyreAndWheelQuotationItemPremium servFComATyreAndWhlTestRec = new servicesFastrComAuQuotationData.TyreAndWheelQuotationItemPremium();
        //servFComATyreAndWhlTestRec.CostExGst = 1.0;
        //servFComATyreAndWhlTestRec.CoverTypeCode = 'test';
        //servFComATyreAndWhlTestRec.EstablishmentFee = 1.0;
        //servFComATyreAndWhlTestRec.Gst = 1.0;
        //servFComATyreAndWhlTestRec.Premium = 1.0;
        //servFComATyreAndWhlTestRec.StampDuty = 1.0;
        
        //Loadings item premium
        //servicesFastrComAuQuotationData.LoadingsItemPremium servFComALoadTestRec = new servicesFastrComAuQuotationData.LoadingsItemPremium();
        //servFComALoadTestRec.CostExGst = 1.0;
        //servFComALoadTestRec.CoverTypeCode = 'test';
        //servFComALoadTestRec.EstablishmentFee = 1.0;
        //servFComALoadTestRec.Gst = 1.0;
        //servFComALoadTestRec.Premium = 1.0;
        //servFComALoadTestRec.StampDuty = 1.0;

        //Main insured
        servicesFastrComAuQuotationData.MainInsured servFComAMainInsurdTestRec = new servicesFastrComAuQuotationData.MainInsured();
        
        servicesFastrComAuMotorData.ArrayOfAccident servFComAArryOfAccTestRec = new servicesFastrComAuMotorData.ArrayOfAccident();
        
        servFComAMainInsurdTestRec.Accidents = servFComAArryOfAccTestRec; 
        
        servicesFastrComAuData3.Date_x servFComADateMainInsureTestRec = new servicesFastrComAuData3.Date_x();
        servFComADateMainInsureTestRec.Day = 1;
        servFComADateMainInsureTestRec.Month = 1;
        servFComADateMainInsureTestRec.Year = 1980;
  
        //servFComAMainInsurdTestRec.DateOfBirth = servFComADateMainInsureTestRec;
  
        servFComAMainInsurdTestRec.FirstName = 'test';
        servFComAMainInsurdTestRec.Gender = 'Male';
        servFComAMainInsurdTestRec.IsHoldingInternationalLicence = false;
        
        servicesFastrComAuMotorData.ArrayOfLicenseEndorsement servFComAArryLicEndorseTestRec = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
        
        servFComAMainInsurdTestRec.LicenseEndorsements = servFComAArryLicEndorseTestRec;
  
        servFComAMainInsurdTestRec.LicenseNumber = 'test';
        
        servicesFastrComAuMotorData.ArrayOfMotoringOffence servFComAArryMotorOffTestRec = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
        
        servFComAMainInsurdTestRec.MotoringOffences = servFComAArryMotorOffTestRec;
    
        servFComAMainInsurdTestRec.Surname = 'test';
        servFComAMainInsurdTestRec.Title = 'test';
        servFComAMainInsurdTestRec.YearFirstLicensed = 2015;
        
        servFComAMainInsurdTestRec.YearSinceLastAccident = String.valueof(2010);
        
        servFComAMainInsurdTestRec.Abn = 'test';
        servFComAMainInsurdTestRec.BusinessName = 'test';
        servFComAMainInsurdTestRec.Email = 'test@test.com';
        servFComAMainInsurdTestRec.InputTaxCredit = 1.0;
        servFComAMainInsurdTestRec.IsBusinessUse = false;
        servFComAMainInsurdTestRec.IsRegisteredOwner = false;
        servFComAMainInsurdTestRec.Mobile = '123';
        servFComAMainInsurdTestRec.Occupation = 'test';
        servFComAMainInsurdTestRec.OccupationCode = 'test';
        servFComAMainInsurdTestRec.Phone1 = 'test';
        servFComAMainInsurdTestRec.Postcode = 'test';
        servFComAMainInsurdTestRec.PostalAddress1 = 'test';
        servFComAMainInsurdTestRec.RegisteredForGst = false;
        servFComAMainInsurdTestRec.RegisteredOwnersName = 'test';
        servFComAMainInsurdTestRec.State = 'test';
        servFComAMainInsurdTestRec.Suburb = 'test';
        servFComAMainInsurdTestRec.WorkPhone = 'test';
        
        //Service contract quotation item 
        servicesFastrComAuQuotationData.ServiceContractQuotationItem servFComAServConTestRec = new servicesFastrComAuQuotationData.ServiceContractQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComAServConCoverEndTestRec = new servicesFastrComAuData3.Date_x();
        servFComAServConCoverEndTestRec.Month = 1;
        servFComAServConCoverEndTestRec.Day = 1;
        servFComAServConCoverEndTestRec.Year = 2017;
        
        //servFComAServConTestRec.CoverEndDate = servFComAServConCoverEndTestRec;
        
        servFComAServConTestRec.CoverTypeCode = 'test';
        servFComAServConTestRec.DealerPolicyReference = 'test';
        
        servicesFastrComAuData3.Date_x servFComAServConDateRegTestRec = new servicesFastrComAuData3.Date_x();
        
        servFComAServConDateRegTestRec.Month = 1;
        servFComAServConDateRegTestRec.Day = 2;
        servFComAServConDateRegTestRec.Year = 2017;
        
        //servFComAServConTestRec.DateFirstRegistered = servFComAServConDateRegTestRec;
        
        servFComAServConTestRec.EngineNumber = 'test';
        servFComAServConTestRec.Odometer = 1;
        
        servicesFastrComAuData3.Date_x servFComAServConStatWarTestRec = new servicesFastrComAuData3.Date_x();
        
        servFComAServConStatWarTestRec.Month = 1;
        servFComAServConStatWarTestRec.Day = 1;
        servFComAServConStatWarTestRec.Year = 2020;
        
        //servFComAServConTestRec.StatutoryWarrantyEndDate = servFComAServConStatWarTestRec;
        
        //Warranty quotation item 
        servicesFastrComAuQuotationData.WarrantyQuotationItem servFComAWarrantyQuotTestRec = new servicesFastrComAuQuotationData.WarrantyQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComAWarrantyCoverEndTestRec = new servicesFastrComAuData3.Date_x();
        servFComAWarrantyCoverEndTestRec.Month = 1;
        servFComAWarrantyCoverEndTestRec.Day = 1;
        servFComAWarrantyCoverEndTestRec.Year = 2020; 
        
        //servFComAWarrantyQuotTestRec.CoverEndDate = servFComAWarrantyCoverEndTestRec;
        servFComAWarrantyQuotTestRec.CoverTypeCode = 'test';
        
        servicesFastrComAuData3.Date_x servFComAWarrantyDateRegTestRec = new servicesFastrComAuData3.Date_x();
        servFComAWarrantyDateRegTestRec.Month = 1;
        servFComAWarrantyDateRegTestRec.Day = 1;
        servFComAWarrantyDateRegTestRec.Year = 2017;
        
        //servFComAWarrantyQuotTestRec.DateFirstRegistered = servFComAWarrantyDateRegTestRec;
        
        servFComAWarrantyQuotTestRec.EngineNumber = 'test';
        servFComAWarrantyQuotTestRec.IsVehicleUnderStatutoryWarranty = false;
        servFComAWarrantyQuotTestRec.Odometer = 50000;
        
        servicesFastrComAuData3.Date_x servFComAWarrantyEndDateTestRec = new servicesFastrComAuData3.Date_x(); 
        servFComAWarrantyEndDateTestRec.Month = 1;
        servFComAWarrantyEndDateTestRec.Day = 1;
        servFComAWarrantyEndDateTestRec.Year = 2020;
        
        //servFComAWarrantyQuotTestRec.StatutoryWarrantyEndDate = servFComAWarrantyEndDateTestRec;
        
        servFComAWarrantyQuotTestRec.VehicleType = 'test';
         
        //servFComAWarrantyQuotTestRec.VehicleLocationPostcode = 1234;
        //servFComAWarrantyQuotTestRec.VehicleLocationSuburb = 'test';
        //servFComAWarrantyQuotTestRec.VehicleLocationState = 'VIC';
        //servFComAWarrantyQuotTestRec.RedbookKey = 'test';

        //LGI quotation item 
        servicesFastrComAuQuotationData.LgiQuotationItem servFComALGIQuotTestRec = new servicesFastrComAuQuotationData.LgiQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComALGICoverEndTestRec = new servicesFastrComAuData3.Date_x();
        servFComALGICoverEndTestRec.Month = 1;
        servFComALGICoverEndTestRec.Day = 1;
        servFComALGICoverEndTestRec.Year = 2020;
        
        //servFComALGIQuotTestRec.CoverEndDate = servFComALGICoverEndTestRec;

        servFComALGIQuotTestRec.CoverTypeCode = 'test';
        
        servFComALGIQuotTestRec.DealerPolicyReference = 'test';
        
        servFComALGIQuotTestRec.BalloonAmount = 10000;
        servFComALGIQuotTestRec.ContractedAnnualKilometres = 10000;
        servFComALGIQuotTestRec.EngineNumber = 'test';
        
        servFComALGIQuotTestRec.FinanceContractEndDate = DateTime.newInstance(1999, 2, 11, 8, 6, 16);
    
        servFComALGIQuotTestRec.IncomeTaxCreditAmount = 10000;
        servFComALGIQuotTestRec.IsNovatedLease = false;
        servFComALGIQuotTestRec.Odometer = 50000;
 
        //Customer number
        servicesFastrComAuQuotationData.CustomerNumber servFComACuNumberTestRec = new servicesFastrComAuQuotationData.CustomerNumber();
        
        servFComACuNumberTestRec.YearOfBirth = 123;
        
        //IsiRepurchase
        servicesFastrComAuQuotationData.IsiRepurchase servFComAIsiRepurchaseTestRec = new servicesFastrComAuQuotationData.IsiRepurchase();
        servFComAIsiRepurchaseTestRec.PolicyNumber = '123';
        
        //IsiQuotationItem
        servicesFastrComAuQuotationData.IsiQuotationItem servFComAIsiQuotTestRec = new servicesFastrComAuQuotationData.IsiQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComACoverEndTestRec = new servicesFastrComAuData3.Date_x();
        servFComACoverEndTestRec.Month = 1;
        servFComACoverEndTestRec.Day = 1;
        servFComACoverEndTestRec.Year = 2020;
        
        //servFComAIsiQuotTestRec.CoverEndDate = servFComACoverEndTestRec;
        
        servFComAIsiQuotTestRec.CoverTypeCode = 'test';
        servFComAIsiQuotTestRec.DealerPolicyReference = 'test';
        
        servFComAIsiQuotTestRec.BenefitExcessPeriod = 123;
        servFComAIsiQuotTestRec.BenefitPaymentPeriod = 123;
        
        servicesFastrComAuIsiData.Employer servFComAIsiEmployrTestRec = new servicesFastrComAuIsiData.Employer();
        
        servFComAIsiQuotTestRec.EmployerDetails = servFComAIsiEmployrTestRec;
        
        servFComAIsiQuotTestRec.FinanceType = 'test';
        servFComAIsiQuotTestRec.GrossSalary = 123;
        servFComAIsiQuotTestRec.MonthlyBenefitAmount = 123;
        servFComAIsiQuotTestRec.PolicyTerm = 123;
        
        servicesFastrComAuQuotationData.IsiRepurchase servFComAIsiRepurTestRec = new servicesFastrComAuQuotationData.IsiRepurchase();
        
        servFComAIsiQuotTestRec.Repurchase = servFComAIsiRepurTestRec;
        
        servFComAIsiQuotTestRec.RetailPremium = 123;
        servFComAIsiQuotTestRec.TrainingBenefitRequired = false;
        
        //Warranty quotation item premium
        servicesFastrComAuQuotationData.WarrantyQuotationItemPremium servFComAWarQuotPremTestRec = new servicesFastrComAuQuotationData.WarrantyQuotationItemPremium();

        servFComAWarQuotPremTestRec.CostExGst = 123.00 ;
        servFComAWarQuotPremTestRec.CoverTypeCode = 'test';
        servFComAWarQuotPremTestRec.EstablishmentFee = 123.00;
        servFComAWarQuotPremTestRec.Gst = 123.00;
        servFComAWarQuotPremTestRec.Premium = 123.00;
        servFComAWarQuotPremTestRec.StampDuty = 123.00;
        
        //Array of payment method
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAArryPymntTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
        
        servicesFastrComAuQuotationData.PaymentMethod[] servFComAPymntMthdTestRec = new servicesFastrComAuQuotationData.PaymentMethod[]{};
        
        servFComAArryPymntTestRec.PaymentMethod = servFComAPymntMthdTestRec;
        
        //Fsg
        servicesFastrComAuQuotationData.Fsg servFComAFsgTestRec = new servicesFastrComAuQuotationData.Fsg ();
        
        servFComAFsgTestRec.AuthorisedRepAsicNumber = 'test';
        
        servicesFastrComAuData3.Date_x servFComADteIssueToClntTestRec = new servicesFastrComAuData3.Date_x();
        //servFComAFsgTestRec.DateIssuedToClient = servFComADteIssueToClntTestRec;
        
        servFComAFsgTestRec.Version = 'test';
        
        servicesFastrComAuData3.Date_x servFComAVerRelDteTestRec = new servicesFastrComAuData3.Date_x();
        //servFComAFsgTestRec.VersionReleaseDate = servFComAVerRelDteTestRec;
        
        //Lgi quotation item premium
        servicesFastrComAuQuotationData.LgiQuotationItemPremium servFComALGIQuotPremTestRec = new servicesFastrComAuQuotationData.LgiQuotationItemPremium();
        
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComArryPymntTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
              
        servFComALGIQuotPremTestRec.AvailablePaymentMethods = servFComArryPymntTestRec;
        
        //Gap quotation item 
        servicesFastrComAuQuotationData.GapQuotationItem servFComGapQuotTestRec = new servicesFastrComAuQuotationData.GapQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComCoverEndDtTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComGapQuotTestRec.CoverEndDate = servFComCoverEndDtTestRec;
        
        servFComGapQuotTestRec.CoverTypeCode = 'test';
        
        servFComGapQuotTestRec.DealerPolicyReference = 'test';
        
        servicesFastrComAuData3.Date_x servFComInsurdExpryTestRec = new servicesFastrComAuData3.Date_x();

        //servFComGapQuotTestRec.InsuranceExpiry = servFComInsurdExpryTestRec;
        
        servFComGapQuotTestRec.Insurer = 'test';
        servFComGapQuotTestRec.VehicleMake = 'test';
        servFComGapQuotTestRec.VehicleModel = 'test';
        servFComGapQuotTestRec.VehicleType = 'test';
        
        //servFComGapQuotTestRec.NewForOldInEffect = false;
        servFComGapQuotTestRec.TopUpBenefitAmount = 1.0;
        servFComGapQuotTestRec.DetailedVehicleType = 'test';
        servFComGapQuotTestRec.IsNovatedLease = false;
        //servFComGapQuotTestRec.YoungestDriverDOB = date.parse('1/1/1980');
        //servFComGapQuotTestRec.VehicleLocationPostcode = 1234;
        //servFComGapQuotTestRec.VehicleLocationSuburb = 'test';
        //servFComGapQuotTestRec.VehicleLocationState = 'test';
        
        //Gap quotation item premium
        servicesFastrComAuQuotationData.GapQuotationItemPremium servFComAGapQuotPremTestRec = new servicesFastrComAuQuotationData.GapQuotationItemPremium();
        
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAArryPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
        
        servFComAGapQuotPremTestRec.AvailablePaymentMethods = servFComAArryPymntMthdTestRec;
        
        servFComAGapQuotPremTestRec.CostExGst = 1.0;
        servFComAGapQuotPremTestRec.CoverTypeCode = 'test';
        servFComAGapQuotPremTestRec.EstablishmentFee = 1.0;
        servFComAGapQuotPremTestRec.Gst = 1.0;
        servFComAGapQuotPremTestRec.Premium = 1.0;
        servFComAGapQuotPremTestRec.StampDuty = 1.0;
        
        //Truck Gap quotation item 
        servicesFastrComAuQuotationData.TruckGapQuotationItem servFComAtGapQuotTestRec = new servicesFastrComAuQuotationData.TruckGapQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComATGapCoverEndDtTestRec = new servicesFastrComAuData3.Date_x();
         
        //servFComAtGapQuotTestRec.CoverEndDate = servFComATGapCoverEndDtTestRec;
        servFComAtGapQuotTestRec.CoverTypeCode = 'test';
        servFComAtGapQuotTestRec.DealerPolicyReference = 'test';
        
        servFComAtGapQuotTestRec.GrossVehicleMass = 1;
        
        servicesFastrComAuData3.Date_x servFComATGapInsureExpTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComAtGapQuotTestRec.InsuranceExpiry = servFComATGapInsureExpTestRec;
        
        servFComAtGapQuotTestRec.Insurer = 'test';
        servFComAtGapQuotTestRec.VehicleMake = 'test';
        servFComAtGapQuotTestRec.VehicleModel = 'test';
        
        //Motor vehicle quotation item premium 
        servicesFastrComAuQuotationData.MotorVehicleQuotationItem servFComAMVQuotTestRec = new servicesFastrComAuQuotationData.MotorVehicleQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComAMVQuotCoverEndDtTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComAMVQuotTestRec.CoverEndDate = servFComAMVQuotCoverEndDtTestRec; 
        
        servFComAMVQuotTestRec.CoverTypeCode = 'test';
        servFComAMVQuotTestRec.DealerPolicyReference = 'test';
        
        servicesFastrComAuMotorData.ArrayOfDriver servFComAMVQuotArryDrvrTestRec = new servicesFastrComAuMotorData.ArrayOfDriver();

        servFComAMVQuotTestRec.NominatedAmountCovered = 1.0;
        servFComAMVQuotTestRec.NominatedBasicExcess = 1.0;
        
        servicesFastrComAuMotorData.OtherInformation servFComAMVQuotOtherInfTestRec = new servicesFastrComAuMotorData.OtherInformation();
        
        servFComAMVQuotTestRec.OtherInformation = servFComAMVQuotOtherInfTestRec;
        
        servFComAMVQuotTestRec.RatingProtectionRequired = false;
        
        servicesFastrComAuMotorData.Vehicle servFComAMVQuotVehTestRec = new servicesFastrComAuMotorData.Vehicle();
        
        servFComAMVQuotTestRec.Vehicle = servFComAMVQuotVehTestRec;
        
        //servFComAMVQuotTestRec.VehicleLocationPostcode = 1234;
        servFComAMVQuotTestRec.VehicleLocationState = 'test';
        servFComAMVQuotTestRec.VehicleLocationSuburb = 'test';
        servFComAMVQuotTestRec.WindscreenProtectionRequired = false;
        
        //Base quotation item premium 
        servicesFastrComAuQuotationData.BaseQuotationItem servFComABaseQuotTestRec = new servicesFastrComAuQuotationData.BaseQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComABaseQuotCoverEndTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComABaseQuotTestRec.CoverEndDate = servFComABaseQuotCoverEndTestRec;
        servFComABaseQuotTestRec.CoverTypeCode = 'test';
        servFComABaseQuotTestRec.DealerPolicyReference = 'test';

        //Lti Quotation Item
        servicesFastrComAuQuotationData.LTIQuotationItem servFComALTIQuotTestRec = new servicesFastrComAuQuotationData.LTIQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComALTIQuotCoverEndTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComALTIQuotTestRec.CoverEndDate = servFComALTIQuotCoverEndTestRec;
        servFComALTIQuotTestRec.CoverTypeCode = 'test';
        servFComALTIQuotTestRec.DealerPolicyReference = 'test';

        servFComALTIQuotTestRec.Insurer = 'test';
        servFComALTIQuotTestRec.VehicleMake = 'test';
        servFComALTIQuotTestRec.VehicleModel = 'test';
        servFComALTIQuotTestRec.VehicleType = 'test';
        
        servFComALTIQuotTestRec.VehicleUsage = 'test';

        servFComALTIQuotTestRec.TopUpBenefitAmount = 1.0;
        servFComALTIQuotTestRec.IsNovatedLease = false;
        servFComALTIQuotTestRec.IsJointLivesInsured = false;
        servFComALTIQuotTestRec.DetailedVehicleType = 'test';
        //servFComALTIQuotTestRec.VehicleLocationPostcode = 1;
        //servFComALTIQuotTestRec.VehicleLocationState = 'test';
        //servFComALTIQuotTestRec.VehicleLocationSuburb = 'test';
        //servFComALTIQuotTestRec.PolicyHolderDOB = datetime.newInstance(1,1,1980);
        //servFComALTIQuotTestRec.SecondInsuredDOB = datetime.newInstance(1,1,1980);
    
        //Payment method 
        servicesFastrComAuQuotationData.PaymentMethod servFComAPymntMthd2TestRec = new servicesFastrComAuQuotationData.PaymentMethod();

        servFComAPymntMthd2TestRec.Code = 'test';
        servFComAPymntMthd2TestRec.InstalmentAmount = 1.0;
        servFComAPymntMthd2TestRec.Name = 'test';
        servFComAPymntMthd2TestRec.NumberOfInstalments = 1;
        servFComAPymntMthd2TestRec.Payable = 1.0;
        
        //Total Assist Quotation item premium
        servicesFastrComAuQuotationData.TotalAssistQuotationItemPremium servFComATAIQuotPremTestRec = new servicesFastrComAuQuotationData.TotalAssistQuotationItemPremium();

        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComATAIQuotArryPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();

        servFComATAIQuotPremTestRec.AvailablePaymentMethods = servFComATAIQuotArryPymntMthdTestRec;

        servFComATAIQuotPremTestRec.CostExGst = 1.0;
        servFComATAIQuotPremTestRec.CoverTypeCode = 'test';
        servFComATAIQuotPremTestRec.EstablishmentFee = 1.0;
        servFComATAIQuotPremTestRec.Gst = 1.0;
        servFComATAIQuotPremTestRec.Premium = 1.0;
        servFComATAIQuotPremTestRec.StampDuty = 1.0;

        //LTI Quotation item premium
        servicesFastrComAuQuotationData.LtiQuotationItemPremium servFComALTIQuotPremTestRec = new servicesFastrComAuQuotationData.LtiQuotationItemPremium();

        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComALTIQuotPremArryPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
        
        servFComALTIQuotPremTestRec.AvailablePaymentMethods = servFComALTIQuotPremArryPymntMthdTestRec;
        
        servFComALTIQuotPremTestRec.CostExGst = 1.0;
        servFComALTIQuotPremTestRec.CoverTypeCode = 'test';
        servFComALTIQuotPremTestRec.EstablishmentFee = 1.0;
        servFComALTIQuotPremTestRec.Gst = 1.0;
        servFComALTIQuotPremTestRec.Premium = 1.0;
        servFComALTIQuotPremTestRec.StampDuty = 1.0;
        
        //Person 
        servicesFastrComAuQuotationData.Person servFComALPersonTestRec = new servicesFastrComAuQuotationData.Person();
        
        servicesFastrComAuMotorData.ArrayOfAccident servFComAArryAccdntTestRec =  new servicesFastrComAuMotorData.ArrayOfAccident();
        
        servFComALPersonTestRec.Accidents = servFComAArryAccdntTestRec;
        
        servicesFastrComAuData3.Date_x servFComALPersonDtOfBirthTestRec = new servicesFastrComAuData3.Date_x();
    
        //servFComALPersonTestRec.DateOfBirth = servFComALPersonDtOfBirthTestRec;
        
        servFComALPersonTestRec.FirstName = 'test';
        servFComALPersonTestRec.Gender = 'Male';
        servFComALPersonTestRec.IsHoldingInternationalLicence = false;
        
        servicesFastrComAuMotorData.ArrayOfLicenseEndorsement servFComAArryLicEndTestRec = new servicesFastrComAuMotorData.ArrayOfLicenseEndorsement();
        
        servFComALPersonTestRec.LicenseEndorsements = servFComAArryLicEndTestRec;
        
        servFComALPersonTestRec.LicenseNumber = 'test';
        
        servicesFastrComAuMotorData.ArrayOfMotoringOffence servFComAArryMtrngOffTestRec = new servicesFastrComAuMotorData.ArrayOfMotoringOffence();
        
        servFComALPersonTestRec.MotoringOffences = servFComAArryMtrngOffTestRec;
        
        servFComALPersonTestRec.Surname = 'test';
        servFComALPersonTestRec.Title = 'test';
        servFComALPersonTestRec.YearFirstLicensed = 1234;
        servFComALPersonTestRec.YearSinceLastAccident = 'test';
        
        //BaseQuotationItemPremium 
        servicesFastrComAuQuotationData.BaseQuotationItemPremium servFComABaseQuotItemPremTestRec = new servicesFastrComAuQuotationData.BaseQuotationItemPremium();
    
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAArryOfPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();
        
        servFComABaseQuotItemPremTestRec.AvailablePaymentMethods = servFComAArryOfPymntMthdTestRec;
    
        servFComABaseQuotItemPremTestRec.CostExGst =  1.0;
        servFComABaseQuotItemPremTestRec.CoverTypeCode = 'test';
        servFComABaseQuotItemPremTestRec.EstablishmentFee = 1.0;
        servFComABaseQuotItemPremTestRec.Gst = 1.0;
        servFComABaseQuotItemPremTestRec.Premium = 1.0;
        servFComABaseQuotItemPremTestRec.StampDuty = 1.0;
        
        //IsiQuotationItemPremium
        servicesFastrComAuQuotationData.IsiQuotationItemPremium servFComAIsiQuotItemPremTestRec = new servicesFastrComAuQuotationData.IsiQuotationItemPremium();
        
        servicesFastrComAuQuotationData.ArrayOfPaymentMethod servFComAIsiQPremArryOfPymntMthdTestRec = new servicesFastrComAuQuotationData.ArrayOfPaymentMethod();

        servFComAIsiQuotItemPremTestRec.AvailablePaymentMethods = servFComAIsiQPremArryOfPymntMthdTestRec;
        
        servFComAIsiQuotItemPremTestRec.CostExGst = 1.0;
        servFComAIsiQuotItemPremTestRec.CoverTypeCode = 'test';
        servFComAIsiQuotItemPremTestRec.EstablishmentFee = 1.0;
        servFComAIsiQuotItemPremTestRec.Gst = 1.0;
        servFComAIsiQuotItemPremTestRec.Premium = 1.0;
        servFComAIsiQuotItemPremTestRec.StampDuty = 1.0;
        
        //QuotationRequest
        servicesFastrComAuQuotationData.QuotationRequest servFComAQuotReqTestRec = new servicesFastrComAuQuotationData.QuotationRequest();
        
        servicesFastrComAuQuotationData.CciQuotationItem servFComAQuotReqCCIQuotItemTestRec = new servicesFastrComAuQuotationData.CciQuotationItem();
        
        servFComAQuotReqTestRec.CciQuotationItem = servFComAQuotReqCCIQuotItemTestRec;
        
        servicesFastrComAuData3.Date_x servFComAQuotReqCoverStrtDtTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComAQuotReqTestRec.CoverStartDate = servFComAQuotReqCoverStrtDtTestRec;
        
        servicesFastrComAuQuotationData.CustomerNumber servFComAQuotReqCuNumberTestRec = new servicesFastrComAuQuotationData.CustomerNumber();
        
        servFComAQuotReqTestRec.CustomerNumber = servFComAQuotReqCuNumberTestRec;
    
        servicesFastrComAuData3.FinanceDetails servFComAQuotReqFinDetailsTestRec = new servicesFastrComAuData3.FinanceDetails();
        
        //servFComAQuotReqTestRec.FinanceDetails = servFComAQuotReqFinDetailsTestRec;
    
        servFComAQuotReqTestRec.FinancierContractReference = '123';
        
        servFComAQuotReqTestRec.FmoCustomerNumber = '123';
        
        servicesFastrComAuQuotationData.Fsg servFComAQuotReqFSGTestRec = new servicesFastrComAuQuotationData.Fsg();
        
        servFComAQuotReqTestRec.Fsg = servFComAQuotReqFSGTestRec;
    
        servicesFastrComAuQuotationData.GapQuotationItem servFComAQuotReqGapQuotItemTestRec = new servicesFastrComAuQuotationData.GapQuotationItem();
        
        servFComAQuotReqTestRec.GapQuotationItem = servFComAQuotReqGapQuotItemTestRec;
    
        servicesFastrComAuQuotationData.IsiQuotationItem servFComAQuotReqIsiQuotItemTestRec = new servicesFastrComAuQuotationData.IsiQuotationItem();
        
        servFComAQuotReqTestRec.IsiQuotationItem = servFComAQuotReqIsiQuotItemTestRec;
    
        servicesFastrComAuQuotationData.LgiQuotationItem servFComAQuotReqLGIQuotItemTestRec = new servicesFastrComAuQuotationData.LgiQuotationItem();
        
        servFComAQuotReqTestRec.LgiQuotationItem = servFComAQuotReqLGIQuotItemTestRec;
    
        servicesFastrComAuQuotationData.LtiQuotationItem servFComAQuotReqLTIQuotItemTestRec = new servicesFastrComAuQuotationData.LtiQuotationItem();
        
        servFComAQuotReqTestRec.LtiQuotationItem = servFComAQuotReqLTIQuotItemTestRec;
    
        servicesFastrComAuQuotationData.MainInsured servFComAQuotReqMainInsurdTestRec = new servicesFastrComAuQuotationData.MainInsured();
        
        servFComAQuotReqTestRec.MainInsured = servFComAQuotReqMainInsurdTestRec;
    
        servicesFastrComAuQuotationData.MotorVehicleQuotationItem servFComAMVQuotItemTestRec = new servicesFastrComAuQuotationData.MotorVehicleQuotationItem();
        
        servFComAQuotReqTestRec.MotorVehicleQuotation = servFComAMVQuotItemTestRec;
    
        servFComAQuotReqTestRec.QuotationNumber = '123';
        servFComAQuotReqTestRec.RedbookKey = 'test';
        servFComAQuotReqTestRec.RegistrationNumber = 'test';
        servFComAQuotReqTestRec.RegistrationState = 'test';
        
        servicesFastrComAuQuotationData.ServiceContractQuotationItem servFComAServConQuotItemTestRec = new servicesFastrComAuQuotationData.ServiceContractQuotationItem();
        
        servFComAQuotReqTestRec.ServiceContractQuotationItem = servFComAServConQuotItemTestRec;
        
        servFComAQuotReqTestRec.StampDutyState = '123';
        
        servicesFastrComAuQuotationData.TotalAssistQuotationItem servFComATAIQuotItemTestRec = new servicesFastrComAuQuotationData.TotalAssistQuotationItem();
        
        servFComAQuotReqTestRec.TotalAssistQuotationItem = servFComATAIQuotItemTestRec;
    
        servicesFastrComAuQuotationData.TruckGapQuotationItem servFComATGapQuotItemTestRec = new servicesFastrComAuQuotationData.TruckGapQuotationItem();
        
        servFComAQuotReqTestRec.TruckGapQuotationItem = servFComATGapQuotItemTestRec;

        servicesFastrComAuData3.Date_x servFComAVehPurchDtTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComAQuotReqTestRec.VehiclePurchaseDate = servFComAVehPurchDtTestRec;

        servFComAQuotReqTestRec.VehiclePurchasePrice = 123;
        
        servFComAQuotReqTestRec.VehicleUsage = 0;
        
        //servFComAQuotReqTestRec.VehicleLocationPostcode = '123';
        
        servFComAQuotReqTestRec.VinNumber = 'test';
       
        servicesFastrComAuQuotationData.WarrantyQuotationItem servFComAWarQuotItemTestRec = new servicesFastrComAuQuotationData.WarrantyQuotationItem();
        
        servFComAQuotReqTestRec.WarrantyQuotationItem = servFComAWarQuotItemTestRec;

        //Total assist quotation item 
        servicesFastrComAuQuotationData.TotalAssistQuotationItem servFComATAITestRec = new servicesFastrComAuQuotationData.TotalAssistQuotationItem();
        
        servicesFastrComAuData3.Date_x servFComATAICoverEndDtTestRec = new servicesFastrComAuData3.Date_x();

        //servFComATAITestRec.CoverEndDate = servFComATAICoverEndDtTestRec;
        servFComATAITestRec.CoverTypeCode = 'test';
        servFComATAITestRec.DealerPolicyReference = 'test';
        
        servicesFastrComAuData3.Date_x servFComATAIInsurExpTestRec = new servicesFastrComAuData3.Date_x();
        
        //servFComATAITestRec.InsuranceExpiry = servFComATAIInsurExpTestRec; 
        servFComATAITestRec.Insurer = 'test';
        servFComATAITestRec.VehicleMake = 'test';
        servFComATAITestRec.VehicleModel = 'test';
        servFComATAITestRec.VehicleType = 'test';
        
        //servFComATAITestRec.BenefitAmount = 1.0;
        //servFComATAITestRec.DetailedVehicleType = 'test';
        //servFComATAITestRec.CustomerDOB = DateTime.newInstance(1,1,1980);
        //servFComATAITestRec.VehicleLocationPostcode = 1;
        //servFComATAITestRec.VehicleLocationSuburb = 'test';
        //servFComATAITestRec.VehicleLocationState = 'test';


        } 
    
}