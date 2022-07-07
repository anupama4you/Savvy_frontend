public class WisrAPIService {
  public WisrAPIRequestDTO getWisrApplication(Custom_Opportunity__c opp, String user, String page) {
    if (StringUtils.isNullOrEmpty(user)){
      throw new GenericException ('Missing Wisr user. Please select one.');
    }
        
    WisrAPIRequestDTO wisrApp = new WisrAPIRequestDTO();
    opp = WisrAPIManager.getCustomOpportunityForApplication(opp);
    Application__c app = opp.Application__r;
        
    wisrApp.loanAmount = null; // TODO - Pending value
    wisrApp.loanPurpose = null; // TODO - Pending value
    wisrApp.otherDetail = null; // TODO - Pending value
    wisrApp.requestSecuredRate = null; // TODO - Pending value
    wisrApp.applicants = null; // TODO - Pending value
    wisrApp.assetDetails = new WisrAPIRequestDTO.AssetDetail();
    wisrApp.assetDetails.isKnown = null; // TODO - Pending value
    wisrApp.assetDetails.yearOfManufacture = null; // TODO - Pending value
    wisrApp.assetDetails.saleType = null; // TODO - Pending value
    wisrApp.assetDetails.approximateAge = null; // TODO - Pending value
    return wisrApp;
  }
      
  private List<WisrAPIRequestDTO.Applicant> getApplicants(Custom_Opportunity__c opp, Application__c app) {
    List<WisrAPIRequestDTO.Applicant> applicants = new List<WisrAPIRequestDTO.Applicant>();
    WisrAPIRequestDTO.Applicant applicant = new WisrAPIRequestDTO.Applicant();
    applicant.title = app.Title_1__c;
    applicant.firstName = app.First_Name__c;
    applicant.middleName = app.Middle_Name__c;
    applicant.lastName = app.Last_Name__c;
    applicant.doB = formatDate(app.Date_of_Birth_1__c);
    applicant.householdDetails = new WisrAPIRequestDTO.HouseholdDetails();
    applicant.householdDetails.maritalStatus = getMaritalStatusValue(app.Marital_Status_1__c);
    applicant.totalIncomeBeforeTax = null; // TODO - Pending value
    applicant.employments = null; // TODO - Pending value
    applicant.identities = new WisrAPIRequestDTO.Identity();
    applicant.identities.driverLicence = new WisrAPIRequestDTO.DriverLicence();
    applicant.identities.driverLicence.wnumber = null; // TODO - Pending value
    applicant.identities.driverLicence.expiryDate = null; // TODO - Pending value
    applicant.identities.driverLicence.state = null; // TODO - Pending value
    applicant.contact = new WisrAPIRequestDTO.Contact();
    applicant.contact.mobile = null; // TODO - Pending value
    applicant.contact.email = null; // TODO - Pending value
    applicant.addresses = null; // TODO - Pending value
    applicant.investmentProperty = new WisrAPIRequestDTO.InvestmentProperty();
    applicant.investmentProperty.ownsInvestmentProperty = null; // TODO - Pending value
    applicant.investmentProperty.investmentPropertyMortgaged = null; // TODO - Pending value
    return applicants;
  }

  private List<WisrAPIRequestDTO.Employment> getEmployments(Custom_Opportunity__c opp, Application__c app) {
    List<WisrAPIRequestDTO.Employment> employments = new List<WisrAPIRequestDTO.Employment>();
    WisrAPIRequestDTO.Employment employment = new WisrAPIRequestDTO.Employment();
    return employments;
  }
      
  private List<WisrAPIRequestDTO.Address> getAddresses(Custom_Opportunity__c opp, Application__c app) {
    List<WisrAPIRequestDTO.Address> addresses = new List<WisrAPIRequestDTO.Address>();
    WisrAPIRequestDTO.Address address = new WisrAPIRequestDTO.Address();
    address.unit = app.Unit_Number__c;
    address.streetNumber = app.Street_Number__c;
    address.streetName = app.Street_Address__c;
    address.streetType = app.Street_Type__c;
    address.suburb = app.Suburb__c;
    address.state = app.State__c;
    address.postcode = app.Postcode__c;
    //address.country
    address.isPrimary = true;
    Date startDate = Date.parse(app.Date_Moved_in_1__c);
    String endDate = app.Date_Moved_in_1__c;
    address.startDate = startDate.month()+'/'+startDate.year();
    //address.endDate
    address.residencyStatus = getResidencyStatus(
      app.Current_Residence_Status_1__c);
    addresses.add(address);

    if (app.Previous_Country_1__c != null && (String.isNotBlank(
      app.Date_From_1__c) || String.isNotBlank(app.Previous_Street_Address_1__c)
      || String.isNotBlank(app.Previous_Residence_Status_1__c))) {
      address = new WisrAPIRequestDTO.Address();
      address.unit = app.Previous_Unit_Number_1__c;
      address.streetNumber = app.Previous_Street_Number_1__c;
      address.streetName = app.Previous_Street_Address_1__c;
      address.streetType = getLabelPicklistField(
        Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1__c);
      address.suburb = app.Previous_Suburb_1__c;
      address.state = app.Previous_State_1__c;
      address.postcode = app.Previous_Postcode_1__c;
      address.country = getLabelPicklistField(
        Application__c.Previous_Country_1__c.getDescribe(), app.Previous_Country_1__c);
      address.isPrimary = false;
      startDate = Date.parse(app.Date_From_1__c);
      address.startDate = startDate.month()+'/'+startDate.year();
      Date eDate = Date.parse(endDate);
      address.endDate = eDate.month()+'/'+eDate.year();
      endDate = app.Date_From_1__c;
      address.residencyStatus = getResidencyStatus(
        app.Previous_Residence_Status_1__c);
      addresses.add(address);  
    }

    if (app.Previous_Country_1b__c != null && (String.isNotBlank(
      app.Date_From_1b__c) || String.isNotBlank(
        app.Previous_Street_Address_1b__c)
      || String.isNotBlank(app.Previous_Residence_Status_1b__c))) {
      address = new WisrAPIRequestDTO.Address();
      address.unit = app.Previous_Unit_Number_1b__c;
      address.streetNumber = app.Previous_Street_Number_1b__c;
      address.streetName = app.Previous_Street_Address_1b__c;
      address.streetType = getLabelPicklistField(
        Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1b__c);
      address.suburb = app.Previous_Suburb_1b__c;
      address.state = app.Previous_State_1b__c;
      address.postcode = app.Previous_Postcode_1b__c;
      address.country = getLabelPicklistField(
        Application__c.Previous_Country_1b__c.getDescribe(), app.Previous_Country_1b__c);
      address.isPrimary = false;
      startDate = Date.parse(app.Date_From_1b__c);
      address.startDate = startDate.month()+'/'+startDate.year();
      Date eDate = Date.parse(endDate);
      address.endDate = eDate.month()+'/'+eDate.year();
      endDate = app.Date_From_1b__c;
      address.residencyStatus = getResidencyStatus(
        app.Previous_Residence_Status_1b__c);
      addresses.add(address);  
    }

    if (app.Previous_Country_1c__c != null && (String.isNotBlank(
      app.Date_From_1c__c) || String.isNotBlank(
        app.Previous_Street_Address_1c__c)
      || String.isNotBlank(app.Previous_Residence_Status_1c__c))) {
      address = new WisrAPIRequestDTO.Address();
      address.unit = app.Previous_Unit_Number_1c__c;
      address.streetNumber = app.Previous_Street_Number_1c__c;
      address.streetName = app.Previous_Street_Address_1c__c;
      address.streetType = getLabelPicklistField(
        Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1c__c);
      address.suburb = app.Previous_Suburb_1c__c;
      address.state = app.Previous_State_1c__c;
      address.postcode = app.Previous_Postcode_1c__c;
      address.country = getLabelPicklistField(
        Application__c.Previous_Country_1c__c.getDescribe(), app.Previous_Country_1c__c);
      address.isPrimary = false;
      startDate = Date.parse(app.Date_From_1c__c);
      address.startDate = startDate.month()+'/'+startDate.year();
      Date eDate = Date.parse(endDate);
      address.endDate = eDate.month()+'/'+eDate.year();
      endDate = app.Date_From_1c__c;
      address.residencyStatus = getResidencyStatus(
        app.Previous_Residence_Status_1c__c);
      addresses.add(address);  
    }

    if (app.Previous_Country_1d__c != null && (String.isNotBlank(
      app.Date_From_1d__c) || String.isNotBlank(
        app.Previous_Street_Address_1d__c)
      || String.isNotBlank(app.Previous_Residence_Status_1d__c))) {
      address = new WisrAPIRequestDTO.Address();
      address.unit = app.Previous_Unit_Number_1d__c;
      address.streetNumber = app.Previous_Street_Number_1d__c;
      address.streetName = app.Previous_Street_Address_1d__c;
      address.streetType = getLabelPicklistField(
        Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1d__c);
      address.suburb = app.Previous_Suburb_1d__c;
      address.state = app.Previous_State_1d__c;
      address.postcode = app.Previous_Postcode_1d__c;
      address.country = getLabelPicklistField(
        Application__c.Previous_Country_1d__c.getDescribe(), app.Previous_Country_1d__c);
      address.isPrimary = false;
      startDate = Date.parse(app.Date_From_1d__c);
      address.startDate = startDate.month()+'/'+startDate.year();
      Date eDate = Date.parse(endDate);
      address.endDate = eDate.month()+'/'+eDate.year();
      endDate = app.Date_From_1d__c;
      address.residencyStatus = getResidencyStatus(
        app.Previous_Residence_Status_1d__c);
      addresses.add(address);  
    }

    if (app.Previous_Country_1e__c != null && (String.isNotBlank(
      app.Date_From_1e__c) || String.isNotBlank(
        app.Previous_Street_Address_1e__c)
      || String.isNotBlank(app.Previous_Residence_Status_1e__c))) {
      address = new WisrAPIRequestDTO.Address();
      address.unit = app.Previous_Unit_Number_1e__c;
      address.streetNumber = app.Previous_Street_Number_1e__c;
      address.streetName = app.Previous_Street_Address_1e__c;
      address.streetType = getLabelPicklistField(
        Application__c.Street_Type__c.getDescribe(), app.Previous_Street_Type_1e__c);
      address.suburb = app.Previous_Suburb_1e__c;
      address.state = app.Previous_State_1e__c;
      address.postcode = app.Previous_Postcode_1e__c;
      address.country = getLabelPicklistField(
      Application__c.Previous_Country_1e__c.getDescribe(), app.Previous_Country_1e__c);
      address.isPrimary = false;
      startDate = Date.parse(app.Date_From_1e__c);
      address.startDate = startDate.month()+'/'+startDate.year();
      Date eDate = Date.parse(endDate);
      address.endDate = eDate.month()+'/'+eDate.year();
      endDate = app.Date_From_1e__c;
      address.residencyStatus = getResidencyStatus(
        app.Previous_Residence_Status_1e__c);
      addresses.add(address);  
    }

    return addresses;
  }
      
  public String formatDate(String mydate) {
    return DateUtils.convertToDateToFormat(mydate, DateUtils.YYYY_MM_DD);
  }
      
  public String getMaritalStatusValue(String maritalStatus) {
    if ('Defacto'.equals(maritalStatus)) {
      return 'De Facto';
    }
    return StringUtils.validateNull(maritalStatus);
  }

  public String getResidencyStatus(String rStatus) {
    String residencyStatus;

    if('Boarding'.equals(rStatus)){
      residencyStatus = 'Boarder'; 
    }

    if('Employer Accommodation'.equals(rStatus)){
      residencyStatus = 'Employer'; 
    }

    if('Parents/Relative'.equals(rStatus)){
      residencyStatus = 'Living with Parents'; 
    }

    if('Own Outright'.equals(rStatus)){
      residencyStatus = 'Owner'; 
    }

    if('Renting(Agent)'.equals(rStatus) || 'Renting(Private)'.equals(rStatus)){
      residencyStatus = 'Renter'; 
    }

    return residencyStatus;
  }

  public static String getLabelPicklistField(Schema.DescribeFieldResult fieldResult, String value) {
    String r = null;
    if (fieldResult != null && String.isNotBlank(value)) {
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            if (f.getValue().equalsIgnoreCase(value)) {
                r = f.getLabel();
                break;
            }
        }
    }
    return String.isNotBlank(r) ? r : value;
  }
}