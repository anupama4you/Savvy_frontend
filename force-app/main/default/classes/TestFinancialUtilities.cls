@isTest
public class TestFinancialUtilities {
    static Decimal rate1;
    static Integer term1;
    static Decimal term2;
    static Decimal pv;
    static Decimal fv;
    static Decimal amount;
    static Decimal payment1;
    static Decimal residual;
    static Decimal interest;
    static boolean isCommercial1;
    static boolean isCommercial2;
    static Decimal income;
    static Decimal rate2;
    static Decimal payment2;
    static Decimal payment3;
    static Decimal tax;
    static Decimal residual1;
    static Decimal income1;
    static Decimal income2;
    static Decimal income3;
    static Decimal income4;
    
    public static void init(){
        rate1 = 0.06 / 12;
        term1 = 12;
        term2 = 60;
        pv = 1000.00;
        amount = 10000.00;
        payment1 = 176.40;
        residual = 1000.00;
        interest = 0.05 / 12;
        isCommercial1 = false;
        isCommercial2 = true;
        income = 50000.00;
        payment3 = 175.67;
        income1 = 15000.00;
        income2 = 35000.00;
        income3 = 100000.00;
        income4 = 200000.00;
    }
    public static testmethod void testCalculations () {
        init ();
        Test.startTest();
        fv = FinancialUtilities.fv(rate1,term1,pv);
        rate2 = FinancialUtilities.rate(amount, term2, payment1, residual, interest, isCommercial1);
        rate2 = FinancialUtilities.rate(amount, term2, payment3, residual, interest, isCommercial2);
        payment2 = FinancialUtilities.pmt(amount, rate2, term2, residual, isCommercial1);
        payment2 = FinancialUtilities.pmt(amount, rate2, term2, residual1, isCommercial2);
        tax = FinancialUtilities.taxCalculate(income);
        tax = FinancialUtilities.taxCalculate(income1);
        tax = FinancialUtilities.taxCalculate(income2);
        tax = FinancialUtilities.taxCalculate(income3);
        tax = FinancialUtilities.taxCalculate(income4);
        Test.stopTest();
    }

    public static testmethod void testRate2 () {
        init ();
        Test.startTest();
        Integer npr = 60;
        decimal pmt = 214.40;
        decimal pvam = -15000;
        decimal fvres = 0.0;
        integer type = 0;
        Decimal result = FinancialUtilities.rate2( npr, pmt, pvam, fvres, type);
        Test.stopTest();
    }

    public static testmethod void testPmt2 () {
        init ();
        Test.startTest();
        decimal r = 1;
        integer nper = 100;
        decimal pvam = 1000;
        decimal fvres = 0;
        integer type = 0;
        Decimal result = FinancialUtilities.pmt2( r, nper, pvam, fvres, type);
        Test.stopTest();
    }

}