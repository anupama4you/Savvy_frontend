//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
    
public class servicesFastrComAuPaymentData {
    public class ArrayOfDetailedPolicy {
        public servicesFastrComAuPaymentData.DetailedPolicy[] DetailedPolicy;
        private String[] DetailedPolicy_type_info = new String[]{'DetailedPolicy','http://services.fastr.com.au/Payment/Data','DetailedPolicy','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'DetailedPolicy'};
    }
    public class ArrayOfPolicy {
        public servicesFastrComAuPaymentData.Policy[] Policy;
        private String[] Policy_type_info = new String[]{'Policy','http://services.fastr.com.au/Payment/Data','Policy','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Policy'};
    }
    public class BankAccountDetails {
        public String AccountHolderName;
        public String AccountNumber;
        public String Bsb;
        private String[] AccountHolderName_type_info = new String[]{'AccountHolderName','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] AccountNumber_type_info = new String[]{'AccountNumber','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] Bsb_type_info = new String[]{'Bsb','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'AccountHolderName','AccountNumber','Bsb'};
    }
    public class CreditCardDetails {
        public String CardNumber;
        public String CardholderName;
        public servicesFastrComAuPaymentData.CreditCardExpiry Expiry;
        public String VerificationCode;
        private String[] CardNumber_type_info = new String[]{'CardNumber','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] CardholderName_type_info = new String[]{'CardholderName','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] Expiry_type_info = new String[]{'Expiry','http://services.fastr.com.au/Payment/Data','CreditCardExpiry','1','1','true'};
        private String[] VerificationCode_type_info = new String[]{'VerificationCode','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'CardNumber','CardholderName','Expiry','VerificationCode'};
    }
    public class CreditCardExpiry {
        public String Month;
        public String Year;
        private String[] Month_type_info = new String[]{'Month','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] Year_type_info = new String[]{'Year','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Month','Year'};
    }
    public class DetailedPaymentResponse {
        public String FailureReason;
        public servicesFastrComAuPaymentData.ArrayOfDetailedPolicy Policies;
        public Boolean ProcessedSuccessfully;
        private String[] FailureReason_type_info = new String[]{'FailureReason','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] Policies_type_info = new String[]{'Policies','http://services.fastr.com.au/Payment/Data','ArrayOfDetailedPolicy','1','1','true'};
        private String[] ProcessedSuccessfully_type_info = new String[]{'ProcessedSuccessfully','http://services.fastr.com.au/Payment/Data','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'FailureReason','Policies','ProcessedSuccessfully'};
    }
    public class DetailedPolicy {
        public String PolicyNumber;
        public servicesFastrComAuPaymentData.Document PolicySchedule;
        private String[] PolicyNumber_type_info = new String[]{'PolicyNumber','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] PolicySchedule_type_info = new String[]{'PolicySchedule','http://services.fastr.com.au/Payment/Data','Document','0','1','true'};
        public String CoverType;
        public String ProductCode;
        private String[] CoverType_type_info = new String[]{'CoverType','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] ProductCode_type_info = new String[]{'ProductCode','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'PolicyNumber','PolicySchedule','CoverType','ProductCode'};
    }
    public class Document {
        public String DocumentDescription;
        public String DocumentUrl;
        private String[] DocumentDescription_type_info = new String[]{'DocumentDescription','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] DocumentUrl_type_info = new String[]{'DocumentUrl','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'DocumentDescription','DocumentUrl'};
    }
    public class MainInsuredPersonalDetails {
        public String Email;
        public String FirstName;
        public String Mobile;
        public String Phone1;
        public String PostCode;
        public String PostalAddress1;
        public String State;
        public String Suburb;
        public String Surname;
        public String Title;
        public String WorkPhone;
        private String[] Email_type_info = new String[]{'Email','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] Mobile_type_info = new String[]{'Mobile','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] Phone1_type_info = new String[]{'Phone1','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] PostCode_type_info = new String[]{'PostCode','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] PostalAddress1_type_info = new String[]{'PostalAddress1','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] State_type_info = new String[]{'State','http://services.fastr.com.au/Payment/Data','State','0','1','false'};
        private String[] Suburb_type_info = new String[]{'Suburb','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] Surname_type_info = new String[]{'Surname','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] Title_type_info = new String[]{'Title','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] WorkPhone_type_info = new String[]{'WorkPhone','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'Email','FirstName','Mobile','Phone1','PostCode','PostalAddress1','State','Suburb','Surname','Title','WorkPhone'};
    }
    public class PaymentRequest {
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail CciQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail GapQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail IsiQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail LgiQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail LtiQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail MotorQuotationItemPaymentDetail;
        public String QuotationNumber;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail ServiceContractQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail TotalAssistQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail TruckGapQuotationItemPaymentDetail;
        public servicesFastrComAuPaymentData.QuotationItemPaymentDetail WarrantyQuotationItemPaymentDetail;
        private String[] CciQuotationItemPaymentDetail_type_info = new String[]{'CciQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] GapQuotationItemPaymentDetail_type_info = new String[]{'GapQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] IsiQuotationItemPaymentDetail_type_info = new String[]{'IsiQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] LgiQuotationItemPaymentDetail_type_info = new String[]{'LgiQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] LtiQuotationItemPaymentDetail_type_info = new String[]{'LtiQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] MotorQuotationItemPaymentDetail_type_info = new String[]{'MotorQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] QuotationNumber_type_info = new String[]{'QuotationNumber','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] ServiceContractQuotationItemPaymentDetail_type_info = new String[]{'ServiceContractQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] TotalAssistQuotationItemPaymentDetail_type_info = new String[]{'TotalAssistQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] TruckGapQuotationItemPaymentDetail_type_info = new String[]{'TruckGapQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] WarrantyQuotationItemPaymentDetail_type_info = new String[]{'WarrantyQuotationItemPaymentDetail','http://services.fastr.com.au/Payment/Data','QuotationItemPaymentDetail','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'CciQuotationItemPaymentDetail','GapQuotationItemPaymentDetail','IsiQuotationItemPaymentDetail','LgiQuotationItemPaymentDetail','LtiQuotationItemPaymentDetail','MotorQuotationItemPaymentDetail','QuotationNumber','ServiceContractQuotationItemPaymentDetail','TotalAssistQuotationItemPaymentDetail','TruckGapQuotationItemPaymentDetail','WarrantyQuotationItemPaymentDetail'};
    }
    public class PaymentResponse {
        public String FailureReason;
        public servicesFastrComAuPaymentData.ArrayOfPolicy Policies;
        public Boolean ProcessedSuccessfully;
        private String[] FailureReason_type_info = new String[]{'FailureReason','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] Policies_type_info = new String[]{'Policies','http://services.fastr.com.au/Payment/Data','ArrayOfPolicy','1','1','true'};
        private String[] ProcessedSuccessfully_type_info = new String[]{'ProcessedSuccessfully','http://services.fastr.com.au/Payment/Data','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'FailureReason','Policies','ProcessedSuccessfully'};
    }
    public class Policy {
        public String PolicyNumber;
        public servicesFastrComAuPaymentData.Document PolicySchedule;
        private String[] PolicyNumber_type_info = new String[]{'PolicyNumber','http://services.fastr.com.au/Payment/Data','string','0','1','true'};
        private String[] PolicySchedule_type_info = new String[]{'PolicySchedule','http://services.fastr.com.au/Payment/Data','Document','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'PolicyNumber','PolicySchedule'};
    }
    public class QuotationItemPaymentDetail {
        public servicesFastrComAuPaymentData.BankAccountDetails BankAccount;
        public servicesFastrComAuPaymentData.CreditCardDetails CreditCard;
        public String PaymentMethodCode;
        private String[] BankAccount_type_info = new String[]{'BankAccount','http://services.fastr.com.au/Payment/Data','BankAccountDetails','0','1','true'};
        private String[] CreditCard_type_info = new String[]{'CreditCard','http://services.fastr.com.au/Payment/Data','CreditCardDetails','0','1','true'};
        private String[] PaymentMethodCode_type_info = new String[]{'PaymentMethodCode','http://services.fastr.com.au/Payment/Data','string','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'BankAccount','CreditCard','PaymentMethodCode'};
    }
    public class UpdateMainInsuredRequest {
        public servicesFastrComAuPaymentData.MainInsuredPersonalDetails MainInsured;
        private String[] MainInsured_type_info = new String[]{'MainInsured','http://services.fastr.com.au/Payment/Data','MainInsuredPersonalDetails','1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.fastr.com.au/Payment/Data','true','false'};
        private String[] field_order_type_info = new String[]{'MainInsured'};
    }
}