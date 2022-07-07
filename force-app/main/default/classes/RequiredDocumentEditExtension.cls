public class RequiredDocumentEditExtension
{
    public RequiredDocumentEditExtension(ApexPages.StandardController c)
    {
        record = (Required_Document__c)c.getRecord();

    }

    public string strSelectedattachmentValue {get; set; }
    private Required_Document__c record;
    public Blob File{ get; set; }
    public String FileName { get; set; }
    public PageReference SaveOverride()
    {
        try
        {
            // this is written under the assumption that documents will only be added and deleted, never edited
            
            // check that we have a file
          /*  if (File == null )
            {
                return CustomException.formatException('You must select a document');
            }             
            */

            
            if( File != null){
            
                // create the attachment object
                Attachment a = new Attachment();  
                a.Name = FileName;          
                a.Body = File;               
                
                File = null;
                                    
                // insert the record
                record.Name = FileName;
                insert record;
                
                // populate the rest of the attachment and insert
                a.ParentId = record.Id;
                insert a;
                
                // update the record with the Id of the attachment
                record.Attachment_Id__c = a.Id;
                update record;
            
            }else {
            
                if (strSelectedattachmentValue == '-- Select Attachment --')
                {
                
                return CustomException.formatException('You must select a document');
                
                }else {
                   
                system.debug('@@strSelectedattachmentValue'+strSelectedattachmentValue);
                
                Attachment attObj = [select id,parentId,OwnerId,Name,Body from Attachment where parentId=:record.Opportunity__c AND id=:strSelectedattachmentValue];
                system.debug('@@Name'+attObj.Name);
                
                // create the attachment object
                Attachment b = new Attachment();  
                b.Name = string.valueOf(record.Type__c);          
                b.Body = attObj.body;               
                
                //File = null;
                                    
                // insert the record
                record.Name = attObj.name;
                insert record;
                
                // populate the rest of the attachment and insert
                b.ParentId = record.Id;
                insert b;
                
                // update the record with the Id of the attachments
                record.Attachment_Id__c = b.Id;
                update record;
                
               // Delete attObj;
                
            }

        }
        
            
        return new PageReference('/' + record.Opportunity__c);    

       
        }      
         catch(Exception e)
        {            
            return CustomException.formatException(e);
        }
    
     }   
        
        Public List<selectOption> getoppAttachmentOptions(){
        List<selectOption> options = new List<selectOption>();
        
       
        
        List<Attachment> attachMntLst = [select id,parentId,OwnerId,Name,Body from Attachment where parentId=:record.Opportunity__c];
        
        system.debug('@@@attachMntLst'+attachMntLst);

        if(attachMntLst.size()>0){
            
            for(Attachment attObj:attachMntLst){
            
                options.add(new selectoption(attObj.id, attObj.name));
                
            }
        }else{
        
            options.add(new selectoption('selectAttachment', '-- Select Attachment --'));
        
        }
        
        return options;
        
        }

}