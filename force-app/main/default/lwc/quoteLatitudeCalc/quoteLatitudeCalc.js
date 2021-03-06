import { api, LightningElement, track, wire } from 'lwc';
import LENDER_LOGO from "@salesforce/resourceUrl/LatitudeLogo3";
import { QuoteCommons } from "c/quoteCommons";
import { CalHelper } from "./quoteLatitudeCalcHelper";
import { getRecord } from 'lightning/uiRecordApi';
import { displayToast } from "c/partnerJsUtils";

export default class QuoteLatitudeCalc extends LightningElement {
    tableRatesCols = CalHelper.TABLE_DATA_COLUMNS;
    isBusy;
    isBaseRateBusy;
    isCalculated = false;
    category;

    @api recordId;
    @track messageObj = QuoteCommons.resetMessage();
    @track quoteForm;

    // table data
    @track tableRates;

    connectedCallback() {
        console.log(`connectedCallback...`);
        this.isBusy = true;
        this.reset();
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded!`);
                this.quoteForm = data;
                console.log(`Data loaded!`, JSON.stringify(this.quoteForm));
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
                this.vehicleCategory();
                this.baseRateCalc();
            });

        console.log('recordID::', this.recordId)
    }

    // lifecycle hook - after rendering all components(child+parent), will triggered
    renderedCallback() {
        QuoteCommons.resetValidateFields(this);
    }

    // Base Rate
    baseRateCalc() {
        this.isBaseRateBusy = true;

        console.log('baseRateCalc::', this.quoteForm.goodsType, this.quoteForm.loanTypeDetail, this.quoteForm.carAge);
        console.log('quote form::', JSON.stringify(this.quoteForm, null, 2));
        CalHelper.baseRates(this.quoteForm)
            .then((data) => {
                console.log(`Data loaded!`);
                this.quoteForm.baseRate = data.baseRate;
                this.quoteForm.maxRate = data.maxRate;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Base Rate...", error, "error");
            })
            .finally(() => {
                this.isBaseRateBusy = false;
            });
    }

    // DOF calculation
    dofCalc() {
            this.quoteForm.dof = CalHelper.getDOF(this.quoteForm);
            this.quoteForm.maxDof = this.quoteForm.dof;
    }

    // Category generation
    vehicleCategory() {
        console.log('vehicle type:::', this.quoteForm.vehicleType)
        if (this.quoteForm.vehicleType) {
            this.category = 'Car/Motorbike';
            if ('BOAT' === this.quoteForm.vehicleType || 'CARAVAN' === this.quoteForm.vehicleType || 'MOTORHOME' === this.quoteForm.vehicleType || 'TRAILER' === this.quoteForm.vehicleType) {
                this.category = 'Boats, Personal Watercraft, Caravans, Camper Trailers, Motorhomes';
            }
            this.quoteForm.category = this.category;
        } else {
            this.category = '';
        }
        this.quoteForm.goodsType = this.category;
        this.tableRates = CalHelper.getAllTableData(this.category);
    }

    // Quote Fee calculation
    calcFees() {
        const quote = CalHelper.getQuoteFees(this.quoteForm);
        this.quoteForm.ppsr = quote.ppsr;
        this.quoteForm.registrationFee = quote.registrationFee;
        this.isBaseRateBusy = false;
    }

    // Combobox options
    get loanTypeOptions() {
        return CalHelper.options.loanTypes;
    }

    get loanProductOptions() {
        return CalHelper.options.loanProducts;
    }

    get paymentTypeOptions() {
        return CalHelper.options.paymentTypes;
    }

    get securedUnsecuredOptions() {
        return CalHelper.options.securedUnsecured;
    }

    get termOptions() {
        return CalHelper.options.terms;
    }

    get classOptions() {
        return CalHelper.options.classes;
    }

    get carAgeOptions() {
        return CalHelper.options.vehicleAges;
    }

    get vehicleTypes() {
        return CalHelper.options.vehicleTypes;
    }

    get privateSalesOptions() {
        return CalHelper.options.privateSales;
    }

    get vehicleConditionOptions() {
        return CalHelper.options.vehicleConditions;
    }

    get tableHeadings() {
        return CalHelper.options.classes;
    }

    get logoUrl() {
        return LENDER_LOGO;
    }

    // Common calculations
    get netDeposit() {
        return CalHelper.getNetDeposit(this.quoteForm);
    }

    get netRealtimeNaf() {
        console.log('netRealtimeNaf:::', CalHelper.getNetRealtimeNaf(this.quoteForm))
        return CalHelper.getNetRealtimeNaf(this.quoteForm);
    }

    get disableAction() {
        return !this.isCalculated;
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
                console.error(
                    "quoteLatitudePLCalc.js: get errors -- ",
                    JSON.stringify(error.messages.errors, null, 2)
                );
                this.messageObj = error.messages;
                QuoteCommons.fieldErrorHandler(this, this.messageObj.errors);
                console.error(
                    "quoteLatitudePLCalc.js: get errors -- ",
                    JSON.stringify(error.messages.errors, null, 2)
                );
            })
            .finally(() => {
                this.isBusy = false;
            });

        if (results && Array.isArray(results) && results.length > 0) {
            // this.quoteResult = results[0];
        }
        this.baseRateCalc();
    }

    // Reset
    reset() {
        this.quoteForm = CalHelper.reset(this.recordId);
        console.log(
            "???? ~ file: QuotePepperMVCalc.js ~ line 113 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
    }

    // Reset
    handleReset(event) {
        this.reset();
        this.messageObj = QuoteCommons.resetMessage();
        this.isCalculated = false;
        QuoteCommons.handleHasErrorClassClear(this);
        console.log(
            "???? ~ file: QuotePepperMVCalc.js ~ line 172 ~ QuotePepperMVCalc ~ reset ~ this.quoteForm",
            JSON.stringify(this.quoteForm, null, 2)
        );
        this.baseRateCalc();
        this.vehicleCategory();
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
        fldName === "term"
            ? (this.quoteForm[fldName] = parseInt(v))
            : (this.quoteForm[fldName] = v);
        console.log(`this.quoteForm:`, JSON.stringify(this.quoteForm, null, 2));
        // --------------
        // Trigger events
        // --------------

        // Vehicle category generation
        if (fldName === 'vehicleType') {
            this.vehicleCategory();
        }

        // Base Rate Calculation
        if (CalHelper.BASE_RATE_FIELDS.includes(fldName)) {
            this.baseRateCalc();
        }

        // DOF calculation
        if (CalHelper.DOF_CALC_FIELDS.includes(fldName)) {
            this.dofCalc();
        }

        // --------------
    }
}