public class ABNlookupDto {
    public String Abn {set;get;}
    public String AbnStatus {set;get;}
    public String AddressDate {set;get;}
    public String AddressPostcode {set;get;}
    public String AddressState {set;get;}
    public String EntityName {set;get;}
    public String EntityTypeName {set;get;}
    public String EntityTypeCode {set;get;}
    public String Gst {set;get;}
    public List<String> BusinessName {set;get;}
    public String Message {set;get;}
    
    public ABNlookupDto(){
        BusinessName = new List<String>();
    }
}