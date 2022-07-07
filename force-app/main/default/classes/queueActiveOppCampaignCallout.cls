global class queueActiveOppCampaignCallout implements Queueable, Database.AllowsCallouts {
  List<Custom_Opportunity__c> opps = new List<Custom_Opportunity__c>();
  Map<id, string> mapStsUpd = new Map<id, string>();

  public queueActiveOppCampaignCallout(
    List<Custom_Opportunity__c> oppObj,
    Map<id, string> oppStsUpdMap
  ) {
    opps = oppObj;
    mapStsUpd = oppStsUpdMap;
  }

  public void execute(QueueableContext context) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    for (Custom_Opportunity__c oppObj : opps) {
      if (isOn && !'Home Loans'.equals(oppObj.Owner_Name__c)) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json'
        );

        req.setBody('Content-Type=application/x-www-form-urlencoded');

        req.setBody('Content-Length="512"');
        string statusUpdate = 'No';

        if (
          mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'Yes'
        ) {
          statusUpdate = 'Yes';
        } else if (
          mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'No'
        ) {
          statusUpdate = 'No';
        }

        req.setBody(opportunityXML(oppObj, statusUpdate));
        HttpResponse response = null;
        if (!Test.isRunningTest()) {
          Http http = new Http();
          response = http.send(req);
          System.debug('HttpRequest Response:' + response.getBody());
        }
      }
    }
  }

  private static String opportunityXML(
    Custom_Opportunity__c opp,
    string isStatusUpd
  ) {
    String msg = '';
    string oppStatus = string.valueOf(opp.Status__c);
    string oppClosure = string.valueOf(opp.Reason_for_closure__c);
    string oppLoanTerm = string.valueOf(opp.Opp_Loan_Term__c);
    string OwnerName = opp.Owner_Name__c == 'System Generated'
      ? ''
      : opp.Owner_Name__c;
    string OwnerEmail = opp.Owner_Email__c == 'systemgenerated@savvy.com.au'
      ? ''
      : opp.Owner_Email__c;
    string OwnerMobile = string.isEmpty(opp.Owner_Mobile__c)
      ? ''
      : opp.Owner_Mobile__c;
    string OwnerPhone = string.isEmpty(opp.Owner_Phone__c)
      ? ''
      : opp.Owner_Phone__c;
    string oppStatusUpd = string.isEmpty(opp.Status__c) ? '' : opp.Status__c;

    msg += 'email=' + opp.Email_Address__c;
    msg += '&First_Name=' + opp.Account_First_Name__c;
    msg +=
      '&p[3]=3&instantresponders[3]=1&field[%OPP_STATUS%,0]=' + opp.Status__c;
    msg += '&instantresponders[3]=1&field[%STATE%,0]=' + opp.State__c;
    msg += '&instantresponders[3]=1&field[%OWNER_NAME%,0]=' + OwnerName;
    msg += '&instantresponders[3]=1&field[%OWNER_EMAIL%,0]=' + OwnerEmail;
    msg += '&instantresponders[3]=1&field[%OWNER_MOBILE%,0]=' + OwnerMobile;
    msg += '&instantresponders[3]=1&field[%OWNER_PHONE%,0]=' + OwnerPhone;
    msg +=
      '&instantresponders[3]=1&field[%OPP_REASON_FOR_CLOSURE%,0]=' +
      opp.Reason_for_closure__c;
    msg +=
      '&instantresponders[3]=1&field[%LOAN_TERM%,0]=' + opp.Opp_Loan_Term__c;
    msg +=
      '&instantresponders[3]=1&field[%LOAN_TYPE%,0]=' + opp.Opp_Loan_Type__c;
    msg += '&tags[0]=' + oppStatus;
    msg += '&tags[1]=' + oppClosure;

    if (isStatusUpd == 'Yes') {
      msg += '&instantresponders[3]=1&field[%OPP_STATUS%,0]=' + opp.Status__c;
    }

    return msg;
  } // end method
}