global class batchActiveOppCampaignCallout implements Database.Batchable<sObject>, Database.AllowsCallouts {
  List<Id> OppIdSet = new List<Id>();
  string dmlOperation;
  Map<id, string> mapStsUpd = new Map<id, string>();
  global batchActiveOppCampaignCallout(
    List<Id> OppId,
    string strOperation,
    Map<id, string> OppStsUpdMap
  ) {
    OppIdSet = OppId;
    dmlOperation = strOperation;
    mapStsUpd = OppStsUpdMap;
  }
  public static void scheduleBatch(
    List<Id> OppId,
    string strOperation,
    Map<Id, string> OppStsUpdMap
  ) {
    scheduleBatch(OppId, strOperation, OppStsUpdMap, 180, 2000);
  }
  public static void scheduleBatch(
    List<Id> OppId,
    string strOperation,
    Map<Id, string> OppStsUpdMap,
    Integer minutesFromNow,
    Integer scopeSize
  ) {
    batchActiveOppCampaignCallout baocc = new batchActiveOppCampaignCallout(
      OppId,
      strOperation,
      OppStsUpdMap
    );
    String cronID = system.scheduleBatch(
      baocc,
      'batchActiveOppCampaignCallout' + DateTime.now().getTime(),
      minutesFromNow,
      scopeSize
    );
    CronTrigger ct = [
      SELECT Id, TimesTriggered, NextFireTime, State
      FROM CronTrigger
      WHERE Id = :cronID
    ];
    System.debug(
      'Job scheduled, next fire >> ' +
      ct.NextFireTime +
      ' | ' +
      cronID +
      ' | ' +
      ct.State
    );
  }
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return DataBase.getQueryLocator(
      [
        SELECT
          id,
          Account_First_Name__c,
          Email_Address__c,
          Status__c,
          Reason_for_closure__c,
          Mobile_Number__c,
          Opp_Loan_Term__c,
          Opp_Loan_Type__c,
          State__c,
          Owner_Name__c,
          Owner_Email__c,
          Owner_Mobile__c,
          Owner_Phone__c
        FROM Custom_Opportunity__c
        WHERE Id IN :OppIdSet AND Owner_Name__c != 'Home Loans'
      ]
    );
  }

  global void execute(
    Database.BatchableContext BC,
    List<Custom_Opportunity__c> scope
  ) {
    Parameters_Service__c param = Parameters_Service__c.getInstance(
      'ActiveCampaign_Status'
    );
    Boolean isOn = param != null && 'ON'.equals(param.value__c);
    if (!isOn) return;
    for (Custom_Opportunity__c oppObj : scope) {
      if (dmlOperation == 'insUpd') {
        system.debug('@@@scopr' + scope);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_sync&api_output=json'
        );

        JSONGenerator gen = JSON.createGenerator(true);
        Integer[] P = new List<Integer>();

        gen.writeStartArray();

        gen.writeStartObject();

        gen.writeEndObject();

        // close the JSON generator
        gen.writeEndArray();

        String jsonOrders = gen.getAsString();
        // debugging call, which you can check in debug logs
        System.debug('jsonOrders: ' + jsonOrders);

        // req.setBody(jsonOrders);
        req.setBody('Content-Type=application/x-www-form-urlencoded');

        //string targetString='email=visu@g.com&first_name=Vishnu&last_name=Vardhan&p[3]=3&organization=PeterElben';
        //targetString = EncodingUtil.URLENCODE(targetString,'UTF-8');
        req.setBody('Content-Length="512"');
        String statusUpdate;

        if (
          mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'Yes'
        ) {
          statusUpdate = 'Yes';
        } else if (
          mapStsUpd.containsKey(oppObj.id) && mapStsUpd.get(oppObj.id) == 'No'
        ) {
          statusUpdate = 'No';
        }

        system.debug('####statusUpdate' + statusUpdate);
        req.setBody(opportunityXML(oppObj, statusUpdate));
        System.debug('HttpRequest :' + req);
        System.debug('HttpRequest :' + req.getBody());
        System.debug('HttpRequest :' + req.getHeader('Authorization'));
        HttpResponse response = null;
        if (!Test.isRunningTest()) {
          Http http = new Http();
          response = http.send(req);
          system.debug('@@@@@@@@@@@' + response);
          system.debug('@@@@@@@@@@@' + response.getBody());
        }
      } else if (dmlOperation == 'del') {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(
          'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_delete&api_output=json'
        );

        req.setBody('Content-Type=application/x-www-form-urlencoded');

        req.setBody('Content-Length="512"');
        req.setBody(oppObj.id);

        HttpResponse response = null;
        if (!Test.isRunningTest()) {
          Http http = new Http();
          response = http.send(req);
          system.debug('@@@@@@@@@@@' + response);
          system.debug('@@@@@@@@@@@' + response.getBody());
        }
      }
    }
  }

  global void finish(Database.BatchableContext BC) {
  }

  private static String opportunityXML(
    Custom_Opportunity__c opp,
    string isStatusUpd
  ) {
    String msg = '';
    string oppStatus = string.valueOf(opp.Status__c);
    string oppClosure = string.valueOf(opp.Reason_for_closure__c);
    string oppLoanTerm = string.valueOf(opp.Opp_Loan_Term__c);
    string OwnerName;
    string OwnerEmail;
    string OwnerMobile;
    string OwnerPhone;
    string oppStatusUpd;

    if (opp.Owner_Name__c == 'System Generated') {
      OwnerName = '';
    } else {
      OwnerName = opp.Owner_Name__c;
    }
    if (opp.Owner_Email__c == 'systemgenerated@savvy.com.au') {
      OwnerEmail = '';
    } else {
      OwnerEmail = opp.Owner_Email__c;
    }
    if (opp.Owner_Mobile__c == '') {
      OwnerMobile = '';
    } else {
      OwnerMobile = opp.Owner_Mobile__c;
    }
    if (opp.Owner_Phone__c == '') {
      OwnerPhone = '';
    } else {
      OwnerPhone = opp.Owner_Phone__c;
    }
    if (opp.Status__c == opp.status__c) {
      oppStatusUpd = '';
    } else {
      oppstatusUpd = oppStatus;
    }

    msg +=
      'email=' +
      opp.Email_Address__c +
      '&First_Name=' +
      opp.Account_First_Name__c +
      '&p[3]=3&instantresponders[3]=1&field[%OPP_STATUS%,0]=' +
      opp.Status__c +
      '&instantresponders[3]=1&field[%STATE%,0]=' +
      opp.State__c +
      '&instantresponders[3]=1&field[%OWNER_NAME%,0]=' +
      OwnerName +
      '&instantresponders[3]=1&field[%OWNER_EMAIL%,0]=' +
      OwnerEmail +
      '&instantresponders[3]=1&field[%OWNER_MOBILE%,0]=' +
      OwnerMobile +
      '&instantresponders[3]=1&field[%OWNER_PHONE%,0]=' +
      OwnerPhone +
      '&instantresponders[3]=1&field[%OPP_REASON_FOR_CLOSURE%,0]=' +
      opp.Reason_for_closure__c +
      '&instantresponders[3]=1&field[%LOAN_TERM%,0]=' +
      opp.Opp_Loan_Term__c +
      '&instantresponders[3]=1&field[%LOAN_TYPE%,0]=' +
      opp.Opp_Loan_Type__c +
      '&tags[0]=' +
      oppStatus +
      '&tags[1]=' +
      oppClosure;

    if (isStatusUpd == 'Yes') {
      msg += '&instantresponders[3]=1&field[%OPP_STATUS%,0]=' + opp.Status__c;
    }

    return msg;
  }
}