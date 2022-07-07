//Yohan Villamizar                 2019-07-25
public class ProspaCalculatorExtension {
    public Double brokerageInc {set; get;}
    public Double naf {set; get;}
    public Custom_Opportunity__c Opp {set; get;}
    public String LENDER_QUOTING = 'Prospa';
    public List<Application_Quoting__c> apps {set; get;}
    
    public ProspaCalculatorExtension(ApexPages.StandardController controller){
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        this.brokerageInc = 0.00;
        this.naf = 0.00;
        
        if(this.Opp.Loan_Product__c != null){
            this.brokerageInc = this.Opp.Loan_Product__r.Brokerage_GST_Inc__c;
        }
        
        apps = [Select Id, Name, NAF__c, Opportunity__c, Commission_Total_GST_Exc__c 
                From Application_Quoting__c 
                Where Opportunity__c =:this.Opp.Id];
        if(!apps.isEmpty()){
            for(Application_Quoting__c app : apps){
            	this.naf = app.NAF__c;
            }
        }
    }
    
    public PageReference save(){
        if(brokerageInc != null && naf != null){
            Product__c updateProduct = null;
            apps = [Select id, Name, Opportunity__c, Commission_Total_GST_Exc__c 
                    From Application_Quoting__c 
                    Where Opportunity__c = :Opp.Id]; //Oder by last modify date
            updateProduct = QuotingToolHelper.updateProduct(this.Opp);
            if(updateProduct == null){
                updateProduct = new Product__c(Opportunity_Name__c = this.Opp.Id);
            }
            
            updateProduct.Loan_Purpose__c = 'Business Use';
            updateProduct.Loan_Type__c = 'Business Loan';
            updateProduct.Loan_Product__c = 'Business Loan';
            updateProduct.Loan_Type_Detail__c = null;
            updateProduct.Loan_Term__c = 36;
            updateProduct.Balloon_Residual_Requested__c = 0.00;
            updateProduct.Client_Rate__c = 0.00;
            updateProduct.Repayment_Regularity__c = null;
            updateProduct.Lender__c = LENDER_QUOTING;
            updateProduct.Loan_Number__c = null;
            updateProduct.Cost_of_Goods__c = 0.00;
            updateProduct.DOF__c	 = 0.00;
            updateProduct.Lender_App_Fee__c = 0.00;
            updateProduct.Deposit__c = 0.00;
            updateProduct.Brokerage__c = (brokerageInc/1.1).setScale(2);
            updateProduct.Equalisation_Fee_PPSR__c = 0.00;
            updateProduct.Payments__c = 0.00;
            updateProduct.Quoting_Source__c = LENDER_QUOTING;
            
            if (updateProduct.Id == null) {
                insert updateProduct;
                Opp.Loan_Product__c = updateProduct.Id;
                update this.Opp;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product saved successfully'));
            }else{
                update updateProduct;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Product updated successfully'));
            }
            createApplication(this.Opp);
            
            if(!apps.isEmpty()){
                boolean execute = false;
                for(Application_Quoting__c app : apps){
                    if(!'General'.equals(app.Name) && !'Prospa'.equals(app.Name)){
                        deleteQuotingApplication();
                        createAppQuoting();
                    }else if('Prospa'.equals(app.Name) || 'General'.equals(app.Name)){
                        app.NAF__c = this.naf;
                        app.Commission_Total_GST_Exc__c = (brokerageInc/1.1).setScale(2);
                        execute = true;
                    }
                }
                if(execute){
                    update apps;   
                }
            }else{
                createAppQuoting();
            }
        }
        return null;
    }
    
    public void deleteQuotingApplication(){
        QuotingCalculation.deleteQuotingApplication(this.Opp);
    }
    
    public void createAppQuoting(){
        Application_Quoting__c appQuot = new Application_Quoting__c();
        appQuot.Name = 'Prospa';
        appQuot.NAF__c = this.naf;
        appQuot.Loan_Product__c = 'Chattel Mortgage';
        appQuot.Commission_Total_GST_Exc__c = (brokerageInc/1.1).setScale(2);
        appQuot.Opportunity__c = this.Opp.Id;
        insert appQuot;
    }
    
    public void createApplication(Custom_Opportunity__c Opp){
        if(Opp.Application__c == null){
            Application__c app = new Application__c();
            
            If(String.isNotBlank(Opp.First_Name__c) && String.isNotBlank(Opp.Last_Name__c) && String.isNotBlank(Opp.Mobile_Number__c) && String.isNotBlank(Opp.Email_Address__c)){
                app.Name = Opp.Name;
                app.First_Name__c = Opp.First_Name__c;
                app.Last_Name__c = Opp.Last_Name__c;
                app.Mobile_Number__c = Opp.Mobile_Number__c;
                app.Email_Address__c = Opp.Email_Address__c;
                
            }else if(String.isNotBlank(Opp.Account__r.FirstName) && String.isNotBlank(Opp.Account__r.LastName) && String.isNotBlank(Opp.Account__r.Phone)){
                app.Name = Opp.Account__r.FirstName+' '+Opp.Account__r.LastName;
                app.First_Name__c = Opp.Account__r.FirstName;
                app.Last_Name__c = Opp.Account__r.LastName;
                app.Mobile_Number__c = Opp.Account__r.Phone;
                app.Email_Address__c = Opp.Email_Address__c;
                
            }else if(String.isNotBlank(Opp.Lead__r.First_Name__c) && String.isNotBlank(Opp.Lead__r.Last_Name__c) && String.isNotBlank(Opp.Lead__r.Mobile_Number__c) && String.isNotBlank(Opp.Lead__r.Email_Address__c)){
                app.Name = Opp.Lead__r.First_Name__c+' '+Opp.Lead__r.Last_Name__c;
                app.First_Name__c = Opp.Lead__r.First_Name__c;
                app.Last_Name__c = Opp.Lead__r.Last_Name__c;
                app.Mobile_Number__c = Opp.Lead__r.Mobile_Number__c;
                app.Email_Address__c = Opp.Lead__r.Email_Address__c;
            }else{
                app.Name = 'N/A';
                app.First_Name__c = 'N/A';
                app.Last_Name__c = 'N/A';
                app.Mobile_Number__c = '000000';
                app.Email_Address__c = 'noavailable@savvy.com.au';
            }
            insert app;
            
            this.Opp.Application__c = app.Id;
            update this.Opp;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Application saved successfully'));
        }
    }

    public Boolean getIsBrokerPartnerUser() {
      return SOQLSingletonQueries.recs().isBrokerPartnerUser;
    }
}