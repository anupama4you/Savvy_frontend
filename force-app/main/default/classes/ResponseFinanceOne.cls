public class ResponseFinanceOne {
    public String message {get;set;}
    public Error errors {get;set;}
    public Data data {get;set;}
    
    public class Error {
        public Simple[] simple {get;set;}
        public Application[] application {get;set;}
        public Applicants[] applicants {get;set;}
    }
    
    public class Simple {
        public String path {get;set;}
        public String errorType {get;set;}
        public String errorMessage {get;set;}
        public String errorCode {get;set;}
    }
    
    public class Application {
        public String errorType {get;set;}
        public String errorMessage {get;set;}
        public String errorCode {get;set;}
    }
    
    public class Applicants {
        public Errors[] errors {get;set;}
    }
    
    public class Errors {
        public String errorType {get;set;}
        public String errorMessage {get;set;}
        public String errorCode {get;set;} 
    }
    
    public class Data {
        public String uuid {get;set;}
        public String accountId {get;set;}               
    }
}