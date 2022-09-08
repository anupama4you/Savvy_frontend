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

      if (quote.brokerage == null || quote.brokerage === 0.0) {
         errorList.push({
         field: "brokerage",
         message: "Brokerage cannot be Zero."
         });
      }else if (quote.brokerage < 0.0) {
         errorList.push({
         field: "brokerage",
         message: "Brokerage should not be below Zero."
         });
      } 

      if(lender.length !== 0 && lender !== null){
         
         let lenderMaxBrokerage = (lender.Max_Brokerage__c === null || lender.Max_Brokerage__c === "undefined" ? 0.0 : lender.Max_Brokerage__c);
         if (quote.brokerage > lenderMaxBrokerage) {
            warningList.push({
               field: "brokerage",
               message: `Brokerage should not be greater than $${lenderMaxBrokerage}.`
            });
         }
      }

      if (quote.baseRate === null || quote.baseRate === 0.0 || quote.baseRate < 0) {
         errorList.push({
            field: "baseRate",
            message: "Base Rate cannot be Zero."
         });
      }

      if (quote.term === null || quote.term === 0) {
         errorList.push({
            field: "term",
            message: "Please choose an appropriate term."
         });
      }

      if(rate.length !== 0 && rate !== null){
         let rateMaxAmount = (rate[0].Maximun_Amount__c === null || rate[0].Maximun_Amount__c === "undefined" ? 0.0 : rate[0].Maximun_Amount__c);
         let rateMinAmount = (rate[0].Minimum_Amount__c === null || rate[0].Minimum_Amount__c === "undefined" ? 0.0 : rate[0].Minimum_Amount__c);
         let rateMaxTerm = (rate[0].Max_Term__c === null || rate[0].Max_Term__c === "undefined" ? 0 : rate[0].Max_Term__c);
         let rateProduct = (rate[0].Product__c === null || rate[0].Product__c === "undefined" ? '' : rate[0].Product__c);
         let categoryProduct = rate[0].Category__c + ' - ' + rate[0].Product__c;
         if (quote.loanProduct !== 'Consumer Loan' && (rateProduct === 'Gold' || rateProduct === 'Platinum')  && quote.propertyOwner !== 'Y') { 
               rateMaxAmount = 75000.0;
               if (naf > rateMaxAmount) {
                  warningList.push({
                     message: "Only property owners can borrow $75k-$150K."
                  });
               }
         }

         if (naf < rateMinAmount || naf > rateMaxAmount) {
            warningList.push({
               message: `${categoryProduct}: NAF should be between $${rateMinAmount} and $${rateMaxAmount}.`
            });
         }

         if (quote.term < 36 || quote.term > rateMaxTerm) {
            errorList.push({
               field: "term",
               message: `${categoryProduct}: term should be between 36 months to ${rateMaxTerm} months.`
            });
         } 
      }

      if (quote.residual > 0 && quote.term > 60) {
         errorList.push({
            field: "residual",
            message: "You cannot have a balloon or residual payment when the loan term is > 5 years."
         });
      }

      if (quote.loanTypeDetail === 'Silver'){    
         if (quote.riskFee > quote.calcRiskFee){
            warningList.push({
               message: "Greater than $1995 - Max risk fee exceeded Refer to Finance one."
            });
         } else if(quote.riskFee > 0 && quote.riskFee < 995){
            warningList.push({
               message: "Less than $995 - Below minimum risk fee - refer to Finance one."
            });
         } else if(quote.riskFee < quote.calcRiskFee && quote.riskFee !== 0){
            warningList.push({
               message: "Risk fee change - refer to Finance one."
            });   
         }
      }else if(quote.loanTypeDetail === 'Gold' || quote.loanTypeDetail === 'Platinum'){
         if (quote.riskFee !== 0) {
         warningList.push({
            message: "Risk Fee should be $0."
         });
         }
      }

      if (quote.riskFee < 0.0) {
         errorList.push({
            field: "riskFee",
            message: "Risk Fee should not be below Zero."
         });
      }

      if(quote.goodsSubType === null && (quote.goodType === "Car" || quote.goodType === "Motorbike" || quote.goodType === "Boat" || quote.goodType === "Caravan" )){
            errorList.push({
            field: "goodsSubType",
            message: "Please select Goods SubType."
         });
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