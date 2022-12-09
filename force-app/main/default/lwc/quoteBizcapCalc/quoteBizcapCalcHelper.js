import getQuotingData from "@salesforce/apex/QuoteBizcapCalcController.getQuotingData";
import save from "@salesforce/apex/QuoteBizcapCalcController.save";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
// import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};

const LENDER_QUOTING = "Bizcap";

const QUOTING_FIELDS = new Map([
    ["naf", "NAF__c"],
    ["brokerageInc", "Commission_Total_GST_Inc__c"],
    ["brokerageExc", "Commission_Total_GST_Exc__c"],
]);

const FIELDS_MAPPING_FOR_APEX = new Map([
    ...QUOTING_FIELDS,
    ["Id", "Id"],
]);

// LOAD
const fieldsMapper = (quoteData, fields, recordId) => {
    let res = {};
    res.name = LENDER_QUOTING;
    if (!quoteData.data || !quoteData.data.Id) {
        recordId && (res.recordId = recordId);
        return res;
    }
    fields.quote.forEach((key, val) => {
        res[`${val}`] = quoteData.data[`${key}`];
    });
    res.quotingId = quoteData.data.Id;
    res.name = quoteData.data.Name;
    res.recordId = recordId;
    return res;
};

// SAVING
const fieldsApexMapper = (quoteData) => {
    let res = {};
    res.data = {};
    // res.loan = {};
    res.data.Commission_Total_GST_Exc__c = (quoteData.brokerageInc / 1.1).toFixed(2);
    res.data.Commission_Total_GST_Inc__c = quoteData.brokerageInc.toFixed(2);
    res.data.Opportunity__c = quoteData.recordId;
    res.data.Id = quoteData.quotingId;
    res.data.Name = quoteData.name;
    res.data.NAF__c = quoteData.naf;
    res.brokerageExc = quoteData.brokerageInc;
    console.log('res: ', JSON.stringify(res, null, 2));
    return res;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        const fields = [
            ...QUOTING_FIELDS.values(),
        ];
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
            }
        })
            .then((quoteData) => {
                console.log(`@@SF Get Data:`, JSON.stringify(quoteData, null, 2));
                const fields = {
                    quote: QUOTING_FIELDS,
                };
                const data = fieldsMapper(quoteData, fields, recordId);
                resolve(data);
            })
            .catch((error) => reject(error));
    });

const saveQuote = (approvalType, param) =>
    new Promise((resolve, reject) => {
        if (approvalType && param) {
            console.log(`@@SAVING: ${JSON.stringify(param, null, 2)}`);
            console.log('approvalType: ', approvalType);

            save({
                param: fieldsApexMapper(param),
                approvalType: approvalType
            })
                .then((data) => {
                    resolve(data);
                })
                .catch((error) => {
                    reject(error);
                });
        } else {
            reject(new Error("QUOTE OR RECORDID EMPTY in SaveQuoting function"));
        }
    });

export const CalHelper = {
    load: loadData,
    saveQuote: saveQuote,
};