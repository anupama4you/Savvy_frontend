public with sharing class PrivateSalesTaxInvoiceDetailsExtension {

    private Custom_Opportunity__c opp;
	private Application_Asset_Detail__c asset;
    public Glass_Variant__c variantObj {get;set;}

    public PrivateSalesTaxInvoiceDetailsExtension(ApexPages.StandardController ctrl) {
        this.opp = (Custom_Opportunity__c)ctrl.getRecord ();
        if (this.opp.Application_AssetDetail__r != null) {
            this.asset = this.opp.Application_AssetDetail__r;
            if (this.asset != null) {
                variantObj = GlassServicesHelper.getVariantByCode(this.asset.Variant__c);
            }
        }
        preLoadData();
    }

    public void preLoadData() {
        String r = 'One(1) ';
        if (this.asset != null && String.isBlank(this.asset.Invoice_Description__c)) {
            r += ' ' + this.asset.Type__c;
            r += ' ' + this.asset.Condition__c;
            r += ' ' + this.asset.Year__c;
            if ('Car'.equalsIgnoreCase(this.asset.Type__c)) {
                if (this.variantObj != null) {
                    r += ' ' + this.variantObj.Description__c;   
                }
            } else {
                r += ' ' + this.asset.Make__c;
                r += ' ' + this.asset.Model__c;
                r += ' ' + this.asset.Variant__c;
                r += ' ' + this.asset.Series__c;
            }
            this.asset.Invoice_Description__c = r;
        }
        if (this.opp.Tax_Invoice_Deposit__c == null || this.opp.Tax_Invoice_Deposit__c == 0) {
            if (this.opp.Loan_Product__r.Deposit__c != null) {
                this.opp.Tax_Invoice_Deposit__c = this.opp.Loan_Product__r.Deposit__c;
            } else {
                this.opp.Tax_Invoice_Deposit__c = 0;
            }
        }
        //if (this.opp.Tax_Invoice_Amount__c == null || this.opp.Tax_Invoice_Amount__c == 0) {
            if (this.opp.Loan_Product__r.Cost_of_Goods__c != null) {
                this.opp.Tax_Invoice_Amount__c = this.opp.Loan_Product__r.Cost_of_Goods__c;
                adjustInvoiceAmount(true);
            }
        //}
        //return r;
    }

    public void recalculateFormulas() {
        //this.opp.recalculateFormulas();
    }

    public Decimal getTotalGoods() {
        Decimal r = 0.0;
        if (this.opp.Loan_Product__r.Cost_of_Goods__c != null) {
            r = this.opp.Loan_Product__r.Cost_of_Goods__c;
        }
        //if (this.opp.Tax_Invoice_Amount__c != null) {
        //    r += this.opp.Tax_Invoice_Amount__c;
        //}
        //if (this.opp.Is_Vendor_Company__c) {
        //    r += getGstGoods();
        //}
        if (this.opp.Tax_Invoice_Deposit__c != null) {
            r -= this.opp.Tax_Invoice_Deposit__c;
        }
        if (this.opp.Tax_Invoice_Deposit_2__c != null) {
            r -= this.opp.Tax_Invoice_Deposit_2__c;
        }
        return r;
    }

    public Decimal getGstGoods() {
        Decimal r = 0.0;
        if (this.opp.Is_Vendor_Company__c) {
            if (this.opp.Tax_Invoice_Amount__c != null) {
                //r = this.opp.Tax_Invoice_Amount__c - (this.opp.Tax_Invoice_Amount__c/1.1);
                r = this.opp.Tax_Invoice_Amount__c * 0.11;
                r = r.setScale(2);
            }
        }
        return r;
    }

    public void adjustInvoiceAmount() {
        adjustInvoiceAmount(false);
    }

    private void adjustInvoiceAmount(Boolean isLoading) {
        if (this.opp.Is_Vendor_Company__c) {
            if (this.opp.Tax_Invoice_Amount__c != null) {
                this.opp.Tax_Invoice_Amount__c = this.opp.Tax_Invoice_Amount__c / 1.11;
                this.opp.Tax_Invoice_Amount__c = this.opp.Tax_Invoice_Amount__c.setScale(2);
            }
        } else {
            if (this.opp.Tax_Invoice_Amount__c != null && !isLoading) {
                this.opp.Tax_Invoice_Amount__c = this.opp.Tax_Invoice_Amount__c * 1.11;
                this.opp.Tax_Invoice_Amount__c = this.opp.Tax_Invoice_Amount__c.setScale(2);
            }
        }
    }

    public Boolean isValidForm() {
        //Application Form
        if (this.opp.Application__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Application Form must be created.'));
            return false;
        }
        if (this.opp.Loan_Product__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Loan Product must be asociated.'));
            return false;
        }
        if (this.opp.Application_AssetDetail__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Asset Details - LTV must be saved.'));
            return false;
        }
        Boolean r = true;
        //Vendor
        if (this.opp.Is_Vendor_Company__c) {
            if (String.isBlank(this.opp.Vendor_ABN__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the ABN field.'));
                r = false;   
            }
            //if (this.opp.Tax_Invoice_GST__c == null) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the GST field.'));
            //    r = false;   
            //} else if (this.opp.Tax_Invoice_GST__c == 0) {
            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The GST field is $0.00 and vendor is ticked as a company'));
            //}
        }
        //description
        if (String.isBlank(this.asset.Invoice_Description__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the Description field.'));
            r = false;   
        }
        if (String.isBlank(this.asset.Rego__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the Rego No. field.'));
            r = false;   
        }
        if (String.isBlank(this.asset.VIN__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the VIN field.'));
            r = false;   
        } else if (this.asset.VIN__c.length() != 17) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'The VIN migth usually contain 17 characters'));
        }
        if (String.isBlank(this.asset.Engine_No__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the Engine No. field.'));
            r = false;   
        }
        if (this.asset.Actual_KM__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the Odometer field.'));
            r = false;   
        }
        //Disbursement
        //if (String.isBlank(this.opp.Financier__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the Financier field.'));
        //    r = false;
        //}
        //if (String.isBlank(this.opp.Account_Name_1__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the first Account Name field.'));
        //    r = false;   
        //}
        //if (String.isBlank(this.opp.account_bsb_1__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the first Account BSB field.'));
        //    r = false;   
        //} else {
        //    if (this.opp.account_bsb_1__c.length() < 6) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The first Account BSB field must contain 6 numbers.'));
        //        r = false; 
        //    }
        //}
        //if (String.isBlank(this.opp.Account_Number_1__c)) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the first Account Number field.'));
        //    r = false;   
        //} else {
        //    if (this.opp.Account_Number_1__c.length() < 9) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The first Account Number field must contain 9 numbers.'));
        //        r = false; 
        //    }
        //}

        Decimal disbursement = 0;
        if (this.opp.Account_Amount_1__c == null || this.opp.Account_Amount_1__c == 0) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the first Account Amount field.'));
            //r = false; 
        } else {
            disbursement = this.opp.Account_Amount_1__c;
        }

        //Second Account
        //if (!String.isBlank(this.opp.Account_Name_2__c) ||
        //    !String.isBlank(this.opp.account_bsb_2__c) ||
        //    !String.isBlank(this.opp.Account_Number_2__c) ||
        //    (this.opp.Account_Amount_2__c != null && this.opp.Account_Amount_2__c > 0)) {

        //    if (String.isBlank(this.opp.Account_Name_2__c)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the second Account Name field.'));
        //        r = false;   
        //    }
        //    if (String.isBlank(this.opp.account_bsb_2__c)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the second Account BSB field.'));
        //        r = false;   
        //    } else {
        //        if (this.opp.account_bsb_2__c.length() < 6) {
        //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The second Account BSB field must contain 6 numbers.'));
        //            r = false; 
        //        }
        //    }
        //    if (String.isBlank(this.opp.Account_Number_2__c)) {
        //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the second Account Number field.'));
        //        r = false;   
        //    } else {
        //        if (this.opp.Account_Number_2__c.length() < 9) {
        //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The second Account Number field must contain 9 numbers.'));
        //            r = false; 
        //        }
        //    }
            if (this.opp.Account_Amount_2__c == null || this.opp.Account_Amount_2__c == 0) {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Plese fill the second Account Amount field.'));
                //r = false; 
            } else {
                disbursement += this.opp.Account_Amount_2__c;
            }
        //}


        if (disbursement.setScale(2) != getTotalGoods().setScale(2)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The total value of Goods does not equal the total of the Disbursement, please check out it before saving.'));
            r = false; 
        }

        return r;
    }

    public void saveData() {
        if (isValidForm()) {
            save();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Data has been saved.'));
        }
    }

    private void save() {
        if (this.opp.Is_Vendor_Company__c) {
            this.opp.Tax_Invoice_GST__c = getGstGoods();
        } else {
            this.opp.Tax_Invoice_GST__c = null;
        }
        this.opp.Tax_Invoice_Total__c = this.getTotalGoods();
        update asset;
        update opp;
    }

}