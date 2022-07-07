global class queueActiveLeadTagCallout implements Queueable, Database.AllowsCallouts {
  private static final String API_KEY = '0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898';

  List<Lead__c> ldUpdLst = new List<Lead__c>();
  Map<Id, string> mapStatusToId = new Map<Id, String>();

  public queueActiveLeadTagCallout(
    List<Lead__c> ldLists,
    Map<Id, string> StatusToIdUpdMap
  ) {
    ldUpdLst = ldLists;
    mapStatusToId = StatusToIdUpdMap;
  }

  public void execute(QueueableContext context) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    for (Lead__c ldObj : ldUpdLst) {
      if (
        mapStatusToId.containsKey(ldObj.id) &&
        mapStatusToId.get(ldObj.id) == 'Yes'
      ) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');

        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=' +
          API_KEY +
          '&api_action=contact_tag_remove&api_output=json'
        );

        string msgBody =
          'email=' + EncodingUtil.urlEncode(ldObj.Email_Address__c, 'UTF-8');
        for (string str : createStatus()) {
          msgBody += '&tags[]=' + EncodingUtil.urlEncode(str, 'UTF-8');
        }

        System.debug(msgBody);
        req.setBody(msgBody);
        HttpResponse response = null;
        Http http = new Http();
        if (isOn) {
          response = http.send(req);

          HttpRequest req2 = new HttpRequest();
          req2.setMethod('POST');
          req2.setEndpoint(
            'https://savvyfinance.api-us1.com/admin/api.php?api_key=' +
            API_KEY +
            '&api_action=contact_sync&api_output=json'
          );

          req2.setBody('Content-Type=application/x-www-form-urlencoded');
          req2.setBody('Content-Length="512"');
          string statusUpdate = 'Yes';

          req2.setBody(ContactsXML(ldObj, statusUpdate));
          HttpResponse response2 = null;
          Http http2 = new Http();
          if (!Test.isRunningTest()) {
            response2 = http2.send(req2);
          }
        }
      } //end if
      if (
        !'Small Loan'.equals(ldObj.Loan_Type__c) &&
        'Excellent'.equalsIgnoreCase(ldObj.Credit_History__c)
      ) {
        executeAddContactTransmitSMS(ldObj);
      }
    } //end for

    //System.enqueueJob(new queueActiveLeadCampaignCallout(ldUpdLst,mapStatusToId));
  }

  private static List<string> createStatus() {
    List<string> statusStr = new List<String>();
    //    Lead status:
    statusStr.add('New Lead');
    statusStr.add('Attempted Contact');
    statusStr.add('Attempted Contact 1');
    statusStr.add('Attempted Contact 2');
    statusStr.add('Attempted Contact 3');
    statusStr.add('Attempted Contact 4');
    statusStr.add('Attempted Contact 5');
    statusStr.add('Attempted Contact 6');
    statusStr.add('Become Opportunity');
    statusStr.add('Closed Lead');
    statusStr.add('Unresolved Lead');

    //    Lead - Reason for Closure:
    statusStr.add('Could not make contact');
    statusStr.add('Unable to help - income');
    statusStr.add('Unable to help - credit');
    statusStr.add('Duplicate Lead');
    statusStr.add('Wrong Number or Details');
    statusStr.add('No longer Proceeding - Response Saved');

    //  Opportunity Status:
    statusStr.add('Closed Opportunity');
    statusStr.add('I Consent');
    statusStr.add('Quote Sent');
    statusStr.add('Application Form Sent Prime');
    statusStr.add('Application Form Sent Sub Prime');
    statusStr.add('Application Forms Received');
    statusStr.add('Awaiting Paperwork');
    statusStr.add('24 Hour Call');
    statusStr.add('Submitted for Approval');
    statusStr.add('Pre-Approved');
    //statusStr.add('Pre-approved FFU');
    statusStr.add('Future follow up');
    statusStr.add('Pre-Approved');
    statusStr.add('Invoice requested');
    statusStr.add('Invoice Received');
    statusStr.add('Sent for Settlement');
    statusStr.add('Documents Sent');
    statusStr.add('Documents Received');
    statusStr.add('Awaiting Further Information');
    statusStr.add('Sent to Lender');
    statusStr.add('Settlement Rejected');
    statusStr.add('Settled');
    statusStr.add('Closed Opportunity');
    statusStr.add('Null');
    statusStr.add('Unresolved Opportunity');
    statusStr.add('Could not beat quote');
    statusStr.add('Send details for future reference');
    statusStr.add('Cannot contact after 6 + attempts');
    statusStr.add('Client changed their mind');

    return statusStr;
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
    msg += '&tags[0]=' + leadStatus;
    msg += '&tags[1]=' + leadStatus;
    msg += '&tags[2]=' + leadClosure;

    if (isStatusUpd == 'Yes') {
      msg += '&instantresponders[1]=1&field[%Status%,0]=' + leadStatus;
    }
    return msg;
  } // end method

  private void executeAddContactTransmitSMS(Lead__c lead) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'TransmitSMS_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
    p.endpoint = 'callout:TransmitSMS/add-to-list.json';
    p.method = ConnectionRESTWs.POST;
    p.addRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    p.body = makeContactSMS(lead);
    if (isOn && !Test.isRunningTest()) {
      HttpResponse res = ConnectionRESTWs.invoke(p);
    }
  }

  private static String makeContactSMS(Lead__c ld) {
    String mobile = ld.Mobile_Number__c;
    if (String.isNotBlank(mobile)) {
      mobile = mobile.replaceAll('\\+', '');
      mobile = mobile.replaceAll('\\s', '');
    }
    String msg = '';
    msg =
      'list_id=' +
      Parameters_Service__c.getInstance('TransmitSMS_Excellent_ListID')
        .value__c;
    msg += '&first_name=' + ld.First_Name__c;
    msg += '&last_name=' + ld.Last_Name__c;
    msg += '&msisdn=' + mobile;
    msg += '&countrycode=au';
    msg += '&field_1=' + ld.Email_Address__c;
    msg += '&field_2=' + ld.Credit_History__c;
    return msg;
  } // en
}