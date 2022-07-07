global class batchActiveLeadTagCallout implements Database.Batchable<sObject>, Database.AllowsCallouts {
  List<Id> leadIdSet = new List<Id>();
  string dmlOperation;
  list<string> emailStrGrp = new List<string>();
  List<Lead__c> ldUpdLst = new List<Lead__c>();
  Map<Id, string> mapStatusToId = new Map<Id, String>();
  global batchActiveLeadTagCallout(
    List<Id> leadId,
    List<string> emailAdd,
    string strOperation,
    List<Lead__c> ldLists,
    Map<Id, string> StatusToIdUpdMap
  ) {
    leadIdSet = leadId;
    dmlOperation = strOperation;
    emailStrGrp = emailAdd;
    ldUpdLst = ldLists;
    mapStatusToId = StatusToIdUpdMap;
  }

  public static void scheduleBatch(
    List<Id> leadId,
    List<string> emailAdd,
    string strOperation,
    List<Lead__c> ldLists,
    Map<Id, string> StatusToIdUpdMap
  ) {
    batchActiveLeadTagCallout baltc = new batchActiveLeadTagCallout(
      leadId,
      emailAdd,
      strOperation,
      ldLists,
      StatusToIdUpdMap
    );
    system.scheduleBatch(
      baltc,
      'batchActiveLeadTagCallout' + DateTime.now().getTime(),
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
          Reason_for_closure__c
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
      if (
        mapStatusToId.containsKey(ldObj.id) &&
        mapStatusToId.get(ldObj.id) == 'Yes'
      ) {
        if (dmlOperation == 'insUpd') {
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

          for (string strStatus : statusStr) {
            system.debug('@@@scopr' + scope);
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');

            req.setEndpoint(
              'https://savvyfinance.api-us1.com/admin/api.php?api_key=0ac95604b0ced09c5d5e74573781baa559d134a0320035a15b1adb9da828a267be5b8898&api_action=contact_tag_remove&api_output=json'
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

            req.setBody('Content-Length="512"');
            req.setBody(ContactsTagDelXML(ldObj, strStatus));
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
          }
        }
      }
    }
  }

  global void finish(Database.BatchableContext BC) {
    system.debug('@@@@EnteredtobatchActiveLeadCampaignCallout');

    Database.executeBatch(
      new batchActiveLeadCampaignCallout(
        leadIdSet,
        emailStrGrp,
        dmlOperation,
        ldUpdLst,
        mapStatusToId
      ),
      2000
    );
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
  }
}