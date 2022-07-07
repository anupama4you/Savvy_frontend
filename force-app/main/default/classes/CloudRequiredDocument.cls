public class CloudRequiredDocument {
	
    public String fileName {set;get;}
    public Blob blobFile {set;get;}
    public String docName {set;get;}
    public String contentType {set;get;}
    public String oppId {set;get;}
    public String documentType {set;get;}
    public String accessLevel {set;get;}
    public Boolean isVDType {set;get;}
    public Blob binaryPDF {set;get;}
    public String VDOppId {set;get;}
    public String VDQuotationDealerId {set;get;}
    public String VDQuotationVehicleOfferId {set;get;}
    public String VDOppName {set;get;}
    
    public CloudRequiredDocument(String documentType) {
        this.documentType = documentType;
        this.accessLevel = 'private';
        this.isVDType = false;
    }
    
}