public abstract class ObjectJsonSerialize {
    
    public String serialize(){
        return serialize(false);
    }
    
    public String serialize(Boolean suppressApexObjectNulls){
        String s = JSON.serialize(this, suppressApexObjectNulls);
        system.debug('@** Serialized object: -[' + s + ']-');
        return s;
    }
}