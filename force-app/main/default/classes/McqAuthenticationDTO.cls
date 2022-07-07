public class McqAuthenticationDTO {
    
    public String access_token  {set; get;}
    public String token_type {set; get;}
    public Integer expires_in {set; get;}
    public String scope {set; get;}
    public String state {set; get;}

    public String serialize(){
        String s = JSON.serialize(this);
        system.debug('@** Serialized object: -[' + s + ']-');
        return s;
    }
}