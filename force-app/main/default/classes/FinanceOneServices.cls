public class FinanceOneServices {

    public static final String PARAM_ENDPOINT1 = 'FinanceOne_Endpoint1';
    public static final String PARAM_ENDPOINT2 = 'FinanceOne_Endpoint2';
    public static final String PARAM_TOKEN = 'FinanceOne_Token';
    
    public static String getName(String oppName, String accountId, Integer status){
        String name;
        
        if(status == 200){
            if(oppName.length() > 71){
                name = oppName.substring(0,71)+' ['+accountId+']';
            }else{
                name = oppName+' ['+accountId+']';
            }
        }else{
            Datetime t = Datetime.now();
            name = oppName+' ['+status+'-'+t.getTime()+']';
        }
        return name;
    }
    /*
public static void getService(){
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://sandbox.api.financeone.com.au/api/v1/dynamicTypes');
request.setMethod('GET');
request.setHeader('x-api-key', '04e6b0e5-66de-454a-8cba-59341289f9d0:BSAVVY');
request.setTimeout(40000);
HttpResponse response = http.send(request);
System.debug(response);
System.debug(response.getBody());
}
*/
    // public static LenderAPIResponse__c postServiceIndividualApplication(FinanceOneDTOs.IndividualApplication dto, Custom_Opportunity__c o, String UUID, String apiUser){
    //   return null;
    // }

    // public static LenderAPIResponse__c postServiceCompanyApplication(FinanceOneDTOs.CompanyApplication dto, Custom_Opportunity__c o, String UUID, String apiUser) {
    //   return null;
    // }

    // public static LenderAPIResponse__c postServiceSoleTraderApplication(FinanceOneDTOs.SoleTraderApplication dto, Custom_Opportunity__c o, String UUID, String apiUser){
    //   return null;
    // }

    // public static LenderAPIResponse__c postServicePartnershipApplication(FinanceOneDTOs.PartnershipApplication dto, Custom_Opportunity__c o, String UUID, String apiUser){
    //   return null;
    // }

    // public static LenderAPIResponse__c postServiceTrustWithIndividualTrusteeApplication(FinanceOneDTOs.TrustWithIndividualTrusteeApplication dto, Custom_Opportunity__c o, String UUID, String apiUser){
    //   return null;
    // }

    // public static LenderAPIResponse__c postServiceTrustWithCompanyTrusteeApplication(FinanceOneDTOs.TrustWithCompanyTrusteeApplication dto, Custom_Opportunity__c o, String UUID, String apiUser){
    //   return null;
    // }

    // public static LenderAPIResponse__c service(String body, Custom_Opportunity__c o, String UUID, String endpoint, String apiUser){
    //   return null;
    // }


    public static LenderAPIResponse__c postServiceIndividualApplication(FinanceOneDTOs.IndividualApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/individual?', apiUser, mgr);          
    }
    
    public static LenderAPIResponse__c postServiceCompanyApplication(FinanceOneDTOs.CompanyApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/company?', apiUser, mgr);
    }
    
    public static LenderAPIResponse__c postServiceSoleTraderApplication(FinanceOneDTOs.SoleTraderApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/soleTrader?', apiUser, mgr);
    }
    
    public static LenderAPIResponse__c postServicePartnershipApplication(FinanceOneDTOs.PartnershipApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/partnership?', apiUser, mgr);
    }
    
    public static LenderAPIResponse__c postServiceTrustWithIndividualTrusteeApplication(FinanceOneDTOs.TrustWithIndividualTrusteeApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/individualTrust?', apiUser, mgr);
    }
    
    public static LenderAPIResponse__c postServiceTrustWithCompanyTrusteeApplication(FinanceOneDTOs.TrustWithCompanyTrusteeApplication dto, Custom_Opportunity__c o, String UUID, String apiUser, FinanceOneAPIManager mgr){
        String body = JSON.serialize(dto);
        return FinanceOneServices.service(body, o, UUID, '/applications/companyTrust?', apiUser, mgr);
    }
    
    

    public static LenderAPIResponse__c service(String body, Custom_Opportunity__c o, String UUID, String endpoint, String apiUser, FinanceOneAPIManager mgr){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        // Lelo         2021/07/02
        String url = APIServiceManager.getParameterService(PARAM_ENDPOINT1) + endpoint;
        url += APIServiceManager.getParameterService(PARAM_ENDPOINT2);
        url = url.replace('SFBRID', apiUser);
        System.debug('endpoint => ' + url);
        request.setEndpoint(url);
        //-
        request.setMethod('POST');
        if (SOQLSingletonQueries.recs().isBrokerPartnerUser) {
            Partner_API_Setting__c aps = APIServiceManager.getPartnerAPISetting(APIServiceManager.API_LENDER_FINANCEONE);
            if (aps != null) {
                request.setHeader('x-api-key', aps.Token__c);
            }
        } else {
            request.setHeader('x-api-key', APIServiceManager.getParameterService(PARAM_TOKEN));
        }
        request.setHeader('Content-Type', 'application/json');
        
        String body2 = body.replace('licenceNumber', 'number');
        request.setBody(body2);
        request.setTimeout(40000);
        HttpResponse response = http.send(request);
        
        LenderAPIResponse__c financeOneApp = new LenderAPIResponse__c();
        financeOneApp.Opportunity__c = o.Id;
        financeOneApp.Status__c = response.getStatusCode();
        financeOneApp.DocumentUUID__c = UUID;
        
        if('/applications/individual?'.equals(endpoint)){
            financeOneApp.Service__c = 'individual';
        }
        
        if('/applications/company?'.equals(endpoint)){
            financeOneApp.Service__c = 'company';
        }
        
        if('/applications/soleTrader?'.equals(endpoint)){
            financeOneApp.Service__c = 'soleTrader';
        }
        
        if('/applications/partnership?'.equals(endpoint)){
            financeOneApp.Service__c = 'partnership';
        }
        
        if('/applications/individualTrust?'.equals(endpoint)){
            financeOneApp.Service__c = 'individualTrust';
        }
        
        if('/applications/companyTrust?'.equals(endpoint)){
            financeOneApp.Service__c = 'companyTrust';
        }
        Application_Quoting__c d = QuotingToolHelper.getApplicationQuoting(o.Id, o.Application__c);
        System.debug(o.Id);
        System.debug(o.Application__c);
        System.debug(d);
        financeOneApp.Provider__c = 'Finance One';
        financeOneApp.Request__c = body2;
        financeOneApp.Response__c = response.getBody();
        financeOneApp.Quoting_Source__c = d.Name;
        if (String.isNotBlank(financeOneApp.Request__c) && financeOneApp.Request__c.length() > 131072) {
            financeOneApp.Request__c = financeOneApp.Request__c.substring(0,131072);
        }
        if (String.isNotBlank(financeOneApp.Response__c) && financeOneApp.Response__c.length() > 131072) {
            financeOneApp.Response__c = financeOneApp.Response__c.substring(0,131072);
        }
        if(String.isNotBlank(response.getBody())){
            ResponseFinanceOne r = (ResponseFinanceOne)JSON.deserialize(response.getBody(), ResponseFinanceOne.class);
            if(r.errors != null){
              if(r.errors.simple != null){
                for (ResponseFinanceOne.Simple err : r.errors.simple){
                  mgr.addErrorMessage(
                    '[' + err.errorCode + '] ' + err.errorType + ' - ' + err.errorMessage + ' (' + err.path + ')'
                  );
                }
              }
              
              if(r.errors.application != null){
                for (ResponseFinanceOne.Application err: r.errors.application) {
                  mgr.addErrorMessage(
                    '[' + err.errorCode + '] ' + err.errorType + ' - ' + err.errorMessage
                  );
                }
              }
              
              if(r.errors.applicants != null){
                Integer applicant = 0;
                for (ResponseFinanceOne.Applicants pp: r.errors.applicants) {
                  applicant++;
                  for (ResponseFinanceOne.Errors err: pp.errors) {
                    mgr.addErrorMessage(
                    'Applicant ' + applicant + ' : [' + err.errorCode + '] ' + err.errorType + ' - ' + err.errorMessage
                    );
                  }
                }
              }
            }
            if(r.data != null){
                if(r.data.accountId != null){
                  mgr.addConfirmMessage(r.message);
                  mgr.addConfirmMessage('Account ID: '+r.data.accountId);
                }
            }else{
                mgr.addErrorMessage(r.message); 
            }       
            
            if(r.data != null){
                financeOneApp.Name = FinanceOneServices.getName(o.Name, r.data.accountId, response.getStatusCode());
                financeOneApp.Application_ID__c = r.data.accountId;
            }else{
                financeOneApp.Name = FinanceOneServices.getName(o.Name, null, response.getStatusCode());    
            }
            
            financeOneApp.Message__c = r.message;
            
        }else{
            mgr.addErrorMessage(response.getStatus()+' '+response.getStatusCode()+' - Broker id '+apiUser+' may not be valid, please confirm it with Finance One');
            financeOneApp.Name = FinanceOneServices.getName(o.Name, null, response.getStatusCode()); 
        }
        
        insert financeOneApp;

        return financeOneApp;
    }
}