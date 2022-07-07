public class FinanceOneFile {
    //  The boundary is alligned so it doesn't produce padding characters when base64 encoded.
    private final static string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';
    
    /**
*  Returns the request's content type for multipart/form-data requests.
*/

    public static string GetContentType() {
        return 'multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"';
    }
    
    /**
*  Pad the value with spaces until the base64 encoding is no longer padded.
*/

    private static string SafelyPad(
        string value,
        string valueCrLf64,
        string lineBreaks) {
            string valueCrLf = '';
            blob valueCrLfBlob = null;
                        
            while (valueCrLf64.endsWith('=')) {
                value += ' ';
                valueCrLf = value + lineBreaks;
                valueCrLfBlob = blob.valueOf(valueCrLf);
                
                valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
            }
            
            return valueCrLf64;
        }
    
    /**
*  Write a boundary between parameters to the form's body.
*/

    public static string WriteBoundary() {
        string value = '--' + Boundary + '\r\n';
        blob valueBlob = blob.valueOf(value);
        
        return EncodingUtil.base64Encode(valueBlob);
    }

    /**
*  Write a boundary at the end of the form's body.
*/

    public static string WriteBoundary(
        EndingType ending) {
            string value = '';
            
            if (ending == EndingType.Cr) {
                //  The file's base64 was padded with a single '=',
                //  so it was replaced with '\r'. Now we have to
                //  prepend the boundary with '\n' to complete
                //  the line break.
                value += '\n';
            } else if (ending == EndingType.None) {
                //  The file's base64 was not padded at all,
                //  so we have to prepend the boundary with
                //  '\r\n' to create the line break.
                value += '\r\n';
            }
            //  Else:
            //  The file's base64 was padded with a double '=',
            //  so they were replaced with '\r\n'. We don't have to
            //  do anything to the boundary because there's a complete
            //  line break before it.
            value += '--' + Boundary + '--';
            
            blob valueBlob = blob.valueOf(value);
            
            return EncodingUtil.base64Encode(valueBlob);
        }

    /**
*  Wirte a file to the form's body.
*/

    public static WriteFileResult WriteFile(
        string key,
        string value,
        string mimeType,
        blob fileBlob) {
            
            EndingType ending = EndingType.None;
            string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"; filename="' + value + '"';
            string contentDispositionCrLf = contentDisposition + '\r\n';
            blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
            string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrlfBlob);
            string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n');
            string contentType = 'Content-Type: ' + mimeType;
            string contentTypeCrLf = contentType + '\r\n\r\n';
            
            blob contentTypeCrLfBlob = blob.valueOf(contentTypeCrLf);
            string contentTypeCrLf64 = EncodingUtil.base64Encode(contentTypeCrLfBlob);
            
            content += SafelyPad(contentType, contentTypeCrLf64, '\r\n\r\n');

            string file64 = EncodingUtil.base64Encode(fileBlob);
            integer file64Length = file64.length();
            string file64Ending = file64.substring(file64Length - 3, file64Length);
            
            if (file64Ending.endsWith('==')) {
                file64Ending = file64Ending.substring(0, 1) + '0K';//   0K = \r\n
                file64 = file64.substring(0, file64Length - 3) + file64Ending;
                ending = EndingType.CrLf;
            } else if (file64Ending.endsWith('=')) {
                file64Ending = file64Ending.substring(0, 2) + 'N';//    N = \r
                file64 = file64.substring(0, file64Length - 3) + file64Ending;
                ending = EndingType.Cr;
            }
            
            content += file64;

            return new WriteFileResult(content, ending);
        }

    public static WriteFileResult WriteFile2(
        string key,
        string value,
        string mimeType,
        blob fileBlob) {
            EndingType ending = EndingType.None;
            string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"; filename="' + value + '"';
            string contentDispositionCrLf = contentDisposition + '\r\n';
            blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
            string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrlfBlob);
            string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n');
            string contentType = 'Content-Type: ' + mimeType;
            string contentTypeCrLf = contentType + '\r\n\r\n';
            blob contentTypeCrLfBlob = blob.valueOf(contentTypeCrLf);
            string contentTypeCrLf64 = EncodingUtil.base64Encode(contentTypeCrLfBlob);
            
            content += SafelyPad(contentType, contentTypeCrLf64, '\r\n\r\n');
            
            string file64 = EncodingUtil.base64Encode(fileBlob);
            integer file64Length = file64.length();
            string file64Ending = file64.substring(file64Length - 3, file64Length);
            
            if (file64Ending.endsWith('==')) {
                file64Ending = file64Ending.substring(0, 1) + '0K';//   0K = \r\n
                file64 = file64.substring(0, file64Length - 3) + file64Ending;
                ending = EndingType.CrLf;
            } else if (file64Ending.endsWith('=')) {
                file64Ending = file64Ending.substring(0, 2) + 'N';//    N = \r
                file64 = file64.substring(0, file64Length - 3) + file64Ending;
                ending = EndingType.Cr;
            }
            
            return new WriteFileResult(content, ending);
        }

    /**
*  Write a key-value pair to the form's body.
*/

    public static string WriteBodyParameter(
        string key,
        string value) {
            string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
            string contentDispositionCrLf = contentDisposition + '\r\n\r\n';
            blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
            string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
            string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
            string valueCrLf = value + '\r\n';
            blob valueCrLfBlob = blob.valueOf(valueCrLf);
            string valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
            
            content += SafelyPad(value, valueCrLf64, '\r\n');
            
            return content;
        }

    /**
*  Helper class containing the result of writing a file's blob to the form's body.
*/

    public class WriteFileResult {
        public final string Content { get; private set; }
        public final EndingType EndingType { get; private set; }
        
        public WriteFileResult(
            string content,
            EndingType ending) {
                this.Content = content;
                this.EndingType = ending;
            }
    }

    /**
*  Helper enum indicating how a file's base64 padding was replaced.
*/

    public enum EndingType {
        Cr,
            CrLf,
            None
            }
        
        /**    
        *this method will work for only parameters in the form data    
        */
            public static string append(string key , string value ){
                string formParam=FinanceOneFile.WriteBoundary()+WriteBodyParameter(key, value);
                return formParam;
            }
            
            /**    
        *this method will work for file parameters and other params in the form data    
        */
            public static Blob makeBlobWithFile(String key ,Blob attachBody,string filename,string otherParamsEncoded, Boolean file, String mimeType){
                
                String header = '--' + boundary + '\r\n' +
                    + 'Content-Type: '+mimeType+'\r\n'+
                    + 'Content-Disposition: form-data; name="'+key+'";filename="' + filename +'"';        
                
                String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header + '\r\n\r\n'));
                while(headerEncoded.endsWith('=')){
                    header += ' ';
                    headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
                }
                String footer = '--' + boundary + '--';     
                String bodyEncoded = EncodingUtil.base64Encode(attachBody);       
                Blob formBlob = null;    
                String last4Bytes = bodyEncoded .substring(bodyEncoded.length()-4,bodyEncoded.length());
                
                if(last4Bytes.endsWith('==')) {
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+footerEncoded);
                    if(file){
                      last4Bytes = last4Bytes.substring(0,2) + '0K';
                      bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                      formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
                    }
                } else if(last4Bytes.endsWith('=')) {
                    footer = '\n' + footer;
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+footerEncoded);
                    if(file){
                      last4Bytes = last4Bytes.substring(0,3) + 'N';
                      bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                      formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
                    }
                } else {
                    footer = '\r\n' + footer;
                    String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                    formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+footerEncoded);
                    if(file){
                      formBlob = EncodingUtil.base64Decode(otherParamsEncoded+headerEncoded+bodyEncoded+footerEncoded);
                    }
                }
                
                return formBlob; // returning the form data as a blob 
                
            }
}