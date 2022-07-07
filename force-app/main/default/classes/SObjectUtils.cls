public class SObjectUtils {
    public static String getQueryString(String conditionAndFilters, String objectAPI){
    	SObjectType objType = Schema.getGlobalDescribe().get(objectAPI);
    	
    	List<String> fieldNames = new List<String>( objType.getDescribe().fields.getMap().keySet() );
    	
    	String query = String.format('SELECT {0} FROM {1} {2}', new String[] {
            String.join( fieldNames, ',' ),
            objType.getDescribe().getName(),
            conditionAndFilters
        });
        
        return query;
    }
}