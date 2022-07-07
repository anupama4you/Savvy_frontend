/**
 * Description : Request Dto class for Money3 Broker API service
 */
public class Money3APIRequestDTO extends ObjectJsonSerialize {
    public String brokerLoanReferenceId {get; set;}
    public String loanType {get; set;}
    public Decimal loanAmount {get; set;}
    public Integer loanDuration {get; set;}
    public String purpose {get; set;}
    public Broker broker {get; set;}
    public List<Applicant> applicants {get; set;}
    public List<ResidentialAsset> residentialAssets {get; set;}
    public List<Asset> assets {get; set;}
    public List<Liability> liabilities {get; set;}
    public List<Income> incomes {get; set;}
    public List<Expense> expenses {get; set;}
    public Security security {get; set;}
    public List<Insurance> insurances {get; set;}
    public List<Note> notes {get; set;}

    public class Broker {
        public Integer id {get; set;}
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String company {get; set;}
        public Integer companyId {get; set;}
    }

    public class Applicant {
        public String id {get; set;}
        public String title {get; set;}
        public String firstName {get; set;}
        public String middleName {get; set;}
        public String lastName {get; set;}
        public String gender {get; set;}
        public Date dateOfBirth {get; set;}
        public Boolean isAustralianPermanentResident {get; set;}
        public String maritalStatus {get; set;}
        public Integer dependants {get; set;}
        public String dependantsAge {get; set;}
        public String homePhone {get; set;}
        public String workPhone {get; set;}
        public String mobile {get; set;}
        public String fax {get; set;}
        public String email {get; set;}
        public String preferredContactMethod {get; set;}
        public String bestTimeToCall {get; set;}
        public String bankruptcyStatus {get; set;}
        // public Date dateEnterBankruptcy {get; set;}
        public Spouse spouse {get; set;}
        public List<Identification> identifications {get; set;}
        public List<Address> addresses {get; set;}
        public List<Employment> employments {get; set;}
        public List<Reference> references {get; set;}
    }

    public class Spouse {
        public String name {get; set;}
        public String employerName {get; set;}
        public Decimal netIncomeAmount {get; set;}
    }

    public class Identification {
        public String identificationType {get; set;}
        public String identificationNumber {get; set;}
        public String stateOfIssue {get; set;}
        public String countryOfIssue {get; set;}
        public Date dateOfIssue {get; set;}
        public Date expiryDate {get; set;}
        public Boolean isVerified {get; set;}
        public String note {get; set;}
    }

    public class Address {
        public Boolean isDefaultResidentialAddress {get; set;}
        public Boolean isDefaultMailingAddress {get; set;}
        public String addressType {get; set;}
        public String streetType {get; set;}
        public String suite {get; set;}
        public String floor {get; set;}
        public String propertyName {get; set;}
        public String unit {get; set;}
        public String streetNumber {get; set;}
        public String streetName {get; set;}
        public String suburb {get; set;}
        public String postcode {get; set;}
        public String state {get; set;}
        // public String note {get; set;}
        public Property property {get; set;}
        public BoardingOrWithParentsContact boardingOrWithParentsContact {get; set;}
        public GovernmentHousingContact governmentHousingContact {get; set;}
        public MortgageContact mortgageContact {get; set;}
        public RentingContact rentingContact {get; set;}
    }
    
    public class Property {
        public String residentialStatus {get; set;}
        public Date addressStartDate {get; set;}
        public Decimal periodYear {get; set;}
        public Decimal periodMonth {get; set;}
        // public String note {get; set;}
    }

    public class BoardingOrWithParentsContact {
        public String title {get; set;}
        public String contactName {get; set;}
        public String phone {get; set;}
        public String fax {get; set;}
    }

    public class GovernmentHousingContact {
        public String title {get; set;}
        public String contactName {get; set;}
        public String fax {get; set;}
    }

    public class MortgageContact {
        public String financier {get; set;}
    }

    public class RentingContact {
        // public String title {get; set;}
        public String contactName {get; set;}
        // public String agentName {get; set;}
        public String phone {get; set;}
        // public String fax {get; set;}
    }

