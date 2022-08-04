import getQuotingData from "@salesforce/apex/QuoteGreenLightController.getQuotingData";
import getBaseRates from "@salesforce/apex/QuoteController.getBaseRates";
import calculateRepayments from "@salesforce/apex/QuoteController.calculateRepayments";
import sendQuote from "@salesforce/apex/QuoteController.sendQuote";
import save from "@salesforce/apex/QuotePepperMVController.save";
import {
  QuoteCommons,
  CommonOptions,
  FinancialUtilities as fu
} from "c/quoteCommons";
//import { Validations } from "./quoteValidations"; CLA TO DO


//return term months
const getTerms = () => {
    let r = [];
    const terms = CommonOptions.terms(12, 84);
    terms.forEach(function (item) {
    r.push({ label: item.label.toString(), value: item.value.toString()})
    });
    return r;
}

//return asset age options - TO DO AFTER load data
/*const getAssetAgeOptions = (formValues) => {
    let r = [];
    
    //for (let i = 0; i < 20; i++) {
      //let res = currentYear - i;
      //r.push({ label: res.toString(), value: res.toString()});  
    //}

    console.log(formValues.);
    return r;
};*/


const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: [
        { label: "Consumer Loan", value: "Consumer Loan" },
        { label: "Gold Club - Non-Property", value: "Gold Club - Non-Property" },
        { label: "Chattel Mortgage-Full-Doc", value: "Chattel Mortgage-Full-Doc" },
        { label: "Chattel Mortgage-Low-Doc", value: "Chattel Mortgage-Low-Doc" },
    ],
    assetTypes: [
        { label: "Car", value: "Car" },
        { label: "Bikes / Scooters", value: "Bikes / Scooters" },
        { label: "Boats / Personal Watercraft", value: "Boats / Personal Watercraft" },
        { label: "Caravans / Motorhomes", value: "Caravans / Motorhomes" },
    ],
    assetConditions: [
        { label: "New/Demo", value: "New/Demo" },
        { label: "Used", value: "Used" }
    ],
    terms: getTerms(),
    residency: [
        { label: "Property Owner", value: "Property Owner" },
        { label: "Renting", value: "Renting" },
        { label: "Living With Parents", value: "Living With Parents" },
        { label: "Employer Accommodation", value: "Employer Accommodation" },
        { label: "Boarding/Other", value: "Boarding/Other" },
    ],
    assetAges: [
        { label: "0-3 years", value: "0-3 years" },
        { label: "4-7 years", value: "4-7 years" },
        { label: "8-10 years", value: "8-10 years" },
        { label: "11-20 years", value: "11-20 years" },
        { label: "21+ years", value: "21+ years" },
    ],
    employmentStats: [
        { label: "No", value: "N" },
        { label: "Yes", value: "Y" }
    ],
    creditImpaireds: [
        { label: "No", value: "N" },
        { label: "Yes", value: "Y" }
    ],
    payDayEnqs: [
        { label: "Within last six months", value: "Within last six months" },
        { label: "Over 6 months ago", value: "Over 6 months ago" }
    ],
    imports: [
        { label: "No", value: "N" },
        { label: "Yes", value: "Y" }
    ],
    odometers: [
        { label: "<200,000", value: "<200,000" },
        { label: ">200,000", value: ">200,000" }
    ],
    privateSales: CommonOptions.yesNo,
    paymentTypes: CommonOptions.paymentTypes   
};

export const CalHelper = {
    options: calcOptions
    //getAssetAge: getAssetAgeOptions - TO DO After load data
    /*calculate: calculate, 
    load: loadData,
    reset: reset, 
    baseRates: getMyBaseRates, 
    BASE_RATE_FIELDS: BASE_RATE_FIELDS, 
    lenderSettings: lenderSettings,
    getTableRatesData: getTableRatesData,
    tableRateDataColumns: tableRateDataColumns, 
    getNetRealtimeNaf: QuoteCommons.calcNetRealtimeNaf,
    getNetDeposit: QuoteCommons.calcNetDeposit,
    saveQuote: saveQuote,
    sendEmail: sendEmail*/
};