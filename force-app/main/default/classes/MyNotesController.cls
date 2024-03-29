public class MyNotesController {
    
    public void setNotes() {
        myNotepad.note__c = Notes;
        update myNotepad;
    }
    
    My_Notes__c myNotepad;
    Integer notesCount;
    
    public String notes{ get; set;}

    public MyNotesController() {
        notesCount = [Select COUNT() from My_Notes__c where ownerId = :UserInfo.getUserId()];
    }

    public void init() {
        My_Notes__c  notesObject;
        if (notesCount == 0) {
            notesObject = new My_Notes__c();
            notesObject.ownerId = UserInfo.getUserId();
            insert notesObject;
        } else {
            notesObject = [Select Note__c from My_Notes__c where ownerId = :UserInfo.getUserId()LIMIT 1];
        }
        myNotepad = notesObject;
        notes = notesObject.note__c;
    }
}