@isTest
private class TestPostcodeHelper {
	
	@isTest static void testState() {
		String postcode = null;
		System.assert(String.isBlank(PostcodeHelper.getState(postcode)));

		postcode = 'just text';
		System.assert(String.isBlank(PostcodeHelper.getState(postcode)));

		//NSW
		postcode = '1000';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2599';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2620';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2899';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2921';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2999';
		System.assert(PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));

		postcode = '999';
		System.assert(!PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2600';
		System.assert(!PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2619';
		System.assert(!PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));
		postcode = '2900';
		System.assert(!PostcodeHelper.NSW.equals(PostcodeHelper.getState(postcode)));

		//Victoria
		postcode = '3000';
		System.assert(PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '3999';
		System.assert(PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '8000';
		System.assert(PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '8999';
		System.assert(PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));

		postcode = '2999';
		System.assert(!PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '4000';
		System.assert(!PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '7999';
		System.assert(!PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));
		postcode = '9000';
		System.assert(!PostcodeHelper.VIC.equals(PostcodeHelper.getState(postcode)));

		//Queensland
		postcode = '4000';
		System.assert(PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '4999';
		System.assert(PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '9000';
		System.assert(PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '9999';
		System.assert(PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));

		postcode = '3999';
		System.assert(!PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '5000';
		System.assert(!PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '8999';
		System.assert(!PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));
		postcode = '10000';
		System.assert(!PostcodeHelper.QLD.equals(PostcodeHelper.getState(postcode)));

		// South Australia
		postcode = '5000';
		System.assert(PostcodeHelper.SA.equals(PostcodeHelper.getState(postcode)));
		postcode = '5999';
		System.assert(PostcodeHelper.SA.equals(PostcodeHelper.getState(postcode)));

		postcode = '4999';
		System.assert(!PostcodeHelper.SA.equals(PostcodeHelper.getState(postcode)));
		postcode = '6000';
		System.assert(!PostcodeHelper.SA.equals(PostcodeHelper.getState(postcode)));

		//Western Australia
		postcode = '6000';
		System.assert(PostcodeHelper.WA.equals(PostcodeHelper.getState(postcode)));
		postcode = '6999';
		System.assert(PostcodeHelper.WA.equals(PostcodeHelper.getState(postcode)));

		postcode = '5999';
		System.assert(!PostcodeHelper.WA.equals(PostcodeHelper.getState(postcode)));
		postcode = '7000';
		System.assert(!PostcodeHelper.WA.equals(PostcodeHelper.getState(postcode)));

		// Tasmania
		postcode = '7000';
		System.assert(PostcodeHelper.TAS.equals(PostcodeHelper.getState(postcode)));
		postcode = '7999';
		System.assert(PostcodeHelper.TAS.equals(PostcodeHelper.getState(postcode)));

		postcode = '6999';
		System.assert(!PostcodeHelper.TAS.equals(PostcodeHelper.getState(postcode)));
		postcode = '8000';
		System.assert(!PostcodeHelper.TAS.equals(PostcodeHelper.getState(postcode)));

		// Australian Capital Territory
		postcode = '0200';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '0299';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));

		postcode = '2600';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2619';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));

		postcode = '2900';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2920';
		System.assert(PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));

		postcode = '0199';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '0300';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2599';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2620';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2899';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));
		postcode = '2921';
		System.assert(!PostcodeHelper.ACT.equals(PostcodeHelper.getState(postcode)));

		// Northen Territorio
		postcode = '0800';
		System.assert(PostcodeHelper.NT.equals(PostcodeHelper.getState(postcode)));
		postcode = '0999';
		System.assert(PostcodeHelper.NT.equals(PostcodeHelper.getState(postcode)));

		postcode = '600';
		System.assert(!PostcodeHelper.NT.equals(PostcodeHelper.getState(postcode)));
		postcode = '1000';
		System.assert(!PostcodeHelper.NT.equals(PostcodeHelper.getState(postcode)));

	}

	@isTest static void testTimezones() {
		Map<String, String> data = new Map<String, String>();
		data.put(PostcodeHelper.NSW,'Australia/Sydney');
		data.put(PostcodeHelper.ACT,'Australia/Sydney');
		data.put(PostcodeHelper.QLD,'Australia/Brisbane');
		data.put(PostcodeHelper.VIC,'Australia/Melbourne');
		data.put(PostcodeHelper.TAS,'Australia/Melbourne');
		data.put(PostcodeHelper.SA,'Australia/Adelaide');
		data.put(PostcodeHelper.NT,'Australia/Adelaide');
		data.put(PostcodeHelper.WA,'Australia/Perth');
		for (String k: data.keySet()) {
			System.assertEquals(data.get(k), PostcodeHelper.getTimezone(k));
		}
	}

}