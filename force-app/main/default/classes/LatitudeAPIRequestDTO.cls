public class LatitudeAPIRequestDTO {
    
    public class Application {
        public Applicants applicants { get; set; }
        public Broker broker { get; set; }
        public String comments { get; set; }
        public ApplicationRequestedLoan loan { get; set; }
        public String salesSource { get; set; }
        public List<TradeIn> tradein { get; set; }
        public ApplicationVehicle vehicle { get; set; }
    }

    public class Preapproval {
        public Applicants applicants { get; set; }
        public Broker broker { get; set; }
        public String comments { get; set; }
        public RequestedLoan loan { get; set; }
        public PreApprovalVehicle vehicle { get; set; }
    }
    /*
    public class NotificationSubscription {
        public String callback { get; set; }
        public List<String> eventTypes { get; set; }
    }
    
    public class NotificationUnsubscription {
        public List<String> eventTypes { get; set; }
    }
    */
    public class Applicants {
        public List<IndividualApplicant> individualApplicants { get; set; }
    }
    
    public class IndividualApplicant {
        public Business business { get; set; }
        public Consent consent { get; set; }
        public Contact contact { get; set; }
        public String dateOfBirth { get; set; }
        public Long dependants { get; set; }
        public List<EmploymentHistoryItem> employmentHistory { get; set; }
        public Expenses expenses { get; set; }
        public String gender { get; set; }
        public Holdings holdings { get; set; }
        public IdentityDocuments identityDocuments { get; set; }
        public Income income { get; set; }
        public String maritalStatus { get; set; }
        public PersonName name { get; set; }
        public Boolean partnerPartyToLoan { get; set; }
        public Boolean primary { get; set; }
    }
    
    public class Business {
        public String abn { get; set; }
    }
    
    public class Consent {
        public Boolean signedNoticeOfDisclosure { get; set; }
    }
    
    public class Contact {
        public Addresses addresses { get; set; }
        public String email { get; set; }
        public Phone phone { get; set; }
    }
    
    public class Addresses {
        public MailingAddress mailingAddress { get; set; }
        public List<ResidentialAddress> residentialAddresses { get; set; }
    }
    
    public class MailingAddress {
        public PostalAddress postalAddress { get; set; }
        public AddressDetails streetAddress { get; set; }
    }
    
    public class PostalAddress {
        public String country { get; set; }
        public String r_number { get; set; }
        public String postcode { get; set; }
        public String state { get; set; }
        public String suburb { get; set; }
        public String r_type { get; set; }
    }
    
    public class ResidentialAddress {
        public AddressDetails addressDetails { get; set; }
        public Boolean current { get; set; }
        public Long lengthOfResidence { get; set; }
        public String residentialStatus { get; set; }
    }
    
    public class Phone {
        public String fax { get; set; }
        public String home { get; set; }
        public String mobile { get; set; }
        public String work { get; set; }
    }
    
    public class EmploymentHistoryItem {
        public String activity { get; set; }
        public Boolean current { get; set; }
        public Long duration { get; set; }
        public AddressDetails employerAddress { get; set; }
        public String employerName { get; set; }
        public String employerPhone { get; set; }
        public String occupation { get; set; }
    }
    
    public class AddressDetails {
        public String country { get; set; }
        public String postcode { get; set; }
        public String propertyName { get; set; }
        public String state { get; set; }
        public String streetName { get; set; }
        public String streetNumber { get; set; }
        public String streetType { get; set; }
        public String suburb { get; set; }
        public String unitNumber { get; set; }
    }
    
    public class Expenses {
        public Long livingMonthly { get; set; }
        public Long otherMonthly { get; set; }
        public Long rentMonthly { get; set; }
        public Boolean sharedExpenses { get; set; }
    }
    
    public class Holdings {
        public List<CreditCard> creditCards { get; set; }
        public List<InvestmentProperty> investmentProperties { get; set; }
        public List<LoanDetails> loans { get; set; }
        public List<ResidentialProperty> residentialProperties { get; set; }
    }
    
    public class CreditCard {
        public Long creditLimit { get; set; }
        public Long currentBalance { get; set; }
        public String issuer { get; set; }
    }
    
    public class InvestmentProperty {
        public Long estimatedValue { get; set; }
        public Mortgage mortgage { get; set; }
        public Long rentalIncomeAmount { get; set; }
        public String rentalIncomeFrequency { get; set; }
    }
    
    public class Mortgage {
        public Long mortgageOriginalAmount { get; set; }
        public Long mortgageOutstandingBalance { get; set; }
        public String mortgagee { get; set; }
        public Long repaymentAmount { get; set; }
        public String repaymentFrequency { get; set; }
        public Boolean sharedMortgage { get; set; }
    }
    
    public class LoanDetails {
        public Boolean currentAtSettlement { get; set; }
        public String lender { get; set; }
        public Long originalAmount { get; set; }
        public Long outstandingBalance { get; set; }
        public String purpose { get; set; }
        public Long repaymentAmount { get; set; }
        public String repaymentFrequency { get; set; }
        public String type { get; set; }
    }
    
    public class ResidentialProperty {
        public Long estimatedValue { get; set; }
        public Mortgage mortgage { get; set; }
    }
    
    public class IdentityDocuments {
        public DriverLicenceDetails driverLicence { get; set; }
    }
    
    public class DriverLicenceDetails {
        public DriverLicence licenceDetails { get; set; }
        public String reasonUnlicensed { get; set; }
    }
    
    public class DriverLicence {
        public String expiryDate { get; set; }
        public String r_number { get; set; }
    }
    
    public class Income {
        public Long grossYearly { get; set; }
        public Long otherNetMonthly { get; set; }
        public Long partTimeNetMonthly { get; set; }
        public Long primaryNetMonthly { get; set; }
    }
    
    public class PersonName {
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String maidenName { get; set; }
        public String middleName { get; set; }
        public String title { get; set; }
    }
    
    public class Broker {
        public String id { get; set; }
    }
    
    public class ApplicationRequestedLoan {
        public Long balloon { get; set; }
        public Long deposit { get; set; }
        public Fees fees { get; set; }
        public Goods goods { get; set; }
        public Payees payees { get; set; }
        public Repayment repayment { get; set; }
        public Long term { get; set; }
    }

    public class RequestedLoan {
        public Long amountRequested { get; set; }
        public Long term { get; set; }
    }
    
    public class Fees {
        public Long origination { get; set; }
        public Long registration { get; set; }
    }
    
    public class Goods {
        public Boolean businessUse { get; set; }
        public Long cashPrice { get; set; }
    }
    
    public class Payees {
        public CollateralSupplier collateralSupplier { get; set; }
    }
    
    public class CollateralSupplier {
        public CompanyPayee company { get; set; }
        public IndividualPayee individual { get; set; }
    }
    
    public class CompanyPayee {
        public String abn { get; set; }
        public String acn { get; set; }
        public String tradingName { get; set; }
    }
    
    public class IndividualPayee {
        public String firstName { get; set; }
        public String lastName { get; set; }
    }
    
    public class Repayment {
        public String frequency { get; set; }
        public String type { get; set; }
    }
    
    public class TradeIn {
        public String model { get; set; }
        public Long payout { get; set; }
        public Long value { get; set; }
        public Long year { get; set; }
    }
    
    public class ApplicationVehicle {
        public ApplicationAutoVehicle auto { get; set; }
    }

    public class PreApprovalVehicle {
        public String condition { get; set; }
        public String stateOfRegistration { get; set; }
        public String type { get; set; }
    }
    
    public class ApplicationAutoVehicle {
        public String complianceDate { get; set; }
        public String condition { get; set; }
        public GaragedLocation garagedLocation { get; set; }
        public Long kilometers { get; set; }
        public String nvic { get; set; }
        public String stateOfRegistration { get; set; }
        public String type { get; set; }
    }
    
    public class GaragedLocation {
        public AddressDetails address { get; set; }
    }
}