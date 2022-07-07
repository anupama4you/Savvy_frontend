public class LeadServicingCalcPdfExtension {
    
    public ServicingCalculatorDTO dto {set;get;} 
    
    public LeadServicingCalcPdfExtension(ApexPages.StandardController controller) {
        
        String objData = System.currentPageReference().getParameters().get('OBJ_DATA');
        if (objData != null) {
        	dto = (ServicingCalculatorDTO)JSON.deserialize(objData, ServicingCalculatorDTO.class);
        } else {
            dto = new ServicingCalculatorDTO();
        }
        
    }

}