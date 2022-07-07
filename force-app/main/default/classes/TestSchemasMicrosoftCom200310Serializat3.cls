/**
* @author  Phil Dennison C. Fang
* @version 1.0
* @date   2017-03-08 
* @description    Test class for testing schemasMicrosoftCom200310Serializat3 web service apex class
*/

@isTest(SeeAllData=true)
public class TestSchemasMicrosoftCom200310Serializat3 {

    public static testMethod void schemasMicrosoftCom200310Serializat3Test(){
    
            schemasMicrosoftCom200310Serializat3.ArrayOfstring schemasMic200310Ser3ArryStrngTestRec = new schemasMicrosoftCom200310Serializat3.ArrayOfstring(); 
            schemasMic200310Ser3ArryStrngTestRec.string_x = new String[]{'test1','test2','test3'};
            schemasMicrosoftCom200310Serializat3.ArrayOfdecimal schemasMic200310Ser3ArryDcmlTestRec = new schemasMicrosoftCom200310Serializat3.ArrayOfdecimal();
            schemasMic200310Ser3ArryDcmlTestRec.decimal_x = new decimal[]{1.0,2.0,3.0};     
    
    }
    
}