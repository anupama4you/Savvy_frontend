public with sharing class VDApprovalDetailExtension {
	private Custom_Opportunity__c opp;
    public String noteText {set;get;}
    public String actionSelected {set;get;}
    private String userProfile = null;
    private List<ApprovalStepDTO> approvalHistoryList = null;
    public String declineSelected {set;get;}
    public DetailDTO detailDto {set;get;}
    /** HJ - 05-05-2017 - I **/
    public List <SelectOption> statesOfIssue2Sel {get; set;}
    /** HJ - 05-05-2017 - F **/

    public VDApprovalDetailExtension(ApexPages.StandardController controller) {
    	//Current user profile
    	Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
		userProfile = p.name;

        String id = System.currentPageReference().getParameters().get('ID');
        if (!String.isBlank(id)) {
            try {
                controller.addFields(new List<String>{'Id', 'Name', 'Status__c', 'Owner.Id', 'Owner.Name', 'New_Used__c', 'Vehicle_Details__c', 
                               'Lender_Approved__c', 'Pre_Approved_Amount__c', 'Pre_Approved_Vehicle_Age__c',
                               'Required_Client_Deposit__c', 'Client_Budget__c', 'Payout_Details__c', 
                               'Trade_in_Details__c', 'Dealer_Contacted__c', 'Special_Conditions__c','Dealer_Account_Email__c',
                               'VD_Notes__c', 'VD_Status__c', 'VD_Owner__c', 'Owner.Email', 'Owner_Email__c',
                                'New_Used__c', 'Vehicle_ID__c', 'Vehicle_Color__c', 'Vehicle_Registration__c','VD_Approver__r',
                                'Dealer_Name__c', 'Dealer_Address__c', 'Dealer_Contact_Name__c', 'Dealer_Phone_Number__c', 
                                'Dealer_Mobile__c', 'Dealer_Email__c', 'New_Used_Final__c', 'VD_Date_Settled__c',
                    			'Dealer_Street_Number__c', 'Dealer_Street_Type__c', 'Dealer_Suburb__c', 'Dealer_Postcode__c', 'Dealer_State__c'});
            } catch (SObjectException e) {}
            this.Opp = (Custom_Opportunity__c)controller.getRecord ();

            this.detailDto = new DetailDTO(this.Opp);
        }
        statesOfIssue2Sel = UtilitiesList.getStatesOptions();
    }
    
    public List <SelectOption> getActionOptions() {
    	List <SelectOption> r = new List <SelectOption>();
    	if (isVDSales()) {
    		if (VDApprovalSummaryExtension.VD_SALES_STATUS[0].equals(this.opp.VD_Status_Process__c) || 
    			VDApprovalSummaryExtension.VD_SALES_STATUS[2].equals(this.opp.VD_Status_Process__c)) {
    			r.add(new SelectOption('ACO', VDApprovalSummaryExtension.VD_SALES_STATUS[1])); //'Attempted Contact'
    		}
    		if (VDApprovalSummaryExtension.VD_SALES_STATUS[0].equals(this.opp.VD_Status_Process__c) ||
    			VDApprovalSummaryExtension.VD_SALES_STATUS[1].equals(this.opp.VD_Status_Process__c)) {
    			r.add(new SelectOption('SVN', VDApprovalSummaryExtension.VD_SALES_STATUS[2]));	//Searching for Vehicle and Negotiating deal
    		}
    		r.add(new SelectOption('SVS', 'Send to VD Settlement'));
            r.add(new SelectOption('DEC', 'Decline'));
		} else if (isVDSettlements()) {
			if (VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[0].equals(this.opp.VD_Status_Process__c) || 
    			VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[2].equals(this.opp.VD_Status_Process__c)) {
				r.add(new SelectOption('IRS', VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[1])); //'Invoice Request Sent'
			}
			if (VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[0].equals(this.opp.VD_Status_Process__c) ||
    			VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[1].equals(this.opp.VD_Status_Process__c)) {
	    		r.add(new SelectOption('IRR', VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[2])); //'Invoice Request Received'
	    	}
            r.add(new SelectOption('SBV', 'Send back to VD Sales'));
    		r.add(new SelectOption('SBC', 'Send back to Sales Consultant'));
            r.add(new SelectOption('DEC', 'Decline'));
		}
		return r;
    }
    
    public Boolean isVDSales() {
    	Boolean r = false;
    	if (VDApprovalSummaryExtension.VD_SALES.equals(userProfile)) {
    		r = true;
    	}
    	return r;
    }

    public Boolean getIsVDSales() {
        return isVDSales();
    }

    public Boolean getIsVDSettlements() {
        return isVDSettlements();
    }

    public Boolean isVDSettlements() {
    	Boolean r = false;
    	if (VDApprovalSummaryExtension.VD_SETTLEMENTS.equals(userProfile)) {
    		r = true;
    	}
    	return r;
    }

    public Custom_Opportunity__c getOpp() {
        return opp;
    }
    
    public PageReference approveProcess() {
        return process('Approve');
    }

    public PageReference rejectProcess() {
        return process('Reject');
    }
	
    public PageReference cancelProcess() {
        PageReference r = Page.VDApprovalSummary;
        //r.getParameters().put('approvalType', approvalType);
        r.setRedirect(true);
        return r;
    }
    
    private Boolean isValidForProcess(Boolean isReject) {
    	Boolean r = true;
    	if (!isReject) {
    		if (String.isBlank(actionSelected)) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose an Action before processing.'));
            	r = false;	
    		}
    	} else {
    		/*if (String.isBlank(this.declineSelected)) {
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please choose a declining reason before processing.'));
            	r = false;		
    		}*/
    	}
        if (String.isBlank(this.noteText)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill Comments field before processing.'));
            r = false;
        }
        if ('SBC'.equals(actionSelected)) {
			//Validate for Tax Invoice document
			if (!PreApprovalValidatorHelper.validateADocumentUploaded(this.opp.Id, 'Tax Invoice/COS/ Rego Papers')) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload the required Tax Invoice into the Cloud Documents to proceed.'));
            	r = false;
			}

		}
        if ('SVS'.equals(actionSelected)) {
            //Validate for Tax Invoice document
            if (!isValidationWS()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check Worksheet values to proceed.'));
                r = false;
            }
        }
		System.debug(isReject + '!' + actionSelected + '!' + r);
        return r;
    }

    private PageReference process(String action) {
    	Boolean isReject = false;
    	//if ('Reject'.equals(action)) isReject = true;
    	if ('DEC'.equals(actionSelected)) {
    		isReject = true;
    		action = 'Reject';
    	}
        if (!isValidForProcess(isReject)) {
            return null;
        }

        //Save Worksheet
        if (isVDSales()) {
            saveWorkSheet();
        }

		String currentStatus = this.opp.VD_Status__c;
		String nextApprovalProcess = null;
		Id VDOwnerId = this.opp.VD_Owner__c;
        Id OppOwnerId = this.opp.Owner.Id;
        Id WSId = this.opp.VD_Worksheet__c;
		if (!isReject) {

			if ('ACO'.equals(actionSelected)) {
				//this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SALES_STATUS[1];
				nextApprovalProcess = ApprovalTools.VD_SALES_ATTEMPT_CONTACT_PROCESS_DEFINITION;
			} else if ('SVN'.equals(actionSelected)) {
				//this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SALES_STATUS[2];
				nextApprovalProcess = ApprovalTools.VD_SALES_SEARCHING_VEHICLE_PROCESS_DEFINITION;
			} else if ('SVS'.equals(actionSelected)) {
				//this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[0];
				nextApprovalProcess = ApprovalTools.VD_SETTLEMENT_FILE_IN_PROCESS_DEFINITION;
			} else if ('IRS'.equals(actionSelected)) {
				//this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SALES_STATUS[2];
				nextApprovalProcess = ApprovalTools.VD_SETTLEMENT_INVOICE_SENT_PROCESS_DEFINITION;
			} else if ('IRR'.equals(actionSelected)) {
				//this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[0];
				nextApprovalProcess = ApprovalTools.VD_SETTLEMENT_INVOICE_RECEIVED_PROCESS_DEFINITION;
			} else if ('SBV'.equals(actionSelected)) {
                //this.opp.VD_Status__c = VDApprovalSummaryExtension.VD_SETTLEMENTS_STATUS[0];
                nextApprovalProcess = ApprovalTools.VD_SALES_NEW_LEAD_PROCESS_DEFINITION;
            }
		}
		System.debug('WSId >> ' + WSId + '|action >> ' + action + '|' + isReject + '!' + nextApprovalProcess + '!' + actionSelected);
        ApprovalTools.approvalVDProcess(WSId, action, this.noteText, currentStatus, actionSelected, UserInfo.getUserId(), VDOwnerId);

        if (isReject) {
			updateVDReasonClosure(this.noteText);
			EmailSender.sendEmailVDFailure(this.opp, this.noteText);
		} else {
			if ('SBC'.equals(actionSelected)) {
				updateVDStatus('Send back to Sales Consultant');
				EmailSender.sendEmailToPreVD(this.opp, getUserEmail(new Id[]{this.opp.Owner.Id}));
			} else {
		        //Check for the next process
		        if (!String.isBlank(nextApprovalProcess)) {
		        	if (nextApprovalProcess.equals(ApprovalTools.VD_SETTLEMENT_FILE_IN_PROCESS_DEFINITION)) {
		        		VDOwnerId = VDAllocation.allocateSettlements();
		        	}
		        	System.debug('Creating a new approval process >> ' + nextApprovalProcess + '!' + VDOwnerId);
                    if (!SOQLSingletonQueries.isActiveUser(OppOwnerId)) {
                        OppOwnerId = UserInfo.getUserId();
                    }
		        	ApprovalTools.submittForApproval(
		            	nextApprovalProcess, WSId, null, false, VDOwnerId, OppOwnerId);

		        	if (nextApprovalProcess.equals(ApprovalTools.VD_SETTLEMENT_FILE_IN_PROCESS_DEFINITION)) {
		        		assignVDOwner(VDOwnerId);
                        //Cloud doc
                        generateWorksheetDocument();
		        		//Notify
		        		List<Id> ids = new List<Id>();
		        		ids.add(VDOwnerId);
		        		ids.add(this.opp.Owner.Id);
                        List<String> emailList = getUserEmail(ids);
                        emailList.add('neil.p@vehiclesdirect.com.au');
		        		EmailSender.sendEmailToVDSet(new List<Attachment>(), emailList, this.opp);
                    } else if (nextApprovalProcess.equals(ApprovalTools.VD_SALES_NEW_LEAD_PROCESS_DEFINITION)) {
                        VDOwnerId = this.opp.VD_Worksheet__r.VD_Approver__c;
                        System.debug('Wsheet Approver >> ' + VDOwnerId);
                        assignVDOwner(VDOwnerId);
                        EmailSender.sendEmailToVDSalesBack(getUserEmail(new Id[]{VDOwnerId}), this.Opp);
		        	} else {
		        		String newStatus = ApprovalTools.getOpportunityVDCurrentStatus(this.opp.Id);
		        		EmailSender.sendEmailToConsultantVDStatus(
		        			this.opp, getUserEmail(new Id[]{this.opp.Owner.Id}), newStatus, userProfile);
		        	}
		        }
		    }
		}
        return new PageReference ('/apex/VDApprovalSummary');
    }

    public List<ApprovalStepDTO> getAllApprovalHistory() {
    	if (approvalHistoryList == null) {
    		approvalHistoryList = ApprovalTools.getApprovalHistory(opp.Id);
    	}
        return approvalHistoryList;
    }

    private void assignVDOwner(Id VDOwnerId) {
    	System.debug('Assigning an approver >> '+ VDOwnerId);
    	Custom_Opportunity__c o = [Select VD_Owner__c, VD_Status__c From Custom_Opportunity__c Where Id = :this.opp.id];
    	System.debug('currentStatus 2 >> ' + o.VD_Status__c);
        if (String.isBlank(o.VD_Owner__c) || !o.VD_Owner__c.equals(VDOwnerId)) {
            o.VD_Owner__c = VDOwnerId;
            update o;
        }
    }

    private void updateVDStatus(String newStatus) {
    	System.debug('Updating the status >> '+ newStatus);
    	Custom_Opportunity__c o = [Select VD_Owner__c, VD_Status__c, VD_Date_Settled__c From Custom_Opportunity__c Where Id = :this.opp.id];
        VD_Worksheet__c w = [Select Approval_Status__c From VD_Worksheet__c Where Id = :this.opp.VD_Worksheet__c];
        if ('Send back to Sales Consultant'.equals(newStatus)) {
            o.VD_Date_Settled__c = System.now();
        }
    	System.debug('currentStatus 2 >> ' + o.VD_Status__c + '!' + newStatus);
    	o.VD_Status__c = newStatus;
        w.Approval_Status__c = newStatus;
        update o;
        update w;
    }

	private void updateVDReasonClosure(String reason) {
    	System.debug('Updating the reason for closure >> '+ reason);
    	Custom_Opportunity__c o = [Select VD_Reason_for_closure__c From Custom_Opportunity__c Where Id = :this.opp.id];
    	o.VD_Reason_for_closure__c = reason;
        update o;
    }    


    public List<String> getUserEmail(List<Id> userIds) {
    	List<User> lst = [SELECT Email FROM User Where id in :userIds];
    	List<String> r = new List<String>();
    	for (User u : lst) {
    		r.add(u.Email);
    	}
    	//r.add('leandro.l@savvy.com.au');
    	return r;
    }

    public List<SelectOption> getDeclineOptions() {
    	List <SelectOption> r = new List <SelectOption>();
    	r.add(new SelectOption('', '--None--'));
    	this.declineSelected = null;
    	if ('DEC'.equals(this.actionSelected)) {
			r.add(new SelectOption('Could not beat quote', 'Could not beat quote'));
			r.add(new SelectOption('Client changed their mind', 'Client changed their mind'));
			r.add(new SelectOption('Send details for future reference', 'Send details for future reference'));
			r.add(new SelectOption('Cannot contact after 6 + attempts', 'Cannot contact after 6 + attempts'));
			r.add(new SelectOption('Declined – Reason Saved', 'Declined – Reason Saved'));
			r.add(new SelectOption('', ''));
		}
    	return r;
    }

    private Boolean isValidationWS() {
        Boolean r = true;
        if (String.isBlank(this.detailDto.newUsed)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please select a value for New/Used field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.vehicleId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Vehicle ID field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.color)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Color field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.registration)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Registration field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerName)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Name field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerAddress)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Address field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerContact)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Contact field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerPhone)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Phone field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerMobile)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Mobile field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerEmail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Email field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerAccountEmail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Account Email field.'));
            r = false;
        }

        //Worksheet
        if (this.opp.VD_Worksheet__r.Cost_Price__c == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Worksheet Dealer - Please fill a value for Cost Price field.'));
            r = false;
        }
        //if (this.opp.VD_Worksheet__r.Total_Vehicle_Direct_Invoice__c == 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Worksheet Dealer - Please fill a value for Total on Vehicle Direct Invoice field.'));
        //    r = false;
        //}
        //if (this.opp.VD_Worksheet__r.Total_VD_Margin_Inc_GST__c == 0) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Worksheet Dealer - Please fill a value for Total VD Margin Inc GST field.'));
        //    r = false;
        //}
        if (this.opp.VD_Worksheet__r.Trading_Customer__c > 0 && String.isBlank(this.opp.VD_Worksheet__r.Trading_Customer_Comments__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Worksheet Dealer - Please include some commets for Trading to the Customer (VD).'));
            r = false;   
        }
        
        
        /** HJ 05-05-207 - I **/
        if (String.isBlank(this.detailDto.dealerSubUrb)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer SubUrb field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerPostcode)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer Postcode field.'));
            r = false;
        }
        if (String.isBlank(this.detailDto.dealerState)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vehicle Details - Please fill a value for Dealer State field.'));
            r = false;
        }
        /** HJ 05-05-2017 - F **/
        
        return r;
    }

    public PageReference saveWorkSheet() {
        //Validation
        if (!isValidationWS()) {
            return null;
        }
        if (isVDSales()) {
            //System.debug('Assigning VD Approver >> ' + UserInfo.getUserId());
            this.opp.VD_Worksheet__r.VD_Approver__c = UserInfo.getUserId();
            this.opp.VD_Worksheet__r.VD_Approval_Date__c = System.now();
        }
        
        update this.opp.VD_Worksheet__r;
        
        Custom_Opportunity__c o = [
            Select New_Used_Final__c, Vehicle_ID__c, Vehicle_Color__c, Vehicle_Registration__c, Dealer_Name__c,
                   Dealer_Address__c, Dealer_Contact_Name__c, Dealer_Phone_Number__c, Dealer_Mobile__c,
                   Dealer_Email__c, Dealer_Account_Email__c, Dealer_Street_Number__c, Dealer_Street_Type__c, 
                   Dealer_Suburb__c, Dealer_Postcode__c, Dealer_State__c
            From Custom_Opportunity__c Where Id = :this.opp.id];
        //Validation
        o.New_Used_Final__c = this.detailDto.newUsed;
        o.Vehicle_ID__c = this.detailDto.vehicleId;
        o.Vehicle_Color__c = this.detailDto.color;
        o.Vehicle_Registration__c = this.detailDto.registration;
        o.Dealer_Name__c = this.detailDto.dealerName;
        o.Dealer_Address__c = this.detailDto.dealerAddress;
        o.Dealer_Contact_Name__c = this.detailDto.dealerContact;
        o.Dealer_Phone_Number__c = this.detailDto.dealerPhone;
        o.Dealer_Mobile__c = this.detailDto.dealerMobile;
        o.Dealer_Email__c = this.detailDto.dealerEmail;
        o.Dealer_Account_Email__c = this.detailDto.dealerAccountEmail;
        
        o.Dealer_Street_Number__c = this.detailDto.dealerStreetNumber;
        o.Dealer_Street_Type__c = this.detailDto.dealerStreetType;
        o.Dealer_Suburb__c = this.detailDto.dealerSubUrb;
        o.Dealer_Postcode__c = this.detailDto.dealerPostcode;
        o.Dealer_State__c = this.detailDto.dealerState;
        
        update o;

        //generateWorksheetDocument();

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Worksheet data has been saved successfully.'));
        return null;
    }

    public class DetailDTO {
        public String newUsed {set;get;}
        public String vehicleId {set;get;}
        public String color {set;get;}
        public String registration {set;get;}
        public String dealerName {set;get;}
        public String dealerAddress {set;get;}
        public String dealerContact {set;get;}
        public String dealerPhone {set;get;}
        public String dealerMobile {set;get;}
        public String dealerEmail {set;get;}
        public String dealerAccountEmail {set;get;}
        public String dealerStreetNumber {set; get;}
        public String dealerStreetType {set; get;}
        public String dealerSubUrb {set; get;}
        public String dealerPostcode {set; get;}
        public String dealerState {set; get;}

        public DetailDTO() {}

        public DetailDTO(Custom_Opportunity__c o) {
            if (String.isBlank(o.New_Used_Final__c)) {
                this.newUsed = o.New_Used__c;
            } else {
                this.newUsed = o.New_Used_Final__c;
            }
            this.vehicleId = o.Vehicle_ID__c;
            this.color = o.Vehicle_Color__c;
            this.registration = o.Vehicle_Registration__c;
            // Dealer
            this.dealerName = o.Dealer_Name__c;
            this.dealerAddress = o.Dealer_Address__c;
            this.dealerContact = o.Dealer_Contact_Name__c;
            this.dealerPhone = o.Dealer_Phone_Number__c;
            this.dealerMobile = o.Dealer_Mobile__c;
            this.dealerEmail = o.Dealer_Email__c;
            this.dealerAccountEmail = o.Dealer_Account_Email__c;
            
            this.dealerStreetNumber = o.Dealer_Street_Number__c;
            this.dealerStreetType = o.Dealer_Street_Type__c;
            this.dealerSubUrb = o.Dealer_Suburb__c;
            this.dealerPostcode = o.Dealer_Postcode__c;
            this.dealerState = o.Dealer_State__c;

        }

    }

    public void recalculateFormulas() {
        this.opp.VD_Worksheet__r.recalculateFormulas();
    }

    private void generateWorksheetDocument() {
        System.debug('Generating Worksheet pdf...');
        PageReference pdf = Page.VDWorksheetPdf;
        //PageReference pdf = Page.FleetReferral;
        //PageReference pdf = new PageReference('/apex/VDWorksheetPdf');
        pdf.getParameters().put('id',String.valueOf(this.opp.Id));
        System.debug('URL >> ' + pdf.getUrl() + '!' + pdf.getParameters());

        Blob body;
        try {
            body = pdf.getContent();
            //System.debug('CONTENT >> ' + body.toString());
        } catch (VisualforceException e) {
            System.debug('Error: ' + e.getMessage());
            body = Blob.valueOf('Error occurred in generating the PDF file.');
        } 
        //System.debug('Saving attachment...');
        //Attachment attachCalc = new Attachment();
        //attachCalc.Body = body;
        //attachCalc.Name = 'VD - Worksheet - ' + System.currentTimeMillis() + '.pdf';
        //attachCalc.IsPrivate = false;
        //attachCalc.ParentId = this.opp.Id;
        //insert attachCalc;
        System.debug('Saving in cloud...');
        CloudDocsHelper.uploadFile(this.opp.Id, 'VD - Worksheet', 'Worksheet', body, 'application/pdf', 'pdf', true);
    }
    
    public List<SelectOption> getStreetTypeOptions() {
        List<SelectOption> stOptions = UtilitiesList.getStreetTypeOptions();
        return stOptions;
    }


}