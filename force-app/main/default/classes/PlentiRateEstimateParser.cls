public class PlentiRateEstimateParser {

	public class AdditionalInformation {
		public String AppRequiresFSRConsideration {get;set;} 
		public String vehiclepurchaseprice {get;set;} 
		public String isCaravanBroker {get;set;} 
		public String canUseFlex {get;set;} 
		public String canUseAutoPremiumBucket {get;set;} 

		public AdditionalInformation(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'AppRequiresFSRConsideration') {
							AppRequiresFSRConsideration = parser.getText();
						} else if (text == 'vehiclepurchaseprice') {
							vehiclepurchaseprice = parser.getText();
						} else if (text == 'isCaravanBroker') {
							isCaravanBroker = parser.getText();
						} else if (text == 'canUseFlex') {
							canUseFlex = parser.getText();
						} else if (text == 'canUseAutoPremiumBucket') {
							canUseAutoPremiumBucket = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AdditionalInformation consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProductQuotes {
		public Integer productId {get;set;} 
		public String name {get;set;} 
		public String description {get;set;} 
		public Integer term {get;set;} 
		public Double loanAmount {get;set;} 
		public Double annualRate {get;set;} 
		public Double financierRate {get;set;} 
		public String rateType {get;set;} 
		public Double repayment {get;set;} 
		public String repaymentFrequency {get;set;} 
		public Double totalRepaid {get;set;} 
		public Double effectiveRate {get;set;} 
		public Double asicComparisonRate {get;set;} 
		public List<UpfrontFees> upfrontFees {get;set;} 
		public List<RepaymentFees> repaymentFees {get;set;} 
		public Double balloonAmount {get;set;} 
		public Double balloonPercentage {get;set;} 
		public Object paymentSchedule {get;set;} 
		public Object fullPaymentSchedule {get;set;} 

		public ProductQuotes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'productId') {
							productId = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'term') {
							term = parser.getIntegerValue();
						} else if (text == 'loanAmount') {
							loanAmount = parser.getDoubleValue();
						} else if (text == 'annualRate') {
							annualRate = parser.getDoubleValue();
						} else if (text == 'financierRate') {
							financierRate = parser.getDoubleValue();
						} else if (text == 'rateType') {
							rateType = parser.getText();
						} else if (text == 'repayment') {
							repayment = parser.getDoubleValue();
						} else if (text == 'repaymentFrequency') {
							repaymentFrequency = parser.getText();
						} else if (text == 'totalRepaid') {
							totalRepaid = parser.getDoubleValue();
						} else if (text == 'effectiveRate') {
							effectiveRate = parser.getDoubleValue();
						} else if (text == 'asicComparisonRate') {
							asicComparisonRate = parser.getDoubleValue();
						} else if (text == 'upfrontFees') {
							upfrontFees = arrayOfUpfrontFees(parser);
						} else if (text == 'repaymentFees') {
							repaymentFees = arrayOfRepaymentFees(parser);
						} else if (text == 'balloonAmount') {
							balloonAmount = parser.getDoubleValue();
						} else if (text == 'balloonPercentage') {
							balloonPercentage = parser.getDoubleValue();
						} else if (text == 'paymentSchedule') {
							paymentSchedule = parser.readValueAs(Object.class);
						} else if (text == 'fullPaymentSchedule') {
							fullPaymentSchedule = parser.readValueAs(Object.class);
						} else {
							System.debug(LoggingLevel.WARN, 'ProductQuotes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RepaymentFees {

		public RepaymentFees(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'RepaymentFees consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UpfrontFees {
		public String name {get;set;} 
		public Double amount {get;set;} 
		public String feeType {get;set;} 

		public UpfrontFees(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'amount') {
							amount = parser.getDoubleValue();
						} else if (text == 'feeType') {
							feeType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UpfrontFees consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String quoteCreated {get;set;} 
	public Double amountRequested {get;set;} 
	public List<ProductQuotes> productQuotes {get;set;} 
	public AdditionalInformation additionalInformation {get;set;} 

	public PlentiRateEstimateParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'quoteCreated') {
						quoteCreated = parser.getText();
					} else if (text == 'amountRequested') {
						amountRequested = parser.getDoubleValue();
					} else if (text == 'productQuotes') {
						productQuotes = arrayOfProductQuotes(parser);
					} else if (text == 'additionalInformation') {
						additionalInformation = new AdditionalInformation(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'PlentiRateEstimateParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static PlentiRateEstimateParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new PlentiRateEstimateParser(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<UpfrontFees> arrayOfUpfrontFees(System.JSONParser p) {
        List<UpfrontFees> res = new List<UpfrontFees>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new UpfrontFees(p));
        }
        return res;
    }

    private static List<RepaymentFees> arrayOfRepaymentFees(System.JSONParser p) {
        List<RepaymentFees> res = new List<RepaymentFees>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new RepaymentFees(p));
        }
        return res;
    }

    private static List<ProductQuotes> arrayOfProductQuotes(System.JSONParser p) {
        List<ProductQuotes> res = new List<ProductQuotes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ProductQuotes(p));
        }
        return res;
    }
    
   private static  void testParse() {
		String json = '{'+
		'    \"quoteCreated\": \"2022-10-09T04:50:42.5314544Z\",'+
		'    \"amountRequested\": 35000.0,'+
		'    \"productQuotes\": ['+
		'        {'+
		'            \"productId\": 8,'+
		'            \"name\": \"1 Year Loan\",'+
		'            \"description\": \"Variable rate 1 year loan\",'+
		'            \"term\": 12,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 8.09,'+
		'            \"financierRate\": 8.09,'+
		'            \"rateType\": \"Variable\",'+
		'            \"repayment\": 3106.89,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 37282.68,'+
		'            \"effectiveRate\": 11.92,'+
		'            \"asicComparisonRate\": 9.47,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 41,'+
		'            \"name\": \"2 Year Loan Product\",'+
		'            \"description\": \"Variable rate 2 year loan.\",'+
		'            \"term\": 24,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 8.09,'+
		'            \"financierRate\": 8.09,'+
		'            \"rateType\": \"Variable\",'+
		'            \"repayment\": 1616.03,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 38784.72,'+
		'            \"effectiveRate\": 10.11,'+
		'            \"asicComparisonRate\": 9.47,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 11,'+
		'            \"name\": \"3 Year Loan\",'+
		'            \"description\": \"Fixed rate 3 year loan\",'+
		'            \"term\": 36,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 8.09,'+
		'            \"financierRate\": 8.09,'+
		'            \"rateType\": \"Fixed\",'+
		'            \"repayment\": 1120.16,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 40325.76,'+
		'            \"effectiveRate\": 9.47,'+
		'            \"asicComparisonRate\": 9.47,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 12,'+
		'            \"name\": \"4 Year Loan\",'+
		'            \"description\": \"Fixed rate 4 year loan\",'+
		'            \"term\": 48,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 8.09,'+
		'            \"financierRate\": 8.09,'+
		'            \"rateType\": \"Fixed\",'+
		'            \"repayment\": 873.03,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 41905.44,'+
		'            \"effectiveRate\": 9.1,'+
		'            \"asicComparisonRate\": 8.92,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 13,'+
		'            \"name\": \"5 Year Loan\",'+
		'            \"description\": \"Fixed rate 5 year loan\",'+
		'            \"term\": 60,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 8.09,'+
		'            \"financierRate\": 8.09,'+
		'            \"rateType\": \"Fixed\",'+
		'            \"repayment\": 725.39,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 43523.40,'+
		'            \"effectiveRate\": 8.92,'+
		'            \"asicComparisonRate\": 8.92,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 60,'+
		'            \"name\": \"Warehouse Loan 72 Month Personal and Renewable\",'+
		'            \"description\": \"72 Month Personal and Renewable Warehouse Loan\",'+
		'            \"term\": 72,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 9.89,'+
		'            \"financierRate\": 9.89,'+
		'            \"rateType\": \"Fixed\",'+
		'            \"repayment\": 659.38,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 47475.36,'+
		'            \"effectiveRate\": 10.66,'+
		'            \"asicComparisonRate\": 10.75,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        },'+
		'        {'+
		'            \"productId\": 62,'+
		'            \"name\": \"Warehouse Loan 84 Month Personal and Renewable\",'+
		'            \"description\": \"84 Month Personal and Renewable Warehouse Loan\",'+
		'            \"term\": 84,'+
		'            \"loanAmount\": 35699.0,'+
		'            \"annualRate\": 9.89,'+
		'            \"financierRate\": 9.89,'+
		'            \"rateType\": \"Fixed\",'+
		'            \"repayment\": 590.62,'+
		'            \"repaymentFrequency\": \"Monthly\",'+
		'            \"totalRepaid\": 49612.08,'+
		'            \"effectiveRate\": 10.57,'+
		'            \"asicComparisonRate\": 10.75,'+
		'            \"upfrontFees\": ['+
		'                {'+
		'                    \"name\": \"Credit Assistance Fee\",'+
		'                    \"amount\": 699.0,'+
		'                    \"feeType\": \"CreditAssistanceFee\"'+
		'                }'+
		'            ],'+
		'            \"repaymentFees\": [],'+
		'            \"balloonAmount\": 0.0,'+
		'            \"balloonPercentage\": 0.0,'+
		'            \"paymentSchedule\": null,'+
		'            \"fullPaymentSchedule\": null'+
		'        }'+
		'    ],'+
		'    \"additionalInformation\": {'+
		'        \"AppRequiresFSRConsideration\": \"true\",'+
		'        \"vehiclepurchaseprice\": \"35000\",'+
		'        \"isCaravanBroker\": \"True\",'+
		'        \"canUseFlex\": \"false\",'+
		'        \"canUseAutoPremiumBucket\": \"true\"'+
		'    }'+
		'}';
		PlentiRateEstimateParser r = PlentiRateEstimateParser.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PlentiRateEstimateParser.AdditionalInformation objAdditionalInformation = new PlentiRateEstimateParser.AdditionalInformation(System.JSON.createParser(json));
		System.assert(objAdditionalInformation != null);
		System.assert(objAdditionalInformation.AppRequiresFSRConsideration == null);
		System.assert(objAdditionalInformation.vehiclepurchaseprice == null);
		System.assert(objAdditionalInformation.isCaravanBroker == null);
		System.assert(objAdditionalInformation.canUseFlex == null);
		System.assert(objAdditionalInformation.canUseAutoPremiumBucket == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PlentiRateEstimateParser.ProductQuotes objProductQuotes = new PlentiRateEstimateParser.ProductQuotes(System.JSON.createParser(json));
		System.assert(objProductQuotes != null);
		System.assert(objProductQuotes.productId == null);
		System.assert(objProductQuotes.name == null);
		System.assert(objProductQuotes.description == null);
		System.assert(objProductQuotes.term == null);
		System.assert(objProductQuotes.loanAmount == null);
		System.assert(objProductQuotes.annualRate == null);
		System.assert(objProductQuotes.financierRate == null);
		System.assert(objProductQuotes.rateType == null);
		System.assert(objProductQuotes.repayment == null);
		System.assert(objProductQuotes.repaymentFrequency == null);
		System.assert(objProductQuotes.totalRepaid == null);
		System.assert(objProductQuotes.effectiveRate == null);
		System.assert(objProductQuotes.asicComparisonRate == null);
		System.assert(objProductQuotes.upfrontFees == null);
		System.assert(objProductQuotes.repaymentFees == null);
		System.assert(objProductQuotes.balloonAmount == null);
		System.assert(objProductQuotes.balloonPercentage == null);
		System.assert(objProductQuotes.paymentSchedule == null);
		System.assert(objProductQuotes.fullPaymentSchedule == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PlentiRateEstimateParser.RepaymentFees objRepaymentFees = new PlentiRateEstimateParser.RepaymentFees(System.JSON.createParser(json));
		System.assert(objRepaymentFees != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PlentiRateEstimateParser.UpfrontFees objUpfrontFees = new PlentiRateEstimateParser.UpfrontFees(System.JSON.createParser(json));
		System.assert(objUpfrontFees != null);
		System.assert(objUpfrontFees.name == null);
		System.assert(objUpfrontFees.amount == null);
		System.assert(objUpfrontFees.feeType == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		PlentiRateEstimateParser objPlentiRateEstimateParser = new PlentiRateEstimateParser(System.JSON.createParser(json));
		System.assert(objPlentiRateEstimateParser != null);
		System.assert(objPlentiRateEstimateParser.quoteCreated == null);
		System.assert(objPlentiRateEstimateParser.amountRequested == null);
		System.assert(objPlentiRateEstimateParser.productQuotes == null);
		System.assert(objPlentiRateEstimateParser.additionalInformation == null);
	}
}