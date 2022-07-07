@isTest
private class TestCustomReportExtension {
	
	@isTest static void testTotalUnassignedLeads() {
		CustomReportExtension c = new CustomReportExtension();
		c.getTotalUnassignedLeads();
	}
	
	@isTest static void testTotalHomeUnassignedLeads() {
		CustomReportExtension c = new CustomReportExtension();
		c.getTotalHomeUnassignedLeads();
	}

	@isTest static void testMachineLearningItems() {
		CustomReportExtension c = new CustomReportExtension();
		c.getMachineLearningItems();
	}

	@isTest static void testTotalBCCLLeads() {
		CustomReportExtension c = new CustomReportExtension();
		c.getTotalUnassignedBCCLLeads();
	}

	@isTest static void testTotalMoney3Leads() {
		CustomReportExtension c = new CustomReportExtension();
		c.getTotalUnassignedMoney3Leads();
	}

}