public class ActiveOppTagCallout {
  @future(callout=true)
  public static void InsertAndUpdate(
    Set<Id> setOppIds,
    Map<id, string> mapStatusToId
  ) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    if (!isOn) return;
    List<string> statusStr = createStatus();

    for (Custom_Opportunity__c oppObj : [
      SELECT
        id,
        Name,
        Email_Address__c,
        Status__c,
        Reason_for_closure__c,
        Opp_Loan_Term__c,
        Opp_Loan_Type__c
      FROM Custom_Opportunity__c
      WHERE Id IN :setOppIds AND Owner_Name__c != 'Home Loans'
    ]) {
      if (
        mapStatusToId.containsKey(oppObj.id) &&
        mapStatusToId.get(oppObj.id) == 'Yes'
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
          System.debug(opportunityXML(oppObj, strStatus));

          req.setBody(opportunityXML(oppObj, strStatus));

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
    string OpptStatus
  ) {
    String msg = '';
    string oppClosure = '';

    msg +=
      'email=' +
      opp.Email_Address__c +
      '&first_name=' +
      opp.Name +
      '&p[3]=3&instantresponders[3]=1&field[%OPP_STATUS%,0]=' +
      opp.Status__c +
      '&instantresponders[3]=1&field[%OPP_REASON_FOR_CLOSURE%,0]=' +
      opp.Reason_for_closure__c +
      '&instantresponders[3]=1&field[%LOAN_TERM%,0]=' +
      opp.Opp_Loan_Term__c +
      '&instantresponders[3]=1&field[%LOAN_TYPE%,0]=' +
      opp.Opp_Loan_Type__c +
      '&tags[0]=' +
      OpptStatus +
      '&tags[1]=' +
      oppClosure;

    return msg;
  } // end method
} //end class