import getQuotingData from "@salesforce/apex/QuotePepperCommController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import {
    QuoteCommons,
    CommonOptions,
    FinancialUtilities as fu
} from "c/quoteCommons";
import { Validations } from "./quoteValidations";

// Default settings
let lenderSettings = {};
let tableRatesData = [];
let tableRateDataColumns = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New", fieldName: "Rate0__c", fixedWidth: 80 },
    { label: "Used 0-5 years", fieldName: "Rate1__c", fixedWidth: 140 },
    { label: "Used 6+ years", fieldName: "Rate2__c", fixedWidth: 140 },
    // { label: "Used 10+ years", fieldName: "Rate3__c", fixedWidth: 140 }
];
let tableRateDataColumns2 = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New and Demo", fieldName: "Rate0__c", fixedWidth: 140 },
    { label: "Used all ages", fieldName: "Rate1__c", fixedWidth: 140 },
    // { label: "Used 6-9 years", fieldName: "Rate2__c", fixedWidth: 140 },
    // { label: "Used 10+ years", fieldName: "Rate3__c", fixedWidth: 140 }
];
let tableRateDataColumns3 = [
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New and Used all ages", fieldName: "Rate0__c", fixedWidth: 180 },
    // { label: "Used 0-5 years", fieldName: "Rate1__c", fixedWidth: 140 },
    // { label: "Used 6-9 years", fieldName: "Rate2__c", fixedWidth: 140 },
    // { label: "Used 10+ years", fieldName: "Rate3__c", fixedWidth: 140 }
];
let tableRateDataColumns4 = [
    // { label: "Product", fieldName: "Product__c" },
    { label: "Tier", fieldName: "Tier__c", fixedWidth: 70 },
    { label: "New", fieldName: "Rate0__c", fixedWidth: 80 },
    { label: "Used 0-5 years", fieldName: "Rate1__c", fixedWidth: 140 },
    { label: "Used 6-9 years", fieldName: "Rate2__c", fixedWidth: 140 },
    { label: "Used 10+ years", fieldName: "Rate3__c", fixedWidth: 140 }
];
const LENDER_QUOTING = "Pepper Leisure";

const QUOTING_FIELDS = new Map([
    ["loanType", "Loan_Type__c"],
    ["loanProduct", "Loan_Product__c"],
    ["assetType", "Goods_type__c"],
    // ["assetSubtype", "Goods_sub_type__c"],
    ["price", "Vehicle_Price__c"],
    ["deposit", "Deposit__c"],
    ["tradeIn", "Trade_In__c"],
    ["payoutOn", "Payout_On__c"],
    ["applicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["residual", "Residual_Value__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"],
    ["term", "Term__c"],
    ["clientRate", "Client_Rate__c"],
    ["paymentType", "Payment__c"]
]);

const RATE_SETTING_NAMES = ["PepperRate__c"];

const SETTING_FIELDS = new Map([
    ["applicationFee", "Application_Fee__c"],
    ["maxApplicationFee", "Application_Fee__c"],
    ["dof", "DOF__c"],
    ["maxDof", "DOF__c"],
    ["ppsr", "PPSR__c"],
    ["monthlyFee", "Monthly_Fee__c"]
]);

const BASE_RATE_FIELDS = [
    "customerProfile",
    "clientTier",
    "assetAge",
    "assetType",
    "privateSales"
];

const calculate = (quote) =>
    new Promise((resolve, reject) => {
        console.log(`Calculating repayments...`, JSON.stringify(quote, null, 2));
        let res = {
            commissions: QuoteCommons.resetResults(),
            messages: QuoteCommons.resetMessage()
        };
        // Validate quote
        res.messages = Validations.validate(quote, res.messages);
        if (res.messages && res.messages.errors.length > 0) {
            reject(res);
        } else {
            // Prepare params
            const profile = "LEISURE";
            const p = {
                lender: LENDER_QUOTING,
                totalAmount: QuoteCommons.calcTotalAmount(quote),
                totalInsurance: QuoteCommons.calcTotalInsuranceType(quote),
                clientRate: quote.clientRate,
                baseRate: quote.baseRate,
                paymentType: quote.paymentType,
                term: quote.term,
                dof: quote.dof,
                monthlyFee: quote.monthlyFee,
                residualValue: quote.residual,
                customerProfile: profile,
                clientTier: quote.clientTier,
                productLoanType: quote.loanProduct,
                vehicleYear: quote.assetAge,
                privateSales: quote.privateSales,
                goodsType: quote.assetType,
                // goodsSubType: quote.assetSubtype,
            };

            // Calculate
            console.log(`@@param:`, JSON.stringify(p, null, 2));
            calculateRepayments({
                param: p
            })
                .then((data) => {
                    console.log(`@@SF:`, JSON.stringify(data, null, 2));
                    // Mapping
                    res.commissions = QuoteCommons.mapCommissionSObjectToLwc(data);
                    console.log(JSON.stringify(res.commissions, null, 2));
                    // Validate the result of commissions
                    res.messages = Validations.validatePostCalculation(res.commissions, res.messages);
                    resolve(res);
                })
                .catch((error) => {
                    res.messages.errors.push({ field: "calculation", message: error });
                    reject(res);
                });
        }
    });

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    paymentTypes: CommonOptions.paymentTypes,
    loanProducts: CommonOptions.businessLoanProducts,
    privateSales: CommonOptions.yesNo,
    assetTypes: [
        { label: "Car", value: "Car" },
        { label: "Caravan", value: "Caravan" },
        { label: "Wheels & Tracks", value: "Wheels & Tracks" },
        { label: "Other-Primary Assets", value: "Other-Primary Assets" },
        { label: "Other-Secondary & Tertiary Assets", value: "Other-Secondary & Tertiary Assets" },
    ],
    clientTiers: [
        { label: "A", value: "A" },
        { label: "B", value: "B" },
        { label: "C", value: "C" }
    ],
    vehicleAges: [
        { label: "New", value: "New" },
        { label: "Used 0-5 years", value: "Used 0-5 years" },
        { label: "Used 6-9 years", value: "Used 6-9 years" },
        { label: "Used 10+ years", value: "Used 10+ years" }
    ],
    terms: CommonOptions.terms(12, 84)
};

