public with sharing class GenerateProductInvoicesExtension
{
    public Id insRT;
    public Id finRT;
    public Integer k {set;get;}
    public String updateInvoiceID {set;get;}
    public String loanNumber;
    public boolean isDisabled {set;get;}
    public Map<Id, Invoice__c> productInvoice{set;get;}
    public Invoice__c invBrokerage {set;get;}
    public Xero_API_Setting__c xeroApiSetting; 
    public PageReference orderPage;
    private Custom_Opportunity__c record;
    public List<Product__c> products;
    public List<Invoice__c> invoices {set;get;}
    public List<Invoice__c> invs {set;get;}
    
    public GenerateProductInvoicesExtension(ApexPages.StandardController c)
    {
        k = 0;
        isDisabled = false;
        record = (Custom_Opportunity__c)c.getRecord();
        invoices = getDisplayInvoices();
        productInvoice = getProductsInvoices();
        products = getProducts();
        finRT = SOQLSingletonQueries.recs().recordTypes.get('Finance Invoice');
        insRT = SOQLSingletonQueries.recs().recordTypes.get('Insurance Invoice');
        invs = new List<Invoice__c>();
    }
    
    public PageReference GenerateMain(){
        this.isDisabled = true;
        return null;
    }
    
    public PageReference Generate()
    {
        this.isDisabled = true;
        Map<Id, String> recLists = recordType();
        
        if(invoices.isEmpty()){
            for (Product__c p : products) {
                Invoice__c inv = chargeInvoices(p); 
                invoices.add(inv);
            }     
            xeroApiSetting = XeroService.createInvoices(invoices, record, 3, loanNumber);
            insert invoices;
        }else{
            boolean flag = false;
            Integer i=3;
            
            for(Product__c p : products){
                if(!productInvoice.containsKey(p.Id)){
                    Invoice__c inv = chargeInvoices(p);
                    invs.add(inv);
                }
            }
            
            for(Invoice__c inv : invoices){
                if(inv.Xero_Invoice_Number__c == null){
                    if(recLists.get(inv.RecordTypeId).equals('Finance Invoice')){
                        flag = true;
                        i=1;
                    }
                    invs.add(inv);
                }
                if(recLists.get(inv.RecordTypeId).equals('Finance Invoice') && inv.Xero_Invoice_DOF_Number__c == null){
                    if(!flag){
                        i=2;
                        invs.add(inv);
                    }else{
                        i=3;
                    }
                }
            }
            if(!invs.isEmpty()){
                xeroApiSetting = XeroService.createInvoices(invs, record, i, getLoanNumber());
                upsert invs; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ' Invoice(s) created in Xero successfully'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ' No Invoice(s) to create'));
            }
        }
        return null;
    }
    
    public Invoice__c chargeInvoices(Product__c p){
        Invoice__c inv = new Invoice__c();    
        inv.Opportunity__c = record.Id;
        inv.Product__c = p.Id;
        inv.Date_of_Invoice__c = Date.today();
        
        if (p.RecordType.Name == 'Finance'){
            inv.RecordTypeId = finRT;
            loanNumber = p.Loan_Number__c;
        } else if (p.RecordType.Name == 'Insurance') {
            inv.RecordTypeId = insRT;
        }
        return inv;
    }
    
    public List<Invoice__c> getDisplayInvoices() {
        return [SELECT Name, Date_of_Invoice__c, RecordType.Name, Invoice_Amount__c, Opportunity__c, Product__c, 
                Xero_Invoice_Id__c, Xero_Invoice_Number__c, Xero_Invoice_DOF_Id__c, Xero_Invoice_DOF_Number__c,
                Xero_Message__c
                FROM Invoice__c
                WHERE Opportunity__c = :this.record.Id 
                ORDER BY Name DESC];
    }
    
    public List<Product__c> getProducts() {
        return [SELECT Id, RecordType.Name, Loan_Number__c FROM Product__c
                WHERE Opportunity_Name__c = :record.Id
                ORDER BY RecordType.Name];
    }
    
    static Map<Id,String> recordType(){
        Map<Id,String> recordType = new Map<Id,String>();
        for (RecordType rt: [SELECT Id, Name FROM RecordType]) {
            recordType.put(rt.Id, rt.Name);
        }
        return recordType;
    }
    
    public PageReference downloadXeroInvoicePdf(){
        this.isDisabled = true;
        if(k==0){
            wait(5000);
            invoices = getDisplayInvoices();
        }
        if(k == invoices.size()){
            XeroService.downloadInvoicePdf(invBrokerage, record, false);
            if (Test.isRunningTest()) {
                System.debug('Refreshed with success');
            }else{
                wait(5000);
                orderPage = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/GenerateProductInvoices?id='+record.Id);
                orderPage.setRedirect(true);
            }
        }else if(k < invoices.size()) {
            Invoice__c invAux = XeroService.downloadInvoicePdf(invoices[k], record, true);
            if(invAux != null){
                invBrokerage = invAux;
            }
            k++;
        }
        return orderPage;
    }
    
    public void updateXeroCommissionInvoice(){
        updateXeroInvoice(1, false);
    }
    
    public void updateXeroDOFInvoice(){
        updateXeroInvoice(2, true);
    }
    
    public void updateXeroInvoice(Integer i, boolean isDOF){
        Invoice__c inv = XeroService.InvoiceUpdate(updateInvoiceID, record, i, getLoanNumber());
        XeroService.downloadInvoicePdf(inv, record, isDOF);
    }
    
    public String getLoanNumber(){
        for (Product__c p : products) {
            if (p.RecordType.Name == 'Finance'){
                loanNumber = p.Loan_Number__c;
            }
        }
        return loanNumber;
    }
    
    public void Refresh(){
        getDisplayInvoices();
    }
    
    public Map<Id, Invoice__c> getProductsInvoices(){
        Map<Id, Invoice__c> recordType = new Map<Id, Invoice__c>();
        for (Invoice__c rt: [SELECT Name, Date_of_Invoice__c, RecordType.Name, Invoice_Amount__c, Opportunity__c, Product__c, 
                             Xero_Invoice_Id__c, Xero_Invoice_Number__c, Xero_Invoice_DOF_Id__c, Xero_Invoice_DOF_Number__c,
                             Xero_Message__c
                             FROM Invoice__c
                             WHERE Opportunity__c = :this.record.Id 
                             ORDER BY Name DESC]) {
                                 recordType.put(rt.Product__c, rt);
                             }
        return recordType;
    }
    
    public Boolean getIsDisabled(){
        return this.isDisabled;
    }
    
    public static void wait(Integer millisec) {
        
        if(millisec == null || millisec < 0) {
            millisec = 0;
        }
        
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < millisec) {
            finishTime = DateTime.now().getTime();
        }
    }
}