public with sharing class EricDTOs {

    public EricDTOs() {}

    public class Settings {
        public String dealerId {set;get;}
        public String dealerName {set;get;}
        public String baseEndpoint {set;get;}
        public String pwd {set;get;}
        public String userId {set;get;}
        public String username {set;get;}
        public Settings() {}
    }

    public class Token {
        public String accessToken {set;get;}
        public Datetime tokenExpiresAfter {set;get;}
        public Datetime generated {set;get;}
        public Integer result {set;get;}
        public ErrorMessage error {set;get;}
        public String validationErrors {set;get;}

        public Token() {}
    }

    public class QuoteDetails {
        public GeneralDetails GeneralDetails {get;set;}
        public FinancialDetails FinancialDetails {get;set;}
        public InsuredDetails InsuredDetails {get;set;}
        public VehicleDetails VehicleDetails {get;set;}
        public ItemDetails ItemDetails {get;set;}
    }
    
    public class GeneralDetails {
        public String CoverStartDate {get;set;}
        public String CustomerNumber {get;set;}
        public String FmoCustomerNumber {get;set;}
        public String StampDutyState {get;set;}
        public String PurchaseDate {get;set;}
        public String PurchasePrice {get;set;}
        //Jesus Mora 2020-06-01 start
        public EmploymentQuestions EmploymentQuestions {get;set;}
        //Jesus Mora 2020-06-01 end
    }
    //Jesus Mora 2020-06-01 start
    public class EmploymentQuestions {
        public Boolean ContinuouslyEmployed {set;get;}
        public Boolean CurrentlyEmployed {set;get;}
        public Boolean SelfEmployed {set;get;}
        public EmploymentQuestions(){}
    }
    //Jesus Mora 2020-06-01 end
    public class FinancialDetails {
        //Jesus Mora 2020-06-04 start
        public Decimal AmountFinanced {get;set;}
        //Jesus Mora 2020-06-04 end
        public String BalloonAmount {get;set;}
        public String FinanceTerm {get;set;}
        public String FinanceType {get;set;}
        public String FinancierId {get;set;}
        public String FinancierName {get;set;}
        public String FinancierContractReference {get;set;}
    }

    public class Gender {
        public String Name {get;set;}
        public Gender() {}
        public Gender(String name) {
            this.Name = name;
        }
    }

    public class InsuredMedicalHistory {
        //public Boolean HasBeenHospitalised {get;set;}
        //public Boolean HasLongTermMedicalCondition {get;set;}
        //public Boolean IsTakingRegularMedication {get;set;}
        //public Boolean IsUnderCurrentMedicalTreatment {get;set;}
        public Boolean AcknowledgmentOfExclusion {get;set;}
    }

    public virtual class Person {
        public String Title {get;set;}
        public String FirstName {get;set;}
        public String Surname {get;set;}
        public String FullName {get;set;}
        public Gender Gender {get;set;}
        public DateTime DateOfBirth {get;set;}
    }
    
    public virtual class Driver extends Person {
        public List<Accident> Accidents {get;set;}
        public Boolean IsHoldingInternationalLicence {get;set;}
        public List<LicenseEndorsement> LicenseEndorsements {get;set;}
        public String LicenseNumber {get;set;}
        public List<MotoringOffence> MotoringOffences {get;set;}
        public String RelationshipToInsured {get;set;}
        public String YearFirstLicensed {get;set;}
        public String YearSinceLastAccident {get;set;}
    }

    public class Insured extends Driver {
        public String Abn {get;set;}
        public String BusinessName {get;set;}
        public String Email {get;set;}
        public String InputTaxCredit {get;set;}
        public InsuredMedicalHistory InsuredMedicalHistory {get;set;}
        public String IsBusinessUse {get;set;}
        public String Mobile {get;set;}
        public String Occupation {get;set;}
        public String OccupationCode {get;set;}
        public String Phone1 {get;set;}
        public String PostalAddress1 {get;set;}
        public String PostalAddress2 {get;set;}
        public String PostCode {get;set;}
        public String RegisteredForGst {get;set;}
        public String State {get;set;}
        public String Suburb {get;set;}
        public String WorkPhone {get;set;}

        public Insured extracBusinessDetails() {
            Insured r = new Insured();
            r.IsBusinessUse = this.IsBusinessUse;
            r.PostalAddress1 = this.PostalAddress1;
            r.PostalAddress2 = this.PostalAddress2;
            r.PostCode = this.PostCode;
            r.State = this.State;
            r.Suburb = this.Suburb;
            r.Phone1 = this.Phone1;
            r.Mobile = this.Mobile;
            r.WorkPhone = this.WorkPhone;
            r.Email = this.Email;
            r.BusinessName = this.BusinessName;
            r.Abn = this.Abn;
            r.InputTaxCredit = this.InputTaxCredit;
            r.RegisteredForGst = this.RegisteredForGst;
            // basic details
            r.Title = this.Title;
            r.FirstName = this.FirstName;
            r.Surname = this.Surname;
            r.FullName = this.FullName;
            r.Gender = this.Gender;
            r.DateOfBirth = this.DateOfBirth;
            // driver
            r.YearFirstLicensed = this.YearFirstLicensed;
            r.YearSinceLastAccident = this.YearSinceLastAccident;
            //Jesus Mora 2020-06-01 start
            r.LicenseNumber = this.LicenseNumber;
            //Jesus Mora 2020-06-01 end
            return r;
        }

        public void resetBusinessDetails() {
            this.Abn = null;
            this.BusinessName = null;
            this.InputTaxCredit = null;
            this.RegisteredForGst = null;
            this.IsBusinessUse = null;
        }

    }

    public class InsuredDetails {
        public Insured MainInsured {get;set;}
        public Insured SecondInsured {get;set;}
        public List<Driver> AdditionalDrivers {get;set;}
    }

    public class VehicleDetails {
        public String EngineNumber {get;set;}
        public Integer Odometer {get;set;}
        public String RedbookCode {get;set;}
        public String RegistrationMark {get;set;}
        public String RegistrationState {get;set;}
        public String VehicleCondition {get;set;}
        public String VehicleMake {get;set;}
        public String VehicleModel {get;set;}
        public String VehicleType {get;set;}
        public String VehicleUsage {get;set;}
        public String Vin {get;set;}
        // Info without MOTOR insurance
        //public String Make {get;set;}
        //public String Model {get;set;}
        //public String BadgeDescription {get;set;}
        //public Integer BuildYear {get;set;}
    }

    public class GapItemDetail {
        public String CoverType {get;set;}
        public String Insurer {get;set;}
        public String InsuranceExpiry {get;set;}
        public String IncludePremiumInFinance {get;set;}
        public String InsuranceNewForOldInPlace {get;set;}
    }

    public class TaiItemDetail {
        public String CoverType {get;set;}
        public String DealerPolicyReference {get;set;}
        public String Insurer {get;set;}
        public String InsuranceExpiry {get;set;}
        public String IncludePremiumInFinance {get;set;}
    }

    public class LtiItemDetail {
        public String CoverType {get;set;}
        public String DealerPolicyReference {get;set;}
        public String Insurer {get;set;}
        public String InsuranceExpiry {get;set;}
        public String IncludePremiumInFinance {get;set;}
        public String IsFinanceLoan {get;set;}
        public String IncludeMaintenanceCostsForPab {get;set;}
    }
    //Jesus Mora 2020-06-01 start
    public class CciItemDetail {
        public String CoverType {get;set;}
        public String BalloonCoverRequired {get;set;}
        public String BalloonAmount {get;set;}
        public String SecondInsuredRequired {get;set;}
        public String RegularMonthlyPayment {get;set;}
        public String IncludePremiumInFinance {get;set;}
        public String Insurer {get;set;}
        public String InsuranceExpiry {get;set;}
    }
    //Jesus Mora 2020-06-01 end
    public class MotorItemDetail {
        public String CoverType {get;set;}
        public String VehicleLocationPostcode {get;set;}
        public String VehicleLocationSuburb {get;set;}
        public String VehicleLocationState {get;set;}
        public String HasCriminalConviction {get;set;}
        public String CriminalConvictionDetails {get;set;}
        public String HadInsuranceRefused {get;set;}
        public String InsuranceRefusedDetails {get;set;}
        public String RatingProtectionRequired {get;set;}
        public String WindscreenProtectionRequired {get;set;}
        public String NominatedBasicExcess {get;set;}
        public String NominatedAmountCovered {get;set;}
    }

    public class WarItemDetail {
        public String CoverType {get;set;}
        public String DealerPolicyReference {get;set;}
        public DateTime DateFirstRegistered {get;set;}
        public String IsVehicleUnderStatutoryWarranty {get;set;}
        public DateTime StatutoryWarrantyEndDate {get;set;}
        public Boolean IncludePremiumInFinance {get;set;}
    }

    public class ItemDetails {
        public List<MotorItemDetail> MotorItemDetails {get;set;}
        public List<GapItemDetail> GapItemDetails {get;set;}
        public List<TaiItemDetail> TaiItemDetails {get;set;}
        public List<LtiItemDetail> LtiItemDetails {get;set;}
        //Jesus Mora 2020-06-01 start
        public List<CciItemDetail> CciItemDetails {get;set;}
        //Jesus Mora 2020-06-01 end
        public List<WarItemDetail> WarItemDetails {get;set;}
    }

    public class MotoringOffence {
        public String IncidentDate {get;set;}
        public String IncidentDetails {get;set;}
        public Integer DemeritPoints {get;set;}
    }

    public class Accident {
        public String IncidentDate {get;set;}
        public String IncidentDetails {get;set;}
        public Boolean AtFault {get;set;}
        public String InsurerName {get;set;}
        public Decimal LossAmount {get;set;}
        public Boolean TheftOrMaliciousDamage {get;set;}
    }

    public class LicenseEndorsement {
        public String IncidentDate {get;set;}
        public String IncidentDetails {get;set;}
        public Integer SuspensionPeriodInMonths {get;set;}
    }

    // Response DTOs
    public class QuoteDetailResponse {
        public String QuoteId {set;get;}
        public Datetime Generated {set;get;}
        public Integer Result {set;get;}
        public ErrorMessage Error {set;get;}
        public List<Message> ValidationErrors {set;get;}
    }

    public class LodgementResponse {
        public String QuoteId {set;get;}
        public String QuoteGroupIdentifier {set;get;}
        public List<LodgementDetailResponse> Details {set;get;}
        public Datetime Generated {set;get;}
        public Integer Result {set;get;}
        public ErrorMessage Error {set;get;}
        public List<Message> ValidationErrors {set;get;}
    }

    public class LodgementDetailResponse {
        public String ProductCode {set;get;}
        public String CoverType {set;get;}
        public String PolicyNumber {set;get;}
    }

    // Messages
    public class Message {
        public String Code {set;get;}
        public String Description {set;get;}
        public Message() {}
        public Message(String description) {
            this.Description = description;
        }
        public Message(String code, String description) {
            this.Code = code;
            this.Description = description;
        }
        public override String toString(){
            String r = '';
            if (String.isNotBlank(this.Code)) {
                r = '[' + this.Code + '] ';
            }
            if (String.isNotBlank(this.Description)) {
                r += this.Description;
            }
            if (String.isBlank(r)) {
                r = 'empty message!';
            }
            return r;
        }
    }
    
    public class QuoteResponse {
        public String QuoteId {set;get;}
        public List<QuotedGroup> QuotedGroups {set;get;}
        public QuoteVehicleDetails VehicleDetails {set;get;}
        public Integer QuoteStatus {set;get;}
        public Datetime Generated {set;get;}
        public Integer Result {set;get;}
        public ErrorMessage Error {set;get;}
        public List<Message> ValidationErrors {set;get;}
    }

    public class QuotedGroup {
        public String GroupId {set;get;}
        public String Name {set;get;}
        public String QuotationReferenceNumber {set;get;}
        public Datetime CoverStartDate {set;get;}
        public Datetime WarrantyCoverStartDate {set;get;}
        public Boolean IsReferralRequired {set;get;}
        public List<AssessmentRuling> AssessmentRulings {set;get;}
        public List<QuoteItem> Items {set;get;}
        public List<QuotePaymentOption> PaymentOptions {set;get;}
        public QuoteFinanceDetails FinanceDetails {set;get;}
        public Boolean IsValid {set;get;}
    }

    public class QuoteItem {
        public Double AmountCovered {set;get;}
        public Double AmountCoveredMaximum {set;get;}
        public Double AmountCoveredMinimum {set;get;}
        public Double BasicExcess {set;get;}
        public List<Double> BasicExcessOptions {set;get;}
        public Double ImposedExcess {set;get;}
        public Double SystemImposedExcess {set;get;}
        public Boolean QuotationGenerated {set;get;}
        public Double CostExGst {set;get;}
        public Double Gst {set;get;}
        public Double EstablishmentFee {set;get;}
        public Double Premium {set;get;}
        public Double StampDuty {set;get;}
        public Integer CoverTerm {set;get;}
        public List<QuotePaymentOption> PaymentOptions {set;get;}
        public String Product {set;get;}
        public String CoverType {set;get;}
    }

    public class QuotePaymentOption {
        public String Code {set;get;}
        public String Description {set;get;}
        public Double Payable {set;get;}
        public Double InstalmentAmount {set;get;}
        public Integer NumberOfInstalments {set;get;}
    }

    public class QuoteVehicleDetails {
        public String Make {get;set;}
        public String Model {get;set;}
        public String BadgeDescription {get;set;}
        public Integer BuildYear {get;set;}

        public override String toString() {
            String y = '';
            if (this.BuildYear != null) {
                y = String.valueOf(this.BuildYear);
            }
            return y + ' ' + this.Make + ' ' + this.Model + ' ' + this.BadgeDescription;
        }
    }

    public class QuoteFinanceDetails {
        public Double OriginalFinanceAmount {set;get;}
        public Double NewFinanceAmount {set;get;}
    }

    public class AssessmentRuling {
        public Boolean ReferToOffice {set;get;}
        public Boolean AutomaticDecline {set;get;}
        public String Comment {get;set;}
        public Double ImposedExcess {set;get;}
    }

    public class BeginQuote {
        public String DealerId {get;set;}
        public String UserId {get;set;}
        public List<QuoteGroup> QuoteGroups {get;set;}
    }

    public class QuoteGroup {
        public String GroupId {get;set;}
        public String Name {get;set;}
        public List<Item> Items {get;set;}
    }

    public class Item {
        public String Product {get;set;}
        public String CoverType {get;set;}
    }

    public class CannotQuoteItem {
        public String CoverType {get;set;}
        public String Product {get;set;}
        public String GroupId {get;set;}
        public String Description {get;set;}
    }

    public class AcceptedQuoteGroup {
        public String Name { get;set; }
        public String GroupId { get;set; }
    }

    public class BeginQuoteResponse {
        public String QuoteId {set;get;}
        public Boolean CannotQuoteAllItems {set;get;}
        public List<CannotQuoteItem> CannotQuoteItems {set;get;}
        public List<AcceptedQuoteGroup> AcceptedQuoteGroups {set;get;}
        public Integer QuoteStatus {set;get;}
        public Datetime Generated {set;get;}
        public Integer Result {set;get;}
        public ErrorMessage Error {set;get;}
        public List<Message> ValidationErrors {set;get;}
    }

    // Messages
    public class ErrorMessage {
        public DateTime OccurredAt {set;get;}
        public String Code {set;get;}
        public String Description {set;get;}

        public Message toMessage() {
            return new Message(this.Code, this.Description);
        }
    }

    public class ResponseDTO {
        public BeginQuoteResponse beginQuoteResponse {set;get;}
        public QuoteDetailResponse addDetailsResponse {set;get;}
        public QuoteResponse quoteResponse {set;get;}
        public LodgementResponse preLodgementResponse {set;get;}
        public LodgementResponse lodgementResponse {set;get;}

        public Map<String,List<Message>> customMessages {set;get;} // Error, Warnings, Info or Successful messages

        public String getQuoteId() {
            if (this.beginQuoteResponse != null) {
                return this.beginQuoteResponse.QuoteId;
            }
            if (this.addDetailsResponse != null) {
                return this.addDetailsResponse.QuoteId;   
            }
            if (this.quoteResponse != null) {
                return this.quoteResponse.QuoteId;   
            }
            return null;
        }

        public void addErrorMessage(String message) {
            this.addMessage('Error', null, message);
        }

        public void addErrorMessage(String code, String message) {
            this.addMessage('Error', code, message);
        }

        public void addWarningMessage(String message) {
            this.addMessage('Warning', null, message);
        }

        public void addWarningMessage(String code, String message) {
            this.addMessage('Warning', code, message);
        }

        public void addInfoMessage(String message) {
            this.addMessage('Info', null, message);
        }

        public void addInfoMessage(String code, String message) {
            this.addMessage('Info', code, message);
        }

        public void addSuccessMessage(String message) {
            this.addMessage('Info', null, message);
        }

        public void addSuccessMessage(String code, String message) {
            this.addMessage('Success', code, message);
        }

        public void addMessage(String msgType, String code, String message) {
            addMessage(msgType, new Message(code, message));
        }

        public void addMessage(String msgType, Message message) {
            if (this.customMessages == null) {
                this.customMessages = new Map<String,List<Message>>();
            }
            List<Message> msgList = this.customMessages.get(msgType);
            if (msgList == null) {
                msgList = new List<Message>();
                this.customMessages.put(msgType, msgList);
            }
            msgList.add(message);
        }

        public Boolean hasErrors() {
            if (this.beginQuoteResponse != null) {
                if (this.beginQuoteResponse.Error != null || 
                   (this.beginQuoteResponse.ValidationErrors != null && 
                    !this.beginQuoteResponse.ValidationErrors.isEmpty())) {
                    return true;
                }
            }
            if (this.addDetailsResponse != null) {
                if (this.addDetailsResponse.Error != null || 
                   (this.addDetailsResponse.ValidationErrors != null && 
                    !this.addDetailsResponse.ValidationErrors.isEmpty())) {
                    return true;
                }
            }
            if (this.quoteResponse != null) {
                if (this.quoteResponse.Error != null || 
                   (this.quoteResponse.ValidationErrors != null && 
                    !this.quoteResponse.ValidationErrors.isEmpty())) {
                    return true;
                }
            }
            if (this.preLodgementResponse != null) {
                if (this.preLodgementResponse.Error != null || 
                   (this.preLodgementResponse.ValidationErrors != null && 
                    !this.preLodgementResponse.ValidationErrors.isEmpty())) {
                    return true;
                }
            }
            if (this.lodgementResponse != null) {
                if (this.lodgementResponse.Error != null || 
                   (this.lodgementResponse.ValidationErrors != null && 
                    !this.lodgementResponse.ValidationErrors.isEmpty())) {
                    return true;
                }
            }
            if (this.customMessages != null && 
                this.customMessages.containsKey('Error')) {
                return true;
            }
            return false;
        }

        public Map<String,List<Message>> getAllMessages() {
            Map<String,List<Message>> r = new Map<String,List<Message>>();
            List<Message> errmsgs = new List<Message>();
            if (this.beginQuoteResponse != null) {
                if (this.beginQuoteResponse.Error != null) {
                    errmsgs.add(this.beginQuoteResponse.Error.toMessage());
                }
                if (this.beginQuoteResponse.ValidationErrors != null && 
                    !this.beginQuoteResponse.ValidationErrors.isEmpty()) {
                    errmsgs.addAll(this.beginQuoteResponse.ValidationErrors);
                }
            }

            if (this.addDetailsResponse != null){
                if (this.addDetailsResponse.Error != null) {
                    errmsgs.add(this.addDetailsResponse.Error.toMessage());
                }
                if (this.addDetailsResponse.ValidationErrors != null && 
                    !this.addDetailsResponse.ValidationErrors.isEmpty()) {
                    errmsgs.addAll(this.addDetailsResponse.ValidationErrors);
                }
            }
            if (this.quoteResponse != null){
                if (this.quoteResponse.Error != null) {
                    errmsgs.add(this.quoteResponse.Error.toMessage());
                }
                if(this.quoteResponse.ValidationErrors != null && 
                    !this.quoteResponse.ValidationErrors.isEmpty()) {
                    errmsgs.addAll(this.quoteResponse.ValidationErrors);
                }
            }
            if (this.preLodgementResponse != null){
                if (this.preLodgementResponse.Error != null) {
                    errmsgs.add(this.preLodgementResponse.Error.toMessage());
                }
                if(this.preLodgementResponse.ValidationErrors != null && 
                    !this.preLodgementResponse.ValidationErrors.isEmpty()) {
                    errmsgs.addAll(this.preLodgementResponse.ValidationErrors);
                }
            }
            if (this.lodgementResponse != null){
                if (this.lodgementResponse.Error != null) {
                    errmsgs.add(this.lodgementResponse.Error.toMessage());
                }
                if(this.lodgementResponse.ValidationErrors != null && 
                    !this.lodgementResponse.ValidationErrors.isEmpty()) {
                    errmsgs.addAll(this.lodgementResponse.ValidationErrors);
                }
            }
            if (!errmsgs.isEmpty()) {
                r.put('Error', errmsgs);
            }
            if (this.customMessages != null) {
                for (String k: this.customMessages.keySet()) {
                    List<Message> msgs = this.customMessages.get(k);
                    if (msgs != null) {
                        List<Message> rmsg = r.get(k);
                        if (rmsg == null) {
                            rmsg = new List<Message>();
                            r.put(k, rmsg);
                        }
                        rmsg.addAll(msgs);
                    }
                }
            }
            return r;
        }
    }

    // Pre-lodgement
    public class PreLodgement {
        public String QuoteIdentifier {set;get;}
        public String QuoteGroupIdentifier {set;get;}
        public String QuoteReferenceNumber {set;get;}
        public Boolean PreLodgeAll {set;get;}
        public List<PreLodgementItem> PreLodgementItems {set;get;}
        public String SharedPaymentDetails {set;get;}
    }

    public class PreLodgementItem {
        public String CoverType {set;get;}
        public PaymentDetail PaymentDetails {set;get;}
        public Boolean HasValidDetails {set;get;}
    }

    public class PaymentDetail {
        public BankAccountDetail BankAccountDetails {set;get;}
        public CardDetail CardDetails {set;get;}
        public Boolean HasValidDetails {set;get;}
        public String PaymentMethod {set;get;}
    }

    public class BankAccountDetail {
        public String AccountHolderName {set;get;}
        public String AccountNumber {set;get;}
        public String Bsb {set;get;}
        public Boolean IsValid {set;get;}
    }

    public class CardDetail {
        public String CardholderName {set;get;}
        public String CardNumber {set;get;}
        public CardExpiry Expiry {set;get;}
        public String VerificationCode {set;get;}
        public Boolean IsValid {set;get;}
    }

    public class CardExpiry {
        public Integer Year {set;get;}
        public Integer Month {set;get;}
    }

    // Lodgement
    public class Lodgement {
        public String QuoteIdentifier {set;get;}
        public Boolean LodgeAll {set;get;}
        public List<String> LodgeProposalList {set;get;}
    }
}