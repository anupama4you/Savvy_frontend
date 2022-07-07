@isTest
private class TestConnectionRESTWs {
	
	@isTest static void testDeclaration() {
		Test.startTest();
		ConnectionRESTWs c = new ConnectionRESTWs('endpoint', 'method', 'content_type');
		Test.stopTest();
	}
	
	@isTest static void testInvoking() {
		ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
		// p.requestQuery = new Map<String, String>();
		p.addRequestQuery('P1', null);
		p.addRequestQuery('P1', 'value1');
		p.addRequestQuery('P2', 'value2');
		p.addRequestQuery('P3', 'value3', true);

		// p.requestHeader = new Map<String, String>();
		p.addRequestHeader('P1', 'value1');
		p.addRequestHeader('P2', 'value2');
		p.addRequestHeader('P3', 'value3');

		p.setCredentials('user','passwoord');

		p.body = 'body';
		p.contentType = 'contentType';
		p.endpoint = 'http://test.test.tt/api';
		p.method = 'POST';
		p.timeout = 60000;

		SingleRequestMock fakeRes = getQuickMockRequest('{status: "OK"}');
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		ConnectionRESTWs.invoke(p);
		Test.stopTest();
	}

	@isTest static void testInvokingNotBody() {
		ConnectionRESTWs.Param p = getParameter();
		p.body = null;
		SingleRequestMock fakeRes = getQuickMockRequest('{status: "OK"}');
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		ConnectionRESTWs.invoke(p);
		Test.stopTest();
	}

	@isTest static void testInvokingNullParam() {
		Test.startTest();
		ConnectionRESTWs.invoke(null);
		Test.stopTest();
	}
	
	@isTest static void testConnectionService() {
		ConnectionRESTWs.Param p = getParameter();
		SingleRequestMock fakeRes = getQuickMockRequest('{status: "OK"}');
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		ConnectionRESTWs c = new ConnectionRESTWs(p.endpoint, p.method, p.contentType);
		c.connectionServiceHttpResponse(p.requestHeader, p.requestQuery, p.body);
		Test.stopTest();
	}

	@isTest static void testConnectionService2() {
		ConnectionRESTWs.Param p = getParameter();
		SingleRequestMock fakeRes = getQuickMockRequest('{status: "OK"}');
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		ConnectionRESTWs c = new ConnectionRESTWs(p.endpoint, p.method, p.contentType);
		c.connectionServiceHttpResponse(p.requestHeader, p.body);
		Test.stopTest();
	}

	@isTest static void testConnectionService3() {
		ConnectionRESTWs.Param p = getParameter();
		SingleRequestMock fakeRes = getQuickMockRequest('{status: "OK"}');
		Test.setMock(HttpCalloutMock.class, fakeRes);
		Test.startTest();
		ConnectionRESTWs c = new ConnectionRESTWs(p.endpoint, p.method, p.contentType);
		c.connectionServiceBody(p.requestHeader, p.body);
		Test.stopTest();
	}

	private static SingleRequestMock getQuickMockRequest(String body) {
		SingleRequestMock r = new SingleRequestMock(
				200, 'Complete', body, null
			);
		return r;
	}

	public static ConnectionRESTWs.Param getParameter() {
		ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
		p.requestQuery = new Map<String, String>();
		p.requestQuery.put('P1', 'value1');
		p.requestQuery.put('P2', 'value2');
		p.requestQuery.put('P3', 'value3');

		p.requestHeader = new Map<String, String>();
		p.requestHeader.put('P1', 'value1');
		p.requestHeader.put('P2', 'value2');
		p.requestHeader.put('P3', 'value3');

		p.body = 'body';
		p.contentType = 'contentType';
		p.endpoint = 'http://test.test.tt/api';
		p.method = 'POST';
		p.timeout = 60000;
		return p;
	}


}