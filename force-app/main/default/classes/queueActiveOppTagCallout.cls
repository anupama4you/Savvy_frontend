global class queueActiveOppTagCallout implements Queueable, Database.AllowsCallouts {
  List<Custom_Opportunity__c> opps = new List<Custom_Opportunity__c>();
  Map<id, string> mapStsUpd = new Map<id, string>();

  public queueActiveOppTagCallout(
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

    Map<Id, Custom_Opportunity__c> partners = new Map<Id, Custom_Opportunity__c>();
    Set<Id> oppsIds = new Set<Id>();
    for (Custom_Opportunity__c oppObj : opps) {
      oppsIds.add(oppObj.Id);
    }
    if (!oppsIds.isEmpty()) {
      List<Custom_Opportunity__c> d = [
        SELECT
          Partner_Is_External__c, Partner_Owner__c, Franchise_Owner__c
        FROM Custom_Opportunity__c
        WHERE Id in :oppsIds
      ];
      for (Custom_Opportunity__c o: d) {
        partners.put(o.Id, o);
      }
      // System.debug('@@opp partners: ' + JSON.serializePretty(partners));
    }
    
    for (Custom_Opportunity__c oppObj : opps) {
      if (
        mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'Yes'
      ) {
        // System.debug('@@checking oppId: ' + oppObj.Id + '|' + isExternalPartner(oppObj.Id, partners) + '|' + isOn);
        if (isOn && !'Home Loans'.equals(oppObj.Owner_Name__c) && !isExternalPartner(oppObj.Id, partners)) {
          // System.debug('@@process active campaing for opp: ' + oppObj.Name);
          HttpRequest req = new HttpRequest();
          req.setMethod('POST');
          req.setEndpoint(
            'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_tag_remove&api_output=json'
          );

          string msgBody =
            'email=' + EncodingUtil.urlEncode(oppObj.Email_Address__c, 'UTF-8');
          for (string str : createStatus()) {
            msgBody += '&tags[]=' + EncodingUtil.urlEncode(str, 'UTF-8');
          }

          System.debug(msgBody);
          req.setBody(msgBody);
          req.setTimeout(30000);
          HttpResponse response = null;
          Http http = new Http();
          response = http.send(req);

          HttpRequest req2 = new HttpRequest();
          req2.setMethod('POST');
          req2.setEndpoint(
            'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json'
          );

          req2.setBody('Content-Type=application/x-www-form-urlencoded');
          req2.setBody('Content-Length="512"');
          string statusUpdate = 'Yes';

          req2.setBody(opportunityXML(oppObj, statusUpdate));
          HttpResponse response2 = null;
          Http http2 = new Http();
          if (!Test.isRunningTest()) {
            response2 = http2.send(req2);
            System.debug('response2 >> ' + response2.getBody());
          }
        }
      } //end if
    } //end for
  }

  private static List<string> createStatus() {
    List<string> OppstatusStr = new List<String>();
    //   lead status:
    OppstatusStr.add('Attempted Contact 1');
    OppstatusStr.add('Attempted Contact 2');
    OppstatusStr.add('Attempted Contact 3');
    OppstatusStr.add('Attempted Contact 4');
    OppstatusStr.add('Attempted Contact 5');
    OppstatusStr.add('Attempted Contact 6');
    OppstatusStr.add('Become Opportunity');
    OppstatusStr.add('Closed Lead');
    OppstatusStr.add('Unresolved Lead');

    //   lead - Reason for closure:
    OppstatusStr.add('Could not make contact');
    OppstatusStr.add('Unable to help - income');
    OppstatusStr.add('Unable to help - credit');
    OppstatusStr.add('Duplicate Lead');
    OppstatusStr.add('Wrong Number or Details');
    OppstatusStr.add('No longer Proceeding - Response Saved');

    //   Opportunity status:
    OppstatusStr.add('Become Opportunity');
    OppstatusStr.add('I Consent');
    OppstatusStr.add('Quote Sent');
    OppstatusStr.add('Application Form Sent Prime');
    OppstatusStr.add('Application Form Sent Sub Prime');
    OppstatusStr.add('Application Forms Received');
    OppstatusStr.add('Awaiting Paperwork');
    OppstatusStr.add('24 Hour Call');
    OppstatusStr.add('Submitted for Approval');
    OppstatusStr.add('Pre-Approved');
    //OppstatusStr.add('Pre-approved FFU');
    OppstatusStr.add('Future follow up');
    OppstatusStr.add('Pre-Approved');
    OppstatusStr.add('Invoice requested');
    OppstatusStr.add('Invoice Received');
    OppstatusStr.add('Sent for Settlement');
    OppstatusStr.add('Documents Sent');
    OppstatusStr.add('Documents Received');
    OppstatusStr.add('Awaiting Further Information');
    OppstatusStr.add('Sent to Lender');
    OppstatusStr.add('Settlement Rejected');
    OppstatusStr.add('Settled');
    OppstatusStr.add('Closed Opportunity');
    OppstatusStr.add('Unresolved Lead');
    OppstatusStr.add('Null');
    OppstatusStr.add('Unresolved Opportunity');

    //   Reason for closure:
    OppstatusStr.add('Could not beat quote');
    OppstatusStr.add('Client Changed their mind');
    OppstatusStr.add('Send details for future reference');
    OppstatusStr.add('Cannot contact after 6 + attempts');
    OppstatusStr.add('Declined – Reason Saved');

    return OppstatusStr;
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
    if (opp.emailoptout__c) {
      msg += '&status[1]=2&status[3]=2';
    }
    System.debug(msg);
    return msg;
  } // end method

  public static Boolean isExternalPartner(Id oppId, Map<Id, Custom_Opportunity__c> partners) {
    return (
      oppId != null && partners != null && !partners.isEmpty() &&
      partners.containsKey(oppId) &&  
      partners.get(oppId).Partner_Is_External__c
    );
  }

}