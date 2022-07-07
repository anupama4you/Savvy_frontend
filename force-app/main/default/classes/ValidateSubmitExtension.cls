public with sharing class ValidateSubmitExtension {
  private static String APROVAL_PROCESS_DEFINITION = 'Settlement_Approval';
  public Custom_Opportunity__c opp;
  public List<String> docsValidated { get; set; }
  public List<String> fieldsValidated { get; set; }
  // public String msgInsurance {set;get;}
  public String msgSubmitProcess { get; set; }
  // private Application_Quoting__c quoting;

  public ValidateSubmitExtension(ApexPages.StandardController c) {
    this.opp = (Custom_Opportunity__c) c.getRecord();
  }

  public PageReference Validate2() {
    msgSubmitProcess = null;

    ValidationResult rsl = validateSubmission(this.opp);
    this.docsValidated = rsl.docsValidated;
    this.fieldsValidated = rsl.fieldsValidated;
    
    Boolean isReadyToApproval = (((docsValidated == null ||
    docsValidated.isEmpty()) &&
    (fieldsValidated.isEmpty()) &&
    (String.isBlank(msgSubmitProcess))));

    //Evaluate conditions
    if (isReadyToApproval) {
      return submit();
    }
    return null;
  }

  public PageReference submit() {
    // update the status to internal settlement
    opp.Status__c = 'Internal Settlement';
    update opp;

    try {
      submitForApproval(opp.Id);
      return new PageReference('/' + opp.Id);
    } catch (Exception e) {
      if (e.getMessage().contains('NO_APPLICABLE_PROCESS')) {
        msgSubmitProcess = 'No applicable approval process was found.';
      } else if (e.getMessage().contains('ALREADY_IN_PROCESS')) {
        msgSubmitProcess = 'This record is currently in an approval process. A record can be in only one approval process at a time';
      } else {
        msgSubmitProcess = 'Exception reported: ' + e.getMessage();
      }
    }
    return null;
  }

  /**
   * This method will submit the opportunity automatically
   **/
  public void submitForApproval(Id oppId) {
    // Create an approval request for the Opportunity
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for Settlement Officer Approval');
    req1.setObjectId(oppId);
    req1.setProcessDefinitionNameOrId(APROVAL_PROCESS_DEFINITION);
    req1.setNextApproverIds(ApprovalTools.getApprovalTemUsersIds());

    // Submit the approval request for the Opportunity
    Approval.ProcessResult result = Approval.process(req1);
  }

  public class ValidationResult {
    public List<String> docsValidated { get; set; }
    public List<String> fieldsValidated { get; set; }
    public String lender { get; set; }

    public ValidationResult() {
      this.docsValidated = new List<String>();
      this.fieldsValidated = new List<String>();
    }
  }

  public static ValidationResult validateSubmission(Custom_Opportunity__c opp) {
    ValidationResult v = new ValidationResult();
    Map<String, List<String>> valResult = ApprovalValidations.validateSettlement(
      opp.Id
    );
    if (!valResult.isEmpty()) {
      v.docsValidated = new List<String>();
      for (String k : valResult.keySet()) {
        if (!ApprovalValidations.WARN_MSG.equals(k)) {
          for (String m : valResult.get(k)) {
            v.docsValidated.add(m);
          }
        }
      }
    }
    return v;
  }
}