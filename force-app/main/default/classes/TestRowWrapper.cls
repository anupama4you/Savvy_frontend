@isTest
public class TestRowWrapper {
    public static testmethod void testCalculations () {
        Test.startTest();
        RowWrapper testWrapper = new RowWrapper ();
        testWrapper.addValue(3.14);
        Test.stopTest();
    }
}