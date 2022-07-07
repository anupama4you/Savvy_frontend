/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-09 
* @description    Test class for testing servicesFastrComAuProductData web service apex class
*/

@isTest(SeeAllData=true)
public class TestservicesFastrComAuProductData {

    public static testMethod void servicesFastrComAuProductDataTest(){
    
        servicesFastrComAuProductData.ArrayOfProduct servFComArryOfProdTestRec = new servicesFastrComAuProductData.ArrayOfProduct();
        
        servicesFastrComAuProductData.Product[] servFComArryOfProdListTestRec = new servicesFastrComAuProductData.Product[]{};
        
        servFComArryOfProdTestRec.Product = servFComArryOfProdListTestRec;
       
        servicesFastrComAuProductData.Cover servFComProdDataCovrTestRec = new servicesFastrComAuProductData.Cover();
        servFComProdDataCovrTestRec.Code = 'test';
        servFComProdDataCovrTestRec.CoverTerm = 1;
        servFComProdDataCovrTestRec.Name = 'test';

        servicesFastrComAuProductData.ArrayOfCover servFComArryOfCvrTestRec = new servicesFastrComAuProductData.ArrayOfCover();
       
        servicesFastrComAuProductData.Cover[] servFComArryOfCvrListTestRec = new servicesFastrComAuProductData.Cover[]{};
       
        servFComArryOfCvrTestRec.Cover = servFComArryOfCvrListTestRec;
        
        servicesFastrComAuProductData.PdsResponse servFComPdsRespTestRec = new servicesFastrComAuProductData.PdsResponse();
        
        servFComPdsRespTestRec.DocumentUrl = 'test';
        
        servicesFastrComAuProductData.Product servFComProdTestRec = new servicesFastrComAuProductData.Product();
       
        servicesFastrComAuProductData.ArrayOfCover servFComProdArryOfCvrTestRec = new servicesFastrComAuProductData.ArrayOfCover();
        
        servFComProdTestRec.CoverTypes = servFComProdArryOfCvrTestRec;
        
        servFComProdTestRec.Name = 'test';
        
        servicesFastrComAuProductData.RetrieveAssignedProductsResponse servFComProdRetAssignProdRepTestRec = new servicesFastrComAuProductData.RetrieveAssignedProductsResponse();
        
        servicesFastrComAuProductData.ArrayOfProduct servFComProdRetAssignArryProdTestRec = new servicesFastrComAuProductData.ArrayOfProduct();
        
        servFComProdRetAssignProdRepTestRec.Products = servFComProdRetAssignArryProdTestRec;
        
        servicesFastrComAuProductData.PdsRequest servFComPdsReqTestRec = new servicesFastrComAuProductData.PdsRequest();
       
        servFComPdsReqTestRec.CoverTypeCode = 'test';
    
    }  
    
}