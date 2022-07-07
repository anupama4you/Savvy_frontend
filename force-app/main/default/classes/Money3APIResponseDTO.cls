/**
 * Description : Response Dto for Money3 API service
 */
public class Money3APIResponseDTO extends ObjectJsonSerialize {
    // public String errorCode {get; set;}
    // public String errorMessage {get; set;}
    public Integer loanId {get; set;}
    public String brokerReferenceLoanId {get; set;}
    public String lastResponseApplication {get; set;}
    public List<LenderAPIResponse__c> docs {get; set;}
    public List<Error> errors {get; set;}

    public class DocumentResponse {
        public String id {get; set;}
        // public String file {get; set;}
        // public String documentType {get; set;}
        public String note {get; set;}
        // public Integer byteSize {get; set;}
        // public Datetime createdAt {get; set;}
    }
    
    public class Error {
        public String message {get; set;}
        public String field {get; set;}
    }
}