// Reset
const reset = () => {
    let r = {
        loanType: calcOptions.loanTypes[0].value,
        loanProduct: calcOptions.loanProducts[0].value,
        assetType: calcOptions.assetTypes[0].value,
        // assetSubtype: calcOptions.assetSubtypeNA[0].value,
        price: null,
        deposit: null,
        tradeIn: null,
        payoutOn: null,
        applicationFee: null,
        maxApplicationFee: null,
        dof: null,
        residual: null,
        ppsr: null,
        monthlyFee: null,
        maxDof: null,
        term: 60,
        clientTier: calcOptions.clientTiers[0].value,
        assetAge: calcOptions.vehicleAges[0].value,
        privateSales: "N",
        paymentType: "Arrears",
        baseRate: 0.0,
        maxRate: 0.0,
        clientRate: null,
        commissions: QuoteCommons.resetResults()
    };
    r = QuoteCommons.mapDataToLwc(r, lenderSettings, SETTING_FIELDS);
    return r;
};

// Load Data
const loadData = (recordId) =>
    new Promise((resolve, reject) => {
        const fields = [
            ...QUOTING_FIELDS.values(),
            ...QuoteCommons.COMMISSION_FIELDS.values()
        ];
        // console.log(`@@fields:`, JSON.stringify(fields, null, 2));
        getQuotingData({
            param: {
                oppId: recordId,
                fields: fields,
                calcName: LENDER_QUOTING,
                rateSettings: RATE_SETTING_NAMES
            }
        })
            .then((quoteData) => {
                console.log(`@@SF Get Data:`, JSON.stringify(quoteData, null, 2));
                // Mapping Quote's fields
                let data = QuoteCommons.mapSObjectToLwc({
                    calcName: LENDER_QUOTING,
                    defaultData: reset(),
                    quoteData: quoteData,
                    settingFields: SETTING_FIELDS,
                    quotingFields: QUOTING_FIELDS
                });

                // Settings
                lenderSettings = quoteData.settings;

                // Rate Settings
                if (quoteData.rateSettings) {
                    tableRatesData = quoteData.rateSettings[`${RATE_SETTING_NAMES[0]}`];
                }
                // console.log(`@@data:`, JSON.stringify(data, null, 2));
                resolve(data);
            })
            .catch((error) => reject(error));
    });

// Get Base Rates
const getMyBaseRates = (quote) =>
    new Promise((resolve, reject) => {
        const profile = "LEISURE";
        const p = {
            lender: LENDER_QUOTING,
            productLoanType: quote.loanProduct,
            customerProfile: profile,
            clientTier: quote.clientTier,
            vehicleYear: quote.assetAge,
            goodsType: quote.assetType,
            privateSales: quote.privateSales,
            hasMaxRate: true
        };
        console.log(`getMyBaseRates...`, JSON.stringify(p, null, 2));
        getBaseRates({
            param: p
        })
            .then((rates) => {
                console.log(`@@SF BaseRate:`, JSON.stringify(rates, null, 2));
                resolve(rates);
            })
            .catch((error) => reject(error));
    });


const getTableRatesData = () => {
    return tableRatesData;
};

export const CalHelper = {
    options: calcOptions,
    calculate: calculate,
    load: loadData,
    reset: reset,
    baseRates: getMyBaseRates,
    BASE_RATE_FIELDS: BASE_RATE_FIELDS,
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns,
    tableRateDataColumns2: tableRateDataColumns2,
    tableRateDataColumns3: tableRateDataColumns3,
    tableRateDataColumns4: tableRateDataColumns4,
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit
};