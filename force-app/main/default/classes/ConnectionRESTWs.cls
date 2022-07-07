public class ConnectionRESTWs {
    
    public static final String POST = 'POST';
    public static final String GET = 'GET';
    public static final String PUT = 'PUT';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    public static final String CONTENT_TYPE_XML = 'application/xml';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String SOAP_ACTION = 'SOAPAction';
    
    public String content_type {set; get;}
    public String endpoint {set; get;}
    public String method {set; get;}
    
    public ConnectionRESTWs(String endpoint, String method, String content_type){
        this.endpoint = endpoint;
        this.method = method;
        this.content_type = content_type;
    }
    
    public HttpResponse connectionServiceHttpResponse(Map<String, String> requestHeader, Map<String, String> requestQuery, String body){
        HttpResponse resp = new HttpResponse();
        Http http = new Http();
        HttpRequest req = new HttpRequest();
       
        req.setTimeout(40000);
        req.setMethod(method);
        req.setHeader('Content-Type', content_type);
        if (requestHeader != null){
            for (String key : requestHeader.keySet()){
                req.setHeader(key, requestHeader.get(key));
            }
        }
        
        if (requestQuery != null){
            System.debug('total query params: ' + requestQuery.size());
            Map<String, String> tmp = new Map<String, String>();
            for (String key : requestQuery.keySet()){
                if (String.isNotBlank(requestQuery.get(key))) {
                    tmp.put(key, requestQuery.get(key));
                }
            }
            if (!tmp.isEmpty()) {
                System.debug('total real query params: ' + tmp.size());
                String query = '?';
                for (String key : tmp.keySet()){
                    query += key + '=' + tmp.get(key) + '&';
                }
                endpoint += query.substring(0, query.length()-1);
            }
        }        
        req.setEndpoint(endpoint);
        
        if(method == POST){
	    	req.setBody(Body);
	    }	
        try{
            System.debug('**HttpRequest endPoint:' + req.getEndpoint());
            System.debug('**HttpRequest Body:' + req.getBody());
            System.debug('**HttpRequest Header:' + req.getHeader('Authorization'));
            resp = http.send(req);
            System.debug('**connectionServiceHttpResponse**');
            System.debug('**HttpResponse Body:' + resp.getBody());
            System.debug('**HttpResponse Status Code:' + resp.getStatusCode());
            System.debug('**HttpResponse Status:' + resp.getStatus());
       		return resp;
        }catch (Exception ex){
            throw new GenericException ('<Error in connectionServiceHttpResponse with external service> - ' + ex.getMessage() + ' -' , ex);
        }
    } 
    
     public HttpResponse connectionServiceHttpResponse(Map<String, String> requestHeader, String body){
         return connectionServiceHttpResponse(requestHeader, null, body);
     }
    
    public String connectionServiceBody(Map<String, String> requestHeader, String body){
        HttpResponse resp = connectionServiceHttpResponse(requestHeader, body);
        return resp.getBody();
    } 
    
    // Lelo                 2019-02-19

    public class Param {
        public Map<String, String> requestQuery {set;get;}
        public Map<String, String> requestHeader {set;get;}
        public String body {set;get;}
        public String contentType {set; get;}
        public String endpoint {set; get;}
        public String method {set; get;}
        public Integer timeout {set;get;}
        public Param() {
            this.timeout = 90000;
            this.requestQuery = new Map<String, String>();
            this.requestHeader = new Map<String, String>();
        }

        public void setCredentials(String username, String password) {
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            this.requestHeader.put('Authorization', authorizationHeader);
        }

        public void addRequestQuery(String name, String value) {
            this.addParameterRequest(this.requestQuery, name, value, false);
        }

        public void addRequestQuery(String name, String value, Boolean isEncoded) {
            this.addParameterRequest(this.requestQuery, name, value, isEncoded);
        }

        public void addRequestHeader(String name, String value) {
            this.addParameterRequest(this.requestHeader, name, value, false);
        }

        private void addParameterRequest(Map<String, String> paramList, String name, String value, Boolean isEncoded) {
            if (String.isBlank(name) || String.isBlank(value)) return;
            String var = value;
            if (isEncoded) {
                var = EncodingUtil.urlEncode(value, 'UTF-8');
            }
            paramList.put(name, var);
        }

    }
    
    public static HttpResponse invoke(Param param){
        System.debug('Invoking service...');
        HttpResponse r = new HttpResponse();
        if (param == null) {
            System.debug('Null params');
            return r;
        }
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(param.timeout);
        req.setMethod(param.method);
        if (String.isNotBlank(param.contentType)) {
            req.setHeader('Content-Type', param.contentType);
        }
        if (param.requestHeader != null){
            System.debug('Adding header params...');
            for (String key : param.requestHeader.keySet()){
                String pvalue = param.requestHeader.get(key);
                if (String.isNotBlank(pvalue)) {
                    req.setHeader(key, pvalue);
                    System.debug(key + ': ' + pvalue);
                }
            }
        }
        
        String url = param.endpoint;
        
        if (param.requestQuery != null){
            System.debug('Adding query params...');
            System.debug('total query params: ' + param.requestQuery.size());
            Map<String, String> tmp = new Map<String, String>();
            for (String key : param.requestQuery.keySet()){
                if (String.isNotBlank(param.requestQuery.get(key))) {
                    tmp.put(key, param.requestQuery.get(key));
                }
            }
            if (!tmp.isEmpty()) {
                System.debug('total real query params: ' + tmp.size());
                String query = '?';
                for (String key : tmp.keySet()){
                    query += key + '=' + tmp.get(key) + '&';
                }
                url += query.substring(0, query.length()-1);
            }
            // String query = '?';
            // for (String key : param.requestQuery.keySet()){
            //     query += key + '=' + param.requestQuery.get(key) + '&';
            // }
            // url += query.substring(0, query.length()-1);
        }
        
        req.setEndpoint(url);
        
        if(String.isNotBlank(param.Body)) {
            req.setBody(param.Body);
        } else if(POST.equals(param.method)) {
            req.setBody('');
        }
        try{
            System.debug('**HttpRequest endPoint:' + req.getEndpoint());
            System.debug('**HttpRequest Body:' + req.getBody());
            System.debug('**HttpRequest Header:' + req.getHeader('Authorization'));
            System.debug('Sending request...');
            System.debug(req);
            r = http.send(req);
            System.debug(r);
            System.debug('**connectionServiceHttpResponse**');
            System.debug('**HttpResponse Headers:');
            for (String hk: r.getHeaderKeys()) {
                System.debug('** ' + hk + ': ' + r.getHeader(hk));
            }
            System.debug('**HttpResponse Body:' + r.getBody());
            System.debug('**HttpResponse Status Code:' + r.getStatusCode());
            System.debug('**HttpResponse Status:' + r.getStatus());
            return r;
        }catch (Exception ex){
            throw new GenericException ('<Error in connectionServiceHttpResponse with external service> ' + ex.getMessage() + ' [' +url+']'  , ex);
        }
    } 

}