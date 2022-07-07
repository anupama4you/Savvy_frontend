public class WisrAPIResponseDTO extends ObjectJsonSerialize {
  public String wisrApplicationId {get; set;}
  public String status {get; set;}
  public String description {get; set;}
  public Offer offer {get; set;}

  public class Offer {
    public Decimal loanAmount { get; set; }
    public Decimal rateDiscount { get; set; }
    public List<Offers> offers {get; set;}
    public Fee fees {get; set;}
    public Boolean equifaxAccessSeekerReceived {get; set;}
    public Boolean illionAccessSeekerReceived {get; set;}
  }

  public class Offers {
    public Integer term {get; set;}
    public Decimal rate { get; set; }
    public Decimal monthlyRepayment { get; set; }
    public Decimal totalRepayment { get; set; }
    public Boolean isEligible {get; set;}
  }

  public class Fee {
    public Decimal totalEstablishmentFee { get; set; }
    public Decimal establishmentFee { get; set; }
    public Decimal brokerFee { get; set; }
    public Decimal privateSaleFee { get; set; }
    public Decimal ppsRfee { get; set; }
  }
}