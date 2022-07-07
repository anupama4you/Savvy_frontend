global class queueActiveLeadCampaignCallout implements Queueable, Database.AllowsCallouts {
  List<Lead__c> leads = new List<Lead__c>();
  Map<id, string> mapStsUpd = new Map<id, string>();

  public queueActiveLeadCampaignCallout(
    List<Lead__c> leadObj,
    Map<id, string> leadStsUpdMap
  ) {
    leads = leadObj;
    mapStsUpd = leadStsUpdMap;
  }

  public void execute(QueueableContext context) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    for (Lead__c ldObj : leads) {
      HttpRequest req = new HttpRequest();
      req.setMethod('POST');
      req.setEndpoint(
        'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json'
      );

      req.setBody('Content-Type=application/x-www-form-urlencoded');

      req.setBody('Content-Length="512"');
      string statusUpdate = 'No';

      if (mapStsUpd.containsKey(ldObj.id) && mapStsUpd.get(ldObj.id) == 'Yes') {
        statusUpdate = 'Yes';
      } else if (
        mapStsUpd.containsKey(ldObj.id) && mapStsUpd.get(ldObj.id) == 'No'
      ) {
        statusUpdate = 'No';
      }

      system.debug('####statusUpdate' + statusUpdate);

      System.debug(ContactsXML(ldObj, statusUpdate));
      req.setBody(ContactsXML(ldObj, statusUpdate));
      System.debug('HttpRequest :' + req);
      System.debug('HttpRequest :' + req.getBody());
      System.debug('HttpRequest :' + req.getHeader('Authorization'));
      HttpResponse response = null;
      if (isOn && !Test.isRunningTest()) {
        Http http = new Http();
        response = http.send(req);
        System.debug('HttpRequest Response:' + response.getBody());
      }
    }
  }

  private static String ContactsXML(Lead__c ld, string isStatusUpd) {
    String msg = '';
    string leadStatus = string.valueOf(ld.Status__c);
    string leadClosure = string.valueOf(ld.Reason_for_closure__c);
    string leadDob = string.valueOf(ld.Date_of_Birth__c);
    string leadOwnerName = ld.Lead_Owner__c == 'System Generated'
      ? ''
      : ld.Lead_Owner__c;
    string leadOwnerEmail = ld.Owner_Email__c == 'systemgenerated@savvy.com.au'
      ? ''
      : ld.Owner_Email__c;
    string leadOwnerMobile = string.isEmpty(ld.Owner_Mobile__c)
      ? ''
      : ld.Owner_Mobile__c;
    string leadOwnerPhone = string.isEmpty(ld.Owner_Phone__c)
      ? ''
      : ld.Owner_Phone__c;
    string leadStatusUpd = string.isEmpty(ld.Status__c) ? '' : ld.Status__c;
    string leadCreditHistory = string.isEmpty(ld.Credit_History__c)
      ? ''
      : ld.Credit_History__c;

    msg = 'email=' + ld.Email_Address__c;
    msg += '&first_name=' + ld.First_Name__c;
    msg += '&last_name=' + ld.Last_Name__c;
    msg +=
      '&p[1]=1&instantresponders[1]=1&field[%REASON_FOR_CLOSURE%,0]=' +
      ld.Reason_for_closure__c;
    msg += '&instantresponders[1]=1&field[%OWNER_NAME%,0]=' + leadOwnerName;
    msg += '&instantresponders[1]=1&field[%OWNER_PHONE%,0]=' + leadOwnerPhone;
    msg += '&instantresponders[1]=1&field[%OWNER_MOBILE%,0]=' + leadOwnerMobile;
    msg += '&instantresponders[1]=1&field[%OWNER_EMAIL%,0]=' + LeadOwnerEmail;
    msg +=
      '&instantresponders[1]=1&field[%FINANCE_AMOUNT%,0]=' +
      ld.Finance_Amount__c;
    msg += '&instantresponders[1]=1&field[%LOAN_TYPE%,0]=' + ld.Loan_Type__c;
    msg += '&phone=' + ld.Home_Phone__c;
    msg += '&instantresponders[1]=1&field[%Mobile%,0]=' + ld.Mobile_Number__c;
    msg +=
      '&instantresponders[1]=1&field[%STREET_ADDRESS%,0]=' +
      ld.Street_Address__c;
    msg +=
      '&instantresponders[1]=1&field[%STREET_TYPE%,0]=' + ld.Street_Type__c;
    msg += '&instantresponders[1]=1&field[%SUBURB%,0]=' + ld.Suburb__c;
    msg += '&instantresponders[1]=1&field[%STATE%,0]=' + ld.State__c;
    msg += '&instantresponders[1]=1&field[%POSTCODE%,0]=' + ld.Postcode__c;
    msg +=
      '&instantresponders[1]=1&field[%CREDIT_HISTORY%,0]=' + leadCreditHistory;
    msg += '&tags[0]=' + leadStatus;
    msg += '&tags[1]=' + leadStatus;
    msg += '&tags[2]=' + leadClosure;

    if (isStatusUpd == 'Yes') {
      msg += '&instantresponders[1]=1&field[%Status%,0]=' + leadStatus;
    }
    return msg;
  } // end method
}