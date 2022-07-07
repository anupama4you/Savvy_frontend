public with sharing class FileUploadController {
    public String currentRecordId {get;set;}

    
    public Document document {
        get {
            if (document == null)
                document = new Document();
            return document;
        }
        set;
    }
    public FileUploadController(ApexPages.StandardController controller){
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
    }
    public PageReference upload() {
        List<Folder> folderList = [SELECT Id, Name From Folder WHERE Name = 'Logos' limit 1];
        
        String name = document.name;
        
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = folderList[0].Id;
        document.ContentType = 'image/gif';
        document.Type = 'gif';
        document.IsPublic = true;
        if(name != null){
            document.DeveloperName = name.replace(' ','_');
        }
        
        /*ContentVersion v = new ContentVersion();
        v.versionData = document.body;
        v.title = document.name;
        String name = v.title;
        string newtest = name.replace(' ','-');
        v.pathOnClient = newtest+'.png';*/
        
        String strLogoUrl = '';
        
        try {
            /*insert v;
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = currentRecordId;
            contentlink.contentdocumentid = v.Id;
            contentlink.ShareType = 'V';
            insert contentlink; */
            
            insert document;
            list<Document> lstDocument = [SELECT Id FROM Document WHERE id =: document.Id];
            String strOrgId = UserInfo.getOrganizationId();
            strLogoUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + 
                '/servlet/servlet.ImageServer?id='+lstDocument[0].Id +
                '&oid=' + strOrgId;
            Account acc = [
              select id, URL_Logo__c from Account where id  =: currentRecordId
            ]; 
            acc.URL_Logo__c = strLogoUrl;
            update acc;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
            return null;
        } finally {
            //document.body = null; // clears the viewstate
            //document = new Document();
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
        PageReference pg = new PageReference('/'+currentRecordId);
        pg.setRedirect(true);
        return pg;
 
        //return null;
    }
    
}