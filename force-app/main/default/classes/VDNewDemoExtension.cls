public with sharing class VDNewDemoExtension {
    public Custom_Opportunity__c Opp {set;get;}
    public String currentTime {set;get;}
    public static String VD_TYPE_PROCESS = 'New Car - Demo';
    
    public VDNewDemoExtension (ApexPages.StandardController controller) {
        List<String> fields = new List<String>{
        'VD_Worksheet__c','VD_Date_Sent__c','Owner_Name__c',
        'First_Name__c','Last_Name__c','Address__c','Mobile_Number__c','Home_Phone__c','Work_Phone__c',
        'Email_Address__c','New_Used__c','Vehicle_Details__c','Lender_Approved__c','Pre_Approved_Amount__c',
        'Pre_Approved_Vehicle_Age__c','Required_Client_Deposit__c','Client_Budget__c','Payout_Details__c',
        'Trade_in_Details__c','Dealer_Contacted__c','Special_Conditions__c','VD_Notes__c','VD_Is_Old_Process__c',
        'VD_Status__c','VD_Worksheet__r','VD_Worksheet__r.VD_Approver__c',
        'Application__r.Unit_Number__c', 'Application__r.Street_Number__c', 'Application__r.Street_Address__c',
        'Application__r.Street_Type__c', 'Application__r.Suburb__c', 'Application__r.State__c',
        'Application__r.Postcode__c', 'Application__c', 'Lead__c', 'Lead__r.Postcode__c', 'Lead__r.State__c'
      };
            
        if (!Test.isRunningTest()) controller.addFields(fields);
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        currentTime = datetime.now().format('dd/MM/yyyy h:mm a');
    }
    
    public PageReference validate() {
        isValidationForApproval();
        return null;
    }

    private Boolean isValidationForApproval() {
        Boolean r = true;
        if (Opp.VD_Owner__c != null) {
            if (!String.isBlank(Opp.VD_Status_Process__c) && !'Send back to Sales Consultant - cannot proceed'.equals(Opp.VD_Status_Process__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This deal has already been sent to Vehicles Direct.'));
                r = false;
            }
        }
        return r;
    }

    public PageReference sendVDForApproval () {
        if (!isValidationForApproval()) {
            return null;
        }
        
        Id VDOwnerId = null;
        
        //Check for VD_Worksheet
        Id wsId = null;
        if (Opp.VD_Worksheet__c == null) {
            System.debug('Selecting an approver user...');
            VDOwnerId = VDAllocation.allocateSales();
            System.debug('Creating a new worksheet...');
            VD_Worksheet__c ws = new VD_Worksheet__c();
            ws.Name = 'WS-' + Opp.Name;
            ws.Type_of_Process__c = VD_TYPE_PROCESS;
            ws.Accessory_Label_1__c = 'Window Tint';
            ws.Accessory_Label_2__c = 'Paint Protection';
            ws.Accessory_Label_3__c = 'Reverse Camera';
            ws.Accessory_Invoice_Label_1__c = 'Window Tint';
            ws.Accessory_Invoice_Label_2__c = 'Paint Protection';
            ws.Accessory_Invoice_Label_3__c = 'Transportation';
            ws.VD_Approver__c = VDOwnerId;
            insert ws;
            wsId = ws.Id;
            Opp.VD_Worksheet__c = wsId;
            
        } else {
            System.debug('Assigning previous worksheet owner...');
            VDOwnerId = Opp.VD_Worksheet__r.VD_Approver__c;
            if (!VDAllocation.isActiveVDSalesUser(VDOwnerId)) {
                if (VDAllocation.isActiveVDSalesUser(Opp.VD_Owner__c)) {
                    VDOwnerId = Opp.VD_Owner__c;
                } else {
                    VDOwnerId = VDAllocation.allocateSales();
                }
            }
            Opp.VD_Worksheet__r.Type_of_Process__c = VD_TYPE_PROCESS;
            update Opp.VD_Worksheet__r;
            wsId = Opp.VD_Worksheet__r.Id;
        }

        Opp.VD_Owner__c = VDOwnerId;
        Opp.VD_Date_Sent__c = System.now();
        Opp.Address__c = this.getCustomerAdrress();
        
        update Opp;
        
        ApprovalTools.submittForApproval(
            ApprovalTools.VD_SALES_NEW_LEAD_PROCESS_DEFINITION, wsId, Opp.VD_Notes__c, false, VDOwnerId);

        //Cloud document
        System.debug('Saving in cloud...');
        CloudDocGeneratorBatch.createBatch(this.opp.Id, CloudDocGeneratorBatch.VD_FLEETREFERRAL, 1);
        //Email
        User VDOwner = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id =:Opp.VD_Owner__c];
        List<String> toAddresses = new List<String> ();
        toAddresses.add(VDOwner.Email);       //ORIGINAL
        //toAddresses.add('leandro.l@savvy.com.au');
        List<Attachment> attachments = new List<Attachment>();
        if (!Test.IsRunningTest()){
            EmailSender.sendEmailToVDSent_v2(attachments, toAddresses, this.Opp);
        }

        return new PageReference ('/'+Opp.Id);
        
    }

    public String getCustomerAdrress() {
      String r = '';
      if (
        String.isNotBlank(this.Opp.Application__c) &&
        String.isNotBlank(this.Opp.Application__r.Street_Address__c)
      ) {
        r += String.isNotBlank(this.Opp.Application__r.Unit_Number__c) ? this.Opp.Application__r.Unit_Number__c : '';
        r += r.length() > 0? ' / ' : '';
        r += String.isNotBlank(this.Opp.Application__r.Street_Number__c) ? this.Opp.Application__r.Street_Number__c : '';
        r += r.length() > 0? ' ' : '';
        r += this.Opp.Application__r.Street_Address__c;
        r += String.isNotBlank(this.Opp.Application__r.Street_Type__c) ? ' ' + this.Opp.Application__r.Street_Type__c : '';
        r += String.isNotBlank(this.Opp.Application__r.Suburb__c) ? ', ' + this.Opp.Application__r.Suburb__c : '';
        r += String.isNotBlank(this.Opp.Application__r.State__c) ? ', ' + this.Opp.Application__r.State__c : '';
        r += String.isNotBlank(this.Opp.Application__r.Postcode__c) ? ' ' + this.Opp.Application__r.Postcode__c : '';
      } else if (String.isNotBlank(this.Opp.Lead__c)) {
        r += String.isNotBlank(this.Opp.Lead__r.State__c) ? this.Opp.Application__r.State__c : '';
        r += String.isNotBlank(this.Opp.Lead__r.Postcode__c) ? ' ' + this.Opp.Application__r.Postcode__c : '';
      }
      return r;
    }

}