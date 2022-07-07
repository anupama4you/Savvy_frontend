public class ABNnameLookupDto {
	public String Message {set;get;}
    public List<Names> names {set;get;} 
    
    public ABNnameLookupDto(){
        names = new List<Names>();
    }
    
    public class Names {
        public String Abn {set;get;}
    	public String AbnStatus {set;get;}
        public Boolean IsCurrent {set;get;}
        public String Name {set;get;}
        public String NameType {set;get;}
        public String Postcode {set;get;}
        public Integer Score {set;get;}
        public String State {set;get;}
        
        public Names(){
            
        }
    }
}