public virtual class XMLElement{
    public Dom.XmlNode parent {set; get;}
    public String value {set; get;}
            
    /**
     * Create node XML
     * node. Node father
     * nameNode. Name node
     * textNode. Value node
     * */
    public Dom.Xmlnode createNode (Dom.Xmlnode node, String nameNode, String textNode){
        return createNode(node, nameNode, textNode, null);
    }
        
    /**
     * Create node XML
     * node. Node father
     * nameNode. Name node
     * textNode. Value node
     * attributes. Attributtes node 
     * */
     public Dom.Xmlnode createNode (Dom.XmlNode node, String nameNode, String textNode, Map<String, String> attributes){
         String namespace = null;
         String prefix = null; //Always null for this process
         Dom.Xmlnode nodeChild = node.addChildElement(nameNode, namespace, prefix);
         if (attributes != null){
             for (String key : attributes.keySet()){
                 String value = attributes.get(key);
                 if (value == null){
                     value = '';
                 }
                 nodeChild.setAttribute(key, value); 
             }
         }
         if (textNode != null && !textNode.equalsIgnoreCase('')){
             nodeChild.addTextNode(textNode);
         }
         return nodeChild;
     }
    
}