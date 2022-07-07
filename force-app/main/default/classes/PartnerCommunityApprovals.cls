public class PartnerCommunityApprovals {
  public static final String PRE_APPROVAL_TYPE = 'PA';
  public static final String FORMAL_APPROVAL_TYPE = 'FA';
  public static final String SETTLED_TYPE = 'ST';

  public static final String APPROVAL_TYPE_MANUAL = 'M';
  public static final String APPROVAL_TYPE_API = 'API';
  public static final String APPROVAL_TYPE_BS = 'BS';
  
  @AuraEnabled
  public static Map<String, List<String>> preApprovalValidation(Id oppId) {
    System.debug('preApprovalValidation...');
    return ApprovalValidations.validatePreApproval(oppId);
    // Map<String, List<String>> r = ApprovalValidations.validatePreApproval(oppId);
    // System.debug('Total records => ' + r.size());
    // System.debug(JSON.serialize(r));
    // return r;

    // Map<String, List<String>> r = ApprovalValidations.validatePreApproval(oppId);
    // System.debug('Validations => ' + r.keySet());
    // return r;
    // return new Map<String, List<String>>();

    // Map<String, List<String>> r = new Map<String, List<String>>();
    // // return (r.isEmpty()? null: r);
    // List<String> a = new List<String>();
    // a.add('Tax Returns');
    // a.add('Medicare Card');
    // a.add('Servicing Calculation');
    // a.add('Spouse Information');
    // r.put(ApprovalValidations.DOCUMENT_MSG, a);
    // a = new List<String>();
    // a.add('A Finance Product is required, please create it in Products section');
    // r.put(ApprovalValidations.OTHER_MSG, a);
    // a = new List<String>();
    // a.add('Statement of Position');
    // r.put(ApprovalValidations.ERROR_MSG, a);
    // a = new List<String>();
    // a.add('Secondary evidence of income will be required for Amendment/Formal approvals. Please obtain from client.');
    // r.put(ApprovalValidations.WARN_MSG, a);
    // return r;
  }

  @AuraEnabled
  public static Map<String, List<String>> formalApprovalValidation(Id oppId) {
    return ApprovalValidations.validateFormalApproval(oppId);
  }

  @AuraEnabled
  public static Map<String, List<String>> settlementValidation(Id oppId) {
    return ApprovalValidations.validateManualSettlement(oppId);
  }

  @AuraEnabled(cacheable=true)
  public static Lenders__c getLenderSettings(Id oppId) {
    System.debug('getLenderSettings...');
    Lenders__c r = null;
    if (String.isNotBlank(oppId)) {
      List<Application_Quoting__c> d = [
        SELECT Name
        FROM Application_Quoting__c
        WHERE Opportunity__c = :oppId
        ORDER BY CreatedDate DESC
      ];
      String qn = (!d.isEmpty()) ? d.get(0).Name : null;
      if (String.isNotBlank(qn)) {
        System.debug('Seaching for => ' + qn);
        r = QuotingCalculation.getLenderSettings(qn);
      }
    }
    return r;
  }

  @AuraEnabled
  public static LenderAPI.APIResponse processApi(Id oppId) {
    return LenderAPI.invokeApi(oppId);
  }

  public virtual class GenericResponse {
    @AuraEnabled
    public String status { get; set; }
    @AuraEnabled
    public List<String> errors { get; set; }

    public GenericResponse() {
      this.status = null;
      this.errors = new List<String>();
    }
  }

  @AuraEnabled
  public static GenericResponse submitApproval(
    Id oppId,
    String approvalType,
    String lenderComments,
    String brokerSupportComments
  ) {
    GenericResponse r = new GenericResponse();
    r.status = '1';
    String comments = '';
    Custom_Opportunity__c opp = getOpportunity(oppId);
    if (opp != null) {
      if (
        PRE_APPROVAL_TYPE.equals(approvalType) ||
        FORMAL_APPROVAL_TYPE.equals(approvalType)
      ) {

        comments = 'Submitting request for ';
        comments += FORMAL_APPROVAL_TYPE.equals(approvalType)? 'Formal ' : 'Pre-';
        comments += 'Approval';
        comments +=
          '.\n\nLender: ' +
          lenderComments +
          '\nProcessing: ' +
          brokerSupportComments;
        try {
          Id appId = opp.Application__c;
          String aprocess = FORMAL_APPROVAL_TYPE.equals(approvalType)
            ? ApprovalTools.FORMALAPPROVAL_PROCESS_DEFINITION
            : ApprovalTools.PREAPPROVAL_PROCESS_DEFINITION;
          // Set Approval types
          if (PRE_APPROVAL_TYPE.equals(approvalType)) {
            opp.Partner_PreApproval_Type__c = APPROVAL_TYPE_BS;
          } else if (FORMAL_APPROVAL_TYPE.equals(approvalType)) {
            opp.Partner_ForApproval_Type__c = APPROVAL_TYPE_BS;
          }
          if (String.isBlank(opp.Partner_BS_Service__c)) {
            opp.Partner_BS_Service__c = 'Y';
          }
          opp.All_Documents_Attached__c = true;
          update opp;

          // Submission
          ApprovalTools.submittForApproval(
            aprocess,
            oppId,
            comments,
            false
          );
          // Add coments
          ApplicationExtraDataHelper.addPlainData(
            appId,
            'Note',
            'Notes',
            brokerSupportComments,
            true,
            'Processing'
          );
          ApplicationExtraDataHelper.addPlainData(
            appId,
            'Note',
            'Notes',
            lenderComments,
            true,
            'Lender'
          );
          // Generate documents
          //-------------------
          if (PRE_APPROVAL_TYPE.equals(approvalType)) {
            // Preliminary Assestment
            ApprovalTools.generatePreliminaryAssessmet(oppId);
            // Application Form for Pre-approval
            ApprovalTools.generateApplicationFormDocument(oppId);
          }
          r.status = '0'; // all good!
        } catch (Exception e) {
          String err = 'Exception reported: ' + e.getMessage();
          if (e.getMessage().contains('NO_APPLICABLE_PROCESS')) {
            err = 'No applicable approval process was found.';
          } else if (e.getMessage().contains('ALREADY_IN_PROCESS')) {
            err = 'This record is currently in an approval process. A record can be in only one approval process at a time';
          }
          r.errors.add(err);
          System.debug('Error: ' + e.getMessage());
        }
      } else if (SETTLED_TYPE.equals(approvalType)) {
        try {
          opp.Status__c = 'Settled';
          opp.Date_closed_or_settled__c = Datetime.now();
          update opp;
          r.status = '0';
        } catch (Exception e) {
          String err = 'Exception reported: ' + e.getMessage();
          r.errors.add(err);
          System.debug('Error: ' + e.getMessage());
        }
      }
    } else {
      r.errors.add('Opportunity ID not found [ID: ' + oppId + ']');
    }
    return r;
  }

  @AuraEnabled
  public static GenericResponse manualSubmission(Id oppId, String approvalType, Boolean isApi){
    System.debug('manualSubmission...');
    isApi = isApi == null? false: isApi;
    GenericResponse r = new GenericResponse();
    if (oppId != null && String.isNotBlank(approvalType)) {
      Custom_Opportunity__c opp = getOpportunity(oppId);
      if (opp != null) {
        opp.Status__c = getNextApprovalStatus(approvalType);
        if (String.isNotBlank(opp.Status__c)) {
          if (isApi) {
            opp.Partner_PreApproval_Type__c = APPROVAL_TYPE_API;
          } else {
            // Set Approval types
            if (PRE_APPROVAL_TYPE.equals(approvalType)) {
              opp.Partner_PreApproval_Type__c = APPROVAL_TYPE_MANUAL;
            } else if (FORMAL_APPROVAL_TYPE.equals(approvalType)) {
              opp.Partner_ForApproval_Type__c = APPROVAL_TYPE_MANUAL;
            }
          }
          try {
            update opp;
            r.status = '0';
          } catch (Exception e) {
            r.errors.add('Error processing your request [' + e.getMessage() + ']');
          }

          // Generate documents
          //-------------------
          if (PRE_APPROVAL_TYPE.equals(approvalType)) {
            // Preliminary Assestment
            ApprovalTools.generatePreliminaryAssessmet(oppId);
            // Application Form for Pre-approval
            ApprovalTools.generateApplicationFormDocument(oppId);
          }

        } else {
          r.errors.add('There is not any status to apply in this approval process [' + approvalType + ']');
        }
      }      
    } else {
      r.errors.add('Invalid parameters Opp[' + oppId + '] process[' + approvalType + '] isApi[' + isApi + ']');
    }
    if (!r.errors.isEmpty()) {
      r.status = '1';
    }
    return r;
  }

  private static Custom_Opportunity__c getOpportunity(Id oppId) {
    Custom_Opportunity__c o = null;
    if (oppId != null) {
      List<Custom_Opportunity__c> opps = [
        SELECT 
          Id, Name, Application__c, Status__c,
          Partner_BS_Service__c, Partner_ForApproval_Type__c, 
          Partner_PreApproval_Type__c
        FROM Custom_Opportunity__c
        WHERE Id = :oppId
      ];
      if (!opps.isEmpty()) {
        o = opps.get(0);
      }
    }
    return o;
  }

  private static String getNextApprovalStatus(String approvalType) {
    if (PRE_APPROVAL_TYPE.equals(approvalType)) {
      return 'Sent to Lender for Pre-Approval';
    }
    if (FORMAL_APPROVAL_TYPE.equals(approvalType)) {
      return 'Sent to Lender for Formal Approval';
    }
    return null;
  }
}