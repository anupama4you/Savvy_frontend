/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-09 
* @description    Test class for testing servicesFastrComAuPayment web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuPayment {

    public static testMethod void servicesFastrComAuPayment(){
    
        servicesFastrComAuPayment.ProcessResponse_element servFComProcRespTestRec = new servicesFastrComAuPayment.ProcessResponse_element();
        
        servicesFastrComAuPaymentData.PaymentResponse servFComProcRespPaymtRpTestRec = new servicesFastrComAuPaymentData.PaymentResponse();
        
        servFComProcRespTestRec.ProcessResult = servFComProcRespPaymtRpTestRec;
        
        servicesFastrComAuPayment.ProcessAndUpdateMainInsuredResponse_element servFComProcUpdMainInsTestRec = new servicesFastrComAuPayment.ProcessAndUpdateMainInsuredResponse_element();
        
        servicesFastrComAuPaymentData.PaymentResponse servFComProcUpdMainInsPymtReTestRec = new servicesFastrComAuPaymentData.PaymentResponse(); 
        
        servFComProcUpdMainInsTestRec.ProcessAndUpdateMainInsuredResult = servFComProcUpdMainInsPymtReTestRec;
        
        servicesFastrComAuPayment.Process_element servFComProcEleTestRec = new servicesFastrComAuPayment.Process_element();
        
        servicesFastrComAuPaymentData.PaymentRequest servFComPaymtReqTestRec = new servicesFastrComAuPaymentData.PaymentRequest();
        
        servFComProcEleTestRec.paymentRequest = servFComPaymtReqTestRec;
        servFComProcEleTestRec.apiKey = 'test';
        
        servicesFastrComAuPayment.ProcessAndUpdateMainInsured_element servFComProcUpdMITestRec = new servicesFastrComAuPayment.ProcessAndUpdateMainInsured_element();
        
        servicesFastrComAuPaymentData.PaymentRequest servFComPymtReqTestRec = new servicesFastrComAuPaymentData.PaymentRequest();
        
        servFComProcUpdMITestRec.paymentRequest = servFComPymtReqTestRec;
  
        servicesFastrComAuPaymentData.UpdateMainInsuredRequest servFComUpdMIReqTestRec = new servicesFastrComAuPaymentData.UpdateMainInsuredRequest();
   
        servFComProcUpdMITestRec.updateMainInsuredRequest = servFComUpdMIReqTestRec; 
        
        servFComProcUpdMITestRec.apiKey = 'test';
        
        servicesFastrComAuPayment.PaymentServiceEndpoint_wsHttp servFComPaymtServEndTestRec = new servicesFastrComAuPayment.PaymentServiceEndpoint_wsHttp();
        
        servFComPaymtServEndTestRec.endpoint_x = InsuranceQuoteUtils.getEndPoint() + '/PaymentService.svc';
        
        servFComPaymtServEndTestRec.inputHttpHeaders_x  = new Map<String,String>{'test' => 'test','test1' => 'test1'};
        
        servFComPaymtServEndTestRec.outputHttpHeaders_x = new Map<String,String>{'test' => 'test','test1' => 'test1'};
        
        servFComPaymtServEndTestRec.clientCertName_x = 'test';
        servFComPaymtServEndTestRec.clientCert_x = 'test';
        servFComPaymtServEndTestRec.clientCertPasswd_x = 'test';
        servFComPaymtServEndTestRec.timeout_x = 1;
    
    }
    
}