public class PepperApplicationResponseDTO extends ObjectJsonSerialize{
    
    public String errorCode {set; get;}
    public String errorMessage {set; get;}
    public String requestId {set; get;}
    public String lastResponseApplication {set; get;}
    public Application application {set; get;}
    public List<LenderAPIResponse__c> docs {get; set;}
    public List<ReasonsForSubmissionFailure> reasonsForSubmissionFailure { get; set; }
    
    public class Application {
        public String applicationNo {set; get;}
    }

    public class ReasonsForSubmissionFailure{
      public String applicationSection { get; set; }
      public String errorMessage { get; set; }
      public String errorContext { get; set; }
    }
}