public class OpportunityEditExtension
{
    public OpportunityEditExtension(ApexPages.StandardController c)
    {
        record = (Custom_Opportunity__c)c.getRecord();                
        
        // if lead Id has been supplied then we are converting the lead so populate oppportunity fields
        for (Lead__c l : [SELECT Id,
                                 Name,
                                 Account__c,
                                 Home_Phone__c,
                                 Work_Phone__c,
                                 Mobile_Number__c,
                                 Email_Address__c,
                                 State__c,
                                 Postcode__c,
                                 Notes__c,
                                 Application__c
                          FROM Lead__c
                          WHERE Id = :ApexPages.CurrentPage().getParameters().get('leadId')])
        {                       
            record.Lead__c = l.Id;
            record.Application__c = l.Application__c;
            record.Name = l.Name;
            record.Account__c = l.Account__c;
            record.Home_Phone__c = l.Home_Phone__c;
            record.Work_Phone__c = l.Work_Phone__c;
            record.Mobile_Number__c = l.Mobile_Number__c;
            record.Email_Address__c = l.Email_Address__c;
            record.State__c = l.State__c;
            if (String.isBlank(record.State__c)) {
                record.State__c = PostcodeHelper.getState(l.Postcode__c);
            }
            LeadNotes = l.Notes__c;
        }                                                                  
        
        for (RecordType rt : [SELECT Id,
                                     Name
                              FROM RecordType
                              WHERE sObjectType = 'Product__c'])
        {
            if (rt.Name == 'Finance')
            {
                FinanceRT = rt.Id;
            }
            else if (rt.Name == 'Insurance')
            {
                InsuranceRT = rt.Id;
            }
        }                              
    }

    private Custom_Opportunity__c record;
    public String FinanceRT { get; set; }
    public String InsuranceRT { get; set; }
    public String RemoveKey { get; set; }
    public String LeadNotes { get; set; }
    
    public Boolean Convert 
    { 
        get 
        { 
            return (ApexPages.CurrentPage().getParameters().get('leadId') != null);
        } 
    }
    
    public List<ProductWrapper> Products
    {
        get
        {
            if (Products == null)
            {
                Products = new List<ProductWrapper>();
            }
            return Products;
        }
        set;
    }       
    
    public void AddProduct()
    {
        try
        {                                                           
            Products.add(new ProductWrapper(FinanceRT, String.valueOf(Datetime.now())));    
        }
        catch(Exception e)
        {
            CustomException.formatException(e);
        }     
    }
    
    public void RemoveProduct()
    {
        try
        {                                                           
            for (Integer i = 0; i < Products.size(); i++)
            {
                if (Products[i].Key == RemoveKey)
                {
                    Products.remove(i);
                    break;
                }
            }
        }
        catch(Exception e)
        {
            CustomException.formatException(e);
        }     
    }
          
    public PageReference Save()
    {
        //try
        //{   //Lelo								2016-07-26 
            // check that the products are valid           
            /*      
            if (!ValidateProducts())
            {
                return null;
            }*/
                                    
            // update the status of the parent lead to become opportunity if it's not already that
            for (Lead__c l : [SELECT Id,
                                     Status__c
                              FROM Lead__c
                              WHERE Id = :ApexPages.CurrentPage().getParameters().get('leadId')
                              AND Status__c != 'Become Opportunity'])
            {
                l.Status__c = 'Become Opportunity';
                update l;
            } 

            // upsert the opportunity
            upsert record;
            
            OpportunityService.uploadS3ApplicationDocs(new List<Custom_Opportunity__c>{record}, null);

            
            //Lelo 													2016-07-26
            /*
            List<Product__c> newProducts = new List<Product__c>(); 
            
            // assign the opportunity Id to the products
            for (ProductWrapper p : Products)            
            {
                p.Product.Opportunity_Name__c = record.Id;
                newProducts.add(p.Product);
            }                        
            
            // insert the new products
            insert newProducts;*/
            
            return new PageReference('/' + record.Id);
        //}
        //catch(Exception e)
        //{
        //    return CustomException.formatException(e);
        //}    
    }
    
    public Boolean ValidateProducts()
    {
        Boolean valid = true;
        
        if (Products.size() == 0)
        {
            CustomException.formatException('At least one product must be created before the opportunity can be saved');
            valid = false;    
        }
        
        for (ProductWrapper p : Products)
        {
            if (p.Product.RecordTypeId == FinanceRT)
            {
                if (p.Product.Loan_Type__c == null) { p.Product.Loan_Type__c.addError('You must enter a value'); valid = false; }   
                if (p.Product.Loan_Purpose__c == null) { p.Product.Loan_Purpose__c.addError('You must enter a value'); valid = false; }   
                if (p.Product.Cost_of_Goods__c == null) { p.Product.Cost_of_Goods__c.addError('You must enter a value'); valid = false; }    
                if (p.Product.DOF__c == null) { p.Product.DOF__c.addError('You must enter a value'); valid = false; }    
                if (p.Product.Brokerage__c == null) { p.Product.Brokerage__c.addError('You must enter a value'); valid = false; }    
                if (p.Product.Lender__c == null) { p.Product.Lender__c.addError('You must enter a value'); valid = false; }    
                if (p.Product.Loan_Term__c == null) { p.Product.Loan_Term__c.addError('You must enter a value'); valid = false; }                                     
            }
            else if (p.Product.RecordTypeId == InsuranceRT)
            {
                if (p.Product.Insurance_Type__c == null) { p.Product.Insurance_Type__c.addError('You must enter a value'); valid = false; }                                
                if (p.Product.Insurance_Commission__c == null) { p.Product.Insurance_Commission__c.addError('You must enter a value'); valid = false; }    
                if (p.Product.Insurer__c == null) { p.Product.Insurer__c.addError('You must enter a value'); valid = false; }                
            }
        }
        
        return valid;
    }
    
    public List<SelectOption> ProductTypes
    {
        get
        {
            if (ProductTypes == null)
            {
                ProductTypes = new List<SelectOption>();
            
                for (RecordType rt : [SELECT Id,
                                             Name
                                      FROM RecordType
                                      WHERE sObjectType = 'Product__c'])
                {                                      
                    ProductTypes.add(new SelectOption(rt.Id, rt.Name));
                }                     
            }
            return ProductTypes;
        }
        set;
    }
    
    private class ProductWrapper
    {
        public ProductWrapper(Id rt, String k)
        {
            Product = new Product__c(RecordTypeId = rt);
            Key = k;
        }
    
        public Product__c Product { get; set; }    
        public String Key { get; set; }
    }
}