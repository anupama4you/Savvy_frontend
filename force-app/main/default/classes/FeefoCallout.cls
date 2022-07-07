public without sharing class FeefoCallout {
    
  @future (callout=true)
  public static void makeFeefoCallout (Set<id> oppCallout) {

    List<Custom_Opportunity__c> oppList = [
      SELECT 
        id,Name,Email_Address__c,Date_Closed_or_Settled__c,Opp_Loan_Type__c,
        Finance_Amount__c,Loan_Product__c, Loan_Product__r.Loan_Type__c, 
        Loan_Product__r.Quoting_Source__c, Opp_Asset_Type__c,
        Lead__r.Loan_Type__c, Application__r.Type_Of_Asset__c,
        Lead__r.Loan_For__c, Application__r.Loan_For__c, Mobile_Number__c,
        Account_First_Name__c, Account_Last_Name__c, Status__c, 
        International_Number__c,Application__r.First_Name__c, 
        Application__r.Last_Name__c, Owner_Name__c,
        First_Name__c, Last_Name__c, OwnerId, Partner_Is_External__c
      FROM Custom_Opportunity__c 
      WHERE Id in :oppCallout
    ];
    System.debug('Total opps: ' + oppList.size());
    for (Custom_Opportunity__c opp : oppList) {
      if (!opp.Partner_Is_External__c) {
        String revProvider = 'Feefo';
        if ('Settled'.equals(opp.Status__c)) {
          revProvider = distributeReview();
        }
        
        if (!'Feefo'.equals(revProvider)) {
          createSMS(opp, revProvider);
          createTaskNotification(opp, revProvider);
        } else {
          // Make the message to send
          String apiKey = 'eda91900-b9e2-48ff-870d-86259449703a';            
          String merchantIdentifier = 'savvy';
          if ('Closed Opportunity'.equals(opp.Status__c)) {
              merchantIdentifier = 'savvy-new-co';
              apiKey = '87b40695-94d2-426b-a3fe-10f1b56478d9';
          }
          apiKey = EncodingUtil.urlEncode(apiKey, 'ASCII');
          System.debug('encoded apiKey: ' + apiKey);
          merchantIdentifier = EncodingUtil.urlEncode(merchantIdentifier, 'ASCII');
          System.debug('encoded merchantIdentifier: ' + merchantIdentifier);
          
          String feefoEmail = opp.Email_Address__c;
          feefoEmail = EncodingUtil.urlEncode(feefoEmail, 'ASCII');
          System.debug('encoded feefoEmail: ' + feefoEmail);
          
          String feefoName = getOppFullName(opp);
          feefoName = EncodingUtil.urlEncode(feefoName, 'ASCII');
          System.debug('encoded feefoName: ' + feefoName);
          
          Date settledDate = date.newInstance(opp.Date_Closed_or_Settled__c.year(), opp.Date_Closed_or_Settled__c.month(), opp.Date_Closed_or_Settled__c.day());
          String feefoDate = String.valueOf(settledDate);
          //String feefoDate = String.valueOf(opp.Date_Closed_or_Settled__c);
          feefoDate = EncodingUtil.urlEncode(feefoDate, 'ASCII');
          System.debug('encoded feefoDate: ' + feefoDate);
          
          String description = getProductSearchCode(opp);                              //String description = opp.Opp_Loan_Type__c;
          //String description = '';
          description = EncodingUtil.urlEncode(description, 'ASCII');
          System.debug('encoded description: ' + description);
          
          String productSearchcode = getProductSearchCode(opp);                        //String productSearchcode = opp.Opp_Loan_Type__c;
          productSearchcode = EncodingUtil.urlEncode(productSearchcode, 'ASCII');
          System.debug('encoded productSearchcode: ' + productSearchcode);
          
          String orderRef = opp.Id;
          orderRef = EncodingUtil.urlEncode(orderRef, 'ASCII');
          System.debug('encoded orderRef: ' + orderRef);
          
          String amount = String.valueOf(opp.Finance_Amount__c);
          amount = EncodingUtil.urlEncode(amount, 'ASCII');
          System.debug('encoded amount: ' + amount);
          
          String feedbackDate = String.valueOf(date.today());
          //String feedbackDate = String.valueOf(datetime.now());
          feedbackDate = EncodingUtil.urlEncode(feedbackDate, 'ASCII');
          System.debug('encoded feedbackDate: ' + feedbackDate);
          
          String tag = 'service=' + getProductSearchCode(opp).toUpperCase();                              //String description = opp.Opp_Loan_Type__c;
          String advisor = 'advisor=' + opp.Owner_Name__c;
          tag = EncodingUtil.urlEncode(tag, 'ASCII');
          advisor = EncodingUtil.urlEncode(advisor, 'ASCII');
          tag = '[' + tag + ',' + advisor + ']';
          String msg = null;
          if ('Closed Opportunity'.equals(opp.Status__c)) {
          //    String campaign = 'campaign=Closed Opportunities';
          //    campaign = EncodingUtil.urlEncode(campaign, 'ASCII');
          //    tag = '[' + tag + ',' + advisor + ',' +  campaign + ']';
              String feefoMobile = '+'+opp.International_Number__c;
              //String feefoMobile = opp.Mobile_Number__c;
              feefoMobile = EncodingUtil.urlEncode(feefoMobile, 'ASCII');
              System.debug('encoded feefoMobile: ' + feefoMobile);
              msg = 'apikey='+apiKey+'&merchantidentifier='+merchantIdentifier+'&email='+feefoEmail+'&mobile='+feefoMobile+'&name='+feefoName+'&date='+feefoDate+'&feedbackdate='+feedbackDate+'&description='+description+'&productsearchcode='+productSearchcode+'&amount='+amount+'&orderref='+orderRef+'&tag='+tag;
          } else {
              msg = 'apikey='+apiKey+'&merchantidentifier='+merchantIdentifier+'&email='+feefoEmail+'&name='+feefoName+'&date='+feefoDate+'&feedbackdate='+feedbackDate+'&description='+description+'&productsearchcode='+productSearchcode+'&amount='+amount+'&orderref='+orderRef+'&tag='+tag;
          }
          System.debug('encoded tag: ' + tag);

          //String msg = 'apikey='+apiKey+'&merchantidentifier='+merchantIdentifier+'&email='+feefoEmail+'&name='+feefoName+'&date='+feefoDate+'&feedbackdate='+feedbackDate+'&description='+description+'&productsearchcode='+productSearchcode+'&amount='+amount+'&orderref='+orderRef+'&tag='+tag;
          System.debug('The message is: ' + msg);
          
          Http http = new Http();
          HttpRequest req = new HttpRequest();
          req.setEndpoint('https://admin.feefo.com/api/entersaleremotely');
          req.setMethod('POST');
          req.setBody(msg);
          
          System.debug('HttpRequest :' +req);
          System.debug('HttpRequest :' +req.getBody());
          System.debug('HttpRequest :' +req.getHeader('Authorization'));
          
          HttpResponse res = http.send(req);
          
          System.debug('HttpRequest Response:' +res.getBody());
          System.debug('HttpRequest Status Code:' +res.getStatusCode());
          System.debug('HttpRequest Status:' +res.getStatus());

          if ('Settled'.equals(opp.Status__c)) {
            createTaskNotification(opp, 'Feefo');
          }

        }
      }
    } //end for loop
  } // end method

  public static String getProductSearchCode(Custom_Opportunity__c o) {
    String r = '';
    if (o != null) {
      if (
        'Bad Credit Car Loan'.equals(o.Lead__r.Loan_Type__c) ||
        'Personal Loan'.equals(o.Lead__r.Loan_Type__c) ||
        'Car Loan'.equals(o.Lead__r.Loan_Type__c) ||
        'Chattel Mortgage'.equals(o.Lead__r.Loan_Type__c) ||
        'Home Loan'.equals(o.Lead__r.Loan_Type__c)
      ) {
        r = o.Lead__r.Loan_Type__c;
      } else if ('Leisure Loan'.equals(o.Lead__r.Loan_Type__c)) {
        r = o.Lead__r.Loan_For__c + ' Loan';
        if (String.isNotBlank(o.Opp_Asset_Type__c)) {
          if ('Marine'.equals(o.Opp_Asset_Type__c)) {
            r = 'Boat Loan';
          } 
        }
      } else if (String.isNotBlank(o.Opp_Asset_Type__c)) {
        if ('Marine'.equals(o.Opp_Asset_Type__c)) {
          r = 'Boat Loan';
        } else if ('Motorcycle'.equals(o.Opp_Asset_Type__c)) {
          r = 'Bike Loan';
        } else {
          r = o.Opp_Asset_Type__c + ' Loan';
        }
      } else if (String.isNotBlank(o.Application__r.Type_Of_Asset__c)) {
        if ('JetSki'.equalsIgnoreCase(o.Application__r.Type_Of_Asset__c)) {
          r = 'Boat Loan';
        } else {
          r = o.Application__r.Type_Of_Asset__c + ' Loan';
        }
      }
    }
    return r;
  }

  private static String getOppFullName(Custom_Opportunity__c o) {
    String r = '';
    if (o != null) {
      // Get First name
      if (String.isNotBlank(o.Application__r.First_Name__c)) {
        r = o.Application__r.First_Name__c;
      } else if (String.isNotBlank(o.First_Name__c)) {
        r = o.First_Name__c;
      } else if (String.isNotBlank(o.Account_First_Name__c)) {
        r = o.Account_First_Name__c;
      }
      // Get Last name
      if (String.isNotBlank(o.Application__r.Last_Name__c)) {
        r += ' ' + o.Application__r.Last_Name__c;
      } else if (String.isNotBlank(o.Last_Name__c)) {
        r += ' ' + o.Last_Name__c;
      } else if (String.isNotBlank(o.Account_Last_Name__c)) {
        r += ' ' + o.Account_Last_Name__c;
      }
      // Get Opportunity name
      if (String.isBlank(r)) {
        r = o.Name;
      }
    }
    return r;
  }

  public static String distributeReview() {
    String r = 'Feefo';
    Parameters_Service__c p = Parameters_Service__c.getInstance('Settled_Reviews_Distribution_Status');
    Boolean isActive = p != null && 'ON'.equalsIgnoreCase(p.value__c);
    Map<String, Integer> providers = new Map<String, Integer>();
    for (String pr : getProviders()) {
      providers.put(pr, 0);
    }
    
    if (isActive) {
      List<AggregateResult> d = [
        SELECT Reviewer__c, Count(Id) TOTAL
        FROM Task
        WHERE CreatedDate >= :p.Datetime_Value__c
        AND Type = 'Review Notification'
        GROUP BY Reviewer__c
      ];
      Integer totalFeefo = 0;
      Integer totalOthers = 0;
      for (AggregateResult a: d) {
        String rev = (String)a.get('Reviewer__c');
        Integer totalRevs = (Integer)a.get('TOTAL');
        providers.put(rev, totalRevs);
        if ('Feefo'.equals(rev)) {
          totalFeefo = totalRevs;
        } else {
          totalOthers += totalRevs;
        }
      }
      p = Parameters_Service__c.getInstance('Settled_Reviews_Distribution_Percen');
      Decimal perc = p == null? 50.0 : (100 - Decimal.valueOf(p.value__c));
      Decimal total = totalFeefo + totalOthers;
      if ((perc == 0.0) || (total > 0 && (totalFeefo/total) * 100 > perc)) {
        // Distribute
        String nextRev = null;
        for (String pr: providers.keySet()) {
          if (!'Feefo'.equals(pr)) {
            nextRev = String.isBlank(nextRev) || providers.get(pr) < providers.get(nextRev)? pr : nextRev;
          }
        }
        r = nextRev;
      }
      System.debug('@@perc: [' + r + '] ' + perc + '| total: ' + total + '| totalFeefo: ' + totalFeefo + '| totalOthers: ' + totalOthers + '| feefo perc: ' + (totalFeefo/total) * 100);
    }
    System.debug('@@Distribute lead: ' + r);
    return r;
  }

  public static void createTaskNotification(Custom_Opportunity__c opp, String provider) {
    Task a = new Task();
    a.OwnerId = opp.OwnerId;
    a.WhatId = opp.Id;
    a.Subject = provider + ' Review Notification';
    a.Status = 'Completed';
    a.Priority = 'Low';
    a.Description = 'Notification sent to the customer for a review';
    a.Type = 'Review Notification';
    a.Reviewer__c = provider;
    // a.ActivityDate = task.dueDate;

    a.TaskSubtype = 'Task';
    a.IsReminderSet = false;

    insert a;

    System.debug('@@Task created: ' + provider + ' | ' + a.Id);
  }

  public static void createSMS(Custom_Opportunity__c opp, String provider) {
    List<smagicinteract__smsMagic__c>  smsObjectList = new List<smagicinteract__smsMagic__c>();
    String senderId = getSenderId(); // Please replace the 'smsMagic' with your relevant sender ID.
    // String templateText = opp.First_Name__c + ', thanks for choosing Savvy for your finance. ' +
    //   'Please write a review about your experience. It only takes a minute! ' +
    //   'https://go.savvy.com.au/3sUbBFr'; // you can fetch the template text by querying the record on smagicinteract__SMS_Template__c object
    String templateText = System.Label.SMS_Settled_Opp_Notification;
    if ('Google'.equals(provider)) {
      templateText = System.Label.SMS_Settled_Google_Review;
    }
    templateText = templateText.replace(
      '{FIRST_NAME}', 
      String.isNotBlank(opp.First_Name__c)
        ? opp.First_Name__c : '');
    smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
    
    smsObject.smagicinteract__SenderId__c = senderId;
    smsObject.smagicinteract__PhoneNumber__c = opp.Mobile_Number__c;
    smsObject.smagicinteract__Name__c = opp.Name; // records name
    smsObject.smagicinteract__ObjectType__c = 'Custom_Opportunity__c'; // record type
    smsObject.Custom_Opportunity__c = opp.Id;
    smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
    smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
    smsObject.smagicinteract__SMSText__c = templateText;
    smsObjectList.add(smsObject);

    Database.insert(smsObjectList, false);
  }

  public static String getSenderId() {
    List<smagicinteract__SMS_SenderId__c> d = [
      SELECT Id, name, smagicinteract__senderId__c
      FROM smagicinteract__SMS_SenderId__c
      ORDER BY CreatedDate DESC LIMIT 1
    ];
    return !d.isEmpty() ? d.get(0).smagicinteract__senderId__c : null;
  }

  public static Set<String> getProviders(){
    Set<String> r = new Set<String>();
    Schema.DescribeFieldResult fieldResult = Task.Reviewer__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry f : ple) {
      r.add(f.getValue());
    }
    return r;
  }
}