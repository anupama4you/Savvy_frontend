/**
 * See https://github.com/financialforcedev/fflib-apex-common for more info
 *
 * Install library via
 *   https://githubsfdeploy.herokuapp.com/app/githubdeploy/financialforcedev/fflib-apex-common
 */

/**
 * Encapsulates all service layer logic for a given function or module in the application
 * 
 * For more guidelines and details see 
 *   https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Service_Layer
 *
 **/
public class EricServices {
	
	private static EricDTOs.Token currentToken = null;		

	private static EricDTOs.Settings getSettings() {
		EricDTOs.Settings r = new EricDTOs.Settings();
		r.dealerId = InsuranceQuoteUtils.getRestDeailerId();
		r.dealerName = InsuranceQuoteUtils.getRestDeailerName();
		r.baseEndpoint = InsuranceQuoteUtils.getRestEndPoint();
		r.pwd = InsuranceQuoteUtils.getRestPwd();
		r.userId = InsuranceQuoteUtils.getRestUserId();
		r.username = InsuranceQuoteUtils.getRestUsername();
		return r;
	}
	public static EricDTOs.Token getToken()	{
		return getToken(false);
	}

	public static EricDTOs.Token getToken(Boolean reuseToken){
		if (reuseToken && currentToken != null) {
			return currentToken;
		}
		EricDTOs.Settings s = getSettings();
		ConnectionRESTWs.Param p = new ConnectionRESTWs.Param();
		p.endpoint = s.baseEndpoint + '/api/token';
		p.method = ConnectionRESTWs.GET;
		p.requestQuery = new Map<String, String>();
		p.requestQuery.put('username',s.username);
		p.requestQuery.put('password',s.pwd);
		EricDTOs.Token r = new EricDTOs.Token();
        HttpResponse res = ConnectionRESTWs.invoke(p);
        
		if (res != null) {
			if (res.getStatusCode() == 200) {
				r = (EricDTOs.Token)JSON.deserialize(res.getBody(), EricDTOs.Token.class);
				currentToken = r;
			}
		}
		return r;
	}
	public static ConnectionRESTWs.Param getAuthRequestParam(String endpoint) {
		return getAuthRequestParam(endpoint, false);
	}

	public static ConnectionRESTWs.Param getAuthRequestParam(String endpoint, Boolean reuseToken) {
		ConnectionRESTWs.Param r = null;
        EricDTOs.Token token = getToken(reuseToken);
        
        if (token != null) {
			EricDTOs.Settings s = getSettings();
			r = new ConnectionRESTWs.Param();
			r.endpoint = s.baseEndpoint + endpoint;
			r.requestHeader = new Map<String, String>();
			r.requestHeader.put('Authorization', 'clicktoken ' + token.accessToken);
		}
		return r;
	}

