public class McqQuoteResponseDTO extends ObjectJsonSerialize{
    
    public Decimal gross_payment {set; get;}
    public String payment_frequency {set; get;}
    public Decimal customer_rate {set; get;}
    public String message {set; get;}
    public String lastResponseQuote {set; get;}

}