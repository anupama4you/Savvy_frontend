public class Portal_Lead_AttemptController {
  public Lead__c LeadVal { get; set; }
  public Boolean getisAttemp1() {
    Lead__c var = [SELECT Status__c FROM Lead__c WHERE id = :LeadVal.Id];
    return (var.Status__c == 'Attempted Contact 1');
  }
  public Boolean getisAttemp2() {
    Lead__c var = [SELECT Status__c FROM Lead__c WHERE id = :LeadVal.Id];
    return (var.Status__c == 'Attempted Contact 2');
  }
  public Boolean getisAttemp3() {
    Lead__c var = [SELECT Status__c FROM Lead__c WHERE id = :LeadVal.Id];
    return (var.Status__c == 'Attempted Contact 3');
  }
  public Boolean getisAttemp4() {
    Lead__c var = [SELECT Status__c FROM Lead__c WHERE id = :LeadVal.Id];
    return (var.Status__c == 'Attempted Contact 4');
  }
  public Boolean getisAttemp5() {
    Lead__c var = [SELECT Status__c FROM Lead__c WHERE id = :LeadVal.Id];
    return (var.Status__c == 'Attempted Contact 5');
  }
  public User getUserVar() {
    List<User> userList;
    //userList = [SELECT Id, FirstName, LastName, Email, Phone, MobilePhone FROM User WHERE Id = '005N000000ACtxMIAT' limit 1];
    userList = [
      SELECT Id, FirstName, LastName, Email, Phone, MobilePhone, Title
      FROM User
      WHERE Id = :UserInfo.getUserId()
      LIMIT 1
    ];
    return userList[0];
  }
  public Contact getContactVar() {
    return SOQLSingletonQueries.recs().myContact;
  }
  public Account getAccountVar() {
    Id accountId = SOQLSingletonQueries.recs().myAccountId;
    List<Account> accountList = new List<Account>();
    if (accountId != null) {
      accountList = [
        SELECT
          Id,
          Name,
          Fax,
          Phone,
          BillingStreet,
          BillingCity,
          BillingCountry,
          BillingState,
          BillingPostalCode,
          Website,
          PersonMobilePhone,
          Business_Name__c,
          Business_Logo__c,
          Business_Address__c,
          Business_Website__c
        FROM Account
        WHERE Id = :accountId
        LIMIT 1
      ];
    }
    return (accountList != null && !accountList.isEmpty())
      ? accountList[0] : null;
  }
}