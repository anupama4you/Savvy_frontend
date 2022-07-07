public with sharing class InsuranceQuoteStep3Extension {

	private final Custom_Opportunity__c o;
	public Application_InsuranceQuote__c quote {set;get;}
	public Application_Quoting__c quoting {set;get;}

	private Map<Integer, Decimal> mvExcessOptions;
	public Integer standardExcessSelected {set;get;}
	public Glass_Variant__c glassVariant {set;get;}
	
    public InsuranceQuoteStep3Extension(ApexPages.StandardController ctrl) {
        this.o = (Custom_Opportunity__c)ctrl.getRecord();
        this.loadData();
    }

	public PageReference goToEditCoverTypes() {
		PageReference n = Page.InsuranceQuoteStep1;
        n.getParameters().put('id', this.o.Id);
        return n;
	}

	public PageReference goToEditCoverInformation() {
		PageReference n = Page.InsuranceQuoteStep2;
        n.getParameters().put('id', this.o.Id);
        return n;
	}

	public PageReference goToQuotingTool() {
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> this.quote.Financier_Name__c ' + this.quote.Financier_Name__c);
        return InsuranceQuoteUtils.goToQuotingTool(this.o.Id,this.quote.Financier_Name__c);
	}

	public PageReference importQuote() {
		InsuranceQuoteUtils.importQuoteInQuotingTool(this.quote.Id, this.o.Id, '', this.quoting);
		return goToQuotingTool();
	}

	//Lelo 				Insurance 			2018-03-22
	private void loadData() {
		this.loadVehicleVariant();
		String paramTmp = System.currentPageReference().getParameters().get('C');
		this.quoting = QuotingToolHelper.getApplicationQuoting(this.o.Id, this.o.Application__c);
		if ('N'.equals(paramTmp)) {
			this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteReceived(this.o.Application__c);
		} else if (this.quoting != null && this.quoting.App_Insurance_Quote__c != null) {
			this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteById(this.quoting.App_Insurance_Quote__c);
		} else {
			this.quote = InsuranceQuoteUtils.getApplicationInsuranceQuoteReceived(this.o.Application__c);
		}
        standardExcessSelected = 0;
		mvExcessOptions = new Map<Integer, Decimal>();
		if (this.quote == null) return;
		//Motor Vehicle options
		if (String.isNotBlank(this.quote.Motor_Vehicle__c)) {
			//Load exces options
			String opts = this.quote.MV_Basic_Excess_Options__c;
			if (String.isNotBlank(opts)) {
				opts = opts.remove('[').remove(']');
				String[] excess = opts.split(',');
				Integer i = 0;
				for (String e : excess) {
					Decimal v = NumberUtils.convertToDecimal(e, false);
					if (v == this.quote.MV_Standard_Excess__c) {
						standardExcessSelected = i;
					}
					mvExcessOptions.put(i, v);+i++;
				}
			}
		}
	}

	public List<SelectOption> getExcessOptions() {
		List<SelectOption> r = new List<SelectOption>();
		for (Integer i : mvExcessOptions.keySet()) {
			r.add(new SelectOption(String.valueOf(i), mvExcessOptions.get(i).setScale(0).format()));
		}
		return r;
	}

	public String getMinAmountCovered() {
		return this.quote.MV_Amount_Covered_Min__c.format();
	}

	public String getMaxAmountCovered() {
		return this.quote.MV_Amount_Covered_Max__c.format();
	}

	private Boolean isValidForSubmission() {
		Boolean r = true;
		if (this.quote.MV_Amount_Covered__c == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Please fill Your Amount Covered.'));
			r = false;
		} else if (this.quote.MV_Amount_Covered__c < this.quote.MV_Amount_Covered_Min__c || 
			       this.quote.MV_Amount_Covered__c > this.quote.MV_Amount_Covered_Max__c) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Your Amount Covered must be between $' + getMinAmountCovered() + ' and $' + getMaxAmountCovered()));
			r = false;
		}
		return r;
	}

	public void applyMV() {
        if (isValidForSubmission()) {
        	this.quote.Vehicle_Condition__c = InsuranceQuoteUtils.getVehicleCondition(this.o.Application_AssetDetail__r.Condition__c);
	        this.quote.Odometer__c = this.o.Application_AssetDetail__r.Actual_KM__c;
	        this.quote.Vehicle_Date_First_Registered__c = this.o.Application_AssetDetail__r.Date_First_Registered__c;
	        this.quote.Vehicle_Type__c = InsuranceQuoteUtils.getVehicleType(this.o.Application_AssetDetail__r.Type__c);
	        if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
	            this.quote.Vehicle_Make__c = this.getVehicleMake().Name;
	            this.quote.Vehicle_Model__c = this.glassVariant.Family__c;
	        } else {
	            this.quote.Vehicle_Make__c = this.o.Application_AssetDetail__r.Make__c;
	            this.quote.Vehicle_Model__c  = this.o.Application_AssetDetail__r.Model__c;
	        }

	        if (String.isNotBlank(this.o.Application_AssetDetail__r.Redbook_Key__c)) {
	            this.quote.Redbook_Key__c = this.o.Application_AssetDetail__r.Redbook_Key__c;    
	        } else {
	            if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
	                this.quote.Redbook_Key__c = this.glassVariant.NVIC__c;
	            }
	        }
	        if (this.o.Application__r.Postcode__c != null && this.o.Application__r.Postcode__c.isNumeric()) {
	            this.quote.Vehicle_Location_Postcode__c = Integer.valueOf(this.o.Application__r.Postcode__c);
	        }
	        this.quote.Vehicle_Location_Suburb__c = this.o.Application__r.Suburb__c;
	        this.quote.Vehicle_Location_State__c = this.o.Application__r.State__c;
	        this.quote.Vehicle_Usage__c = this.getVehicleUsage();
	        this.quote.Amount_Financed__c = this.quoting.NAF__c;
	        this.quote.Finance_Term__c = this.quoting.Term__c;
	        this.quote.Financier_Id__c = InsuranceQuoteUtils.getFinancierId(this.quoting.Name);
	        this.quote.Financier_Name__c = this.quoting.Name;
	        this.quote.Vehicle_Purchase_Price__c = this.quoting.Vehicle_Price__c;
            try {
                System.debug('Invoking WS...');
                //Setting values
                this.quote.MV_Standard_Excess__c = mvExcessOptions.get(this.standardExcessSelected);
                InsuranceQuoteWS.QuoteParam param = new InsuranceQuoteWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote; 
                param.quoting = this.quoting;
                if (!Test.isRunningTest()) {
                    InsuranceQuoteWS.getQuote(param);
                }
                InsuranceQuoteUtils.importQuoteInQuotingTool(this.quote.Id, this.o.Id);
                loadData();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote updated successfully.'));
            } catch (Exception e) {
                if(e.getMessage().contains('Unable to locate a vehicle')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }
        }
    }

    public void applyRestMV() {
        if (isValidForSubmission()) {
        	this.quote.Vehicle_Condition__c = InsuranceQuoteUtils.getVehicleCondition(this.o.Application_AssetDetail__r.Condition__c);
	        this.quote.Odometer__c = this.o.Application_AssetDetail__r.Actual_KM__c;
	        this.quote.Vehicle_Date_First_Registered__c = this.o.Application_AssetDetail__r.Date_First_Registered__c;
	        this.quote.Vehicle_Type__c = InsuranceQuoteUtils.getVehicleType(this.o.Application_AssetDetail__r.Type__c);
	        if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
	            this.quote.Vehicle_Make__c = this.getVehicleMake().Name;
	            this.quote.Vehicle_Model__c = this.glassVariant.Family__c;
	        } else {
	            this.quote.Vehicle_Make__c = this.o.Application_AssetDetail__r.Make__c;
	            this.quote.Vehicle_Model__c  = this.o.Application_AssetDetail__r.Model__c;
	        }

	        if (String.isNotBlank(this.o.Application_AssetDetail__r.Redbook_Key__c)) {
	            this.quote.Redbook_Key__c = this.o.Application_AssetDetail__r.Redbook_Key__c;    
	        } else {
	            if ('Car'.equals(this.o.Application_AssetDetail__r.Type__c)) {
	                this.quote.Redbook_Key__c = this.glassVariant.NVIC__c;
	            }
	        }
	        if (this.o.Application__r.Postcode__c != null && this.o.Application__r.Postcode__c.isNumeric()) {
	            this.quote.Vehicle_Location_Postcode__c = Integer.valueOf(this.o.Application__r.Postcode__c);
	        }
	        this.quote.Vehicle_Location_Suburb__c = this.o.Application__r.Suburb__c;
	        this.quote.Vehicle_Location_State__c = this.o.Application__r.State__c;
	        this.quote.Vehicle_Usage__c = this.getVehicleUsage();
	        this.quote.Amount_Financed__c = this.quoting.NAF__c;
	        this.quote.Finance_Term__c = this.quoting.Term__c;
	        this.quote.Financier_Id__c = InsuranceQuoteUtils.getFinancierId(this.quoting.Name);
	        this.quote.Financier_Name__c = this.quoting.Name;
	        this.quote.Vehicle_Purchase_Price__c = this.quoting.Vehicle_Price__c;
            try {
                System.debug('Invoking WS...');
                //Setting values
                this.quote.MV_Standard_Excess__c = mvExcessOptions.get(this.standardExcessSelected);
                
                InsuranceQuoteRestWS.QuoteParam param = new InsuranceQuoteRestWS.QuoteParam();
                param.opp = this.o;
                param.quote = this.quote;
                param.quoting = this.quoting;
                
                Map<String, List<String>> msgList = null;
                if (!Test.isRunningTest()) {
                    msgList = InsuranceQuoteRestWS.getQuote(param);
                }
                if (msgList != null && msgList.containsKey('Error')) {
                    for (String msg : msgList.get('Error')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                    }
                } else {
                    InsuranceQuoteUtils.importQuoteInQuotingTool(this.quote.Id, this.o.Id);
	                loadData();
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quote updated successfully.'));
                }
            } catch (Exception e) {
                if(e.getMessage().contains('Unable to locate a vehicle')) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                        'Vehicle Details: Web service was unable to locate a vehicle from the Glass Service NVIC Code provided. Please try with a RedBook Key for this quote.'));
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }
        }
    }

    public Glass_Make__c getVehicleMake() {
        Glass_Make__c r = null;
        if (this.o.Application_AssetDetail__c != null) {
            r = GlassServicesHelper.getMakeByCode(this.o.Application_AssetDetail__r.Make__c);
        }
        return r;
    }

    // public Glass_Model__c getVehicleModel() {
    //     Glass_Model__c r = null;
    //     if (this.o.Application_AssetDetail__c != null) {
    //         r = GlassServicesHelper.getModelByCode(this.o.Application_AssetDetail__r.Model__c);
    //     }
    //     return r;
    // }    

    // public Glass_Variant__c getVehicleVariant() {
    //     Glass_Variant__c r = null;
    //     if (this.o.Application_AssetDetail__c != null) {
    //         r = GlassServicesHelper.getVariantByCode(this.o.Application_AssetDetail__r.Variant__c);
    //     }
    //     return r;
    // }

    public String getVehicleUsage() {
        return InsuranceQuoteUtils.getUsage(this.o.Application__r.Application_Type__c);
    }
	//-

	public void loadVehicleVariant() {
        this.glassVariant = null;
        if (this.o.Application_AssetDetail__c != null) {
            this.glassVariant = GlassServicesHelper.getVariantByCode(this.o.Application_AssetDetail__r.Variant__c);
        }
    }
}