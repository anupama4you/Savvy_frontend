global class batchActiveLeadCampaignCallout implements Database.Batchable<sObject>, Database.AllowsCallouts {
  List<Id> leadIdSet = new List<Id>();
  string dmlOperation;
  list<string> emailStrGrp = new List<string>();
  List<Lead__c> leads = new List<Lead__c>();
  Map<id, string> mapStsUpd = new Map<id, string>();
  global batchActiveLeadCampaignCallout(
    List<Id> leadId,
    List<string> emailAdd,
    string strOperation,
    List<Lead__c> leadObj,
    Map<id, string> leadStsUpdMap
  ) {
    leadIdSet = leadId;
    dmlOperation = strOperation;
    emailStrGrp = emailAdd;
    leads = leadObj;
    mapStsUpd = leadStsUpdMap;
  }
  public static void scheduleBatch(
    List<Id> leadId,
    List<string> emailAdd,
    string strOperation,
    List<Lead__c> leadObj,
    Map<id, string> leadStsUpdMap
  ) {
    batchActiveLeadCampaignCallout balcc = new batchActiveLeadCampaignCallout(
      leadId,
      emailAdd,
      strOperation,
      leadObj,
      leadStsUpdMap
    );
    system.scheduleBatch(
      balcc,
      'batchActiveLeadCampaignCallout' + DateTime.now().getTime(),
      180,
      2000
    );
  }
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return DataBase.getQueryLocator(
      [
        SELECT
          id,
          First_Name__c,
          Last_Name__c,
          Email_Address__c,
          Status__c,
          Reason_For_Closure__c,
          Date_of_Birth__c,
          Loan_Type__c,
          Finance_Amount__c,
          Home_Phone__c,
          Mobile_Number__c,
          Street_Address__c,
          Street_Type__c,
          Suburb__c,
          State__c,
          Postcode__c,
          Lead_Owner__c,
          Owner_Phone__c,
          Owner_Mobile__c,
          Owner_Email__c
        FROM Lead__c
        WHERE Id IN :leadIdSet
      ]
    );
  }

  global void execute(Database.BatchableContext BC, List<Lead__c> scope) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    if (!isOn) return;
    for (Lead__c ldObj : scope) {
      if (dmlOperation == 'insUpd') {
        system.debug('@@@scopr' + scope);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json'
        );

        req.setBody('Content-Type=application/x-www-form-urlencoded');

        req.setBody('Content-Length="512"');
        string statusUpdate = 'No';

        if (
          mapStsUpd.containsKey(ldObj.id) && mapStsUpd.get(ldObj.id) == 'Yes'
        ) {
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
        if (!Test.isRunningTest()) {
          Http http = new Http();
          response = http.send(req);
          System.debug('HttpRequest Response:' + response.getBody());
        }
      }
    }
  }

  global void finish(Database.BatchableContext BC) {
    if (dmlOperation == 'del') {
      Parameters_Service__c param = Parameters_Service__c.getInstance(
        'ActiveCampaign_Status'
      );
      Boolean isOn = param != null && 'ON'.equals(param.value__c);
      if (!isOn) return;
      for (string email : emailStrGrp) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_view_email&api_output=json'
        );

        string sendemail = 'email=' + email;

        req.setBody('Content-Type=application/x-www-form-urlencoded');

        req.setBody('Content-Length="512"');
        system.debug('@@stringEmail' + email);

        req.setBody(sendemail);

        HttpResponse response = null;
        if (!Test.isRunningTest()) {
          Http http = new Http();
          //response = http.send(req);
          //system.debug('@@@@@@@@@@@'+response);
          //system.debug('@@@@@@@@@@@'+response.getBody());

          string srg = response.getBody();
          system.debug('&&&&&srg&&&&' + srg);

          string srg1 = srg.substringAfter('id');

          system.debug('&&&&&&&&&' + srg1);
          Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(
            srg
          );

          system.debug('%%%%%%%%%%%%%%%%%' + m);
          Object acesstoken = m.get('id');
          system.debug('%%%%%%%%%acesstoken%%%%%%%%' + acesstoken);

          string xyz = (string) acesstoken;

          system.debug('@@xyz' + xyz);

          if (xyz != null) {
            HttpRequest reqDel = new HttpRequest();
            reqDel.setMethod('POST');
            reqDel.setEndpoint(
              'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_delete&api_output=json'
            );
            reqDel.setBody('Content-Type=application/x-www-form-urlencoded');

            reqDel.setBody('Content-Length="512"');
            string deleteId = 'id=' + xyz;
            reqDel.setBody(deleteId);

            HttpResponse responseDel = null;

            Http httpDel = new Http();
            //responseDel = httpDel.send(reqDel);
            //system.debug('@@@@@@@@@@@'+responseDel);
            //system.debug('@@@@@@@@@@@'+responseDel.getBody());
          }
        }
      }
    }
  }

  private static String ContactsXML(Lead__c ld, string isStatusUpd) {
    String msg = '';
    string leadStatus = string.valueOf(ld.Status__c);
    string leadClosure = string.valueOf(ld.Reason_for_closure__c);
    string leadDob = string.valueOf(ld.Date_of_Birth__c);
    string leadOwnerName;
    string leadOwnerEmail;
    string leadOwnerMobile;
    string leadOwnerPhone;
    string leadStatusUpd;

    system.debug('@@ld.Lead_Owner__c' + ld.Lead_Owner__c);

    if (ld.Lead_Owner__c == 'System Generated') {
      leadOwnerName = '';
    } else {
      leadOwnerName = ld.Lead_Owner__c;
    }

    if (ld.Owner_Email__c == 'systemgenerated@savvy.com.au') {
      leadOwnerEmail = '';
    } else {
      leadOwnerEmail = ld.Owner_Email__c;
    }

    if (ld.Owner_Mobile__c == '') {
      leadOwnerMobile = '';
    } else {
      leadOwnerMobile = ld.Owner_Mobile__c;
    }

    if (ld.Owner_Phone__c == '') {
      leadOwnerPhone = '';
    } else {
      leadOwnerPhone = ld.Owner_Phone__c;
    }
    if (ld.Status__c == ld.Status__c) {
      leadStatusUpd = '';
    } else {
      leadStatusUpd = leadStatus;
    }
    system.debug('####isStatusUpd' + isStatusUpd);

    msg +=
      'email=' +
      ld.Email_Address__c +
      '&first_name=' +
      ld.First_Name__c +
      '&last_name=' +
      ld.Last_Name__c +
      '&p[1]=1&instantresponders[1]=1&field[%REASON_FOR_CLOSURE%,0]=' +
      ld.Reason_for_closure__c +
      '&instantresponders[1]=1&field[%OWNER_NAME%,0]=' +
      leadOwnerName +
      '&instantresponders[1]=1&field[%OWNER_PHONE%,0]=' +
      leadOwnerPhone +
      '&instantresponders[1]=1&field[%OWNER_MOBILE%,0]=' +
      leadOwnerMobile +
      '&instantresponders[1]=1&field[%OWNER_EMAIL%,0]=' +
      LeadOwnerEmail +
      '&instantresponders[1]=1&field[%FINANCE_AMOUNT%,0]=' +
      ld.Finance_Amount__c +
      '&instantresponders[1]=1&field[%LOAN_TYPE%,0]=' +
      ld.Loan_Type__c +
      '&phone=' +
      ld.Home_Phone__c +
      '&instantresponders[1]=1&field[%Mobile%,0]=' +
      ld.Mobile_Number__c +
      '&instantresponders[1]=1&field[%STREET_ADDRESS%,0]=' +
      ld.Street_Address__c +
      '&instantresponders[1]=1&field[%STREET_TYPE%,0]=' +
      ld.Street_Type__c +
      '&instantresponders[1]=1&field[%SUBURB%,0]=' +
      ld.Suburb__c +
      '&instantresponders[1]=1&field[%STATE%,0]=' +
      ld.State__c +
      '&instantresponders[1]=1&field[%POSTCODE%,0]=' +
      ld.Postcode__c +
      '&tags[0]=' +
      leadStatus +
      '&tags[1]=' +
      leadStatus +
      '&tags[2]=' +
      leadClosure;

    if (isStatusUpd == 'Yes') {
      msg += '&instantresponders[1]=1&field[%Status%,0]=' + ld.Status__c;
    }
    return msg;
  }
}