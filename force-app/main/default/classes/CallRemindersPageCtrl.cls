public with sharing class CallRemindersPageCtrl {
	public String myReminderHeight{get;set;}
	public Boolean isCustomerLoyalty{get;set;}
	public CallRemindersPageCtrl(){
		this.isCustomerLoyalty = false;
		this.myReminderHeight = '500';
		
		if(!([Select Id from User where Id=:Userinfo.getUserId() and UserRole.name='Customer Loyalty Team'].isEmpty())) {
			this.isCustomerLoyalty = true;
			this.myReminderHeight = '250';
		}
	}
}