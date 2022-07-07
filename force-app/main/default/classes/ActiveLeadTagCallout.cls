public class ActiveLeadTagCallout {
  @future(callout=true)
  public static void InsertAndUpdate(
    Set<Id> setLeadIds,
    Map<id, string> mapStatusToId
  ) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    if (!isOn) return;
    List<string> statusStr = createStatus();

    for (Lead__c ldObj : [
      SELECT
        id,
        First_Name__c,
        Last_Name__c,
        Email_Address__c,
        Status__c,
        Reason_for_closure__c
      FROM Lead__c
      WHERE Id IN :setLeadIds
    ]) {
      if (
        mapStatusToId.containsKey(ldObj.id) &&
        mapStatusToId.get(ldObj.id) == 'Yes'
      ) {
        for (string strStatus : statusStr) {
          Http http = new Http();
          HttpRequest req = new HttpRequest();
          req.setEndpoint(
            'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_tag_remove&api_output=json'
          );
          req.setMethod('POST');
          req.setBody('Content-Type=application/x-www-form-urlencoded');
          req.setBody('Content-Length="512"');
          string statusUpdate = 'No';

          system.debug('####statusUpdate' + statusUpdate);
          System.debug(ContactsTagDelXML(ldObj, strStatus));

          req.setBody(ContactsTagDelXML(ldObj, strStatus));

          System.debug('HttpRequest :' + req);
          System.debug('HttpRequest :' + req.getBody());

          HttpResponse res = http.send(req);
          System.debug('HttpRequest Response:' + res.getBody());
          System.debug('HttpRequest Status Code:' + res.getStatusCode());

          if (res.getStatusCode() != 200) {
            System.debug(
              'Error from ' +
              req.getEndpoint() +
              ' : ' +
              res.getStatusCode() +
              ' ' +
              res.getStatus()
            );
          }
        } //end for
      } //end if
    } // end for
  } // end method

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

  private static String ContactsTagDelXML(Lead__c ld, string Ldstatus) {
    String msg = '';
    string leadStatus = '';
    string leadClosure = '';

    leadStatus = string.valueOf(ld.Status__c);

    leadClosure = string.valueOf(ld.Reason_for_closure__c);

    msg +=
      'email=' +
      ld.Email_Address__c +
      '&first_name=' +
      ld.First_Name__c +
      '&last_name=' +
      ld.Last_Name__c +
      '&p[1]=1&instantresponders[1]=1&field[%Status%,0]=' +
      ld.Status__c +
      '&instantresponders[1]=1&field[%REASON_FOR_CLOSURE%,0]=' +
      ld.Reason_for_closure__c +
      '&tags[0]=' +
      Ldstatus +
      '&tags[1]=' +
      leadClosure;

    return msg;
  } // end method
} //end class