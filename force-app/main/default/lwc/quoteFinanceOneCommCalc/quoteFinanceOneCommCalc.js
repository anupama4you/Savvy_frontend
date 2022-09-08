import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; 
import { CalHelper } from "./quoteFinanceOneCommCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/FinanceOneLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteFinanceOneCommCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    isFullDofCalc = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage(); 
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @wire(getRecord, { recordId: "$recordId", fields }) 
    opp;

    connectedCallback() {
        this.isBusy = true;
        this.reset(); 
        CalHelper.goodsSubTypeOptions();
        CalHelper.load(this.recordId)
            .then((data) => {
            this.quoteForm = data;
            this.tableRates = CalHelper.getTableRatesData();
            })
            .catch((error) => {
            
            displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
            this.isBusy = false;
            this.baseRateCalc(); 
            this.commissionCalc();
            this.riskFeeCalc();
            });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this); 
    }
    //Images
    get logoUrl() {
        return LENDER_LOGO;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get goodTypeOptions() {
        return CalHelper.options.goodTypes;
    }

    get goodsSubTypeOptions() {
        
        return CalHelper.getGoodsSubTypeOptions(this.quoteForm.goodType);
    }

    get loanTypeDetailOptions() {
        return CalHelper.options.loanTypeDetails;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get propertyOwnerOptions() {
        return CalHelper.options.propertyOwners;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    // Calculations
    get netDeposit() {
        this.quoteForm.netDeposit = CalHelper.getNetDeposit(this.quoteForm);
        return this.quoteForm.netDeposit;
    }

    get netRealtimeNaf() {
        return CalHelper.getNetRealtimeNaf(this.quoteForm);      
    }
    
    get disableAction() {
        return !this.isCalculated;
    }

    // Reset
    reset() {
    
        this.quoteForm = CalHelper.reset(this.recordId); 
        
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
        .then((data) => {
            this.quoteForm.baseRate = data.baseRate;
            this.quoteForm.maxRate = data.maxRate;
            this.quoteForm.clientRate = data.clientRate;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Base Rate...", error, "error");
        })
        .finally(() => {
            this.isBaseRateBusy = false;
        });
    }

    //Commission
    commissionCalc(){
        console.log('commision::', JSON.stringify(this.quoteForm, null, 2));
        CalHelper.getFOCommission(this.quoteForm)
        .then((data) => {
            this.quoteForm.commission = data;
            console.log('commision::', this.quoteForm.commission);
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Commission...", error, "error");
        })
    }

    //Risk Fee
    riskFeeCalc(){
        CalHelper.getRiskCalc(this.quoteForm)
        .then((data) => {
            this.quoteForm.calcRiskFee = data;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Risk Fee...", error, "error");
        })
    }

    //DOF and Max DOF
    dofCalc(){
        CalHelper.getDOFCalc(this.quoteForm, this.isFullDofCalc)
        .then((data) => {
            this.quoteForm.dof = data.dof;
            this.quoteForm.maxDof = data.maxDof;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Risk Fee...", error, "error");
        })
    }

    //Application Fee
    appFeeCalc(){
        CalHelper.getAppFeeCalc(this.quoteForm)
        .then((data) => {
            this.quoteForm.applicationFee = data;  
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Application Fee...", error, "error");
        })
    }

    // -------------
    // Button events
    // -------------

    handleFieldChange(event) {
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        if (fld && fld.type === "number") {
        v = Number(v);
        }
        this.quoteForm[fldName] = v;
        this.quoteForm["netDeposit"] = this.netDeposit;
        fldName === "term"
        ? (this.quoteForm[fldName] = parseInt(v))
        : (this.quoteForm[fldName] = v); 

        if(fldName === "loanTypeDetail" && v === 'Silver'){
            this.quoteForm.riskFee = 1995;
        }else if(fldName === "loanTypeDetail" && v !== 'Silver'){
            this.quoteForm.riskFee = 0;
        }

        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc(); 
        }

        //Commission Calculation
        if (CalHelper.COMM_FIELDS.includes(fldName)) {
            this.commissionCalc(); 
        }

        //Risk Fee Calculation
        if (CalHelper.RISK_FEE_FIELDS.includes(fldName)) {
            this.riskFeeCalc(); 
        }

        //DOF Calculation
        if (CalHelper.DOF_Calc_Fields.includes(fldName)) {
            this.isFullDofCalc = true;
            this.dofCalc(); 
        }

        //Application Fee Calculation
        if (CalHelper.APPFEE_Calc_Fields.includes(fldName)) {
            this.appFeeCalc(); 
        }
    }

    // Calculate
    handleCalculate() {
        this.isBusy = true;
        this.messageObj = QuoteCommons.resetMessage();
        CalHelper.calculate(this.quoteForm)
        .then((data) => {
            
            this.quoteForm.commissions = data.commissions;
            this.messageObj = data.messages;
            QuoteCommons.handleHasErrorClassClear(this);
            if (this.quoteForm.commissions) this.isCalculated = true;
        })
        .catch((error) => {
            this.messageObj = error.messages;
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
        })
        .finally(() => {
            this.isBusy = false;
        });
    }

    // Reset
    handleReset() {
        const appQuoteId = this.quoteForm["Id"];
        this.reset();
        this.quoteForm["Id"] = appQuoteId;
        this.isCalculated = false;
        this.messageObj = QuoteCommons.resetMessage();
        QuoteCommons.handleHasErrorClassClear(this);
        
        this.baseRateCalc(); 
        this.commissionCalc();
        this.riskFeeCalc();
    }

    // all Save Buttons actions
    handleSave(event, saveType) {
        let isNONE;
        let loanType;
        if (event) {
            console.log(`event detail : ${event.target.value.toUpperCase()}`);
            isNONE = event.target.value.toUpperCase() === "NONE";
            loanType = event.target.value.toUpperCase();
        } else {
            loanType = saveType.toUpperCase();
        }
        console.log("save type => ", loanType);
        this.isBusy = true;
        if (!this.messageObj.errors.length > 0 || this.isErrorInsuranceOnly()) {
            this.messageObj = QuoteCommons.resetMessage();
            CalHelper.saveQuote(loanType, this.quoteForm, this.recordId)
                .then((data) => {
                    console.log("@@data in handleSave:", JSON.stringify(data, null, 2));
                    !isNONE
                        ? this.messageObj.confirms.push(
                            {
                                field: "confirms",
                                message: "Calculation saved successfully."
                            },
                            {
                                fields: "confirms",
                                message: "Product updated successfully."
                            }
                        )
                        : this.messageObj.confirms.push({
                            field: "confirms",
                            message: "Calculation saved successfully."
                        });
                    // passing data to update quoteform
                    this.quoteForm["Id"] = data["Id"];
                })
                .catch((error) => {
                    console.error("handleSave : ", error);
                })
                .finally(() => {
                    this.isBusy = false;
                    this.quoteForm.commissions.insurance =
                        loanType === "Send" ? 0.0 : this.quoteForm.commissions.insurance;
                });
        } else {
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            this.isCalculated = true;
        }
    }

    // Send Email
    handleSendQuote() {
        this.isBusy = true;
        if (!this.messageObj.errors.length > 0 || this.isErrorInsuranceOnly()) {
            this.messageObj = QuoteCommons.resetMessage();
            CalHelper.sendEmail(this.quoteForm, this.recordId)
                .then((data) => {
                    console.log(
                        "@@data in handle send quote :",
                        JSON.stringify(data, null, 2)
                    );
                    this.messageObj.infos.push({
                        field: "infos",
                        message: "Email has been sent to customer."
                    });
                })
                .catch((error) => {
                    console.error("handleSendQuote: ", error);
                })
                .finally(() => {
                    this.isBusy = false;
                });
        } else {
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            this.isCalculated = true;
        }
    }
}