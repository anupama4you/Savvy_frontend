import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; 
import { CalHelper } from "./quoteAzoraCommercialCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/AzoraLogo";
import ASSET_CATEGORY_IMAGE from "@salesforce/resourceUrl/AzoraAssetCategory";
import ADVERSE_IMAGE from "@salesforce/resourceUrl/AzoraAdverse";
import STREAMLINE_IMAGE from "@salesforce/resourceUrl/AzoraStreamline";
import KICKSTART_IMAGE from "@salesforce/resourceUrl/AzoraKickstart";

import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteAzoraCommercialCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    isFullDofCalc = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    @track tableRates;
    // Rate Settings
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;

    connectedCallback() {
        this.isBusy = true;
        this.reset();
        // CalHelper.goodsSubTypeOptions();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(' Data: ', JSON.stringify(data, null, 2));
                this.quoteForm = data;
                this.tableRates = CalHelper.getTableRatesData();
            })
            .catch((error) => {
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.calculateRates();
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

    get abnOptions() {
        return CalHelper.options.abns;
    }

    get gstOptions() {
        return CalHelper.options.gsts;
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

    get assetCateImage() {
        return ASSET_CATEGORY_IMAGE;
    }

    get adverseImage() {
        return ADVERSE_IMAGE;
    }

    get streamlineImage() {
        return STREAMLINE_IMAGE;
    }

    get kickstartImage() {
        return KICKSTART_IMAGE;
    }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
    }

    calculateRates() {
        this.baseRateCalc();
        this.brokerageCalc();
        this.commissionCalc();
        this.clientCalc();
        this.maxAppFeeCalc();
    }

    maxAppFeeCalc() {
        if (this.quoteForm.privateSales === 'Y') {
            this.quoteForm.maxApplicationFee = this.quoteForm.appFeePrevDefault;
        }
        else {
            this.quoteForm.maxApplicationFee = this.quoteForm.appFeeDefault;
        }
    }

    baseRateCalc() {
        const { loanTypeDetail, baseRates, addOnRate } = this.quoteForm;
        let amendedType = loanTypeDetail;
        // add greater 50K or less 50K into the type detail
        if (loanTypeDetail === 'Streamline') {
            const nafComm = CalHelper.getNafComm(this.quoteForm);
            let tempStatus = '';
            nafComm >= 50000 ? tempStatus = " > 50K" : tempStatus = " < 50K";
            amendedType = `${loanTypeDetail}` + `${tempStatus}`;
        }

        const deBaseRate = baseRates.find(obj => obj.hasOwnProperty(amendedType))[amendedType];
        this.quoteForm.baseRate = deBaseRate + addOnRate;
        // this.quoteForm.baseRate = baseRates.find(obj => obj.hasOwnProperty(amendedType))[amendedType];
    }

    brokerageCalc() {
        const nafComm = CalHelper.getNafComm(this.quoteForm);
        let rate = 10;
        rate = CalHelper.BROKERAGE_RANGE.find(brok => (nafComm >= brok.min && nafComm <= brok.max)).rate;
        this.quoteForm.maxBrok = rate;
    }

    clientCalc() {
        // const { brokerage, baseRate, baseRateManual, addOnRate } = this.quoteForm;
        // let clientRate = brokerage > 4 ? (brokerage - 4) : 0;
        // clientRate += baseRateManual == 0 ? baseRate : baseRateManual;
        // clientRate += parseFloat(addOnRate);
        // this.quoteForm.clientRate = clientRate;
        this.quoteForm.clientRate = CalHelper.getClientRateCalc(this.quoteForm);
    }

    //Commission
    commissionCalc() {
        console.log('commision::', JSON.stringify(this.quoteForm, null, 2));
        CalHelper.getFOCommission(this.quoteForm)
            .then((data) => {
                this.quoteForm.commission = data;
                console.log('commision::', this.quoteForm.commission);
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Commission...", error, "error");
            });
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
        // --------------
        // Trigger events
        // --------------

        this.calculateRates();

        //Commission Calculation
        if (CalHelper.COMM_FIELDS.includes(fldName)) {
            this.commissionCalc();
        }

        if (fldName === "privateSales") {
            if (v === 'Y') {
                this.quoteForm.applicationFee = this.quoteForm.appFeePrevDefault;
                this.quoteForm.maxApplicationFee = this.quoteForm.appFeePrevDefault;
            }
            // if (v === 'N') {
            else {
                this.quoteForm.applicationFee = this.quoteForm.appFeeDefault;
                this.quoteForm.maxApplicationFee = this.quoteForm.appFeeDefault;
            }
        }

        // Insurances
        QuoteCommons.calculateInsurances(this, fldName);
        // --------------
    }

    // Calculate
    handleCalculate(type) {
        this.isBusy = true;
        this.messageObj = QuoteCommons.resetMessage();
        CalHelper.calculate(this.quoteForm)
            .then((data) => {
                console.log("@@data:", JSON.stringify(data, null, 2));
                this.quoteForm.commissions = data.commissions;
                this.messageObj = data.messages;
                QuoteCommons.handleHasErrorClassClear(this);
                // --- insurance ---
                if (this.quoteForm.commissions && type != "load") {
                    this.isCalculated = true;
                    this.template.querySelector(
                        "c-quote-insurance-form"
                    ).isQuoteCalculated = true;
                }
                // --- insurance: end ---
            })
            .catch((error) => {
                if (type !== "load") {
                    this.messageObj = error.messages;
                    QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                    console.error(
                        "quotePepperMVCalc.js: get errors -- ",
                        JSON.stringify(error.messages.errors, null, 2)
                    );
                }
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
        this.calculateRates();


        // --- insurance ---
        this.template.querySelector("c-quote-insurance-form").resetPressed();
        // --- insurance: end ---
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
            // --- insurance ---
            loanType = saveType.toUpperCase();
            // --- insurance: end ---
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
                    // --- insurance ---
                    this.quoteForm.commissions.insurance =
                        loanType === "Send" ? 0.0 : this.quoteForm.commissions.insurance;
                    // --- insurance: end ---
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

    // --- insurance ---
    handleInsuranceMessage(event) {
        try {
            this.messageObj = QuoteCommons.resetMessage();
            this.messageObj.errors = [
                ...this.messageObj.errors,
                ...event.detail.errors
            ];
            console.log(
                "event.detail >> " + JSON.stringify(this.messageObj.errors, null, 2)
            );
        } catch (error) {
            console.error(error);
        }
    }

    isErrorInsuranceOnly() {
        let result = true;
        try {
            if (this.messageObj.errors && this.messageObj.errors.length > 0) {
                for (const error of this.messageObj.errors) {
                    if (error.field !== "insurance") {
                        return false;
                    }
                }
            }
            return result;
        } catch (error) {
            console.error(error);
        }
    }

    handleInsuranceChange(event) {
        this.quoteForm.insurance = event.detail;
        this.isCalculated = this.template.querySelector(
            "c-quote-insurance-form"
        ).isQuoteCalculated = false;

        // comprehensive
        const cms = QuoteCommons.handleComprehensive(this.quoteForm);
        this.quoteForm.commissions = { ...cms };
        // end - comprehensive
        console.log(
            "handle insurance change >>  " + JSON.stringify(this.quoteForm, null, 2)
        );
    }

    handleInsurancePresentation(event) {
        console.log(event.detail);
        this.handleSave(null, event.detail);
    }

    handleInsuanceLoad(event) {
        this.handleInsuranceChange(event);
        // check if there is no acceptance
        if (
            this.quoteForm.insurance.ismvAccept ||
            this.quoteForm.insurance.isshortfallAccept ||
            this.quoteForm.insurance.iswarrantyAccept ||
            this.quoteForm.insurance.isLPIAccept ||
            this.quoteForm.insurance.isIntegrityAccept
        ) {
            this.handleCalculate("load");
        } else {
            this.quoteForm.commissions = {
                ...this.quoteForm.commissions,
                insurances: null
            };
        }
        this.console.log(
            "handleInsuanceLoad>>",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    handleDisableButton(event) {
        this.isCalculated = event.detail;
    }
    // --- insurance: end ---
}