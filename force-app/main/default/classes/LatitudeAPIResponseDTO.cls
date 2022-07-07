public class LatitudeAPIResponseDTO {
    public String applicationId { get; set; }
    public String message { get; set; }
    public List<Error> errors { get; set; }
    
    public class Error {
        public String field{get;set;}
        public String reason {get;set;}
    }
}