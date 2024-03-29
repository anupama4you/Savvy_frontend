//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
@isTest
public class servicesFastrComAuQuotationMockImpl implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		System.debug(LoggingLevel.INFO, 'servicesFastrComAuQuotationMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);
		
		
		//if('RequestInitialQuotation_element'.equals(String.valueOf(request).split(':')[0]) ||
		//   'RequestFinalQuotation_element'.equals(String.valueOf(request).split(':')[0])) {
		//	response.put( 'response_x', new servicesFastrComAuQuotation.RequestInitialQuotationResponse_element());
		//}
		
		
		if(request instanceOf servicesFastrComAuQuotation.RequestFinalQuotation_element) {
			servicesFastrComAuQuotation.RequestFinalQuotationResponse_element r = new servicesFastrComAuQuotation.RequestFinalQuotationResponse_element();
			r.RequestFinalQuotationResult = new servicesFastrComAuQuotationData.QuotationResponse();
			response.put( 'response_x', r);
		}
		else if(request instanceOf servicesFastrComAuQuotation.RequestInitialQuotation_element) {
			servicesFastrComAuQuotation.RequestInitialQuotationResponse_element r = new servicesFastrComAuQuotation.RequestInitialQuotationResponse_element();
			r.RequestInitialQuotationResult = new servicesFastrComAuQuotationData.QuotationResponse();
			response.put( 'response_x', r);
		}
		else if(request instanceOf servicesFastrComAuQuotation.RequestPremiumOverride_element) {
			response.put( 'response_x', new servicesFastrComAuQuotation.RequestPremiumOverrideResponse_element());
		}
		else if(request instanceOf servicesFastrComAuQuotation.RequestQuotationValidation_element) {
			response.put( 'response_x', new servicesFastrComAuQuotation.RequestQuotationValidationResponse_element());
		}
		
		System.debug('Is there response? ' + response.isEmpty());
	}
}