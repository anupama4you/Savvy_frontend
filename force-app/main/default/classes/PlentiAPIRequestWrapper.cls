/**
 * @Description: Used for Request Json Structure
 */
public class PlentiAPIRequestWrapper extends ObjectJsonSerialize {
  
  public Integer Type;
  public String DefinitionName;
  public String Action;
  public Application application;

  public class Application {
    public Applicant applicant;
    public Contact contact;
    public Finances finances;
    public Address address;
    public Expenses expenses;
    public Housing housing;
    public Income income;
    public List<Employment> employment;
    public Bank bank;
    public Broker broker;
    public List<Debt> debts;
    public Loan loan;
    public TermsAndConditions termsAndConditions;
    public BorrowerMetaInfo borrowerMetaInfo;
    public BalloonPayment balloonPayment;
  }

  public class Applicant {
    public String firstName;
    public String middleName; //opt
    public String lastName;
    public DateOfBirth dateOfBirth;
    public String maritalStatus;
    public String residency;
  }

  public class DateOfBirth {
    public String isoString;
  }

  public class Contact {
    public String mobileNumber;
    public String email;
  }

  public class Finances {
    public String employment;
    public String income;
    public String numberOfDependants;
  }

  public class Address {
    public AddressWrapper residentialAddress;
    public AddressWrapper previousAddress;
  }

  public class AddressWrapper {
    public String unitNumber;
    public String streetNumber;
    public String street;
    public String suburb;
    public String postCode;
    public String state;
    public String yearsAtAddress;
  }

  public class Expenses {
    public String netLivingExpenses;
    public String netLivingExpensesFrequency;
    public Boolean forseeRepaymentAbilityChange;
    public ExpenseWrapper foodAndGroceries;
    public ExpenseWrapper utilities; //opt
    public ExpenseWrapper phoneAndInternet; //opt
    public ExpenseWrapper transport; //opt
    public ExpenseWrapper others; //opt
  }

  public class ExpenseWrapper {
    public String amount;
    public String frequency;
  }

  public class Housing {
    public String ownershipStatus;
    public String propertyValue;
    public String monthlyMortgage;
    public String mortgageBalance;
    public String monthlyRent;
  }

  public class Income {
    public String payslipStartDate;
    public String payslipEndDate;
    public String payslipPayPeriodNetIncome;
    public Boolean hasYTDDetail;
    public String employmentStartDate;
    public String netYTD;
    public String netIncome;
    public String netIncomeFrequency;
    public String spouseNetIncome;
    public String spouseNetIncomeFrequency;
    public Boolean hasOtherIncome;
    public List<OtherIncome> other;
  }

  public class OtherIncome {
    public String type;
    public String amount;
    public String frequency;
  }

  public class Employment {
    public String type;
    public String employer;
    public String industry;
    public String occupation;
    public String years;
    public String months;
    public Boolean isCurrent;
  }

  public class Bank {
    public String accountNumber;
    public String accountName;
    public String bsb;
  }

  public class Broker {
    public String brokerEmail;
    public String brokerMobile;
    public String brokerageAmount;
    public String rateDiscount;
  }

  public class Debt {
    public String type;
    public String balance;
    public String claimedMonthlyRepayment;
    public Boolean payoffFullEveryMonth;
    public String limit_m;
    public String claimedLoanAmount;
  }

  public class Loan {
    public String term;
    public String financeType;
    public String saleType;
    public String deposit;
    public String addon;
    public String purchasedPrice;
    public String vehicleCondition;
    public Integer modelYear;
    // PL
    public Integer amount;
    public String purpose;
    public String purposeReason;
  }

  public class TermsAndConditions {
    public Boolean privacyAgreement;
    public Boolean creditReportingAgreement;
    public Boolean creditGuideConfirmation;
    public Boolean balloonPaymentConsentConfirmation;
  }

  public class BorrowerMetaInfo {
    public Boolean sourceFromApi;
  }

  public class BalloonPayment {
    public Boolean enableBalloonPayment;
    public String balloonPaymentAmount;
    public Integer balloonPaymentPercentage;
    public String customerReason;
    public String customerReasonExplanation;
    public String customerPaidMethodWhenLoanDue;
  }
}