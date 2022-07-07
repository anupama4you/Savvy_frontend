public class McqCreditApplicationRequestDTO extends ObjectJsonSerialize{

    public String privacy_disclosure {set; get;}
    public List<Applicants> applicants {set; get;}
    public List<Assets> assets {set; get;}
    public String contract_type {set; get;}
    public String equipment_location {set; get;}
    public Quotation quotation {set; get;}
    public Income_Capacity income_capacity {set; get;}
    public List<Comment_Texts> comment_texts {set; get;}
    public String asset_subtype {set; get;}
    public String finance_type {set; get;}
    public List<Suppliers> suppliers {set; get;}
    public List<Manual_Insurers> manual_insurers {set; get;}
    public List<Guarantors> guarantors {set; get;}
    public String campaign_code {set; get;}
    public String foreseeable_changes {set; get;}  
    
    public Financial_Statement_Application financial_statement_application {set; get;}
    
    
    public virtual class McQ_Individual_Applicant{
        public String individual_applicant_type {set; get;}
        public String accountant_contact_name {set; get;}
        public String accountant_contact_phone {set; get;}
        public String accountant_firm_name {set; get;}
        public String bo_flag {set; get;}
        public String title {set; get;}
        public String first_name {set; get;}
        public String middle_name {set; get;}
        public String surname {set; get;}
        public String other_name {set; get;}
        public String date_of_birth {set; get;}
        public String email {set; get;}
        public String fax {set; get;}
        public String licence_number {set; get;}
        public String licence_type {set; get;}
        public String licence_state {set; get;}
        public String mobile {set; get;}
        public String telephone {set; get;}
        public String work_phone {set; get;}
        public String residential_status {set; get;}
        public String landlord_name {set; get;}
        public String landlord_phone {set; get;}
        public String au_residency_status {set; get;}
        public String customer_number {set; get;}
        public String sole_trader {set; get;}
        public String guarantor_flag {set; get;}
        public Employment employment {set; get;}
        public String same_applicant_addr {set; get;}
        public Address address {set; get;}
        public Mailing_Address mailing_address {set; get;}
        public Previous_Address previous_address {set; get;}
        public Asset_Statement asset_statement {set; get;}
        public Liabilities_Statement liabilities_statement {set; get;}
        public String marketing_excl_flag {set; get;}
        public Income_Detail income_detail {set; get;}
        public String email_unavailable_flag {set; get;}
        
        public Financial_Statement financial_statement {set; get;}
    }
    
    public class Applicants {
        public Individual_Applicant individual_applicant {set; get;}
        public Company_Applicant company_applicant {set; get;}
        public Trust_Applicant trust_applicant {set; get;}
        public Partnership_Applicant partnership_applicant {set; get;}
    }
    
   public class Guarantors{
        public Mcq_Individual_Applicant individual_guarantor {set; get;}
        //public McQ_Company_Applicant company_guarantor {set; get;}
        public Company_Applicant company_guarantor {set; get;}
        public Partnership_Applicant partnership_guarantor {set; get;}
    }
    
    public class Individual_Applicant extends Mcq_Individual_Applicant {}
    public class Individual_Guarantor extends Mcq_Individual_Applicant {}
    public class Business_Person extends Mcq_Individual_Applicant {}
    public class Individual_Trustee extends Mcq_Individual_Applicant {}
    public class Individual_Partner extends Mcq_Individual_Applicant {}
    
    public class Employment {
        public String abn {set; get;}
        public String business_num {set; get;}
        public String employer_contact_name {set; get;}
        public String employer_contact_phone {set; get;}
        public String employer_name {set; get;}
        public String business_activity {set; get;}
        public String employment_type {set; get;}
        public String is_employer_proprietary {set; get;}
        public String occupation {set; get;}
        public String previous_employer_name {set; get;}
        public String previous_employer_phone {set; get;}
        public String previous_years_employed {set; get;}
        public String previous_months_employed {set; get;}
        public String years_employed {set; get;}
        public String months_employed {set; get;}
        public Employer_Address employer_address {set; get;}
    }
    
    public class Employer_Address extends Mailing_Address{}
    public class Supplier_Address extends Mailing_Address{}
    public class Postal_Address extends Mailing_Address{}
    public class Ppb_Address extends Mailing_Address{}
    
    public virtual class Mailing_Address {
        public String address_1 {set; get;}
        public String address_2 {set; get;}
        public String address_3 {set; get;}
        public String postcode {set; get;}
        public String state {set; get;}
        
    }
    
    public virtual class Address extends Mailing_Address{
        public String years_at_address {set; get;}
        public String months_at_address {set; get;}
    }
    
    public class Previous_Address extends Address{}
    
    public class Asset_Statement {
        public Decimal asset_business_amt {set; get;}
        public String asset_business_desc {set; get;}
        public Decimal asset_cash_amt {set; get;}
        public String asset_cash_desc {set; get;}
        public Decimal asset_furniture_amt {set; get;}
        public String asset_furniture_desc {set; get;}
        public Decimal asset_investment_1_amt {set; get;}
        public String asset_investment_1_desc {set; get;}
        public Decimal asset_investment_2_amt {set; get;}
        public String asset_investment_2_desc {set; get;}
        public Decimal asset_investment_3_amt {set; get;}
        public String asset_investment_3_desc {set; get;}
        public Decimal asset_mv_amt {set; get;}
        public String asset_mv_desc {set; get;}
        public Decimal asset_property_1_amt {set; get;}
        public String asset_property_1_desc {set; get;}
        public Decimal asset_property_2_amt {set; get;}
        public String asset_property_2_desc {set; get;}
        public Decimal asset_property_3_amt {set; get;}
        public String asset_property_3_desc {set; get;}
        public Decimal asset_shares_amt {set; get;}
        public String asset_shares_desc {set; get;}
        public Decimal asset_super_amt {set; get;}
        public String asset_super_desc {set; get;}
    }
    
    public class Liabilities_Statement{
        public Decimal liabilities_loan_1_amt {set; get;}
        public String liabilities_loan_1_desc {set; get;}
        public Decimal liabilities_loan_2_amt {set; get;}
        public String liabilities_loan_2_desc {set; get;}
        public Decimal liabilities_loan_3_amt {set; get;}
        public String liabilities_loan_3_desc {set; get;}
        public Decimal liabilities_mortgage_1_amt {set; get;}
        public String liabilities_mortgage_1_desc {set; get;}
        public Decimal liabilities_mortgage_2_amt {set; get;}
        public String liabilities_mortgage_2_desc {set; get;}
        public Decimal liabilities_mortgage_3_amt {set; get;}
        public String liabilities_mortgage_3_desc {set; get;}
        public Decimal liabilities_other_1_amt {set; get;}
        public String liabilities_other_1_desc {set; get;}
        public Decimal liabilities_other_2_amt {set; get;}
        public String liabilities_other_2_desc {set; get;}
        public Decimal liabilities_other_3_amt {set; get;}
        public String liabilities_other_3_desc {set; get;}
        public Decimal liabilities_overdraft_amt {set; get;}
        public String liabilities_overdraft_desc {set; get;}
        public String link_to {set; get;}
        public String disclosed_liabilities {set; get;}
        public String statement_type {set; get;}
    }
    
    public class Income_Detail{
        public Decimal credit_card_expense {set; get;}
        public Decimal household_expense {set; get;}
        public Decimal mortgage_rent {set; get;}
        public Decimal gross_income {set; get;}
        public Decimal net_income {set; get;}
        public Decimal other_expense {set; get;}
        public Decimal spouse_gross_income {set; get;}
        public Decimal spouse_net_income {set; get;}
    }
    
    public class Company_Applicant extends McQ_Company_Applicant {}
    public class Company_Trustee extends McQ_Company_Applicant {}
    public class Company_Partner extends McQ_Company_Applicant {}
    public class Company_Guarantor extends McQ_Company_Applicant {}
    
    public virtual class McQ_Company_Applicant {
        public String accountant_contact_name {set; get;}
        public String accountant_contact_phone {set; get;}
        public String accountant_firm_name {set; get;}
        public String abn {set; get;}
        public String business_num {set; get;}
        public String exchange_name {set; get;}
        public String fax {set; get;}
        public String industry {set; get;}
        public String is_postal_rba {set; get;}
        public String is_ppb_rba {set; get;}
        public String is_proprietary_company {set; get;}
        public String marketing_excl_flag {set; get;}
        public String name {set; get;}
        public String full_name {set; get;}
        public String parent_name {set; get;}
        public String telephone {set; get;}
        public String customer_number {set; get;}
        public Address address {set; get;}
        public Postal_Address postal_address {set; get;}
        public Ppb_Address ppb_address {set; get;}
        public Decimal years_established {set; get;}
        //public List<Business_Persons> business_persons {set; get;}
        public List<McQ_Individual_Applicant> business_person {set; get;}
        public List<Beneficial_Owners> beneficial_owners {set; get;}
    }
    
    public class Business_Persons{
        public McQ_Individual_Applicant business_person {set; get;}
    }
    
    public class Beneficial_Owners {
        public Individual_Beneficial_Owner individual_beneficial_owner {set; get;}
    }
    
    public class Individual_Beneficial_Owner {
        public Address address {set; get;}
        public String date_of_birth {set; get;}
        public String fax {set; get;}
        public String title {set; get;}
        public String first_name {set; get;}
        public String middle_name {set; get;}
        public String surname {set; get;}
        public String mobile {set; get;}
        public String telephone {set; get;}
        public String email {set; get;}
    }
    
    public class Trust_Applicant{
        public String activity_purpose {set; get;}
        public String full_name {set; get;}
        public String marketing_excl_flag {set; get;}
        public String organisation_ABN {set; get;}
        public String organisation_type {set; get;}
        public String trustee_business_name {set; get;}
        public List<Beneficiaries> beneficiaries {set; get;}
        public List<Individual_Trustee> individual_trustee {set;get;}
        public LIst<Company_Trustee> company_trustee {set; get;}
    }
    
    public class Beneficiaries{
        public String beneficiary_type {set; get;}
        public String name {set; get;}
    }
    
    public class Partnership_Guarantor extends Partnership_Applicant{}
    
    public virtual class Partnership_Applicant{
        public String abn {set; get;}
        public String business_num {set; get;}
        public String fax {set; get;}
        public String full_name {set; get;}
        public String membership_details {set; get;}
        public String industry {set; get;}
        public String name {set; get;}
        public Address address {set; get;}
        public String professional_asso_name {set; get;}
        public String telephone {set; get;}
        public Decimal years_established {set; get;}
        public List<Mcq_Individual_Applicant> individual_partner {set; get;}
        public List<McQ_Company_Applicant> company_partner {set; get;}
    }
    
    public class Assets{
        public Decimal asset_cost {set; get;}
        public String inventory_flag {set; get;}
        public String replacement_status {set; get;}
        public Decimal year_of_manufacture {set; get;}
        public Motor_Vehicle motor_vehicle {set; get;} //It's a motor vehicle
        public Plant_And_Equipment plant_and_equipment {set; get;} //It's not a motor vehicle
    }
        
    public class Motor_Vehicle{
        public String accessories {set; get;}
        public String body_type {set; get;}
        public String engine_num {set; get;}
        public String make {set; get;}
        public String model {set; get;}
        public String registration_num {set; get;}
        public Decimal retail_value {set; get;}
        public String vin_chasis_num {set; get;}
        public Decimal wholesale_value {set; get;}
        public String nvic {set; get;}
        public Boolean use_glasses_flag {set; get;}
        public String odometer_reading {set; get;}
    }
        
    public class Plant_And_Equipment {
        public String model_num {set; get;}
        public String description {set; get;}
        public Decimal valuation {set; get;}
        public String serial_num {set; get;}
    }   
    
    public class Suppliers{
        public String supplier_name {set; get;}
        public String supplier_contact_name {set; get;}
        public String supplier_ABN {set; get;}
        public String supplier_business_num {set; get;}
        public Supplier_Address supplier_address {set; get;}
        public String supplier_fax {set; get;}
        public String supplier_telephone {set; get;}
    }
    
    public class Manual_Insurers{
        public Decimal amount {set; get;}
        public String from_date {set; get;}
        public String to_date {set; get;}
        public String insurer {set; get;}
        public String type {set; get;}
    }
    
    public class Quotation {
        public Decimal asset_cost {set; get;}
        public Decimal asset_cost_gst {set; get;}
        public String asset_subtype {set; get;}
        public String basis {set; get;}
        public Decimal origination_fee {set; get;}
        public Decimal brokerage_value {set; get;}
        public String brokerage_type {set; get;}
        public Decimal cash_deposit {set; get;}
        public String direct_debit {set; get;}
        public String deferred_months {set; get;}
        public Decimal effective_rate {set; get;}
        public Decimal application_fee {set; get;}
        public String finance_type {set; get;}
        public String fin_lodge_fee {set; get;}
        public Decimal gst_on_insurance {set; get;}
        public Decimal insurance {set; get;}
        public String condition {set; get;}
        public Integer num_of_assets {set; get;}
        public Decimal own_rate {set; get;}
        public String payment_frequency {set; get;}
        public Decimal payout_amount {set; get;}
        public Decimal residual_value {set; get;}
        public String residual_mode {set; get;}
        public String sale_type {set; get;}
        public String contract_number {set; get;}
        public String solve_for {set; get;}
        public String state {set; get;}
        public String term {set; get;}
        public Decimal trade_in {set; get;}
        public String campaign_code {set; get;}
        public String rate_exception {set; get;}
        public Decimal base_rate {set; get;}
        public Decimal gross_payment {set; get;}
        public String residual_type {set; get;}
    }
    
    public class Income_Capacity{
        public Decimal credit_card_expense {set; get;}
        public Decimal household_expense {set; get;}
        public String marital_status {set; get;}
        public Decimal mortgage_rent {set; get;}
        public Decimal num_child {set; get;}
        public Decimal net_income {set; get;}
        public String net_income_verification {set; get;}
        public String spouse_net_income_verification {set; get;}
        public Decimal govt_benefit_income {set; get;}
        public Decimal superannuation_income {set; get;}
        public Decimal investment_property_income {set; get;}
        public Decimal investment_income {set; get;}
        public Decimal other_expense  {set; get;}
        public Decimal other_income {set; get;}
        public String include_spousal_income {set; get;}
        public Decimal spouse_net_income {set; get;}
        public Decimal spouse_other_income {set; get;}
        public String spouse_no_additional_expense_flag {set; get;}
        public Decimal spouse_credit_card_expense {set; get;}
        public Decimal spouse_mortgage_rent {set; get;}
        public Decimal spouse_other_expense {set; get;}
        public Decimal spouse_govt_benefit_income {set; get;}
        public Decimal spouse_superannuation_income {set; get;}
        public Decimal spouse_investment_property_income {set; get;}
        public Decimal spouse_investment_income {set; get;}
    }
    
    public class Comment_Texts{
        public String comment_text_comment {set; get;}
    }
    
    public class Financial_Statement_Application{
        public String application_type {set; get;}
        public String marital_status {set; get;}
        public Decimal num_dependents {set; get;}
        public String co_borrower_rel {set; get;}
    }
    
    public class Financial_Statement {
        public Financial_Income financial_income {set; get;}
        public Financial_Expense financial_expense {set; get;}
        public List<Financial_Assets> financial_assets {set; get;}
        public List<Financial_Liabilities> financial_liabilities {set; get;}
    }
    
    public class Financial_Income {
        public String net_income_verification {set; get;}
        public Decimal monthly_net_income {set; get;}
        public Decimal gross_annual_income {set; get;}
        public Decimal government_benefits {set; get;}
        public Decimal superannuation {set; get;}
        public Decimal investment_property {set; get;}
        public Decimal investment_income {set; get;}
        public Decimal other_income {set; get;}
        public Decimal spouse_gross_income {set; get;}
        public Decimal spouse_net_income {set; get;}
    }
    
    public class Financial_Expense {
        public Decimal monthly_rent_board {set; get;}
        public Decimal general_living {set; get;}
        public String household_reason {set; get;}
        public Boolean all_household_expenses_declared {set; get;}
        public Decimal vehicle_running_cost {set; get;}
        public Boolean all_vehicle_cost_declared {set; get;}
        public Decimal private_education_childcare {set; get;}
        public Decimal other_expenses {set; get;}
        public Boolean spouse_no_additional_expense_flag {set; get;}
        public Boolean all_liabilities_disclosed {set; get;}
    }
    
    public class Financial_Assets {
        public Integer sequence {set; get;}
        public String type_m {set; get;}
        public Decimal amount {set; get;}
        public String owned_outright {set; get;}
        public Boolean owned_outright_flag {set; get;}
    }
    
    public class Financial_Liabilities {
        public Integer sequence {set; get;}
        public String type_m {set; get;}
        public Decimal balance {set; get;}
        public String asset_sequence_link {set; get;}
        public Decimal monthly_payment {set; get;}
        public String financier {set; get;}
        public Boolean payout_flag {set; get;}
        public Date end_date {set; get;}
        public String limit_amount {set; get;}
    }
}