public class OppApprovalSettlementDetailExtension {
	
    public Custom_Opportunity__c opp{set;get;}
    public String noteText {set;get;}
    public String status {set;get;}
    public List <SelectOption> nextStatus {get;set;}
    public Boolean showNextStatus {set;get;}
    public String NameNextStatus {set;get;}
    public Boolean flagNameNextStatus {set;get;}
    public Boolean flagNameNextStep {set;get;}
    public Boolean typeRejected {set;get;}
    public Boolean RejectedbyLender {set;get;}
    public Application_Extra_Data__c lastNoteSettlement {set;get;}

    public OppApprovalSettlementDetailExtension() {
        String id = System.currentPageReference().getParameters().get('id');
        if (!String.isBlank(id)) {
            this.opp = [SELECT Id, Name, Status__c, Owner.Id, Owner.Name FROM Custom_Opportunity__c WHERE Id = :id];
            findLastApplicationNote();
        }
        NameNextStatus='Next Step ';
        showNextStatus=false;
        typeRejected=false;
        RejectedbyLender=false;
        flagNameNextStatus=false;
        flagNameNextStep=true;
        nextStatus = new List<SelectOption>();
        getNextStatus();
        getNameNextStatus();
        getTypeRejected();
        
    }

    public void getTypeRejected(){
        if(opp.Status__c=='Internal Settlement' || opp.Status__c=='Documents Sent' || opp.Status__c=='Documents Received' || opp.Status__c=='Awaiting Further Information'){
            typeRejected=true;
        }
    }
    
    public void getNameNextStatus(){
        if(opp.Status__c=='Internal Settlement'){
            NameNextStatus=NameNextStatus+'Documents Sent';
            flagNameNextStatus=true;
            flagNameNextStep=false;
        }
        if(opp.Status__c=='Documents Sent'){
            NameNextStatus=NameNextStatus+'Documents Received';
            flagNameNextStatus=true;
            flagNameNextStep=false;
        }
        if(opp.Status__c=='Awaiting Further Information'){
            NameNextStatus=NameNextStatus+'Sent to Lender for Settlement';
            flagNameNextStatus=true;
            flagNameNextStep=false;
        }
        if(opp.Status__c=='Sent to Lender for Settlement'){
            NameNextStatus='Settled';
            flagNameNextStatus=true;
            flagNameNextStep=false;
            RejectedbyLender=true;            
        }
        if(opp.Status__c=='Rejected By Lender'){
            NameNextStatus='Settled';
            flagNameNextStatus=true;
            flagNameNextStep=false;           
        }
    }
    
    public void getNextStatus(){
        if(opp.Status__c=='Documents Received'){
            nextStatus.add(new SelectOption('Awaiting Further Information', 'Awaiting Further Information'));
            nextStatus.add(new SelectOption('Sent to Lender for Settlement', 'Sent to Lender for Settlement'));
            showNextStatus=true;
        } 
    }
    
    public PageReference approveProcess() {
        if(showNextStatus){
            if(status=='Awaiting Further Information' || status=='Sent to Lender for Settlement'){
                opp.Status__c = status;
            	update opp;
            }
            
        }
        
        PageReference process = process('Approve');
        
        return process;
    }
    
    public PageReference approveProcessRBL() {
        opp.Status__c = 'Rejected By Lender';
        update opp;
        
        PageReference process = process('Approve');
        
        return process;
    }

    public PageReference rejectProcess() {
        return process('Reject');
    }
	
    public PageReference cancelProcess() {
        PageReference r = Page.OppSettlementSumary;
        r.setRedirect(true);
        return r;
    }
    
    private Boolean isValidForProcess() {
        if (String.isBlank(this.noteText)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill Comments field before processing.'));
            return false;
        }
        return true;
    }

    private PageReference process(String action) {

        if (!isValidForProcess()) {
            return null;
        }
		String currentStatus = this.opp.Status__c;
		
        
        String comments = this.noteText;
        try {
            ApprovalTools.approvalProcess(opp.id, action, comments, currentStatus, UserInfo.getUserId(), this.opp.Owner.Id);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }

        return new PageReference ('/'+ opp.Id);
    }

    public List<ApprovalStepDTO> getAllApprovalHistory() {
        return ApprovalTools.getApprovalHistory(opp.Id);
    }
    
    public void findLastApplicationNote() {
        
        String[] typeData = new String[]{'Notes','Notes (Amendment)','Notes (Formal Approval)'};
            
            List<Application_Extra_Data__c> a = [SELECT Data__c, Type_of_Data__c, LastModifiedDate, Category__c FROM Application_Extra_Data__c WHERE Application__c IN (
                SELECT Application__c FROM Custom_Opportunity__c WHERE ID = :opp.Id
            ) AND Type_of_Data__c IN :typeData ORDER BY LastModifiedDate DESC LIMIT 5];
        lastNoteSettlement = null;
        if (a != null && !a.isEmpty()) {
            
            for (Application_Extra_Data__c note : a) {
                if (lastNoteSettlement == null && 'Settlement'.equals(note.Category__c)) {
                    lastNoteSettlement = note;
                }
            }
        }
    }

    
}