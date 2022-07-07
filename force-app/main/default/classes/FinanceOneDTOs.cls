public class FinanceOneDTOs {
        
    public class IndividualApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public HouseholdExpenses householdExpenses {get;set;}
        public Individual[] individuals {get;set;}  
    }
    
    public class CompanyApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public CommercialEntity company {get;set;}
        public Guarantor[] directors {get;set;}  
    }
    
    public class CommercialEntity {
        public CreditHistory creditHistory {get;set;}
        public Income[] incomes {get;set;}
        public Expense[] expenses {get;set;}
        public Liabilities liabilities {get;set;}
        public Entity entity {get;set;}
    }
    
    public class Guarantor {
        public Personal personal {get;set;}
        public Residential residential {get;set;}
        public CommercialIndividualEmployment employment {get;set;}
        public CreditHistory creditHistory {get;set;}
        public Other other {get;set;}
    }
    
    public class CommercialIndividualEmployment {
        public GuarantorEmployment guarantorEmployment {get;set;}
        public StandardEmployment standardEmployments {get;set;}
    }
    
    public class GuarantorEmployment {
        public Integer duration {get;set;}
    }
    
    public class SoleTraderApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public HouseholdExpenses householdExpenses {get;set;}
        public SoleTrader soleTrader {get;set;}  
    }
    
    public class SoleTrader {
        public Personal personal {get;set;}
        public Licence licence {get;set;}
        public Residential residential {get;set;}
        public SoleTraderEmployment employment {get;set;}
        public CreditHistory creditHistory {get;set;}
        public Income[] incomes {get;set;}
        public Expense[] expenses {get;set;}
        public Liabilities liabilities {get;set;}
        public Other other {get;set;}
        public Entity entity {get;set;}
    }
    
    public class SoleTraderEmployment {
        public GuarantorEmployment guarantorEmployment {get;set;}
        public StandardEmployment standardEmployments {get;set;}
        public Boolean receivesPaygIncome {get;set;}
    }
    
    public class PartnershipApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public CommercialEntity commercialEntity {get;set;}
        public Guarantor[] partners {get;set;}  
    }
    
    public class TrustWithIndividualTrusteeApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public CommercialEntity trust {get;set;}
        public TrusteeIndividual[] trustees {get;set;}  
    }
    
    public class TrusteeIndividual {
        public Personal personal {get;set;}
        public Residential residential {get;set;}
        public StandardEmployment employment {get;set;}
        public CreditHistory creditHistory {get;set;}
        public Other other {get;set;}
    }
    
    public class TrustWithCompanyTrusteeApplication {
        public String uploadedDocuments {get;set;}
        public String productTypeId {get;set;}
        public Loan loan {get;set;}
        public Financial financial {get;set;}
        public Security security {get;set;}
        public AdditionalInformation additionalInformation {get;set;}  
        public CommercialEntity trust {get;set;}
        public TrusteeCompany trusteeEntity {get;set;}
        public Guarantor[] trusteeDirectors {get;set;}
    }
    
    public class TrusteeCompany {
        public CreditHistory creditHistory {get;set;}
        public Entity entity {get;set;}
    }
    
    public class Loan {
        public String purpose {get;set;}
        public Integer term {get;set;}
        public Decimal repaymentCapacity {get;set;}
        public String repaymentFrequency {get;set;}
        public String feePaymentPreference {get;set;}
        public String otherFeaturesOrRequirements {get;set;}
    }
    
    public class Financial {
        public Decimal retailPrice {get;set;}
        public Decimal brokerageFee {get;set;}
        public Decimal existingPayout {get;set;}
        public Decimal deposit {get;set;}
        public Decimal tradeIn {get;set;}
        public Insurance[] insurances {get;set;}
    }
    
    public class Insurance {
        public String type {get;set;}
        public String name {get;set;}
        public Decimal value {get;set;}
    }
    
    public class Security {
        public Boolean preApproval {get;set;}
        public MotorVehicle[] motorVehicles {get;set;}
        public Motorbike[] motorbikes {get;set;}
        public RecreationalAsset[] recreationalAssets {get;set;}
        public Watercraft[] watercraft {get;set;}
        public AllPAAP[] allPAAP {get;set;}
        public OtherGoods[] otherGoods {get;set;}
    }
    
    public class MotorVehicle {
        public String motorVehicleType {get;set;}
        public String make {get;set;}
        public String model {get;set;}
        public Integer year {get;set;}
        public Boolean hasOdometer {get;set;}
        public Integer odometer {get;set;}
        public Boolean isUnderFinance {get;set;}
        public String vin {get;set;}
        public String nvic {get;set;}
    }
    
    public class Motorbike {
        public String motorbikeType {get;set;}
        public String make {get;set;}
        public String model {get;set;}
        public Integer year {get;set;}
        public Boolean hasOdometer {get;set;}
        public Integer odometer {get;set;}
        public Boolean isUnderFinance {get;set;}
        public String vin {get;set;}
        public String nvic {get;set;}
    }
    
    public class RecreationalAsset {
        public String recreationalAssetType {get;set;}
        public String make {get;set;}
        public String model {get;set;}
        public Integer year {get;set;}
        public Boolean hasOdometer {get;set;}
        public Integer odometer {get;set;}
        public Boolean isUnderFinance {get;set;}
        public String vin {get;set;}
        public String nvic {get;set;}
    }
    
    public class Watercraft {
        public String watercraftType {get;set;}
        public String make {get;set;}
        public String model {get;set;}
        public Integer year {get;set;}
        public Boolean isUnderFinance {get;set;}
        public String hin {get;set;}
    }
    
    public class AllPAAP {
        public String abn {get;set;}
        public String acn {get;set;}
        public Boolean exceptions {get;set;}
    }
    
    public class OtherGoods {
        public Boolean isUnderFinance {get;set;}
        public String description {get;set;}
    }
    
    public class HouseholdExpenses {
        public Decimal livingExpenses {get;set;}
        public Integer minorDependants {get;set;}
        public Integer adultDependants {get;set;}
        public Boolean expensesIncludeDependants {get;set;}
        public Decimal minorExpenses {get;set;}
        public Decimal adultExpenses {get;set;}
        public Boolean sharesLivingExpenses {get;set;}
        public Decimal livingExpensePercentage {get;set;}
    }
    
    public class Individual {
        public Personal personal {get;set;}
        public Licence licence {get;set;}
        public Residential residential {get;set;}
        public StandardEmployment employment {get;set;}
        public CreditHistory creditHistory {get;set;}
        public Income[] incomes {get;set;}
        public Expense[] expenses {get;set;}
        public Liabilities liabilities {get;set;}
        public Other other {get;set;}
    }
    
    public class Personal {
        public Boolean isExistingClient {get;set;}
        public String title {get;set;}
        public String firstName {get;set;}
        public String middleNames {get;set;}
        public String lastName {get;set;}
        public String dateOfBirth {get;set;}
        public String sex {get;set;}
        public String residencyStatus {get;set;}
        public String visaType {get;set;}
        public String maritalStatus {get;set;}
        public ContactMethod[] contactMethods {get;set;}
    }
    
    public class ContactMethod {
        public String type {get;set;}
        public String value {get;set;}
    }
    
    public class Licence {
        public Boolean isLicenceProvided {get;set;}
        public String reasonForNotProviding {get;set;}
        public Boolean hasSpecialRestrictions {get;set;}
        public String specialRestrictionsDetails {get;set;}
        public VehicleLicence[] vehicleLicences {get;set;}
        public MarineLicence[] marineLicences {get;set;}
    }
    
    public class VehicleLicence {
        public String licenceNumber {get;set;}
        public String state {get;set;}
        public String expirationDate {get;set;}
        public String licenceType {get;set;}
    }
    
    public class MarineLicence {
        public String licenceNumber {get;set;}
        public String state {get;set;}
        public String expirationDate {get;set;}
        public String licenceClass {get;set;}
    }
    
    public class Residential {
        public CurrentResidential current {get;set;}
        public PreviousResidential[] previous {get;set;}
        public PostalResidential postal {get;set;}
    }
    
    public class CurrentResidential {
        public Address address {get;set;}
        public Integer duration {get;set;}
        public String status {get;set;}
        public PointOfContact contact {get;set;}
        public Integer numberOfIndividualsOnLease {get;set;}
    }
    
    public class Address {
        public String street {get;set;}
        public String suburb {get;set;}
        public String state {get;set;}
        public String postcode {get;set;}
    }
    
    public class PointOfContact {
        public String name {get;set;}
        public String phone {get;set;}
        public String email {get;set;}
    }
    
    public class PreviousResidential {
        public Address address {get;set;}
        public Integer duration {get;set;}
        public String status {get;set;}
        public String endDate {get;set;}
    }
    
    public class PostalResidential {
        public Address address {get;set;}
        public Boolean sameAsCurrentAddress {get;set;}
    }
    
    public class StandardEmployment {
        public CurrentEmployments current {get;set;}
        public PreviousEmployments previous {get;set;}
    }
    
    public class CurrentEmployments {
        public CurrentStandardEmployment[] standard {get;set;}
        public CurrentSelfEmployment[] self {get;set;}
        public CurrentUnemployed[] unemployed {get;set;}
        public CurrentBenefit[] benefits {get;set;}
    }
    
    public class CurrentStandardEmployment {
        public Integer duration {get;set;}
        public String basis {get;set;}
        public String occupation {get;set;}
        public String employerName {get;set;}
        public PointOfContact contact {get;set;}
        public Address address {get;set;}
    }
    
    public class CurrentSelfEmployment {
        
        public Integer duration {get;set;}
        public String occupation {get;set;}
        public Entity entity {get;set;}
        
    }
    
    public class Entity {
        public String entityType {get;set;}
        public String tradingName {get;set;}
        public String abn {get;set;}
        public String acn {get;set;}
        public PointOfContact accountant {get;set;}
        public Address address {get;set;}
        public String predominantBusinessActivity {get;set;}
    }
    
    public class CurrentUnemployed {
        public Integer duration {get;set;}
        public String notes {get;set;}
    }
    
    public class CurrentBenefit {
        public Integer duration {get;set;}
        public String benefitType {get;set;}
    }
    public class Standard {
        public String current {get;set;}
        public String previous {get;set;}
    }
    
    public class PreviousEmployments {
        public PreviousStandardEmployment[] standard {get;set;}
        public PreviousSelfEmployment[] self {get;set;}
        public PreviousUnemployed[] unemployed {get;set;}
        public PreviousBenefit[] benefits {get;set;}
    }
    
    public class PreviousStandardEmployment {
        public Integer duration {get;set;}
        public String endDate {get;set;}
        public String basis {get;set;}
        public String occupation {get;set;}
        public String employerName {get;set;}
        public PointOfContact contact {get;set;}
        public Address address {get;set;}
    }
    
    public class PreviousSelfEmployment {
        /*
        public Integer duration {get;set;}
        public String endDate {get;set;}
        public String occupation {get;set;}
        public Entity entity {get;set;}
        */
    }
    
    public class PreviousUnemployed {
        public Integer duration {get;set;}
        public String endDate {get;set;}
        public String notes {get;set;}
    }
    
    public class PreviousBenefit {
        public Integer duration {get;set;}
        public String endDate {get;set;}
        public String benefitType {get;set;}
    }
    
    public class CreditHistory {
        public String details {get;set;}
    }
    
    public class Income {
        public String type {get;set;}
        public Decimal value {get;set;}
        public String frequency {get;set;}
        public String comment {get;set;}
    }
    
    public class Expense {
        public String type {get;set;}
        public Decimal value {get;set;}
        public String frequency {get;set;}
    }
    
    public class Liabilities {
        public GeneralLiability[] general {get;set;}
        public CreditFacilityLiability[] creditFacilities {get;set;}
    }
    
    public class GeneralLiability {
        public String type {get;set;}
        public Decimal balance {get;set;}
        public String owedTo {get;set;}
        public Decimal monthlyPayment {get;set;}
    }
    
    public class CreditFacilityLiability {
        public String type {get;set;}
        public Decimal balance {get;set;}
        public String owedTo {get;set;}
        public Decimal creditLimit {get;set;}
    }
    
    public class Other {
        public Boolean circumstancesChanging {get;set;}
        public String changeInformation {get;set;}
    }
    
    public class AdditionalInformationSection {
        public String additionalInformation {get;set;}
    }
    
    public class AdditionalInformation {
        public String notes {get;set;}
    }
}