	public static void getTestPost()	{
		System.debug('TestPost...');
		ConnectionRESTWs.Param p = getAuthRequestParam('/api/Test/Post');
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return;
		}
		p.method = ConnectionRESTWs.POST;
		p.requestHeader.put('Content-Type', 'application/json');
		HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
			} else {

			}
		}
	}

	public static EricDTOs.ResponseDTO getQuote(String quoteId, EricDTOs.QuoteDetails details){
		System.debug('Starting a quote... [' + quoteId + ']');
		System.debug(JSON.serializePretty(details));
		EricDTOs.ResponseDTO r = new EricDTOs.ResponseDTO();
		if (String.isBlank(quoteId)) {
			r = getBeginQuote(details);
			if (r.hasErrors()) {
				return r;
			}
			quoteId = r.beginQuoteResponse.QuoteId;
		}
		// Add/Update details
		System.debug('Addinng Details for ' + quoteId + '...');
		String url = '/api/Quote/QuoteAddDetails/' + quoteId;
        ConnectionRESTWs.Param p = getAuthRequestParam(url, true);
        
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.POST;
		p.requestHeader.put('Content-Type', 'application/json');
		p.body = JSON.serialize(details);
        HttpResponse res = ConnectionRESTWs.invoke(p);
        
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
				r.addDetailsResponse = (EricDTOs.QuoteDetailResponse)JSON.deserialize(res.getBody(), EricDTOs.QuoteDetailResponse.class);
			} else {
				r.addErrorMessage('Status code: ' + res.getStatusCode(), 'Quote process has failed.');
				r.addErrorMessage('Provider Error', res.getBody());
				System.debug('Status code: ' + res.getStatusCode());
				System.debug('Body: ' + res.getBody());
			}
		} else {
			r.addErrorMessage('Quote process has failed. Salesforce could not receive a response from Eric system.');
		}
		// Get the quote
		System.debug('Getting a Quote...');
		if (r.hasErrors()) return r;
		url = '/api/Quote/GetQuote/' + quoteId;
		p = getAuthRequestParam(url, true);
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.GET;
		p.requestHeader.put('Content-Type', 'application/json');
		res = ConnectionRESTWs.invoke(p);
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
				try {
					r.quoteResponse = (EricDTOs.QuoteResponse)JSON.deserialize(res.getBody(), EricDTOs.QuoteResponse.class);
				} catch (JSONException e) {
					throw new InsuranceServiceException(res.getBody());
				}
				return r;
			} else {
				r.addErrorMessage('Status code: ' + res.getStatusCode(), 'Quote process has failed.');
				r.addErrorMessage('Provider Error', res.getBody());
				System.debug('Status code: ' + res.getStatusCode());
				System.debug('Body: ' + res.getBody());
			}
		} else {
			r.addErrorMessage('Quote process has failed. Salesforce could not receive a response from Eric system.');
		}
		return r;
	}

	public static EricDTOs.ResponseDTO getBeginQuote(EricDTOs.QuoteDetails details){
		System.debug('Begining a Quote...');
		EricDTOs.ResponseDTO r = new EricDTOs.ResponseDTO();
		if (details == null) {
			r.addErrorMessage('BeginQuote process can not proceed when its deatils are null');
			return r;
		}
		// Preparing the object request
		EricDTOs.Settings s = getSettings();
		EricDTOs.BeginQuote bq = new EricDTOs.BeginQuote();
		bq.DealerId = s.dealerId;
		bq.UserId = s.userId;
		bq.QuoteGroups = new List<EricDTOs.QuoteGroup>();
		EricDTOs.QuoteGroup qg = new EricDTOs.QuoteGroup();
		bq.QuoteGroups.add(qg);
		qg.GroupId = s.dealerId;
		qg.Name = s.dealerName;
		qg.Items = new List<EricDTOs.Item>();
		if (details.ItemDetails != null) {
			if (details.ItemDetails.MotorItemDetails != null) {
				for (EricDTOs.MotorItemDetail a : details.ItemDetails.MotorItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'MOT';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
			if (details.ItemDetails.GapItemDetails != null) {
				for (EricDTOs.GapItemDetail a : details.ItemDetails.GapItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'GAP';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
			if (details.ItemDetails.TaiItemDetails != null) {
				for (EricDTOs.TaiItemDetail a : details.ItemDetails.TaiItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'TAI';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
			if (details.ItemDetails.LtiItemDetails != null) {
				for (EricDTOs.LtiItemDetail a : details.ItemDetails.LtiItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'LTI';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
            //Jesus Mora 2020-06-22 start
            if (details.ItemDetails.CciItemDetails != null) {
				for (EricDTOs.CciItemDetail a : details.ItemDetails.CciItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'CRE';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
            //Jesus Mora 2020-06-22 end
			if (details.ItemDetails.WarItemDetails != null) {
				for (EricDTOs.WarItemDetail a : details.ItemDetails.WarItemDetails) {
					EricDTOs.Item i = new EricDTOs.Item();
					i.Product = 'WAR';
					i.CoverType = a.CoverType;
					qg.Items.add(i);
				}
			}
		}
		// Request
		String url = '/api/Quote/BeginQuote';
		ConnectionRESTWs.Param p = getAuthRequestParam(url);
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.POST;
		p.requestHeader.put('Content-Type', 'application/json');
		p.body = JSON.serialize(bq);
		HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
				r.beginQuoteResponse = (EricDTOs.BeginQuoteResponse)JSON.deserialize(res.getBody(), EricDTOs.BeginQuoteResponse.class);
				return r;
			} else {
				r.addErrorMessage('Status code: ' + res.getStatusCode(), 'Quote process has failed.');
				r.addErrorMessage('Provider Error', res.getBody());
				System.debug('Status code: ' + res.getStatusCode());
				System.debug('Body: ' + res.getBody());
			}
		} else {
			r.addErrorMessage('Begin Quote process has failed. Salesforce could not receive a response from Eric system.');
		}
		return r;
	}

	public static EricDTOs.ResponseDTO preLodgeQuote(EricDTOs.PreLodgement preLodgement){
		System.debug('preLodgeQuote [' + preLodgement.QuoteIdentifier + ']...');
		EricDTOs.ResponseDTO r = new EricDTOs.ResponseDTO();
		EricDTOs.Settings s = getSettings();
		preLodgement.QuoteGroupIdentifier = s.dealerId;
		System.debug('QuoteGroupIdentifier: ' + preLodgement.QuoteGroupIdentifier);
		String url = '/api/Lodgement/PreLodge';
		ConnectionRESTWs.Param p = getAuthRequestParam(url, true);
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.POST;
		p.requestHeader.put('Content-Type', 'application/json');
		p.body = JSON.serialize(preLodgement);
		HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
				r.preLodgementResponse = (EricDTOs.LodgementResponse)JSON.deserialize(res.getBody(), EricDTOs.LodgementResponse.class);
			} else {
				r.addErrorMessage('Status code: ' + res.getStatusCode(), 'Quote process has failed.');
				r.addErrorMessage('Provider Error', res.getBody());
				System.debug('Status code: ' + res.getStatusCode());
				System.debug('Body: ' + res.getBody());
			}
		} else {
			r.addErrorMessage('Quote process has failed. Salesforce could not receive a response from Eric system.');
		}		
		return r;
	}

	public static EricDTOs.ResponseDTO lodgeQuote(EricDTOs.Lodgement lodgement){
		System.debug('lodgeQuote [' + lodgement.QuoteIdentifier + ']...');
		EricDTOs.ResponseDTO r = new EricDTOs.ResponseDTO();
		EricDTOs.Settings s = getSettings();
		String url = '/api/Lodgement/Lodge';
		ConnectionRESTWs.Param p = getAuthRequestParam(url, true);
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.POST;
		p.requestHeader.put('Content-Type', 'application/json');
		p.body = JSON.serialize(lodgement);
		HttpResponse res = ConnectionRESTWs.invoke(p);
		if (res != null) {
			if (res.getStatusCode() == 200) {
				System.debug(res.getBody());
				r.lodgementResponse = (EricDTOs.LodgementResponse)JSON.deserialize(res.getBody(), EricDTOs.LodgementResponse.class);
			} else {
				r.addErrorMessage('Status code: ' + res.getStatusCode(), 'Quote process has failed.');
				r.addErrorMessage('Provider Error', res.getBody());
				System.debug('Status code: ' + res.getStatusCode());
				System.debug('Body: ' + res.getBody());
			}
		} else {
			r.addErrorMessage('Quote process has failed. Salesforce could not receive a response from Eric system.');
		}		
		return r;
	}

	public static HTTPResponse getPolicyDocument(String policyNumber){
		String url = '/api/Documentation/GetPolicySchedule?policyNumber=' + policyNumber;
		ConnectionRESTWs.Param p = getAuthRequestParam(url, true);
		if (p == null) {
			System.debug('TestPost... parameter not created');
			return null;
		}
		p.method = ConnectionRESTWs.GET;
		p.requestHeader.put('Content-Type', 'application/json');
		return ConnectionRESTWs.invoke(p);
	}

}