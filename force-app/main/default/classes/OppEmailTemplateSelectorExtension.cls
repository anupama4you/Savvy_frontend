public class OppEmailTemplateSelectorExtension {
    
    public List<String> APPLYFORM_OPTIONS = new List<String>{'apply-now','car-loans/application','leisure-finance/application',
                'commercial-finance/application', 'personal-loans/application','home-loans/application'};

    public String selectedTemplateId { public get; public set; }

    public List<SelectOption> myPersonalTemplateOptions {public get; public set;}
    public boolean showerror{get; set;}
    public Custom_Opportunity__c Opp;
    public Custom_Opportunity__c emailOpp;
    
    public List<SelectOption> documentList{public get;public set;}
    public List<String> selectedDocuments = new List<String>();
    public List<String> getselectedDocuments(){
        return selectedDocuments;
    }
    public void setselectedDocuments(List<String> selectedDocuments){
        this.selectedDocuments = selectedDocuments;
    }
    public OppEmailTemplateSelectorExtension (ApexPages.StandardController controller) {
        
        this.Opp = (Custom_Opportunity__c)controller.getRecord ();
        emailOpp = [SELECT Id,Name,Email_Address__c FROM Custom_Opportunity__c WHERE Id =: Opp.Id];
        List<SelectOption> options = new List<SelectOption>();
        for (EmailTemplate t : [
            select Id,Name 
            from EmailTemplate
            // Each User has a 'My Personal Templates' folder
            // of EmailTemplates, whose Id is the User's Id
            where Folder.Name = 'Opp Manual Emails' Order By Name ASC
        ]) {
            options.add(new SelectOption(t.Id,t.Name));
        }
        myPersonalTemplateOptions = options;

        // Set Web App form
        // if (this.Opp.Lead__c != null && String.isNotBlank(this.Opp.Lead__r.Loan_Type__c)) {
        //     if (this.Opp.Lead__r.Loan_Type__c.contains('Car Loan')) {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[1];
        //     } else if ('Leisure Loan'.equals(this.Opp.Lead__r.Loan_Type__c)) {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[2];
        //     } else if ('Commercial Loan'.equals(this.Opp.Lead__r.Loan_Type__c)) {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[3];
        //     } else if ('Personal Loan'.equals(this.Opp.Lead__r.Loan_Type__c)) {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[4];
        //     } else if ('Home Loan'.equals(this.Opp.Lead__r.Loan_Type__c)) {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[5];
        //     } else {
        //         this.Opp.Web_Apply_Now_Section__c = APPLYFORM_OPTIONS[0];
        //     }
        // }
         this.documentList = new List<SelectOption>();
            // for(String doc : System.Label.Opportunity_Documents.Split(';')){
            //     documentOptions.add(new SelectOption(doc,doc));
            // }
        Schema.DescribeFieldResult fieldResult = Required_Document__c.Type__c.getDescribe();
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
            this.documentList.add(new SelectOption(f.getLabel(), f.getValue()));
        }
    }
    
    public PageReference sendEmail () {
      system.debug('Template ID'+ selectedTemplateId);
       
      if(string.isblank(selectedTemplateId)){
          showerror = true;
          return null;
      }
        
      // String docsRequired = string.join(selectedDocuments ,'\n');
      String str = '';
      for (String doc : selectedDocuments) {
        str += '<li>' + doc + '</li>';
      }
      str = String.isNotBlank(str) ? '<ul>' + str + '</ul>' : str;
      this.Opp.Related_Documents__c = str;
      update this.Opp; 
      
      system.debug('selectedDocuments'+ selectedDocuments);
      system.debug('selectedDocuments'+ this.Opp.id);
      
      List<Required_Document__c> docList = new List<Required_Document__c>();
      For(String docName : selectedDocuments) {
          docList.add(new Required_Document__c(Name = docName, Attachment_Id__c = '', Opportunity__c =  this.Opp.id, Type__c = docName, Uploaded_to_S3__c = false ));
      }
      insert docList;
      
      String email = EncodingUtil.urlEncode(emailOpp.Email_Address__c, 'UTF-8');

      return new PageReference('/_ui/core/email/author/EmailAuthor?p3_lkid='+Opp.Id+'&retURL=%2F'+Opp.Id+'&p24='+email+'&template_id='+selectedTemplateId+'&new_template=1&p5=');
        
       
    }

    // public List<SelectOption> getApplyNowOptions() {
    //     List<SelectOption> r = new List<SelectOption>();
    //     SelectOption o = new SelectOption(APPLYFORM_OPTIONS[0], 'Other (Generic form)');
    //     r.add(o);
    //     o = new SelectOption(APPLYFORM_OPTIONS[1], 'Car Loans');
    //     r.add(o);
    //     o = new SelectOption(APPLYFORM_OPTIONS[2], 'Leisure');
    //     r.add(o);
    //     o = new SelectOption(APPLYFORM_OPTIONS[3], 'Commercial');
    //     r.add(o);
    //     o = new SelectOption(APPLYFORM_OPTIONS[4], 'Personal');
    //     r.add(o);
    //     o = new SelectOption(APPLYFORM_OPTIONS[5], 'Home Loan');
    //     r.add(o);
    //     return r;
    // }

    public String getUserType() {
      return UserInfo.getUserType();
    }
}