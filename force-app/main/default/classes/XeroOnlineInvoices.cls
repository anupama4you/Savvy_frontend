public class XeroOnlineInvoices {
    public String OnlineInvoiceUrl {set;get;}
    public String ErrorMsg {set;get;}
    
    public XeroOnlineInvoices(){
        
    }
    
    public XeroOnlineInvoices(String Url){
        OnlineInvoiceUrl = Url;
    }
}