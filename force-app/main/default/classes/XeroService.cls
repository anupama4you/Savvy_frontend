public with sharing class XeroService {
    
    public static Map<Id, String> recLists {set;get;}
    public static Parameter parameters {set;get;}
    public static Map<Id, Custom_Opportunity__c> oppLists {set; get;}
    public static Map<String,Invoice__c> recordInvoices {set; get;}
    public static String DOF = 'DOF';
    public static String BROKERAGE = 'Brokerage';
    
    public static Xero_API_Setting__c createInvoices (List<Invoice__c> invoices, Custom_Opportunity__c opp, Integer i, String loanNumber) {
        setupData(opp, loanNumber);
        
        if(parameters.xeroApiSetting.Active__c){
            for(Invoice__c inv : invoices){
                proccessInvoice(inv, opp, i);
            }
        }
        return parameters.xeroApiSetting;
    }
    
    static void proccessInvoice(Invoice__c inv, Custom_Opportunity__c opp, Integer i){
        parameters.i = i;
        parameters.invoice = inv;
        if(!recLists.isEmpty() && !oppLists.isEmpty()){
            if (validateParameters(parameters.invoice, opp, recLists, oppLists)){
                if('Insurance Invoice'.equals(recLists.get(inv.RecordTypeId))){
                    for (Product__c p : oppLists.get(opp.Id).Products__r){
                        if(inv.Product__c == p.Id){
                            if(p.Insurer__c != null && parameters.contactsList.get(p.Insurer__c) !=null){
                                createCommissionInvoice(parameters, inv, p, 1);
                            }else{
                                inv.Xero_Message__c = 'This invoice was not created in Xero because the Lender does not exist for this product';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, inv.Xero_Message__c));
                            }
                        }
                    }
                }else if('Finance Invoice'.equals(recLists.get(inv.RecordTypeId))){
                    for (Product__c p : oppLists.get(opp.Id).Products__r){
                        if(inv.Product__c == p.Id){ 
                            if(p.Lender__c != null  && parameters.contactsList.get(p.Lender__c) !=null){
                                switch on parameters.i {
                                    when 1 {
                                        createCommissionInvoice(parameters, inv, p, 2);
                                    }
                                    when 2 {
                                        createDofInvoice(parameters, inv, p);
                                    }
                                    when 3 {
                                        createBrokerageDofInvoices(parameters, inv, p);
                                    }
                                }
                            }else{
                                inv.Xero_Message__c = 'This invoice was not created in Xero because the Lender does not exist for this product';
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,inv.Xero_Message__c));
                            }
                        }
                    }
                }
            }
        }
    }
    
    static void createCommissionInvoice(Parameter param, Invoice__c inv, Product__c p, Integer status){
        param.trackinOption = '201';
        if(status == 1){
            createInvoice(p.Insurance_Commission_2__c, p.Insurance_Commission__c, p.Insurance_Type__c, p.Insurer__c , param, false);
            updateInvoice(inv, param, 'noDOF', p.Insurance_Type__c);
        }else if(status == 2){
            String d = BROKERAGE;
            if(String.isNotBlank(param.contactsList.get(p.Lender__c).Brokerage_Description__c)){
                d = param.contactsList.get(p.Lender__c).Brokerage_Description__c;
            }
            createInvoice(p.Brokerage__c, p.Brokerage_GST_Inc__c, d, p.Lender__c , param, false);
            if(param.xi!=null){
                updateInvoice(inv, param, 'noDOF', d);    
            }
        }
    }
    
    static void createDofInvoice( Parameter param, Invoice__c inv, Product__c p){
        param.trackinOption = '200';
        Boolean isFreeTax = false;
        
        List<Xero_Contact_Setting__c> settings = getXeroContactSeting(param, p);
        
        if(settings[0].DOF_GST_Free__c){
            isFreeTax = true;
        }
        String d = DOF;
        if(String.isNotBlank(param.contactsList.get(p.Lender__c).DOF_Description__c)){
            d = param.contactsList.get(p.Lender__c).DOF_Description__c;
        }
        createInvoice(p.DOF_2__c, p.DOF__c, d, p.Lender__c , param, isFreeTax);
        if(param.xi!=null){
        	updateInvoice(inv, param, 'DOF', d);    
        }
    }
    
    static void createBrokerageDofInvoices(Parameter param, Invoice__c inv, Product__c p){
        createDofInvoice(param, inv, p);
        createCommissionInvoice(param, inv, p, 2);
    }
    
    static void createInvoice(Decimal exclusive, Decimal inclusive, String descripcion, String lender, Parameter param, Boolean isFreeTax){
        if((exclusive != null && inclusive != null) || (exclusive > 0 && inclusive > 0)){
            List<XeroInvoice.LineItem> items = new List<XeroInvoice.LineItem>();
            XeroContact newContact = new XeroContact();
            XeroInvoice newInvoice = chargeInvoice(exclusive, inclusive, param);
            
            newContact.ContactID = param.contactsList.get(lender).ContactID__c;
            newInvoice.Contact = newContact;
            String ownerName = createOwnerName(param.ownerName);
            
            if(!param.trackingCategoryOptions.containsKey(ownerName)){
                XeroTrackingCategories.Option option = new XeroTrackingCategories.Option();
                option.Name = ownerName;
                XeroAccountingApi.createTrackingOption(XeroXmlUtility.serializeJson(option), param.xeroApiSetting);
                param.trackingCategoryOptions.put(ownerName,'');
            }
            
            XeroInvoice.LineItem item = chargeItem(exclusive, descripcion, ownerName, param, isFreeTax);
            items.add(item);
            newInvoice.LineItems = items;
            param.xi = XeroAccountingApi.createInvoice(XeroXmlUtility.serializeJson(newInvoice), param.xeroApiSetting);
            items.clear();
            newInvoice.LineItems = null;
        }
    }
    
    static void updateInvoice(Invoice__c xInvoice, Parameter param, String isDOF, String msg){
        if(param.xi!=null){
            String msgType = 'created';
            if(xInvoice.Xero_Invoice_Id__c != null ){
                msgType = 'updated';
            }
            
            if('DOF'.equals(isDOF)){
                xInvoice.Xero_Invoice_DOF_Id__c = param.xi.InvoiceID;
                xInvoice.Xero_Invoice_DOF_Number__c = param.xi.InvoiceNumber;
            }else{
                xInvoice.Xero_Invoice_Id__c = param.xi.InvoiceID;
                xInvoice.Xero_Invoice_Number__c = param.xi.InvoiceNumber;
            }
            
            if(msg != null){
                xInvoice.Xero_Message__c = msg + ' Invoice #' +param.xi.InvoiceNumber+' '+msgType+ ' in Xero successfully'; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, xInvoice.Xero_Message__c));
            }
        }else{
            xInvoice.Xero_Message__c = msg + ' Invoice was not processed in Xero';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, xInvoice.Xero_Message__c));
        }
    }
    
    static XeroInvoice chargeInvoice(Decimal exclusive, Decimal inclusive, Parameter param){
        XeroInvoice xi = new XeroInvoice();
        xi.Status = param.invoiceStatus;
        xi.LineAmountTypes = 'Exclusive';
        
        switch on param.i {
            when 1 {
                xi.InvoiceID = param.invoice.Xero_Invoice_Id__c;
                xi.InvoiceNumber = param.invoice.Xero_Invoice_Number__c;
            }
            when 2 {
                xi.InvoiceID = param.invoice.Xero_Invoice_DOF_Id__c;
                xi.InvoiceNumber = param.invoice.Xero_Invoice_DOF_Number__c;
            }
        }
        
        if(param.loandNumber != null){ xi.Reference = param.oppName+', '+param.loandNumber;
                                     }else{ xi.Reference = param.oppName;}
        xi.CurrencyCode = 'AUD';
        xi.Date_x = String.valueof(param.invoice.Date_of_Invoice__c);
        xi.DueDate = String.valueof(param.invoice.Date_of_Invoice__c);
        xi.Type = 'ACCREC';
        xi.SubTotal = exclusive;
        xi.TotalTax = inclusive - exclusive;                     
        xi.Total = inclusive;    
        return xi;
    }
    
    static XeroInvoice.LineItem chargeItem(Decimal exclusive, String descripcion, String ownerName, Parameter param, Boolean isFreeTax){
        XeroInvoice.LineItem i = new XeroInvoice.LineItem();
        i.Quantity = 1;
        i.UnitAmount = exclusive;      
        i.LineAmount = i.Quantity*i.UnitAmount;  
        i.AccountCode = param.trackinOption;
        i.Description = descripcion;
        if(isFreeTax){
            i.TaxType = 'EXEMPTOUTPUT';
        }else{
            i.TaxType = 'OUTPUT';
        }
        List<XeroInvoice.cls_Tracking> trackings = new List<XeroInvoice.cls_Tracking>();
        XeroInvoice.cls_Tracking tracking = new XeroInvoice.cls_Tracking();
        
        tracking.Name = 'Tags';
        tracking.Option = ownerName;
        trackings.add(tracking);
        i.Tracking = trackings;
        return i;
    }
    
    static String createOwnerName(String n){
        String[] ownerNames = n.split(' ');
        String ownerName = ownerNames[0] + ownerNames[1].substring(0,1);
        if ('Daniel Carter'.equalsIgnoreCase(n)) {
          ownerName = 'DCarter';
        }
        return ownerName;
    }
    
    public static void setupData( Custom_Opportunity__c opp, String loanNumber){
        Set<Id> oppIds = new Set<Id>();
        oppIds.add(opp.Id);
        oppLists = opportunityProducts(oppIds);
        Xero_API_Setting__c xeroApiSetting = getXeroAPISetting();
        
        recordInvoices = getInvoices();
        recLists = recordType();
        parameters = createParams(oppLists, xeroApiSetting, opp, loanNumber);
    }
    
    static Map<String,String> recordTrackingOptions(Xero_API_Setting__c xeroSetting) {
        Map<String,String> recordTrackingOptions = new Map<String,String>();
        XeroTrackingCategories trackingCategories = XeroAccountingApi.getTrackingCaategory(xeroSetting);
        if (trackingCategories.Options != null) {
            for (XeroTrackingCategories.Option op: trackingCategories.Options) {
                recordTrackingOptions.put(op.Name, op.TrackingOptionID);
            }
        }
        return recordTrackingOptions;
    }
    
    static Map<String,Xero_Contact_Setting__c> xeroContacts(){
        Map<String, Xero_Contact_Setting__c> xeroContacts = new Map<String, Xero_Contact_Setting__c>();
        List<Xero_Contact_Setting__c> settings = [Select t.Id, t.Name, t.Contact__c, t.ContactID__c, t.DOF_Description__c, t.Brokerage_Description__c, t.DOF_GST_Free__c From Xero_Contact_Setting__c t];
        
        for (Xero_Contact_Setting__c xc: settings) {
            xeroContacts.put(xc.Name, xc);
        }
        return xeroContacts;
    }
    
    static Map<Id,String> recordType(){
        Map<Id,String> recordType = new Map<Id,String>();
        for (RecordType rt: [SELECT Id, Name FROM RecordType]) {
            recordType.put(rt.Id, rt.Name);
        }
        return recordType;
    }
    
    static Map<Id, Custom_Opportunity__c> opportunityProducts(Set<Id> oppIds){
        Map<Id, Custom_Opportunity__c> opportunityProducts;
        if(oppIds != null && !oppIds.isEmpty()){
            opportunityProducts = new Map<Id, Custom_Opportunity__c> ([SELECT Id, Owner_Name__c, Account__c, Name,
                                                                       (SELECT Id, Brokerage__c, Brokerage_2__c, Brokerage_GST_Inc__c, DOF__c, DOF_2__c, Insurance_Commission__c, 
                                                                        Insurance_Commission_2__c, Insurance_Type__c, Lender__c, Insurer__c, Loan_Number__c, Name
                                                                        FROM Products__r
                                                                       )
                                                                       FROM Custom_Opportunity__c
                                                                       WHERE Id IN :oppIds]);
        }
        if(opportunityProducts == null){
            opportunityProducts = new Map<Id, Custom_Opportunity__c>();
        }
        return opportunityProducts;
    }
    
    static List<Xero_API_Setting__c> getXeroSettings(){
        return Xero_API_Setting__c.getAll().values();
    }
    
    static Xero_API_Setting__c getXeroAPISetting (){
        List<Xero_API_Setting__c> xeroSettings = getXeroSettings();
        return xeroSettings[0];
    }
    
    static List<Xero_Contact_Setting__c> getXeroContactSeting(Parameter param, Product__c p){
        return [SELECT ContactID__c, DOF_GST_Free__c 
                FROM Xero_Contact_Setting__c 
                WHERE ContactID__c = :param.contactsList.get(p.Lender__c).ContactID__c
               ];
    }
    
    public class Parameter {
        public Integer i {set; get;}
        public String ownerName {set; get;}
        public String invoiceStatus {set; get;}
        public String tagCategory {set; get;}
        public String trackinOption {set; get;}
        public String description {set; get;}
        public String account {set; get;}
        public String loandNumber {set; get;}
        public String oppName {set; get;}
        public String urlInvoice {set; get;}
        public List<String> lenderValues;
        Map<String, String> trackingCategoryOptions;
        Map<String, Xero_Contact_Setting__c> contactsList;
        Xero_API_Setting__c xeroApiSetting;
        Invoice__c invoice;
        XeroInvoice xi;
    }  
    
    static XeroService.Parameter createParams(Map<Id, Custom_Opportunity__c> oppLists, Xero_API_Setting__c xeroSetting, Custom_Opportunity__c opp, String loandNumber){
        XeroService.Parameter parameters = new XeroService.Parameter();
        parameters.ownerName = oppLists.get(opp.Id).Owner_Name__c;
        parameters.invoiceStatus =  xeroSetting.Invoice_Status__c;
        parameters.tagCategory = xeroSetting.Tag_Category__c;
        parameters.account = opp.Account_First_Name__c+' '+opp.Account_Last_Name__c;
        parameters.oppName = opp.Name;
        parameters.trackingCategoryOptions = recordTrackingOptions(xeroSetting);
        parameters.contactsList = xeroContacts();
        parameters.xeroApiSetting = xeroSetting;
        parameters.loandNumber = loandNumber;
        return parameters;
    }
    
    static boolean validateParameters(Invoice__c inv, Custom_Opportunity__c opp, Map<Id, String> recLists, Map<Id, Custom_Opportunity__c> oppLists){
        if(recLists.containsKey(inv.RecordTypeId) && oppLists.containsKey(opp.Id) && oppLists.get(opp.Id).Products__r != null ){
            return true;
        }
        return false;    
    }
    
    public static Invoice__c downloadInvoicePdf(Invoice__c inv, Custom_Opportunity__c opp, boolean isDOF){
        String url;
        if(inv != null){
            recLists = recordType();
            if('Finance Invoice'.equals(recLists.get(inv.RecordTypeId))){
                if(inv.Xero_Invoice_Id__c != null){
                    if(inv.Xero_Invoice_DOF_Number__c != null && isDOF){
                        url = InvoicePdf(inv.Xero_Invoice_DOF_Id__c, inv);
                        if(url != null){
                            if (Test.isRunningTest()) {
                                System.debug('PDFs downloading');
                            }else{
                                CloudDocsHelper.uploadFileFromUrl(inv.Opportunity__c, url, 'DOF Invoice', inv.Xero_Invoice_DOF_Number__c + ' - '+DateUtils.getTimeForFileName()+'.pdf');
                            }    
                            return inv;
                        }
                    }else if(inv.Xero_Invoice_Number__c != null){
                        url = InvoicePdf(inv.Xero_Invoice_Id__c, inv);
                        if(url != null){
                            if (Test.isRunningTest()) {
                                System.debug('PDFs downloading');
                            }else{
                                CloudDocsHelper.uploadFileFromUrl(inv.Opportunity__c, url, 'Commission Invoice', inv.Xero_Invoice_Number__c + ' - '+DateUtils.getTimeForFileName()+'.pdf');
                            }
                        }
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Invoice synchonized successfully'));
                    }
                }
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There no invoice created in Xero to synchonized'));
        }
        return null;
    }
    
    public static String InvoicePdf(String xeroInvoiceID, Invoice__c inv){
        Xero_API_Setting__c xeroApiSetting = getXeroAPISetting();
        XeroOnlineInvoices onlineInvoices = XeroAccountingApi.getInvoicePdf(xeroInvoiceID, xeroApiSetting);
        if(onlineInvoices.OnlineInvoiceUrl != null){
            return onlineInvoices.OnlineInvoiceUrl + '/Invoice/DownloadPdf/' + xeroInvoiceID;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, onlineInvoices.ErrorMsg));
            inv.Xero_Message__c += onlineInvoices.ErrorMsg;
            return null;
        }
    }
    
    public static Invoice__c InvoiceUpdate(String updateInvoiceID, Custom_Opportunity__c opp, Integer i, String loanNumber){
        Xero_API_Setting__c xeroApiSetting = getXeroAPISetting();
        setupData(opp, loanNumber);
        Invoice__c xeroInvoiceUpdate = recordInvoices.get(updateInvoiceID);
        if(xeroInvoiceUpdate != null){
            proccessInvoice(xeroInvoiceUpdate, opp, i);    
        }
        return xeroInvoiceUpdate;
    }
    
    static Map<String,Invoice__c> getInvoices(){
        Map<String,Invoice__c> recordInvoices = new Map<String,Invoice__c>();
        for (Invoice__c r: [SELECT Id, Name, Date_of_Invoice__c, RecordType.Name, Invoice_Amount__c, Opportunity__c, Product__c, 
                            Xero_Invoice_Id__c, Xero_Invoice_Number__c, Xero_Invoice_DOF_Id__c, Xero_Invoice_DOF_Number__c, Xero_Message__c 
                            FROM Invoice__c t]) {
                                if(r.Xero_Invoice_DOF_Id__c != null){
                                    recordInvoices.put(r.Xero_Invoice_DOF_Id__c, r);
                                }
                                recordInvoices.put(r.Xero_Invoice_Id__c, r);
                            }
        return recordInvoices;
    }
}