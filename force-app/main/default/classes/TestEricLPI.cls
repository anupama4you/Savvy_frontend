@isTest(SeeAllData=true)
public class TestEricLPI {
    public static final String DISABILITY = 'Disability';
    public static final String DISABILITYUNEMPLOYMENT = 'Disability/Unemployment';
    
    @isTest static void testEricLPI() {
        EricLPI.Parameter parameters = new EricLPI.Parameter();
        parameters.coverOption = DISABILITY;
        parameters.term = 5;
        parameters.initialAmount = 90000;
        EricLPI.Result results = EricLPI.CalculateEricLPI(parameters);
        parameters.term = 2;
        results = EricLPI.CalculateEricLPI(parameters);
        results = EricLPI.CalculateEricLPI(null);
    }
}