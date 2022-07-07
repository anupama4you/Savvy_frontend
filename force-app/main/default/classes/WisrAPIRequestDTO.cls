public class WisrAPIRequestDTO extends ObjectJsonSerialize {
  public Decimal loanAmount { get; set; }
  public String loanPurpose {get; set;}
  public String otherDetail {get; set;}
  public Boolean requestSecuredRate {get; set;}
  public List<Applicant> applicants {get; set;}
  public AssetDetail assetDetails {get; set;}

  public class Applicant {
    public String title {get; set;}
    public String firstName {get; set;}
    public String middleName {get; set;}
    public String lastName {get; set;}
    public String doB {get; set;}
    public HouseholdDetails householdDetails {get; set;}
    public Decimal totalIncomeBeforeTax { get; set; }
    public List<Employment> employments {get; set;}
    public Identity identities {get; set;}
    public Contact contact {get; set;}
    public List<Address> addresses {get; set;}
    public InvestmentProperty investmentProperty {get; set;}
  }

  public class HouseholdDetails {
    public String maritalStatus {get; set;}
  }

  public class Address {
    public String unit {get; set;}
    public String streetNumber {get; set;}
    public String streetName {get; set;}
    public String streetType {get; set;}
    public String suburb {get; set;}
    public String state {get; set;}
    public String postcode {get; set;}
    public String country {get; set;}
    public Boolean isPrimary {get; set;}
    public String startDate {get; set;}
    public String endDate {get; set;}
    public String residencyStatus {get; set;}
  }

  public class Employment {
    public String employmentStatus {get; set;}
    public String startDate {get; set;}
    public String endDate {get; set;}
  }

  public class Contact {
    public String mobile {get; set;}
    public String email {get; set;}
  }

  public class Identity {
    public DriverLicence driverLicence {get; set;}
  }

  public class DriverLicence  {
    public String wnumber {get; set;}
    public String expiryDate {get; set;}
    public String state {get; set;}
  }

  public class InvestmentProperty {
    public Boolean ownsInvestmentProperty {get; set;}
    public Boolean investmentPropertyMortgaged {get; set;}
  }

  public class AssetDetail {
    public Boolean isKnown {get; set;}
    public Integer yearOfManufacture {get; set;}
    public String saleType {get; set;}
    public Integer approximateAge {get; set;}
  }
}