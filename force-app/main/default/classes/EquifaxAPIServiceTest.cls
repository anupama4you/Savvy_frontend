@IsTest(SeeAllData=true)
public class EquifaxAPIServiceTest {

  @IsTest
  static void testService() {
    Custom_Opportunity__c o = Test_DataGeneratorHelper.buildOpp(true);
    Test.startTest();
    
    // Load xml data
    Dom.Document doc = new DOM.Document();
    doc.load(equifaxResponseMock());
    Dom.XmlNode node = doc.getRootElement();
    
    Integer score = EquifaxAPIService.getCreditScore(node);
    System.debug('@@score: '+ score);
    System.assert(score != null, 'Credit score not found');

    EquifaxAPIService.updateCreditScore(o.Id, score);

    Test.stopTest();
  }
  
  public static String equifaxResponseMock() {
    String xml = '';
    xml = '<vsa:response response-type="report" xmlns:vsa="http://www.vedaxml.com/products/vedascore/apply/v1">';
    xml += '   <vsa:product-data>';
    xml += '      <vsa:score-data>';
    xml += '         <vsa:score>';
    xml += '            <vsa:scorecard id="VSA_2.0_X_CR" scorecard-index="1">';
    xml += '               <vsa:name>VedaScore Apply</vsa:name>';
    xml += '               <vsa:version>2.0</vsa:version>';
    xml += '               <vsa:type>Consumer</vsa:type>';
    xml += '               <vsa:data-level code="C">Comprehensive</vsa:data-level>';
    xml += '            </vsa:scorecard>';
    xml += '            <vsa:risk-odds>2.1</vsa:risk-odds>';
    xml += '            <vsa:score-masterscale>307</vsa:score-masterscale>';
    xml += '         </vsa:score>';
    xml += '      </vsa:score-data>';
    xml += '   </vsa:product-data>';
    xml += '</vsa:response>';
    return xml;
  }


}