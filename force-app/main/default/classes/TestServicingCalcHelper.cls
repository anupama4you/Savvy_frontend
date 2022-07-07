@isTest
private class TestServicingCalcHelper {
	
	@isTest static void testServicing() {
		// Null parameter
		ServicingCalcHelper.Parameter p = null;
		ServicingCalcHelper.calculate(p);
		// Empty parameter
		p = new ServicingCalcHelper.Parameter();
		ServicingCalcHelper.calculate(p);
		p.lender = 'Finance One';
		ServicingCalcHelper.calculate(p);
		p.lender = 'Green Light';
		ServicingCalcHelper.calculate(p);
		p.lender = 'Macquarie Consumer';
		ServicingCalcHelper.calculate(p);
		p.lender = 'Macquarie Commercial';
		p.maritalStatus = 'Married';
		ServicingCalcHelper.calculate(p);
		p.appId = null;
		ServicingCalcHelper.Result r = ServicingCalcHelper.calculate(p);
		if (r != null) {
			r.getAmountAvailable();
		}
		p.lender = 'Finance One';
		p.splitingExpenses = true;
		p.maritalStatus = 'Married';
		p.dependents = 0;
		ServicingCalcHelper.calculate(p);
	}
		
}