    public class Employment {
        public String id {get; set;}
        public String employerName {get; set;}
        public String contactPhone {get; set;}
        public String contactPerson {get; set;}
        public String occupation {get; set;}
        public String jobTitle {get; set;}
        public Date startDate {get; set;}
        public Date endDate {get; set;}
        public Decimal serviceYear {get; set;}
        public Decimal serviceMonth {get; set;}
        public String employmentStatus {get; set;}
        // public Decimal hoursPerWeek {get; set;}
        public Boolean isCurrentEmployment {get; set;}
        public Boolean isPrimaryEmployment {get; set;}
        public Boolean isOnProbation {get; set;}
        public String employerAbn {get; set;}
        // public String addressSuiteNumber {get; set;}
        // public String addressFloorNumber {get; set;}
        // public String addressPropertyName {get; set;}
        public String addressUnit {get; set;}
        public String addressStreetNumber {get; set;}
        public String addressStreetName {get; set;}
        public String addressStreetType {get; set;}
        public String addressSuburb {get; set;}
        public String addressState {get; set;}
        public String addressPostcode {get; set;}
        // public String note {get; set;}
        // public String seIndustryType {get; set;}
        // public String seTradingName {get; set;}
        // public Decimal seServiceYear {get; set;}
        // public Decimal seServiceMonth {get; set;}
        // public String seACN {get; set;}
        // public Integer seCurrentYear {get; set;}
        // public Decimal seCurrentProfit {get; set;}
        // public Integer sePreviousYear {get; set;}
        // public Decimal sePreviousProfit {get; set;}
        // public String seProfitType {get; set;}
        // public String seIncomeDetails {get; set;}
    }

    public class Reference {
        public String relationship {get; set;}
        public String name {get; set;}
        public String homePhone {get; set;}
        public String workPhone {get; set;}
        public String mobile {get; set;}
        public Address address {get; set;}
    }

    public class ResidentialAsset {
        public List<String> owners {get; set;}
        // public String proprietorName {get; set;}
        public Decimal estimatedAmount {get; set;}
        public Date purchasedDate {get; set;}
        // public String addressPropertyName {get; set;}
        // public String addressUnit {get; set;}
        public String addressStreetNumber {get; set;}
        public String addressStreetName {get; set;}
        // public String addressStreetType {get; set;}
        public String addressSuburb {get; set;}
        public String addressState {get; set;}
        public String addressPostcode {get; set;}
    }

    public class Asset {
        public List<String> owners {get; set;}
        public String assetType {get; set;}
        public Decimal amount {get; set;}
        // public String note {get; set;}
        public Boolean isCurrent {get; set;}
    }

    public class Liability {
        public List<String> owners {get; set;}
        public String expenseId {get; set;}
        public String liabilityType {get; set;}
        public Decimal balanceAmount {get; set;}
        public Decimal limit_m {get; set;} //replace limit_m with limit
        public Decimal monthlyPayment {get; set;}
        public String creditProvider {get; set;}
        // public String note {get; set;}
        public Boolean isCurrent {get; set;}
        public Boolean monthlyRepaymentMinimum {get; set;}
    }

    public class Income {
        public List<String> owners {get; set;}
        public String employmentId {get; set;}
        public String incomeType {get; set;}
        public String frequency {get; set;}
        public Decimal amount {get; set;}
        public String netOrGross {get; set;}
        public Boolean isCurrent {get; set;}
        // public String note {get; set;}
    }

    public class Expense {
        public String id {get; set;}
        public List<String> owners {get; set;}
        public String expenseType {get; set;}
        public String frequency {get; set;}
        public Decimal amount {get; set;}
        public Boolean isCurrent {get; set;}
        // public String note {get; set;}
    }

    public class Security {
        public String typeOfSecurity {get; set;}
        public String registrationNumber {get; set;}
        public String make {get; set;}
        public String model {get; set;}
        public String transmission {get; set;}
        public Integer year {get; set;}
        public String color {get; set;}
        // public String colorInternal {get; set;}
        public Decimal currentKms {get; set;}
        public Decimal purchaseAmount {get; set;}
        public Decimal depositTradeAmount {get; set;}
        public Decimal glassValue {get; set;}
        public String vinNumber {get; set;}
        public String engineNumber {get; set;}
        // public String manufacturerNumber {get; set;}
        public Boolean isNewVehicle {get; set;}
        // public String note {get; set;}
        public String bodyType {get; set;}
        // public String fuelType {get; set;}
        // public Decimal quoteValue {get; set;}
        // public Decimal weightGross {get; set;}
        public Decimal engineSize {get; set;}
        public Decimal engineCylinders {get; set;}
        public String ppsrNumber {get; set;}
        public String ppsrRegnumber {get; set;}
        // public Date ppsrExpiryDate {get; set;}
        public String chasisNumber {get; set;}
        // public Date regoRenewal {get; set;}
    }

    public class Insurance {
        public String insuranceType {get; set;}
        public Decimal amount {get; set;}
        // public Decimal durationInMonth {get; set;}
        // public String note {get; set;}
    }

    public class Note {
        public String noteSubject {get; set;}
        public String noteBody {get; set;}
    }
}