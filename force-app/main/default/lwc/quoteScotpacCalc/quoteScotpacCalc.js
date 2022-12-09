import { LightningElement, track, api, wire } from 'lwc';
import { displayToast } from "c/partnerJsUtils";
import LENDER_LOGO from "@salesforce/resourceUrl/ScotPacLogo";
import { getRecord } from "lightning/uiRecordApi";
import { CalHelper } from "./quoteScotpacCalcHelper";


export default class QuoteScotpacCalc extends LightningElement {
    @track isBusy;
    @api recordId; // Opportunity Id
    @track quoteForm = {};
    @track messageObj;
    @track messages = { confirms: [] };
    @wire(getRecord, { recordId: "$recordId" })
    opp;

    connectedCallback() {
        this.quoteForm.commissions = "";
        console.log(`connectedCallback... ${this.recordId}`);
        this.isBusy = true;
        CalHelper.load(this.recordId)
            .then((data) => {
                console.log(`Data loaded! ${JSON.stringify(data, null, 2)}`);
                this.quoteForm = data;
            })
            .catch((error) => {
                console.error(JSON.stringify(error, null, 2));
                displayToast(this, "Loading...", error, "error");
            })
            .finally(() => {
                this.isBusy = false;
            });
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
        // Base Rate Calculation
    }

    get logoUrl() {
        return LENDER_LOGO;
    }

    get commWithoutGST() {
        return (this.quoteForm.brokerageInc / 1.1).toFixed(2);
    }

    // all Save Buttons actions
    handleSave(event) {
        console.log(`event detail : ${event.target.value.toUpperCase()}`);
        const isNONE = event.target.value.toUpperCase() === "NONE";
        this.isBusy = true;
        const loanType = event.target.value.toUpperCase();
        CalHelper.saveQuote(loanType, this.quoteForm)
            .then((data) => {
                console.log("@@data in handleSave:", JSON.stringify(data, null, 2));
                !isNONE
                    ? this.messages.confirms.push(
                        {
                            field: "confirms",
                            message: "Calculation saved successfully."
                        },
                        {
                            fields: "confirms",
                            message: "Product updated successfully."
                        }
                    )
                    : this.messages.confirms.push({
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
            });
    }
}