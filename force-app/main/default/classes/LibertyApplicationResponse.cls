public class LibertyApplicationResponse {

    public ApiResponse apiResponse {set; get;}
    
    public class ApiResponse extends XMLElement{
        public ApplicationNumber applicationNumber  {set; get;}
        public Status status {set; get;}
        public List<ValidationError> validationErrors {set; get;}
        public ResponseContent responseContent {set; get;}
        public String lastResponseApp {set; get;}
    }
    
    public class ApplicationNumber extends XMLElement{}
    public class Status extends XMLElement{}
    public class ValidationError  extends XMLElement {}
    public class ResponseContent extends XMLElement {}
    
    public LibertyApplicationResponse XMLParse(String xml){
        apiResponse = new ApiResponse();
        DOM.Document doc=new DOM.Document();
        try{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, xml));
            doc.load(xml);
            DOM.XmlNode rootNode=doc.getRootElement();
            parseXML(rootNode);
        }catch(exception e){
            system.debug(e.getMessage());
        }
        return this;
    }
    
    private void parseXML(DOM.XMLNode node) {
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
        	system.debug(node.getName());
            if (node.getName() == 'Status'){
                LibertyApplicationResponse.Status status = new LibertyApplicationResponse.Status();
                status.value = node.getText().trim();
                this.apiResponse.status = status;
            }
            if (node.getName() == 'ApplicationNumber'){
                LibertyApplicationResponse.ApplicationNumber applicationNumber = new LibertyApplicationResponse.ApplicationNumber();
                applicationNumber.value = node.getText().trim();
                this.apiResponse.applicationNumber = applicationNumber;
            }
            if (node.getName() == 'ResponseContent'){
                LibertyApplicationResponse.ResponseContent responseContent = new LibertyApplicationResponse.ResponseContent();
                responseContent.value = node.getText().trim();
                this.apiResponse.responseContent = responseContent;
            }
            
            
        	if(node.getName()=='ValidationErrors'){
                List<ValidationError> validationErrors = new List<ValidationError>();
                for (integer i = 0; i < node.getChildElements().size(); i++){
                    DOM.XMLNode ch = node.getChildElements().get(i);
                    validationErrors(ch, validationErrors);
                }
                this.apiResponse.validationErrors = validationErrors;
       		}
            for (Dom.XMLNode child: node.getChildElements()) {
                parseXML(child);
            }
            
        }
    }
    
    private void validationErrors (DOM.XMLNode node, List<ValidationError> validationErrors) {
        if(node.getName()=='ValidationError'){
            ValidationError validateError = new ValidationError();
            validateError.value = node.getText().trim();
            validationErrors.add(validateError);
        }
    }
}