global class queueActiveSmallLoanLeadCallout implements Queueable, Database.AllowsCallouts {

  private static final String API_KEY = '0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898';
  private static final String LISTID = '30';

  List<Lead__c> ldUpdLst = new List<Lead__c>();

  public queueActiveSmallLoanLeadCallout(List<Lead__c> ldLists) {
    ldUpdLst = ldLists;
  }

  public void execute(QueueableContext context) {
    for (Lead__c ldObj : ldUpdLst) {
      HttpRequest req2 = new HttpRequest();
      req2.setMethod('POST');
      req2.setEndpoint(
        'https://savvyfinance.api-us1.com/admin/api.php?api_key=' + API_KEY + '&api_action=contact_sync&api_output=json'
      );

      req2.setBody('Content-Type=application/x-www-form-urlencoded');
      req2.setBody('Content-Length="512"');
      req2.setBody(makeContactXML(ldObj));
      req2.setTimeout(40000);
      HttpResponse response2 = null;
      Http http2 = new Http();
      if (!Test.isRunningTest()) {
        response2 = http2.send(req2);
        system.debug(response2.getBody());
      }

      executeAddContactTransmitSMS(ldObj);

    } //end for
  }

  private static String makeContactXML(Lead__c ld) {
    String msg = '';
    msg = 'email=' + ld.Email_Address__c;
    msg += '&first_name=' + ld.First_Name__c;
    msg += '&last_name=' + ld.Last_Name__c;
    msg += '&phone=' + ld.Mobile_Number__c;
    msg += '&p[' + LISTID + ']=' + LISTID;
    return msg;
  } // end method

  private void executeAddContactTransmitSMS(Lead__c lead) {
    Parameters_Service__c param =  Parameters_Service__c.getInstance('TransmitSMS_Status');
    Boolean isOn = param !=null && 'ON'.equals(param.value__c);
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
      mobile = mobile.replaceAll('\\+','');
      mobile = mobile.replaceAll('\\s','');
    }
    String msg = '';
    msg = 'list_id=' + Parameters_Service__c.getInstance('TransmitSMS_ListID').value__c;
    msg += '&first_name=' + ld.First_Name__c;
    msg += '&last_name=' + ld.Last_Name__c;
    msg += '&msisdn=' + mobile;
    msg += '&countrycode=au';
    msg += '&field_1=' + ld.Email_Address__c;
    return msg;
  } // en

}