public with sharing class ValidateGenerateDocumentsExtension
{
    public ValidateGenerateDocumentsExtension(ApexPages.StandardController c)
    {
        record = (Custom_Opportunity__c)c.getRecord();
    }

    private Custom_Opportunity__c record;    
    
    public PageReference DoValidate()
    {
        try
        {
            if (!Validate())
            {
                return null;
            }
            
            return new PageReference('/apex/SDOC__SDCreate1?id=' + record.Id + '&Object=Custom_Opportunity__c');
        }
        catch(Exception e)
        {
            return CustomException.formatException(e);
        }
    }
    
    public Boolean Validate()
    {      
        Boolean valid = true;
      
        if (record.Account__r.Unit_House_Number__c == null
            || record.Account__r.Street_Address__c == null
            || record.Account__r.Street_Type__c == null
            || record.Account__r.Suburb__c == null
            || record.Account__r.State__c == null
            || record.Account__r.Postcode__c == null
            || record.Occupation__c == null
            || record.Occupation_Status__c == null
            || record.Occupation_Time_Years__c == null
            || record.Occupation_Time_Months__c == null
            || record.Number_of_Dependents__c == null
            || record.Goods_Description__c == null
            || record.Preferred_Lender__c == null
            || record.Insurance_Cover__c == null            
            //|| record.Vehicle_securities_registration_fee__c == null
            //|| record.ASIC_Registration__c == null
            //|| record.Other_Fees_or_Charges__c == null                
            || record.Applicant_Net_Income__c == null
            || record.Borrower_Contact__c == null
            || record.Co_Borrower_Net_Income__c == null
            || record.Credit_Card_Payments__c == null
            || record.Living_Expenses__c == null
            || record.Existing_Loan_Payments__c == null
            || record.Mortgage_Rent__c == null
            || record.Other_Expenses__c == null
            || record.Other_Income__c == null
            || (record.Other_Income__c != null && record.Other_Income_Detail__c == null)
            || record.This_Commitment__c == null                
            || record.Loan_Product__r.Deposit__c == null
            || record.Loan_Product__r.Lender_App_Fee__c == null
            || record.Loan_Product__r.Equalisation_Fee_PPSR__c == null
            || record.Loan_Product__r.Residual_Percentage__c == null
            || record.Loan_Product__r.Balloon_Residual_Requested__c == null
            || record.Loan_Product__r.Liberty_Trail__c == null
            || record.Loan_Product__r.Client_Rate__c == null
            || record.Loan_Product__r.Repayment_Regularity__c == null
            || record.Loan_Product__r.Payments__c == null)
        {     
            valid = false;                        
        }                                
        
        if (record.Purchase_Type__c == 'Dealer')
        { 
            if (record.Dealer_Name__c == null
                || record.Dealer_Contact_Name__c == null
                || record.Dealer_Address__c == null
                || record.Dealer_Phone_Number__c == null
                || record.Dealer_Email__c == null)
            {
                valid = false;
            }                    
        }
             
        if (record.Loan_Product__r.Loan_Purpose__c == 'Personal Use')     
        {
            if (record.Finance_Product__c == null)
            {
                valid = false;
            }
        }           
        else if (record.Loan_Product__r.Loan_Purpose__c == 'Business Use')
        {
            if (record.Low_Doc_confirmation__c == false
                || record.No_hardship_for_applicant__c == false)
            {      
                valid = false;      
            }
        
            if (record.Occupation_Status__c != 'Self Employment')
            {
                if (record.Current_payslip_with_vehicle_allowance__c == false
                    && record.Employer_letter_confirming_business_use__c == false
                    && record.Signed_Deed_of_Novation__c == false)                       
                {
                    valid = false;
                }
            }
            else
            {
                if (record.Recent_Business_Activity_Statement__c == false
                    && record.Recent_Tax_Return_with_M_V_deductions__c == false
                    && record.Letter_from_Accountant__c == false)
                {
                    valid = false;
                }
            }                           
        }
        
        // check if all insurance products have an insurance policy amount               
        for (Product__c p : [SELECT Id
                             FROM Product__c
                             WHERE Opportunity_Name__c = :record.Id
                             AND RecordType.Name = 'Insurance'
                             AND Insurance_Policy_Amount__c = null])
        {
            CustomException.formatException('Insurance Policy Amount must be completed before documents can be generated.');
            valid = false;
        }                             
                                    
        
        return valid;
        
    }
    
    public PageReference SaveContinue()
    {
        try
        {
            if (!Validate())
            {
                return CustomException.formatException('All fields must be completed');    
            }
                            
            update record;
            
            for (Account a : [SELECT Id,
                                     Unit_House_Number__c,
                                     Street_Address__c,
                                     Street_Type__c,
                                     Suburb__c,
                                     State__c,
                                     Postcode__c
                              FROM Account
                              WHERE Id = :record.Account__c])
            {
                a.Unit_House_Number__c = record.Account__r.Unit_House_Number__c;
                a.Street_Address__c = record.Account__r.Street_Address__c;
                a.Street_Type__c = record.Account__r.Street_Type__c;
                a.Suburb__c = record.Account__r.Suburb__c;
                a.State__c = record.Account__r.State__c;
                a.Postcode__c = record.Account__r.Postcode__c;
                
                update a;
            } 
            
            for (Product__c p : [SELECT Id,
                                        Residual_Percentage__c,
                                        Balloon_Residual_Requested__c,
                                        Liberty_Trail__c,
                                        Client_Rate__c,
                                        Repayment_Regularity__c,
                                        Payments__c,
                                        Deposit__c,
                                        Lender_App_Fee__c,
                                        Equalisation_Fee_PPSR__c
                                 FROM Product__c
                                 WHERE Id = :record.Loan_Product__c])
            {
                p.Residual_Percentage__c = record.Loan_Product__r.Residual_Percentage__c;
                p.Balloon_Residual_Requested__c = record.Loan_Product__r.Balloon_Residual_Requested__c;
                p.Liberty_Trail__c = record.Loan_Product__r.Liberty_Trail__c;
                p.Client_Rate__c = record.Loan_Product__r.Client_Rate__c;
                p.Repayment_Regularity__c = record.Loan_Product__r.Repayment_Regularity__c;
                p.Payments__c = record.Loan_Product__r.Payments__c;
                p.Deposit__c = record.Loan_Product__r.Deposit__c;
                p.Lender_App_Fee__c = record.Loan_Product__r.Lender_App_Fee__c;
                p.Equalisation_Fee_PPSR__c = record.Loan_Product__r.Equalisation_Fee_PPSR__c;
                
                update p;
            }                                 
            
            return new PageReference('/apex/SDOC__SDCreate1?id=' + record.Id + '&Object=Custom_Opportunity__c');
        }
        catch(Exception e)
        {
            return CustomException.formatException(e);
        }
    }
}