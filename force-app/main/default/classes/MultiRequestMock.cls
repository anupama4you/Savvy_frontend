public class MultiRequestMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public MultiRequestMock() {
		this.requests = new Map<String, HttpCalloutMock>();
	}

	public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
		this();
		if (requests != null) {
			this.requests = requests;
		}
	}

	public HTTPResponse respond(HTTPRequest req) {
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		if (mock != null) {
			return mock.respond(req);
		} else {
    			throw new BaseException('HTTP callout not supported for test methods >> ' + req.getEndpoint());
		}
	}

	public void addRequestMock(String url, HttpCalloutMock mock) {
		requests.put(url, mock);
	}
}