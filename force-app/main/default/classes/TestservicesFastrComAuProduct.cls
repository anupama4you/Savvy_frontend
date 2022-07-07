/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-09 
* @description    Test class for testing servicesFastrComAuProduct web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuProduct {

    public static testMethod void servicesFastrComAuProductTest(){
    
        servicesFastrComAuProduct.RetrievePds_element servFComRetPdsTestRec = new servicesFastrComAuProduct.RetrievePds_element();
        
        servicesFastrComAuProductData.PdsRequest servFComRetPdsReqTestRec = new servicesFastrComAuProductData.PdsRequest();
        
        servFComRetPdsTestRec.request = servFComRetPdsReqTestRec;
        servFComRetPdsTestRec.apiKey = '1CFEC356-2259-4E1B-B3BE-FE000EFF0387';
        
        servicesFastrComAuProduct.RetrievePdsResponse_element servFComRetPdsRespTestRec = new servicesFastrComAuProduct.RetrievePdsResponse_element();
    
        servicesFastrComAuProductData.PdsResponse servFComRetPdsRespSampleTestRec = new servicesFastrComAuProductData.PdsResponse();
    
        servFComRetPdsRespTestRec.RetrievePdsResult = servFComRetPdsRespSampleTestRec;
    
        servicesFastrComAuProduct.RetrieveAssignedProductsResponse_element servFComProdRetAssignProdTestRec = new servicesFastrComAuProduct.RetrieveAssignedProductsResponse_element();
        
        servicesFastrComAuProductData.RetrieveAssignedProductsResponse servFComProdRetAssignProdSampleTestRec = new servicesFastrComAuProductData.RetrieveAssignedProductsResponse();
        
        servFComProdRetAssignPRodTestRec.RetrieveAssignedProductsResult = servFComProdRetAssignProdSampleTestRec;
 
        servicesFastrComAuProduct.RetrieveAssignedProducts_element servFComRetAssignProdTestRec = new servicesFastrComAuProduct.RetrieveAssignedProducts_element();
        
        servFComRetAssignProdTestRec.apiKey = 'test';
        
        servicesFastrComAuProduct.ProductService_Endpoint_basicHttpBinding servFComProdServEndTestRec = new servicesFastrComAuProduct.ProductService_Endpoint_basicHttpBinding();
        
        servFComProdServEndTestRec.endpoint_x = InsuranceQuoteUtils.getEndPoint() + '/ProductService.svc';
        servFComProdServEndTestRec.inputHttpHeaders_x = new Map<String,String>{'test'=>'test','test1'=>'test1'};
        servFComProdServEndTestRec.outputHttpHeaders_x = new Map<String,String>{'test'=>'test','test1'=>'test1'};
        servFComProdServEndTestRec.clientCertName_x = 'test';
        servFComProdServEndTestRec.clientCert_x = 'test';
        servFComProdServEndTestRec.clientCertPasswd_x = 'test';
        servFComProdServEndTestRec.timeout_x = 1;
    
    }
    
}