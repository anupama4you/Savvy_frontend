public class McqDocumentUploadRequestDTO extends ObjectJsonSerialize{
    
    public String application_id {set; get;}
    public String filename {set; get;}
    public String document_class {set; get;}
    public String file_content {set; get;}
    public String author {set; get;}
    public String description {set; get;}
    public String comments {set; get;}
    
    public override String toString(){
        String s = '-{';
        s += '-application_id: ' + application_id;
        s += '-filename: ' + filename;
        s += '-document_class: ' + document_class;
        s += '-file_content: ' + file_content;
        s += '-author: ' + author;
        s += '-description: ' + description;
        s += '-comments: ' + comments;
        s += '}-';
        return s;
    }
}