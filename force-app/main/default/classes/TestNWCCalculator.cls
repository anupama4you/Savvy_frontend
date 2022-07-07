@isTest(SeeAllData=true)
public class TestNWCCalculator {

    @isTest static void testNWCCalculator() {
        NWCCalc.Parameter p = new NWCCalc.Parameter();
        p.state = 'TAS';
        p.assetType = 'Car';
        p.plan = 'Bronze';
        p.term = '12';
        p.type_p = 'Safeguard';
        p.awd4wd = 'Yes';
        p.luxuryCar = 'No';
        p.isManuallyNWCPrice = false;
        p.nwcPriceToCustomer = 0;
        p.vehicleAgeYears = 2;
        p.actualKm = 1500;
        p.isIntegrity = true;
        
        NWCCalc.Result r = NWCCalc.CalculateNWC(p);
        System.debug(r.retailPrice);
        System.debug(r.commission);
        
        NWCCalc.NWCPlanOptions('Car');
        NWCCalc.NWCPlanOptions('Car', 'Integrity');
        NWCCalc.NWCTermOptions('Car');
        NWCCalc.NWCTypeOptions ('Car', 'Bronze');  
        NWCCalc.NWCTypeOptions ('Car');
        NWCCalc.NWCTypeOptionsFiltered ('Car', new List<String>{'typeName'});
        
        try{
            p.type_p = 'XX';
        	NWCCalc.CalculateNWC(p);
        }catch(GenericException e){
            System.debug('Excepction- ' + e.getMessage());
        }
        
        try{
            p.state = 'XX';
        	NWCCalc.CalculateNWC(p);
        }catch(GenericException e){
            System.debug('Excepction- ' + e.getMessage());
        }
        
        try{
            p.assetType = 'Bike';
            p.plan = '-';
            p.type_p = '';
        	NWCCalc.CalculateNWC(p);
        }catch(GenericException e){
            System.debug('Excepction- ' + e.getMessage());
        }
        
    }
}