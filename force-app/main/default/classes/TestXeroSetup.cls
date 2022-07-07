@isTest
public class TestXeroSetup {
	    
	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Create test data for the method
	**/
	@testSetup
	public static void setupTestData () {
        
        List<Xero_API_Setting__c> xettings = [Select t.id, t.Endpoint__c from Xero_API_Setting__c t];
        
        for(Xero_API_Setting__c xe : xettings){
            xe.Endpoint__c = 'https://api.xero-test.com/';
            xe.Tag_Category__c = 'fcfa4b51-5489-4347-ae47-5dea90f33c75';
        }
        update xettings;
    }
    
    public static void setupTestInvoiceFinanceData(Invoice__c xe){

        xe.Xero_Invoice_Id__c = '565acaa9-e7f3-4fbf-80c3-16b081ddae10';
        xe.Xero_Invoice_DOF_Id__c = '565acaa9-e7f3-4fbf-80c3-16b081ddae11';            
        xe.Xero_Invoice_DOF_Number__c = 'INV-1235';
        xe.Xero_Invoice_Number__c = 'INV-1234';
        update xe;
    }
    
    public static void setupTestInvoiceCommissionData(Invoice__c xe){
        xe.Xero_Invoice_Id__c = '565acaa9-e7f3-4fbf-80c3-16b081ddae12'; 
        xe.Xero_Invoice_Number__c = 'INV-1236';
        update xe;
    }
    
    public static void setupTestInvoiceOnlineData(){
    	XeroOnlineInvoices onlineInvoices = new XeroOnlineInvoices('https://test.xero.com/');
    }
}