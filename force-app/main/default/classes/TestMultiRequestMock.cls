@isTest
private class TestMultiRequestMock {
	
	@isTest static void testFull() {
		Test.startTest();
		MultiRequestMock m = new MultiRequestMock();

		Map<String, HttpCalloutMock> requests = new Map<String, HttpCalloutMock>();
		SingleRequestMock rm = new SingleRequestMock(200, 'Complete', '{any: "text"}', null);
		String url = '/api/test';
		m = new MultiRequestMock(requests);
		m.addRequestMock(url, rm);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);

		System.assertNotEquals(null, m.respond(req));
		
		req = new HttpRequest();
		req.setEndpoint(url+'/2');
		try {
			m.respond(req);
		} catch (BaseException e) {
			System.assert(e.getMessage().contains('HTTP callout not supported'));
		}

		Test.stopTest();	
	}

}