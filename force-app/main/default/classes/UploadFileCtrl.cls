public with sharing class UploadFileCtrl {
    @AuraEnabled
    public static void uploadPartnerLogo(String userId, String documentId){
        try {
            User[] user = [SELECT Id, AccountId, Account.Name FROM User WHERE Id=: userId];
            if(!user.isEmpty()){
                if(String.isNotBlank(documentId) && String.isNotBlank(User[0].Account.Name)){
                    ContentDocument objCD = new ContentDocument(Id= documentId, Title=User[0].Account.Name+'_Logo');
                    update objCD;
                    ContentDocumentLink objCDL = new ContentDocumentLink(ContentDocumentId=documentId, LinkedEntityId =User[0].AccountId, ShareType ='I', Visibility='AllUsers');
                    insert objCDL;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}