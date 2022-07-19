import { LightningElement, api, track, wire } from "lwc";
import { displayToast } from "c/partnerJsUtils";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteWisrPLCalcHelper";
import LENDER_LOGO from "@salesforce/resourceUrl/WisrLogo";
import FNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_First_Name__c";
import LNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Account_Last_Name__c";
import OPPNAME_FIELD from "@salesforce/schema/Custom_Opportunity__c.Name";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const fields = [FNAME_FIELD, LNAME_FIELD, OPPNAME_FIELD];

export default class QuoteWisrPLCalc extends LightningElement {
    tableRatesCols = CalHelper.tableRateDataColumns;
    tableFeesCols = CalHelper.tableFeeDataColumns;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    @api recordId; // Opportunity Id
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;
    // Rate Settings
    @track tableRates;
    @track tableFees;
    @wire(getRecord, { recordId: "$recordId", fields })
    opp;
    // -

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
        .then((data) => {
            console.log(`CalHelper: Data loaded!`, data);
            this.quoteForm = data;
            this.tableRates = CalHelper.getTableRatesData();
            console.log('@@tableRates', JSON.stringify(this.tableRates));
            this.tableFees = CalHelper.getTableFeesData();
            console.log('@@tableFees', JSON.stringify(this.tableFees));
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Loading...", error, "error");
        })
        .finally(() => {
            this.isBusy = false;
            console.log('is busy', this.isBusy);
            this.baseRateCalc();
        });
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

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

    get assetTypeOptions() {
        return CalHelper.options.assetTypes;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get assetAgeOptions() {
        return CalHelper.options.vehicleAges;
    }

    get clientTierOptions() {
        return CalHelper.options.clientTiers;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    // Events
    handleFieldChange(event) {
        console.log(`Changing value for: ${event.target.name}...`);
        const fldName = event.target.name;
        this.isCalculated = false;
        let fld = this.template.querySelector(`[data-id="${fldName}-field"]`);
        let v = event.detail ? event.detail.value : "";
        if (fld && fld.type === "number") {
            v = Number(v);
        }
        this.quoteForm[fldName] = v;
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        // --------------
        // Trigger events
        // --------------

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }
        if(CalHelper.APPLICATION_FEE_DOF_FIELDS.includes(fldName)) {
            this.maxFeeDofCalc();
        }

        // --------------
    }

    // Calculations
    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
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
        console.log(
        "🚀 ~ file: QuoteWisrPLCalc.js ~ line 130 ~ QuoteWisrPLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;
        CalHelper.baseRates(this.quoteForm)
        .then((data) => {
            console.log(`baseRateCalc Data loaded!`);
            this.quoteForm.baseRate = data.baseRate;
        })
        .catch((error) => {
            console.error(JSON.stringify(error, null, 2));
            displayToast(this, "Base Rate...", error, "error");
        })
        .finally(() => {
            this.isBaseRateBusy = false;
        });
    }

    // Max Application Fee and DOF 
    maxFeeDofCalc() {
        console.log(`maxFeeDofCalc...`);
        let maxValues = CalHelper.maxFees(this.quoteForm);
        this.quoteForm.maxDof = maxValues.maxDof;
        this.quoteForm.maxApplicationFee = maxValues.maxApplicationFee;
    }

    // -------------
    // Button events
    // -------------

    // Calculate
    handleCalculate(event) {
        this.isBusy = true;
        CalHelper.calculate(this.quoteForm)
        .then((data) => {
            console.log("@@data:", JSON.stringify(data, null, 2));
            this.quoteForm.commissions = data.commissions;
            // displayToast(this, "Calculate", "Done!", "info");
            this.messageObj = data.messages;
            QuoteCommons.handleHasErrorClassClear(this);
            if (this.quoteForm.commissions) this.isCalculated = true;
        })
        .catch((error) => {
            this.messageObj = error.messages;
            QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
            console.error(
            "QuoteWisrPLCalc.js: get errors -- ",
            JSON.stringify(error.messages.errors, null, 2)
            );
        })
        .finally(() => {
            this.isBusy = false;
        });
    }

    // Reset
    handleReset(event) {
        this.reset();
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
        "🚀 ~ file: QuoteWisrPLCalc.js ~ line 172 ~ QuoteWisrPLCalc ~ reset ~ this.quoteForm",
        JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
    }
}