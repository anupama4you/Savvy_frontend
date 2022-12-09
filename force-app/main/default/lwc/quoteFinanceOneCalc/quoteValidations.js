import { QuoteCommons } from "c/quoteCommons";

// Validation Types: ERROR, WARNING, INFO
/**
 * @param {Object} quote - quote form
 * @param {Object} rate - finance one rates
 * @param {Object} lender - lender 
 * @param {Object} naf - total naf 
 * @param {Object} messages - old messages object
 * @returns
 */

 const validate = (quote, rate, lender, naf, messages ) => {

    const r =
      typeof messages == "undefined" || messages == null
         ? QuoteCommons.resetMessage()
         : messages;
      let errorList = r.errors;
      let warningList = r.warnings;

      if (quote.clientRate == null || quote.clientRate === 0.0) {
        errorList.push({
        field: "clientRate",
        message: "Client Rate cannot be Zero."
        });
      } 

      if (quote.baseRate === null || quote.baseRate === 0.0 || quote.baseRate < 0) {
        errorList.push({
           field: "baseRate",
           message: "Base Rate cannot be Zero."
        });
      }
      
      if (quote.residual > 0 && quote.term > 60) {
        errorList.push({
           field: "residual",
           message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
        });
      }
      
      if(quote.riskFee > 1995){
        warningList.push({
            message: "Greater than $1995 - Max risk fee exceeded Refer to Finance one."
        });
      }else if(quote.riskFee > 0 && quote.riskFee < 995){
        warningList.push({
            message: "Less than $995 - Below minimum risk fee - refer to Finance one."
        });
      }else if(quote.riskFee < quote.calcRiskFee && quote.riskFee !== 0){
        warningList.push({
            message: "Risk fee change - refer to Finance one."
        });
      }
      
      if(quote.riskFee > quote.calcRiskFee){ 
        warningList.push({
            message: "Risk fee is greater than Risk fee calculated."
        });     
      }
      
      if(quote.goodsSubType === null && (quote.goodType === "Car" || quote.goodType === "Motorbike" || quote.goodType === "Boat" || quote.goodType === "Caravan" )){
        errorList.push({
            field: "goodsSubType",
            message: "Please select Goods SubType."
        });
      }
      
      if(rate.length !== 0 && rate !== null){
            let rateMaxAmount = (rate[0].Maximun_Amount__c === null || rate[0].Maximun_Amount__c === "undefined" ? 0.0 : rate[0].Maximun_Amount__c);
            let rateMinAmount = (rate[0].Minimum_Amount__c === null || rate[0].Minimum_Amount__c === "undefined" ? 0.0 : rate[0].Minimum_Amount__c);
            let rateMaxTerm = (rate[0].Max_Term__c === null || rate[0].Max_Term__c === "undefined" ? 0 : rate[0].Max_Term__c);
            let rateProduct = (rate[0].Product__c === null || rate[0].Product__c === "undefined" ? '' : rate[0].Product__c);
            let rateBaseRate = (rate[0].Base_Rate__c === null || rate[0].Base_Rate__c === "undefined" ? 0.0 : rate[0].Base_Rate__c);
            let rateMaxRate = (rate[0].Max_Rate__c === null || rate[0].Max_Rate__c === "undefined" ? 0.0 : rate[0].Max_Rate__c);
            let categoryProduct = rate[0].Category__c + ' - ' + rate[0].Product__c;
            
            let maxAmount = rateMaxAmount;
            if (quote.loanType !== 'Consumer Loan' && rateProduct === 'Gold' && quote.propertyOwner !== 'Y') {
                maxAmount = 75000.0;
            }

            if (rateProduct === 'Economy') {
                let price = quote.price > 0 ? quote.price : 0.00;
                price -= quote.netDeposit;
                if (price < rateMinAmount || price > rateMaxAmount) {
                    errorList.push({
                        field: "price",
                        message: `${categoryProduct} : Vehicle price should be between $${rateMinAmount} and $${rateMaxAmount}.`
                    });
                } 
            } else if (naf < rateMinAmount || naf > maxAmount) {
                warningList.push({
                    message: `${categoryProduct} : NAF should be between $${rateMinAmount} and $${maxAmount}.`
                });
            }

            if (quote.clientRate > 0) {
                if (quote.clientRate < rateBaseRate) {
                    errorList.push({
                        field: "clientRate",
                        message: `${categoryProduct} : Client rate is below the base rate.`
                    });
                } else if (quote.clientRate > rateMaxRate) {
                    errorList.push({
                        field: "clientRate",
                        message: `${categoryProduct} : client rate larger than ${rateMaxRate}%.`
                    });
                }
            }

            if (quote.term < 36 || quote.term > rateMaxTerm) {
                errorList.push({
                    field: "term",
                    message: `${categoryProduct} : term should be between 36 months to ${rateMaxTerm} months.`
                });
            }
            
            if(rateProduct !== 'Economy' && (quote.riskFee === 0 || quote.riskFee === null)) {
                errorList.push({
                    field: "riskFee",
                    message: "The risk fee must be greater than zero."
                });
            } 
      }

    r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
    r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
    return r;

 };

 const validatePostCalculation = (quote, messages) => {
   const r =
      typeof messages == "undefined" || messages == null
         ? QuoteCommons.resetMessage()
         : messages;
      let errorList = r.errors;
      let warningList = r.warnings;

      if(quote.commission <= 0) {
         warningList.push({
           message: "The commission is below zero. Please make adjustment to make sure commission is above zero."
         });
       }

   r.warnings = [].concat(QuoteCommons.uniqueArray(warningList));
   r.errors = [].concat(QuoteCommons.uniqueArray(errorList));
   return r;   
 };

 const Validations = {
    validate: validate,
    validatePostCalculation: validatePostCalculation
 };

export { Validations };