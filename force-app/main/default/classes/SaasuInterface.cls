public class SaasuInterface
{               
    public void Go()
    {
        /*SendInvoices([SELECT Id,
                             Name,
                             Date_of_Invoice__c,
                             RecordType.Name,
                             Invoice_Amount__c
                      FROM Invoice__c 
                      WHERE RecordType.Name != 'RCTI'
                      AND Invoice_Amount__c > 0]);*/
    }              

    @future(callout=true)
    public static void SendInvoices(List<Id> invoiceIds)
    {       
        List<Invoice__c> invoices = [SELECT Id,
                                            Name,
                                            Date_of_Invoice__c,
                                            RecordType.Name,
                                            Invoice_Amount__c,
                                            Saasu_Expense_Number__c,
                                            Saasu_Invoice_Number__c
                                     FROM Invoice__c 
                                     WHERE Id IN :invoiceIds];
             
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(Saasu_Settings__c.getInstance().URL__c);
        req.setMethod('POST');        
        req.setBody(InsertInvoiceXML(invoices));        
        
        if (!Test.isRunningTest())
        {
            Http http = new Http();              
            HandleResponse(http.send(req), invoices);
        }
        
        //return response.getBody();
    }
            
    private static String InsertInvoiceXML(List<Invoice__c> invoices)
    {
        String msg = '';
        
        msg += '<?xml version="1.0" encoding="utf-8"?>\r\n';
        msg += '<tasks>\r\n';
        
        for (Invoice__c i : invoices)
        {   
            String saasuAccountId = '';
            if (i.RecordType.Name == 'RCTI')
            {
                saasuAccountId = Saasu_Settings__c.getInstance().RCTI_Account_Id__c;
            }
            else if (i.RecordType.Name == 'Finance Invoice')
            {
                saasuAccountId = Saasu_Settings__c.getInstance().Finance_Account_Id__c;
            }
            else if (i.RecordType.Name == 'Insurance Invoice') 
            {
                saasuAccountId = Saasu_Settings__c.getInstance().Insurance_Account_Id__c;
            }
        
            // note that Saasu requires the indentation for SOME of the fields (date and layout) so I'm just applying it everywhere for consistency
            msg += '<insertInvoice emailToContact="false">\r\n';
            msg += '  <invoice uid="0">\r\n';
            msg += '    <transactionType>' + (i.RecordType.Name == 'RCTI' ? 'P' : 'S') + '</transactionType>\r\n';
            msg += '    <date>' + String.valueOf(i.Date_of_Invoice__c) + '</date>\r\n';                   
            //msg += '    <dueOrExpiryDate>' + String.valueOf(i.Date_of_Invoice__c.addDays(14)) + '</dueOrExpiryDate>';            
            msg += '    <layout>S</layout>\r\n';
            msg += '    <status>I</status>\r\n';
            if (i.RecordType.Name == 'RCTI')
            {
                msg += '    <invoiceNumber>' + i.Name + '</invoiceNumber>\r\n';
                msg += '    <purchaseOrderNumber>&lt;Auto Number&gt;</purchaseOrderNumber>\r\n';                                
            }
            else
            {
                msg += '    <invoiceNumber>&lt;Auto Number&gt;</invoiceNumber>\r\n';
            }
            msg += '    <invoiceItems>\r\n';
            msg += '      <serviceInvoiceItem>\r\n';
            msg += '        <description>Brokerage</description>\r\n';
            msg += '        <accountUid>' + saasuAccountId + '</accountUid>\r\n';
            msg += '        <taxCode>' + Saasu_Settings__c.getInstance().Tax_Code__c + '</taxCode>\r\n';
            msg += '        <totalAmountInclTax>' + String.valueOf(i.Invoice_Amount__c) + '</totalAmountInclTax>\r\n';
            msg += '      </serviceInvoiceItem>\r\n';
            msg += '    </invoiceItems>\r\n';
            msg += '    <isSent>false</isSent>\r\n';
            msg += '  </invoice>\r\n';
            msg += '</insertInvoice>\r\n';                        
        }
        
        msg += '</tasks>';                
        //system.debug('debug1:' + msg);
        return msg;
    }  
    
    @TestVisible private static void HandleResponse(HttpResponse response, Invoice__c[] invoices)
    {    
        system.debug(response.getBody());                
        Dom.XmlNode root = response.getBodyDocument().getRootElement();
        
        for (Integer i = 0; i < root.getChildElements().size(); i++)
        {
            if (root.getChildElements()[i].getName() == 'insertInvoiceResult')
            {
                if (invoices[i].RecordType.Name == 'RCTI')
                {
                    invoices[i].Saasu_Expense_Number__c = root.getChildElements()[i].getAttribute('generatedPurchaseOrderNumber', null);
                }
                else
                {
                    invoices[i].Saasu_Invoice_Number__c = root.getChildElements()[i].getAttribute('generatedInvoiceNumber', null);
                }
            }
        }
        
        update invoices;
    }                                           
}