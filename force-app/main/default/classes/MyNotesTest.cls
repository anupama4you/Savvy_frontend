@isTest(SeeAllData=true)
public class MyNotesTest {
    
    public static testMethod void myTestHardcodedIds(){
        MyNotesController myNotes= new MyNotesController();
        myNotes.notes = 'Test value';
        myNotes.init(); 
		myNotes.setNotes();
    }

}