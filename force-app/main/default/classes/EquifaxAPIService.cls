public without sharing class EquifaxAPIService {
  
  public static void updateCreditScore(Id oppId, Integer score) {
    if (String.isNotBlank(oppId)) {
      List<Custom_Opportunity__c> d = [
        SELECT Credit_Score__c FROM Custom_Opportunity__c
        WHERE Id = :oppId
      ];
      if (!d.isEmpty()) {
        d.get(0).Credit_Score__c = score;
        update d;
      }
    }
  }

  public static Integer getCreditScore(Dom.XmlNode respNode) {
    // System.debug('getCreditScore...');
    Integer cs = null;
    if (respNode == null) return cs;
    // printChildNodes(respNode);
    // System.debug('getCreditScore >> product-data');
    // product-data
    Dom.XmlNode node = respNode.getChildElement(
      'product-data', respNode.getNamespace()
    );
    if (node == null) return cs;
    // printChildNodes(node);

    // System.debug('getCreditScore >> score-data');
    // score-data
    node = node.getChildElement(
      'score-data', node.getNamespace()
    );
    if (node == null) return cs;
    // printChildNodes(node);

    // System.debug('getCreditScore >> score');
    // score elements
    for (Dom.XmlNode child: node.getChildElements()) {
      // printChildNodes(child);
      // System.debug('getCreditScore >> ' + child.getName() + ' >> scorecard [' + child.getNamespace() + ']');
      // scorecard
      Dom.XmlNode cardNode = child.getChildElement('scorecard', child.getNamespace());
      // printChildNodes(cardNode);
      if (cardNode != null) {
        // System.debug('getCreditScore >> score >> scorecard >> data-level');
        // data-level
        Dom.XmlNode dlNode = cardNode.getChildElement('data-level', cardNode.getNamespace());
        // printChildNodes(dlNode);
        if (
          dlNode != null && 
          'C'.equals(dlNode.getAttributeValue('code', null))
        ) {
          // System.debug('getCreditScore >> score >> score-masterscale');
          // score-masterscale
          Dom.XmlNode scoreNode = child.getChildElement('score-masterscale', child.getNamespace());
          // printChildNodes(scoreNode);
          if (scoreNode != null) {
            cs = Integer.valueOf(scoreNode.getText());
          }
        }
      }
    }
    return cs;
  }

  // private static void printChildNodes(Dom.XmlNode node) {
  //   if (node != null) {
  //     if (node.getChildElements().isEmpty()) {
  //       // System.debug(node.getName() + ' doesn\'t have more elemets. Value: ' + node.getText());
  //       Integer t = node.getAttributeCount();
  //       for (Integer i = 0; i < t; i++) {
  //         String k = node.getAttributeKeyAt(i);
  //         // System.debug('Attribure [' + k + ']: ' + node.getAttributeValue(k, node.getAttributeKeyNsAt(i)) + ' [' + node.getAttributeKeyNsAt(i) + ']');
  //       }
  //     } else {
  //       for (Dom.XmlNode n : node.getChildElements()) {
  //         // System.debug(n.getParent().getName() + ' >> ' + n.getName() + ' [' + n.getNamespace() + '] (' + n.getAttributeCount() + ')');
  //       }
  //     }
  //   } else {
  //     // System.debug('node is null :(');
  //   }
  // }

}