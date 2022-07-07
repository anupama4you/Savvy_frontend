public class FinanceOneSecurity {
    public static FinanceOneDTOs.Security security(Application__c a, Application_Asset_Detail__c asset, Glass_Variant__c g, Application_Quoting__c quoting){
        FinanceOneDTOs.Security security = new FinanceOneDTOs.Security();
        
        if(asset != null){
            security.preApproval = false;
            System.debug(quoting.Goods_type__c);
            if(quoting.Goods_type__c.equals('Car')){
                security.motorVehicles = new FinanceOneDTOs.MotorVehicle[1];
                security.watercraft = new FinanceOneDTOs.Watercraft[0];
                security.motorbikes = new FinanceOneDTOs.Motorbike[0];
                security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[0];
                security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
                security.otherGoods = new FinanceOneDTOs.OtherGoods[0];
                security.motorVehicles[0] = new FinanceOneDTOs.MotorVehicle();
                security.motorVehicles[0].make = asset.Make__c;
                security.motorVehicles[0].model = asset.Model__c;
                security.motorVehicles[0].year = asset.Year__c.intValue();
                if(asset.Actual_KM__c != null){
                    security.motorVehicles[0].hasOdometer = true;
                    security.motorVehicles[0].odometer = asset.Actual_KM__c.intValue();
                }else{
                    security.motorVehicles[0].hasOdometer = false;    
                }
                security.motorVehicles[0].isUnderFinance = false;
                security.motorVehicles[0].vin = asset.VIN__c;
                if(g != null){
                    security.motorVehicles[0].nvic = g.NVIC__c;
                }
                security.motorVehicles[0].motorVehicleType = quoting.Goods_sub_type__c;
            }
            
            if(quoting.Goods_type__c.equals('Motorbike')){
                security.motorVehicles = new FinanceOneDTOs.MotorVehicle[0];
                security.watercraft = new FinanceOneDTOs.Watercraft[0];
                security.motorbikes = new FinanceOneDTOs.Motorbike[1];
                security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[0];
                security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
                security.otherGoods = new FinanceOneDTOs.OtherGoods[0];
                security.motorbikes[0] = new FinanceOneDTOs.Motorbike();
                security.motorbikes[0].make = asset.Make__c;
                security.motorbikes[0].model = asset.Model__c;
                security.motorbikes[0].year = asset.Year__c.intValue();
                if(asset.Actual_KM__c != null){
                    security.motorbikes[0].hasOdometer = true;
                    security.motorbikes[0].odometer = asset.Actual_KM__c.intValue();
                }else{
                    security.motorbikes[0].hasOdometer = false;    
                }
                security.motorbikes[0].isUnderFinance = false;
                security.motorbikes[0].vin = asset.VIN__c;
                if(g != null){
                    security.motorbikes[0].nvic = g.NVIC__c;
                }
                security.motorbikes[0].motorbikeType = quoting.Goods_sub_type__c;
            }
            
            if(quoting.Goods_type__c.equals('Caravan')){
                security.motorVehicles = new FinanceOneDTOs.MotorVehicle[0];
                security.watercraft = new FinanceOneDTOs.Watercraft[0];
                security.motorbikes = new FinanceOneDTOs.Motorbike[0];
                security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[1];
                security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
                security.otherGoods = new FinanceOneDTOs.OtherGoods[0];
                security.recreationalAssets[0] = new FinanceOneDTOs.RecreationalAsset();
                security.recreationalAssets[0].make = asset.Make__c;
                security.recreationalAssets[0].model = asset.Model__c;
                security.recreationalAssets[0].year = asset.Year__c.intValue();
                if(asset.Actual_KM__c != null){
                    security.recreationalAssets[0].hasOdometer = true;
                    security.recreationalAssets[0].odometer = asset.Actual_KM__c.intValue();
                }else{
                    security.recreationalAssets[0].hasOdometer = false;    
                }
                security.recreationalAssets[0].isUnderFinance = false;
                security.recreationalAssets[0].vin = asset.VIN__c;
                if(g != null){
                    security.recreationalAssets[0].nvic = g.NVIC__c;
                }
                security.recreationalAssets[0].recreationalAssetType = quoting.Goods_sub_type__c;
            }
            
            if(quoting.Goods_type__c.equals('Boat')){
                security.motorVehicles = new FinanceOneDTOs.MotorVehicle[0];
                security.watercraft = new FinanceOneDTOs.Watercraft[1];
                security.motorbikes = new FinanceOneDTOs.Motorbike[0];
                security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[0];
                security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
                security.otherGoods = new FinanceOneDTOs.OtherGoods[0];
                security.watercraft[0] = new FinanceOneDTOs.Watercraft();
                security.watercraft[0].make = asset.Make__c;
                security.watercraft[0].model = asset.Model__c;
                security.watercraft[0].year = asset.Year__c.intValue();
                security.watercraft[0].isUnderFinance = false;
                security.watercraft[0].hin = asset.VIN__c;
                security.watercraft[0].watercraftType = quoting.Goods_sub_type__c;
            }
            
            if(quoting.Goods_type__c.equals('Equipment') || 
              quoting.Goods_type__c.equals('Truck')){
                security.motorVehicles = new FinanceOneDTOs.MotorVehicle[0];
                security.watercraft = new FinanceOneDTOs.Watercraft[0];
                security.motorbikes = new FinanceOneDTOs.Motorbike[0];
                security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[0];
                security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
                security.otherGoods = new FinanceOneDTOs.OtherGoods[1];
                security.otherGoods[0] = new FinanceOneDTOs.OtherGoods();
                security.otherGoods[0].isUnderFinance = false;
                security.otherGoods[0].description = asset.Make__c+' '+asset.Model__c+' '+asset.Variant__c+' '+asset.Series__c;
            }
        }else{
            security.preApproval = true;
            security.motorVehicles = new FinanceOneDTOs.MotorVehicle[0];
            security.watercraft = new FinanceOneDTOs.Watercraft[0];
            security.motorbikes = new FinanceOneDTOs.Motorbike[0];
            security.recreationalAssets = new FinanceOneDTOs.RecreationalAsset[0];
            security.allPAAP = new FinanceOneDTOs.AllPAAP[0];
            security.otherGoods = new FinanceOneDTOs.OtherGoods[0];
        }
        return security;
    }
}