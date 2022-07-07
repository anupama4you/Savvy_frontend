public class XeroTrackingCategories {
    public String TrackingCategoryID;
    public String Name;
    public String Status;
    public Option[] Options;
    
    public class Option {
        public String TrackingOptionID;
        public String Name;
        public String Status;
        public boolean HasValidationErrors;
        public boolean IsDeleted;
        public boolean IsArchived;
        public boolean IsActive;
        
        public Option(){}
    }
    public XeroTrackingCategories(){}
}