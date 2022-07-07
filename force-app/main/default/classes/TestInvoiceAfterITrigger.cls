@isTest
private class TestInvoiceAfterITrigger {
	
	@isTest static void testTrigger() {
		Test_DataGeneratorHelper.createInvoice('Finance Invoice', 'Finance', 1, 1);
	}
	
}