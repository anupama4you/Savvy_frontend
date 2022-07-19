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

  public static CompToolLenderCalcAbstract.FilterParams buildFilterParameter() {
    CompToolLenderCalcAbstract.FilterParams f = new CompToolLenderCalcAbstract.FilterParams();
    f.price = 20000;
    return f;
  }

}