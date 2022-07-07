global class queueActiveLeadDeleteCallout implements Queueable, Database.AllowsCallouts {
  list<string> emails = new List<String>();

  public queueActiveLeadDeleteCallout(list<string> emailStrGrp) {
    emails = emailStrGrp;
  }

  public void execute(QueueableContext context) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    for (string email : emails) {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setEndpoint(
        'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_view_email&api_output=json'
      );
      req.setMethod('GET');
      req.setBody('Content-Type=application/x-www-form-urlencoded');
      req.setBody('Content-Length="512"');

      req.setBody('email=' + email);
      if (isOn) {
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
        } else {
          HttpRequest reqDel = new HttpRequest();
          reqDel.setMethod('POST');
          reqDel.setEndpoint(
            'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_delete&api_output=json'
          );
          reqDel.setBody('Content-Type=application/x-www-form-urlencoded');
          reqDel.setBody('Content-Length="512"');
          HttpResponse responseDel = null;
          Http httpDel = new Http();

          Map<String, Object> m = null;

          try {
            m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
          } catch (Exception e) {
          }

          if (m != null) {
            reqDel.setBody('id=' + string.valueOf(m.get('id')));
            responseDel = httpDel.send(reqDel);
          } //end if
        } //end else
      }
    } // end loop
  } //end execute
} //end class