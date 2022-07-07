trigger trgAccountBeforeIU on Account (before insert, before update) 
{
    // find the person account record type
    RecordType rt = [SELECT Id
                     FROM RecordType
                     WHERE sObjectType = 'Account'
                     AND Name = 'Person Account'];

    // find the sets of first names and last names
    Set<String> firstNames = new Set<String>();
    Set<String> lastNames = new Set<String>();
    Set<String> PersonMobilePhones = new Set<String>();
    Set<String> PersonEmails =new Set<String>();

    for (Account newAcc : Trigger.New)
    {
        if (newAcc.RecordTypeId == rt.Id)
        {
            firstNames.add(newAcc.FirstName.toLowerCase());
            lastNames.add(newAcc.LastName.toLowerCase());
        }
    }

    // collect the map of existing accounts
    Map<String, Set<Id>> existing = new Map<String, Set<Id>>();
    for (Account a : [SELECT Id,
                             //FirstName,
                             //LastName,
                             PersonMobilePhone,
                             PersonEmail
                      FROM Account
                      WHERE RecordType.Name = 'Person Account'
                      AND PersonMobilePhone IN :PersonMobilePhones
                      AND PersonEmail IN :PersonEmails])
                    
                    //AND FirstName IN :firstNames
                    //AND LastName IN :lastNames])
    {    
        String key = //(a.FirstName != null ? a.FirstName : '').toLowerCase() + ';' 
                     //+ (a.LastName != null ? a.LastName : '').toLowerCase() + ';' + 
                     (a.PersonMobilePhone != null ? a.PersonMobilePhone : '').replace(' ', '') + ';' +
                      (a.PersonEmail != null ? a.PersonEmail : '').toLowerCase();

        if (!existing.containsKey(key))
        {
            existing.put(key, new Set<Id>());    
        }
        
        existing.get(key).add(a.Id);
    }                      
                                     
    for (Account newAcc : Trigger.New)
    {
        // only check duplicates if this is a person account
        if (newAcc.RecordTypeId == rt.Id)
        {    
            String key = //newAcc.FirstName.toLowerCase() + ';' + newAcc.LastName.toLowerCase() + ';' + 
            newAcc.PersonMobilePhone.replace(' ', '') + ';' + newAcc.PersonEmail.toLowerCase();
        
            if (existing.containsKey(key))
            {
                for (Id i : existing.get(key))
                {
                    if (i != newAcc.Id)
                    {
                        newAcc.addError('An Account already exists with this mobile phone and email.');
                    }
                }                        
            }
        }
    }
}