public with sharing class DisplayStaffPartnerContactsExtension {
  // List of PartnerContacts user class
  public List<User> contactList = new List<User>();
  public List<PartnersContact__c> partnerContactList = new List<PartnersContact__c>();

  public Map<String, List<User>> mapStaffContacts = new Map<String, List<User>>();
  public Map<String, List<PartnersContact__c>> mapPartnerContacts = new Map<String, List<PartnersContact__c>>();

  public String searchContact { get; set; }
  public Boolean isShowForm { get; set; }
  public PartnersContact__c objPartner { get; set; }

  public Id recordId { get; set; }

  public List<User> getContactList() {
    return contactList;
  }

  /**
   * Get contact list
   * */
  public List<PartnersContact__c> getPartnerContactList() {
    return partnerContactList;
  }

  public Map<String, List<PartnersContact__c>> getMapPartnerContacts() {
    return mapPartnerContacts;
  }

  public Map<String, List<User>> getMapStaffContacts() {
    return mapStaffContacts;
  }

  /**
   * Constructor
   * */
  public DisplayStaffPartnerContactsExtension() {
    loadForm();
    loadPartners();
    loadConsultants();
  }

  /**
   * Get contact list size.
   * */
  public Integer getSizeList() {
    try {
      return contactList.size();
    } catch (Exception e) {
      System.debug('Error list ::: ' + e.getStackTraceString());
      return 0;
    }
  }

  /**
   * Reload form for each refresh
   * */
  public void loadForm() {
    isShowForm = false;
    // String idPartner = System.currentPageReference().getParameters().get('ID');
    System.debug('Record ID: ' + this.recordId);
    if (this.recordId != null) {
      objPartner = [
        SELECT
          name,
          department__c,
          contact__c,
          title__c,
          phone__c,
          email__c,
          description__c
        FROM PartnersContact__c
        WHERE id = :this.recordId
      ];
      isShowForm = true;
    }
  }

  /**
   * New record
   * */
  public PageReference newPartner() {
    isShowForm = true;
    objPartner = new PartnersContact__c();
    return null;
  }

  /**
   * Delete record
   * */
  public PageReference deletePartner() {
    if (objPartner != null && objPartner.Id != null) {
      delete objPartner;
      ApexPages.addMessage(
        new ApexPages.message(
          ApexPages.Severity.INFO,
          'The record has been deleted'
        )
      );
      loadPartners();
      isShowForm = false;
      objPartner = null;
    }
    return null;
  }

  /**
   * Cancel action
   * */
  public PageReference cancel() {
    isShowForm = false;
    objPartner = null;
    return null;
  }

  /**
   * Save data
   * */
  public PageReference save() {
    if (isFormValid()) {
      upsert objPartner;
      ApexPages.addMessage(
        new ApexPages.message(
          ApexPages.Severity.INFO,
          'The record has been saved'
        )
      );
      loadPartners();
      isShowForm = false;
      objPartner = null;
    }
    return null;
  }

  /**
   * Validate data
   * */
  private Boolean isFormValid() {
    if (String.isBlank(objPartner.name)) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please fill partner name.'
        )
      );
      return false;
    }
    if (
      String.isBlank(objPartner.department__c) &&
      String.isBlank(objPartner.contact__c) &&
      String.isBlank(objPartner.title__c) &&
      String.isBlank(objPartner.email__c) &&
      String.isBlank(objPartner.description__c)
    ) {
      ApexPages.addMessage(
        new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'Please fill some fields.'
        )
      );
      return false;
    }
    return true;
  }

  /**
   * Cancel search
   **/
  public PageReference cancelSearchConsultants() {
    searchContact = null;
    loadConsultants();
    return null;
  }

  /**
   * Load data staff contacts
   * */
  public PageReference loadConsultants() {
    System.debug('loadConsultants...');
    contactList.clear();
    mapStaffContacts.clear();
    if (searchContact != null) {
      String likeSearch = searchContact.replace('*', '%') + '%';
      contactList = [
        SELECT name, extension, phone, mobilephone, email, timezonesidkey, title
        FROM user
        WHERE isActive = TRUE AND name LIKE :likeSearch
        ORDER BY timezonesidkey DESC, name ASC
      ];
    } else {
      contactList = [
        SELECT name, extension, phone, mobilephone, email, timezonesidkey, title
        FROM user
        WHERE isActive = TRUE
        ORDER BY timezonesidkey DESC, name ASC
      ];
    }
    System.debug('Total list consultants >> ' + contactList.size());

    for (User u : contactList) {
      if (mapStaffContacts.get(u.timezonesidkey) != null) {
        mapStaffContacts.get(u.timezonesidkey).add(u);
      } else {
        List<User> c = new List<User>();
        c.add(u);
        mapStaffContacts.put(u.timezonesidkey, c);
      }
    }
    return null;
  }

  /**
   * Load data Partner contacts
   * */
  public PageReference loadPartners() {
    System.debug('loadPartners...');
    mapPartnerContacts.clear();
    partnerContactList = [
      SELECT
        name,
        department__c,
        contact__c,
        title__c,
        phone__c,
        email__c,
        description__c
      FROM PartnersContact__c
      ORDER BY name, department__c, contact__c
    ];
    System.debug('Total list partner >>' + partnerContactList.size());

    for (PartnersContact__c p : partnerContactList) {
      if (mapPartnerContacts.get(p.name) != null) {
        mapPartnerContacts.get(p.name).add(p);
      } else {
        List<PartnersContact__c> partnerList = new List<PartnersContact__c>();
        partnerList.add(p);
        mapPartnerContacts.put(p.name, partnerList);
      }
    }

    return null;
  }

  public Boolean getIsBrokerPartnerUser() {
    return SOQLSingletonQueries.recs().isBrokerPartnerUser;
  }
}