@isTest
public class ComparisonToolsControllerTest {
 
  @IsTest(SeeAllData=true) 
  static void searchTest() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    List<Calculator__c> data = null;
    try {
      data = ComparisonToolsController.search(null);
    } catch (AuraHandledException e) {}
    data = ComparisonToolsController.search(p);
    p.assetAge = 3;
    data = ComparisonToolsController.search(p);
    p.loanType = 'Business';
    p.creditScore = '853 - 1200';
    p.hasVerifiableCredit = 'N';
    p.paydays = '0';
    data = ComparisonToolsController.search(p);
    Test.stopTest();
  }

  @IsTest(SeeAllData=true)
  static void calculateTest() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.price = 20000.00;
    Test.startTest();
    // No calculator
    ComparisonToolsController.calculate(null, p);
    // All calcs
    List<Calculator__c> calcs = [
      SELECT Id, Name FROM Calculator__c
    ];
    for (Calculator__c c : calcs) {
      try {
        ComparisonToolsController.calculate(c, p);
      } catch (MathException e) {}
    }  
    Test.stopTest();
  }


  @IsTest(SeeAllData=true) 
  static void makeCompToolCalculatorTest()  {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.price = 20000.00;
    Test.startTest();
    List<Calculator__c> calcs = [
      SELECT Id, Name FROM Calculator__c
    ];
    for (Calculator__c c : calcs) {
      ComparisonToolsController.makeCompToolCalculator(c, p);
    }    
    Test.stopTest();
  }

  @isTest
  static void resultClass()  {
    Test.startTest();
    CompToolLenderResult r = new CompToolLenderResult();
    r.details = null;
    System.debug(r.commission);
    System.debug(r.dof);
    System.debug(r.monthlyPayment);
    System.debug(r.naf);
    System.debug(r.rental);
    System.debug(r.fortnightlyPayment);
    System.debug(r.totalCommission);
    System.debug(r.totalCommissionGst);
    System.debug(r.weeklyPayment);
    
    Test.stopTest();
  }

  @isTest
  static void initialParams() {
    Test_DataGeneratorHelper.buildCarApp(true);
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(false);
    Test_DataGeneratorHelper.createLead();
    Lead__c lead = Test_DataGeneratorHelper.tstLead;
    lead.Credit_History__c = 'Excellent';
    lead.Finance_Amount__c = 20000;
    lead.Loan_Type__c = 'Car Loan';
    lead.Loan_For__c = 'Car';
    lead.Employment_Status__c = 'Employer';
    lead.Property_Owner__c = 'Yes';
    lead.Vehicle_Year__c = String.valueOf(Date.today().year() - 1);
    lead.Length_of_Term__c = 3;
    update lead;

    o.Lead__c = lead.Id;
    update o;

    Test.startTest();
    try {
      ComparisonToolsController.getInitialParamsById(null);
      System.assert(false, 'Opp Id null should get an error');
    } catch (GenericException e) {
      System.debug(e.getMessage());
    }

    ComparisonToolsController.getInitialParamsById(o.Id);

    Test_DataGeneratorHelper.reloadOpportunity();
    o = Test_DataGeneratorHelper.tstOpportunity;

    System.debug('@@opp: ' + JSON.serializePretty(o));

    // Personal
    o.Application__r.Application_Type__c = 'Personal';

    // Asset types
    List<String> tmp = new List<String>{
      'Car', 'Bike', 'Caravan', 'Truck', 'Boat', 'Other'
    };

    for (String a: tmp) {
      o.Application__r.Type_of_Asset__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // Employments
    tmp = new List<String>{
      'Full Time', 'Part Time', 'Casual', 'Truck', 'Boat', 'Other'
    };

    for (String a: tmp) {
      o.Application__r.Mode_of_Employment_1__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // Residential status
    tmp = new List<String>{
      'Own Outright', 'Mortgage', 'Renting(Agent)', 'Renting(Private)', 'Boarding'
    };

    for (String a: tmp) {
      o.Application__r.Current_Residence_Status_1__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // Business
    o.Application__r.Application_Type__c = 'Business';
    ComparisonToolsController.getInitialParams(o);

    // Lead details
    o.Application__c = null;
    
    o.Lead__r.Vehicle_Year__c = String.valueOf(Date.today().year() - 1);

    // Credit History
    tmp = new List<String>{
      'Excellent', 'Average', 'Not Sure', 'Poor'
    };

    for (String a: tmp) {
      o.Lead__r.Credit_History__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // Loan Type
    tmp = new List<String>{
      'Commercial Loan', 'Chattel Mortgage'
    };

    for (String a: tmp) {
      o.Lead__r.Loan_Type__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // Residential
    tmp = new List<String>{
      'Yes', 'No'
    };

    for (String a: tmp) {
      o.Lead__r.Property_Owner__c = a;
      ComparisonToolsController.getInitialParams(o);
    }

    // getCompAssetType
    tmp = new List<String>{
      'Boat', 'Bike', 'Bus', 'Caravan', 'Trailers', 'Personal', 'Solar',
      'Printing', 'IT - Software Finance', 'Technology', 'Telephone System',
      'Commercial Utilities and Van', 'Bulldozer', 'Dental', 'Point of Sale',
      'Equipment'
    };

    for (String a: tmp) {
      ComparisonToolsController.getCompAssetType('Business', 'Other', a);
    }




    Test.stopTest();
  }

  public static CompToolLenderCalcAbstract.FilterParams buildFilterParameter() {
    CompToolLenderCalcAbstract.FilterParams f = new CompToolLenderCalcAbstract.FilterParams();
    f.price = 20000;
    return f;
  }

}