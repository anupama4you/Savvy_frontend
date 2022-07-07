public without sharing class VehiclesComponentCtrl {
    public static String VD_TYPE_PROCESS = 'Fleet Referral';
    
    @AuraEnabled
    public static Map<String, Object> fetchInitialData(String recordId){
        try{
            Map<String, Object> responseMap = new Map<String, Object>();
            Custom_Opportunity__c customOpp = [SELECT ID,Name, VD_Worksheet__c, VD_Date_Sent__c,VD_Worksheet__r.VD_Approver__c,Second_Applicant_First_Name__c,Second_Applicant_Last_Name__c, Owner_Name__c, First_Name__c, Last_Name__c, Address__c, Mobile_Number__c, Home_Phone__c, Work_Phone__c, Email_Address__c, New_Used__c, Vehicle_Details__c, Lender_Approved__c, Pre_Approved_Amount__c, Pre_Approved_Vehicle_Age__c, Required_Client_Deposit__c, Client_Budget__c, Payout_Details__c, Trade_in_Details__c, Dealer_Contacted__c, Special_Conditions__c, VD_Notes__c, VD_Is_Old_Process__c, VD_Status__c, Application__r.No_of_People__c
                                               FROM Custom_Opportunity__c WHERE Id =:recordId];
            Boolean isBrokerPartnerUser = SOQLSingletonQueries.recs().isBrokerPartnerUser;
            responseMap.put('opportunity',customOpp);
            responseMap.put('isBrokerPartnerUser',isBrokerPartnerUser);
            return responseMap;
        }catch(Exception excp){
            throw new CustomException(excp.getMessage());
        }
    } 

    @AuraEnabled 
    public static void handleSubmission(Custom_Opportunity__c Opp){
        try{
            if (isValidationForApproval(Opp)) {
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
                update Opp;
        
                ApprovalTools.submittForApproval(
            ApprovalTools.VD_SALES_NEW_LEAD_PROCESS_DEFINITION, wsId, Opp.VD_Notes__c, false, VDOwnerId);

                // //Cloud document
                System.debug('Saving in cloud...');
                CloudDocGeneratorBatch.createBatch(opp.Id, CloudDocGeneratorBatch.VD_FLEETREFERRAL, 1);
                //Email
                User VDOwner = [SELECT ID, Phone, Email, MobilePhone, Name, profileid FROM User Where id =:Opp.VD_Owner__c];
                List<String> toAddresses = new List<String> ();
                toAddresses.add(VDOwner.Email);       //ORIGINAL
                // toAddresses.add('leandro.l@savvy.com.au');
                List<Attachment> attachments = new List<Attachment>();
                if (!Test.IsRunningTest()){
                    EmailSender.sendEmailToVDSent_v2(attachments, toAddresses, Opp);
                }
            }

        }catch(Exception excp){
            System.debug('Excp line number '+excp.getLineNUmber());
            System.debug('Excp Stack '+excp.getStackTraceString());
            throw new CustomException(excp.getMessage());
        }

    }
    @testVisible
    private static Boolean isValidationForApproval(Custom_Opportunity__c Opp) {
        Boolean r = true;
        if (Opp.VD_Owner__c != null) {
            if (!String.isBlank(Opp.VD_Status_Process__c) && !'Send back to Sales Consultant - cannot proceed'.equals(Opp.VD_Status_Process__c)) {
                    throw new CustomException('This deal has already been sent to Vehicles Direct.');
            }
        }
        return r;
    }

}