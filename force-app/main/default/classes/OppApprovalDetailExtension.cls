public class OppApprovalDetailExtension {
    
    private Custom_Opportunity__c opp;
    public String noteText {set;get;}
    public String documentType {get;set;}
    public String DocumentsRequired {get;set;}
    public List <Approval_Condition__c> approvalConditions;
    public Application_Extra_Data__c lastNote {set;get;}
    public Application_Extra_Data__c lastNoteLender {set;get;}

    public OppApprovalDetailExtension() {
        //String id = System.currentPageReference().getParameters().get('ID');
        //if (!String.isBlank(id)) {
        //    this.opp = [
        //        SELECT Id, Name, Status__c, Owner.Id, Owner.Name, Application__c, Purchase_Type__c, ApplicationYTD__c,
        //               ApplicationYTD__r.Type__c, ApplicationYTD__r.Self_Employed_Type__c, ApplicationYTD__r.Self_Employed_Class__c,
        //               Application__r.Business_Structure__c, Application_AssetDetail__r.Type__c, Application_AssetDetail__r.LVR__c,
        //               Application__r.Application_Type__c, Application__r.Type_of_Asset__c
        //        FROM Custom_Opportunity__c 
        //        WHERE Id = :id];
        //    findLastApplicationNote();
        //}
        this.init();
    }
    
    private void init() {
        this.reloadOpp();
        this.approvalConditions = new List<Approval_Condition__c>();
        if (this.opp != null) {
            this.approvalConditions = [Select o.Custom_Opportunity__c, o.Name, o.Document_Type__c 
                                       from Approval_Condition__c o WHERE o.Custom_Opportunity__c = : this.opp.Id];
        }
    }
    
    private void reloadOpp() {
        String id = System.currentPageReference().getParameters().get('ID');
        if (this.opp != null) {
            id = this.opp.Id;
        }
        if (!String.isBlank(id)) {
            this.opp = [
                SELECT Id, Name, Status__c, Owner.Id, Owner.Name, Application__c, Purchase_Type__c, ApplicationYTD__c,
                       ApplicationYTD__r.Type__c, ApplicationYTD__r.Self_Employed_Type__c, ApplicationYTD__r.Self_Employed_Class__c,
                       Application__r.Business_Structure__c, Application_AssetDetail__r.Type__c, Application_AssetDetail__r.LVR__c,
                       Application__r.Application_Type__c, Application__r.Type_of_Asset__c, Application__r.No_of_People__c, 
                       Loan_Product__r.Loan_Number__c, ApplicationServicing__c
                FROM Custom_Opportunity__c 
                WHERE Id = :id];
            findLastApplicationNote();
        }
    }

    /*This method lets painting, initially, all the documents type than exist in Savvy*/
    public List <SelectOption> getDocumentTypeSelect(){
        List<SelectOption> r = new List <SelectOption>();
        r.add(new SelectOption('','--None--'));
        Schema.DescribeFieldResult fieldResult = Cloud_Documents__c.Document_Type__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
            r.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return r;
    }
    
    /*This method lets painting, initially, all the approvals conditions for the custom opportunity*/
    public List <SelectOption> getRequiredDocuments(){
        List<SelectOption> r = new List <SelectOption>();
        for(Approval_Condition__c f : this.approvalConditions){
            r.add(new SelectOption(f.Document_Type__c, f.Document_Type__c));
        }
        return r;
    }
    
    
    public Custom_Opportunity__c getOpp() {
        return opp;
    }
    
    public void addDocumentsRequired() {
        boolean document = false;
        
        if (!String.isBlank(documentType)) {
            if(this.approvalConditions.isEmpty()){
                document = true;
            }else{
                for(Approval_Condition__c f : this.approvalConditions){
                    if(documentType.equals(f.Document_Type__c)){
                        document = false;
                        break;
                    }else{
                        document = true;
                    }
                }
            }
            
            if(document){
                Approval_Condition__c approvalCondition = new Approval_Condition__c();
                approvalCondition.Custom_Opportunity__c = opp.Id;
                approvalCondition.Name = opp.Name+'('+documentType+')';
                approvalCondition.Document_Type__c = documentType;
                this.approvalConditions.add(approvalCondition);
                document = false;
            }
        }
    }
    
    public void removeDocumentsRequired(){
        String documentRequired = DocumentsRequired.replace('[', '');
        String documentRequieredAux = documentRequired.replace(']', '');
        
        if(!String.isBlank(documentRequieredAux)){
            integer i = 0;
            for(Approval_Condition__c f : this.approvalConditions){
                if(documentRequieredAux.compareTo(f.Document_Type__c)==0){
                    this.approvalConditions.remove(i);
                    break;
                }
                i++;
            }
        }
    }
    
    public PageReference approveProcess() {
        PageReference process = process('Approve');
        if(process!=null){
            saveApprovalCondition();
            //Jesus Mora 2019-12-03 start
            if(this.opp.Loan_Product__r!=null){
                update this.opp.Loan_Product__r;   
            }
            //Jesus Mora 2019-12-03 end
        }
        return process;
    }
    
    public PageReference rejectProcess() {
        return process('Reject');
    }
    
    public PageReference cancelProcess() {
        PageReference r = Page.OppApprovalSummary;
        //r.getParameters().put('approvalType', approvalType);
        r.setRedirect(true);
        return r;
    }
    
    private void saveApprovalCondition(){
        //upsert this.approvalConditions;
                
        clearApprovalCondition();
        for(Approval_Condition__c f : this.approvalConditions){
            f.Id = null;
        }
        insert this.approvalConditions;
    }

	private void clearApprovalCondition(){
		delete[select o.Custom_Opportunity__c, o.Document_Type__c, o.Name 
               from Approval_Condition__c o 
               where o.Custom_Opportunity__c = :this.opp.Id];
	}
 
    private Boolean isValidForProcess(String action) {
        Boolean r = true;
        if (String.isBlank(this.noteText)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill Comments field before processing.'));
            r = false;
        }
        if ('Internal Settlement'.equals(opp.Status__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Current Opportunity status ('+this.opp.Status__c+') is not valid for approving'));
            r = false;   
        }
        // Verify if it is for a Formal Approval
        if ('Approve'.equals(action) && 'Sent to Lender for Formal Approval'.equals(opp.Status__c)) {
            // Checking for Settlement conditions
            ValidateSubmitExtension.ValidationResult rsl = ValidateSubmitExtension.validateSubmission(this.opp);
            if (rsl != null) {
                // Document validations
                if (rsl.docsValidated != null && !rsl.docsValidated.isEmpty()) {
                    for (String m: rsl.docsValidated) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Document: ' + m));
                    }
                    r = false;
                }
                // Field validations
                if (rsl.fieldsValidated != null && !rsl.fieldsValidated.isEmpty()) {
                    for (String m: rsl.fieldsValidated) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, m));
                    }
                    r = false;
                }
            }
        }
        return r;
    }
    
    private PageReference process(String action) {
        
        if (!isValidForProcess(action)) {
            return null;
        }
        String pref = '/'+opp.Id;
        String currentStatus = this.opp.Status__c;
        String documentsRequires = '\n\nApproval Conditions:' ;
        for(Approval_Condition__c f : this.approvalConditions){
            documentsRequires = documentsRequires + '\n'+f.Document_Type__c;
        }
        String comments = this.noteText + ' ' + documentsRequires;
        ApprovalTools.approvalProcess(opp.id, action, comments, currentStatus, UserInfo.getUserId(), this.opp.Owner.Id);
        //juan carlos romero 10/09/2018 - lelo adjusted 2019-04-02
        if('Internal Settlement'.equals(ApprovalTools.getOpportunityCurrentStatus(opp.Id))){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        	req1.setComments('Submitting request for Settlement Officer Approval');
        	req1.setObjectId(opp.Id); 
			req1.setProcessDefinitionNameOrId('Settlement_Approval');
        	req1.setNextApproverIds(ApprovalTools.getApprovalTemUsersIds());
        	Approval.ProcessResult result = Approval.process(req1);
            if (!result.isSuccess()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Opportunity could not be submitted for Settlement, please proceed manually'));
                for (Database.Error e: result.getErrors()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStatusCode() + ': ' + e.getMessage()));
                }
                this.reloadOpp();
                pref = null;
            }
        }
        //fin
        return new PageReference (pref);
    }
    
    public List<ApprovalStepDTO> getAllApprovalHistory() {
        return ApprovalTools.getApprovalHistory(opp.Id);
    }
    
    private void findLastApplicationNote() {
        
        String[] typeData = new String[]{'Notes','Notes (Amendment)','Notes (Formal Approval)'};
            
            List<Application_Extra_Data__c> a = [SELECT Data__c, Type_of_Data__c, LastModifiedDate, Category__c FROM Application_Extra_Data__c WHERE Application__c IN (
                SELECT Application__c FROM Custom_Opportunity__c WHERE ID = :opp.Id
            ) AND Type_of_Data__c IN :typeData ORDER BY LastModifiedDate DESC LIMIT 5];
        lastNoteLender = null;
        lastNote = null;
        if (a != null && !a.isEmpty()) {
            
            for (Application_Extra_Data__c note : a) {
                if (lastNoteLender == null && 'Lender'.equals(note.Category__c)) {
                    lastNoteLender = note;
                } else if (lastNote == null && 'Processing'.equals(note.Category__c)) {
                    lastNote = note;
                }
            }
        }
    }
    
}