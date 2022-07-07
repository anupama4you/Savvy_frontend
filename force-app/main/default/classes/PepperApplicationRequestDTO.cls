public class PepperApplicationRequestDTO extends ObjectJsonSerialize {
  public String loanWriter { get; set; }
  public Integer merchant { get; set; }
  public String riskTier { get; set; }
  public String supplierType { get; set; }
  public boolean brokerDeclaration { get; set; }
  public String brokersReference { get; set; }
  public String messageToCreditAnalyst { get; set; }
  public PrimaryApplicant primaryIndividualApplicant { get; set; }
  public AdditionalApplicant additionalIndividualApplicant { get; set; }
  public Serviceability serviceability { get; set; }
  public FinancialDetails financialDetails { get; set; }
  public List<Asset> assets { get; set; }
  public List<Insurance> insurances { get; set; }
  public PaymentDetails paymentDetails { get; set; }
  //Commercial
  public Boolean privacyFlag { get; set; }
  public Boolean submissionRequired { get; set; }
  public PrimaryApplicant primaryApplicant { get; set; }
  public List<AdditionalApplicant> additionalApplicants { get; set; }
  public String applicationType { get; set; }

  public class PrimaryApplicant extends GeneralApplicant {
    public JointIncomeDeclaration jointIncomeDeclaration { get; set; }
	  public String applicantId { get; set; }
	  public String applicantType { get; set; }
	  public String abn { get; set; }
    public String acn { get; set; }
	  public String industry { get; set; }
	  public String mainBusinessActivity { get; set; }
    public AuthorisedSignatoryDetails authorisedSignatoryDetails { get; set; }
  }

  public class AdditionalApplicant extends GeneralApplicant {
    public String relationshipWithprimaryIndividualApplicant { get; set; }
	  public String applicantId { get; set; }
	  public String applicantType { get; set; }
	  public String relationshipType { get; set; }
	  public List<String> relatedApplicants { get; set; }
	  public GeneralApplicant personalDetails { get; set; }
	  public List<ApplicantAsset> applicantAssets { get; set; }
    public List<Liability> liabilities { get; set; }
    public OrganisationDetails organisationDetails { get; set; }
  }

  public virtual class GeneralApplicant {
    public String middleName { get; set; }
    public Passport passport { get; set; }
    public List<Employment> employments { get; set; }
    public String dateOfBirth { get; set; }
    public Boolean privacyFlag { get; set; }
    public String lastName { get; set; }
    public Integer numberOfDependants { get; set; }
    public OtherName otherName { get; set; }
    public String title { get; set; }
    public String firstName { get; set; }
    public String homePhone { get; set; }
    public String country { get; set; } // new field, 3 letter country codes, always AUS
    public String email { get; set; }
    public String workPhone { get; set; }
    public String residencyStatus { get; set; }
    public ApplicantNCCP applicantNCCP { get; set; }
    public String mobile { get; set; }
    public Boolean isForeignCitizen { get; set; }
    public ApplicantAddresses addresses { get; set; }
    public String gender { get; set; }
    public String maritalStatus { get; set; }
    public DriversLicence driversLicence { get; set; }
  }

  public class JointIncomeDeclaration {
    public String partnerEmailAddress { get; set; }
    public String partnerFirstName { get; set; }
    public String partnerLastName { get; set; }
    public String partnerMobileNumber { get; set; }
    public String partnerIncomeFrequency { get; set; }
    public String partnerMiddleName { get; set; }
    public Decimal partnerIncome { get; set; }
  }

  public class Serviceability {
    public List<Income> income { get; set; }
    public List<ApplicantAsset> applicantAssets { get; set; }
    public List<Liability> liabilities { get; set; }
    public List<Expense> basicExpenses { get; set; }
    public List<Expense> otherExpenses { get; set; }
  }

  public class DriversLicence {
    public String number_m { get; set; } //replace number_m by number
    public String cardNumber { get; set; }
    public String expiry { get; set; } //
    public String state { get; set; }
  }

  public class Passport {
    public String number_m { get; set; } //replace number_m by number
    public String country { get; set; }
    public String expiry { get; set; } // Format is yyyy-mm-dd
  }

  public class OtherName {
    public String firstName { get; set; }
    public String middleName { get; set; }
    public String lastName { get; set; }
  }

  public class ApplicantAddresses {
    public Address currentAddress { get; set; }
    public List<Address> previousAddress { get; set; }
    // public Address postalAddress {set; get;}
	  public Address tradingAddress { set; get; }
  }

  public virtual class Address {
    public String addressLine1 { get; set; }
    public String postcode { get; set; }
    public String format { get; set; }
    public String unitNumber { get; set; }
    public String state { get; set; }
    public String streetName { get; set; }
    public String suburb { get; set; }
    public String countryCode { get; set; }
    public String streetDirection { get; set; }
    public String streetNumber { get; set; }
    public String streetType { get; set; }
    public String level { get; set; }
    public String addressLine2 { get; set; }
    public String fullAddress { get; set; }
    public String propertyName { get; set; }
    // Primary Applicant
    public Integer timeAtAddressInMonths { get; set; }
    public Boolean mailingAsResidential { get; set; }
    public String residentialStatus { get; set; }
	  public Boolean registeredAddressSameAsTrading { get; set; }
	  public Boolean postalAddressSameAsTrading { get; set; }
    public String addressId { get; set; }
  }

  public class Income {
    public String type_m { get; set; } //replace type_m by type
    public String owner { get; set; }
    public Decimal amount { get; set; }
    public String frequency { get; set; }
    public String description { get; set; } //mandatory when type is 'Other'
    public String incomeId { get; set; }

    public Income() {
      this.frequency = 'Monthly';
    }
  }

  public class Expense {
    public String type_m { get; set; } //replace type_m by type
    public Decimal amount { get; set; }
    public String frequency { get; set; }
    public String description { get; set; } //mandatory when type is 'Other'

    public Expense() {
      this.frequency = 'Monthly';
    }
  }

  public class ApplicantAsset {
    public String type_m { get; set; } //replace type_m by type
    public Decimal value { get; set; }
    public String description { get; set; } //mandatory when type is 'Other'
    public String owner { get; set; }
    public String applicantAssetId { get; set; }
  }

  public class Liability {
    public String type_m { get; set; }
    public String owner { get; set; }
    public String financier { get; set; }
    public Decimal limit_m { get; set; }
    public Decimal outstandingAmount { get; set; }
    public String description { get; set; } //mandatory when type is 'Other'
    public String expenseFrequency { get; set; }
    public Decimal expenseAmount { get; set; }
    public String liabilityId { get; set; }

    public Liability() {
      this.expenseFrequency = 'Monthly';
    }
  }

  public class Employment {
    public String status { get; set; }
    public String occupation { get; set; }
    public Integer timeAtEmploymentInMonths { get; set; }
    public String type_m { get; set; } //replace type_m by type ** Current, Previous
    public Employer employer { get; set; }
    public Employment() {
      this.employer = new Employer();
    }
  }

  public class Employer {
    public String name { get; set; }
    public String contactName { get; set; }
    public Address address { get; set; }
    public String industry { get; set; }
    public String ABN { get; set; }
    public String mobile { get; set; }
    public String phone { get; set; }
  }

  public class ApplicantNCCP {
    public String whatIsThePurposeOfThisApplication { get; set; }
    public String whyDoesThisLoanTermSuitYourRequirements { get; set; }
    public String whyDoesThisLoanTermSuitYourRequirementsDetails { get; set; }
    public List<String> whatAreYouLookingForInYourLoan { get; set; }
    public Boolean anyForeseeableChangesImpactingLoanRepayment { get; set; }
    public String typeOfChangeExpected { get; set; }
    public String howApplicantIntendToDoLoanRepaymentAfterChange { get; set; }
    public Boolean increaseInLoanAmountForFinancingCostOfInsurance { get; set; }
    public Boolean balloonPaymentAtTheEndOfTheLoan { get; set; }
    public String whatToDoWithBalloonPaymentAtTheEndOfTheLoanTerm { get; set; }
    public String whyAreYouLookingAtRefinancing { get; set; }
    public String detailedReasonForRefinancing { get; set; }
    public Boolean isApplicantPlanningToRetireBeforeLoanCompletion { get; set; }
    public ApplicantProposeToRepay howTheApplicantProposeToRepayTheLoan {
      get;
      set;
    }

    public ApplicantNCCP() {
      this.howTheApplicantProposeToRepayTheLoan = new ApplicantProposeToRepay();
    }
  }

  public class ApplicantProposeToRepay {
    public String response { get; set; }
    public String details { get; set; }
  }

  public class Asset {
    public String nvic { get; set; }
    public String rbKey { get; set; }
    public String model { get; set; }
    public String colour { get; set; }
    public String registrationState { get; set; }
    public Decimal balloonAmount { get; set; }
    public String make { get; set; }
    public String hin { get; set; }
    public String bikeType { get; set; }
    public String complianceDate { get; set; }
    public Integer odometer { get; set; }
    public String engineNumber { get; set; }
    public String vin { get; set; }
    public List<AdditionalAssetDetails> additionalAssetDetails { get; set; }
    public TradeIn tradeIn { get; set; }
    public Decimal assetCost { get; set; }
    public String registrationNumber { get; set; }
    public String class_m { get; set; } //replace class_m by class
    public String variant { get; set; }
    public Integer yearOfManufacture { get; set; }
    public String category { get; set; }
    public Decimal deposit { get; set; }
    public String additionalAsset { get; set; }
    public String type_m { get; set; }
    public String hours { get; set; }
    public String description { get; set; }

    public Asset() {
      this.tradeIn = new TradeIn();
    }
  }

  public class AdditionalAssetDetails {
    public String subType { get; set; }
    public String class_m { get; set; }
    public String rbKey { get; set; }
    public String make { get; set; }
    public String model { get; set; }
    public Integer yearOfManufacture { get; set; }
    public String vin { get; set; }
    public String registrationNumber { get; set; }
    public String engineNumber { get; set; }
    public String serialNumber { get; set; }
    public String registrationState { get; set; }
    public String description { get; set; }
  }

  public class FinancialDetails {
    public String loanTermInMonths { get; set; }
    public Decimal establishmentFee { get; set; }
    public String paymentFrequency { get; set; }
    public String establishmentFeeOccurrence { get; set; }
    public Decimal originationFee { get; set; }
    public String paymentMode { get; set; }
    public Decimal interestRate { get; set; }

    public FinancialDetails() {
      this.paymentFrequency = 'Monthly';
      this.establishmentFeeOccurrence = 'Financed';
    }
  }

  public class TradeIn {
    public Decimal value { get; set; }
    public Decimal payoutAmount { get; set; }
  }

  public class Insurance {
    public Integer termInMonths { get; set; }
    public Decimal premiumAmount { get; set; }
    public String policyNumber { get; set; }
    public String startDate { get; set; } // Format is yyyy-mm-dd
    public Integer insurerId { get; set; }
    public String type_m { get; set; } //replace type_m by type
  }

  public class PaymentDetails {
    public String accountName { get; set; }
    public String accountNumber { get; set; }
    public String bsb { get; set; }
  }

  public class OrganisationDetails {
    public String mainBusinessActivity { get; set; }
    public String abn { get; set; }
    public String industry { get; set; }
	  public String acn { get; set; }
    public AuthorisedSignatoryDetails authorisedSignatoryDetails { get; set; }
  }

  public class AuthorisedSignatoryDetails {
    public String title { get; set; }
    public String firstName { get; set; }
    public String lastName { get; set; }
  }
}