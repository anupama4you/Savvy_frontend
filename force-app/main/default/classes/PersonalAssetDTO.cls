public with sharing class PersonalAssetDTO {
	public String assetType {set;get;}      //Property (P) or Vehicle (V)
    public String detail {set;get;}
    public Decimal value {set;get;}
    public String hasLoan {set;get;}
    public String loanType {set;get;}
    public String lender {set;get;}
    public Decimal amountOwing {set;get;}
    public Decimal payment {set;get;}
    public String frequency {set;get;}
    public Boolean isPayout {set;get;}
    public Integer order {set;get;}
    public sObject data {set;get;}

    public PersonalAssetDTO() {

    }

    public PersonalAssetDTO(String assetType) {
        this.assetType = assetType;
    }

	public PersonalAssetDTO(ApplicationService.Asset asset) {
		if (asset != null) {
			this.assetType = asset.assetType;	
			this.detail = asset.detail;	
			this.value = asset.value;	
			this.hasLoan = asset.hasLoan;	
			this.loanType = asset.loanType;	
			this.lender = asset.lender;	
			this.amountOwing = asset.amountOwing;	
			this.payment = asset.payment;	
			this.frequency = asset.frequency;	
			this.isPayout = asset.isPayout;	
			this.order = asset.order;	
		}
        
    }

    public PersonalAssetDTO(sObject o, Integer order) {
        this.data = o;
        this.order = order;
    }

}