@isTest
public class ComparisonToolsControllerTest {
 
  @isTest
  static void searchTest() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    Test.startTest();
    List<Calculator__c> data = null;
    try {
      data = ComparisonToolsController.search(null);
    } catch (AuraHandledException e) {}
    data = ComparisonToolsController.search(p);
    Test.stopTest();
  }

  @isTest
  static void calculateTest() {
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.price = 20000.00;
    Test.startTest();
    ComparisonToolsController.calculate(null, p);
    Test.stopTest();
  }


  @isTest
  static void makeCompToolCalculatorTest()  {
    Set<String> lenders = new Set<String>();
    Schema.DescribeFieldResult fieldResult = Calculator__c.Lender__c.getDescribe();
    for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
        lenders.add(f.getValue());
    } 
    CompToolLenderCalcAbstract.FilterParams p = buildFilterParameter();
    p.price = 20000.00;
    Test.startTest();
    Calculator__c c = new Calculator__c();
    for (String a : lenders) {
      c.Lender__c = a;
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
    return f;
  }

}