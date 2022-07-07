/**
 * @description       :
 * @author            : Contrivers
 * @group             :
 **/
public with sharing class BOQCalculatorCommercialHelper {
	public static final Integer STATUS_OK = 200;
	public static final Integer STATUS_REQUEST_VALIDATE = 400;
	public static final Integer STATUS_INTERNAL_ERROR = 510;
	public static final Integer STATUS_NOT_AUTHORIZED = 401;
	public static final Integer STATUS_UNAUTHORIZED_ACCESS = 403;
	public static final Integer STATUS_ENTITY_NOT_FOUND = 404;

	public static final String BEARER = 'Bearer ';
	public static final String ACCESS_TOKEN = 'access_token';
	public static final String AUTHORIZATION = 'Authorization';

	public static final String DOMAIN_ASSET_TYPE = 'ASSET_TYPE';
	public static final String LOAN_FREQUENCY = 'FREQUENCY_LOAN';

	public static final String TYPE_PERCENTAGE = 'Percentage';
	public static final String TYPE_VALUE = 'Value';

	public static final Set<String> ASSET_TYPE = new Set<String> {
		'Cars/Trucks',
		'Earthmoving',
		'Construction',
		'Agricultural',
		'Industrial Plant and Equipment'
	};
	public final String ERROR_MESSAGE_PRIVATE_SALE = 'Dealer transactions only';
	public final String ERROR_MESSAGE_NAF_EXCEEDED = 'NAF exceeds $100,000 - check with the lender';
	public final String ERROR_MESSAGE_NOT_OWNER = '20% deposit required for low doc non property owner';
	public Map<String, Map<String, Decimal> > mapAssetRates = new Map<String, Map<String, Decimal> >();
	public BOQCalculatorCommercialHelper() {
		getMapAssetRates();
	}
	public Map<String, Map<String, Decimal> > getMapAssetRates() {
		for (BOQCommercialConfigs__mdt config : [
			     SELECT Name__c, value__c, AssetType__c
			     FROM BOQCommercialConfigs__mdt
			     WHERE ConfigType__c = 'InterestRate'
		     ]) {
			Map<String, Decimal> mapRate = new Map<String, Decimal>();
			if (mapAssetRates.containsKey(config.Name__c)) {
				mapRate = mapAssetRates.get(config.Name__c);
			}
			mapRate.put(config.AssetType__c, config.Value__c);
			mapAssetRates.put(config.Name__c, mapRate);
		}
		return mapAssetRates;
	}
	/**
	 * @description get interset rates
	 * @author Girish P | 08-08-2021
	 * @return Decimal
	 **/
	public Decimal getInterestRates(String asset, String type) {
		Decimal rate;
		System.debug('asset*****'+asset);
		System.debug('mapAssetRates*****'+mapAssetRates);
		System.debug('type*****'+type);
        return mapAssetRates.containsKey(asset) &&
            mapAssetRates.get(asset).containsKey(type)
            ? mapAssetRates.get(asset).get(type)
            : 0;
    }
    public void addError(String message) {
        ApexPages.addMessage(
            new ApexPages.Message(ApexPages.Severity.ERROR, message)
        );
    }
}