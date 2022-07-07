//Created by Jack.li@toptechservice.com.au on 21/7/2017
//testing code for consoleTaskList.cls

@isTest
private class consoleTaskListTest {

	@isTest
	private static void testGetTasks() {
		consoleTaskList aConsoleTaskList = new consoleTaskList();
		List<task> tasks = new List<task>();
		tasks=aConsoleTaskList.getTasks();
	}
}