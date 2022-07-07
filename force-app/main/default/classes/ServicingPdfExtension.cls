public with sharing class ServicingPdfExtension {
    
    public AppServicingCalculatorDTO servCalc {set;get;} 
    public List<Application_Credit_Card__c> creditCards {set;get;}
    public Decimal totalCreditCards {set;get;}
    public ServicingPdfExtension (ApexPages.StandardController controller) {
        try {
        	controller.addFields(new List<String>{'Application__c'});
        } catch (SObjectException e) {}
        Custom_Opportunity__c Opp = (Custom_Opportunity__c)controller.getRecord ();
        
        String objData = System.currentPageReference().getParameters().get('OBJ_DATA');
        
        loadPreApprovalData(Opp.Application__c, objData);
        this.loadMoreDetails(Opp.Application__c);
    }
	
    private void loadPreApprovalData(Id appId, String objData) {
        Application_Extra_Data__c a = null;
        if (objData == null) {
        	a = ApplicationExtraDataHelper.getApplicationExtraDataId(appId, 'Servicing Calculation');
        	if (a != null) {
                servCalc = (AppServicingCalculatorDTO)JSON.deserialize(a.Data__c, AppServicingCalculatorDTO.class);
            } else {
                servCalc = new AppServicingCalculatorDTO();
            }
        } else {
            servCalc = (AppServicingCalculatorDTO)JSON.deserialize(objData, AppServicingCalculatorDTO.class);
        }
    }
    
    private void loadMoreDetails(Id appId) {
        this.creditCards = ApplicationService.getApplicationCreditCards(appId);
        this.totalCreditCards = 0.0;
        for (Application_Credit_Card__c a : this.creditCards) {
            if(!a.Is_Payout__c){
            	this.totalCreditCards += a.Monthly_Payment__c;
            }
        }
        this.totalCreditCards = this.totalCreditCards.setScale(2);
    }
}