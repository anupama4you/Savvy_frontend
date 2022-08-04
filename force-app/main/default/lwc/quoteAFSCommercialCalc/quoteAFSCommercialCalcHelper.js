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
  const terms = CommonOptions.terms(12, 72);
  terms.forEach(function (item) {
  r.push({ label: item.label.toString(), value: item.value.toString()})
  });
  return r;
}

const calcOptions = {
    loanTypes: CommonOptions.loanTypes,
    loanProducts: CommonOptions.fullLoanProducts,
    terms: getTerms(),
    carAges: [
      { label: "New - 6 years old", value: "New - 6 years old" },
      { label: "Used 7 years+", value: "Used 7 years+" }
    ],
    residency: [
        { label: "Home Buyer", value: "Home Buyer" },
        { label: "Non-Home Buyer", value: "Non-Home Buyer" }
    ],
    paymentTypes: CommonOptions.paymentTypes,
    gst: [
        { label: "Registered", value: "Registered" },
        { label: "Not Registered", value: "Not Registered" }
    ],
    
};

export const CalHelper = {
    options: calcOptions,
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