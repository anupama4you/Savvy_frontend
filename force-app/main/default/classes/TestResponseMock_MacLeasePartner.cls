@isTest
public class TestResponseMock_MacLeasePartner implements HttpCalloutMock {
    protected Integer code;
    protected String status;
	protected String bodyAuth;
    protected String bodyService;
	protected Map<String, String> responseHeaders;
    
    public TestResponseMock_MacLeasePartner(Integer code, String status, String bodyAuth, String bodyService,
                                         Map<String, String> responseHeaders) {
		this.code = code;
        this.status = status;
        this.bodyAuth = bodyAuth;
		this.bodyService = bodyService;
        this.responseHeaders = responseHeaders;
	}



	public HTTPResponse respond(HTTPRequest req) {
		HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
    
        if (req.getEndpoint().contains('auth')){
            resp.setBody(bodyAuth);
        }else{
            resp.setBody(bodyService);
        }
            
      
        
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
}