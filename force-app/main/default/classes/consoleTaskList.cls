//Created by Jack.li@toptechservice.com.au on 20/7/2017
//controller for console task list vf page used as console component in console sidebar

public class consoleTaskList {

public List<task> getTasks() { 
	List<task> taskList = [SELECT id,ActivityDate,OwnerId,Status,Subject,What.name 
							FROM Task 
							where isclosed=false and ownerid=:UserInfo.getUserId() order by activitydate desc limit 20];  
	return taskList;
}

}