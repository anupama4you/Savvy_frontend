public class CustomException extends Exception
{
    public static PageReference formatException(Exception e)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, CustomException.getExceptionMessage(e)));
        return null;
    }

    public static PageReference formatWarning(String message)
    {
        formatException(ApexPages.Severity.WARNING, message);
        return null;
    }
    
    public static PageReference formatMessage(String message)
    {
        return formatWarning(ApexPages.Severity.INFO, message);
    }

    public static PageReference formatWarning(ApexPages.Severity severity, String message)
    {
        formatException(severity, message);
        return null;
    }

    public static PageReference formatException(ApexPages.Severity severity, Exception e)
    {
        ApexPages.addMessage(new ApexPages.Message(severity, CustomException.getExceptionMessage(e)));
        return null; 
    }

    public static PageReference formatException(String message)
    {
        return formatException(ApexPages.Severity.ERROR, message);
    }

    public static PageReference formatException(ApexPages.Severity severity, String message)
    {
        ApexPages.addMessage(new ApexPages.Message(severity, message));
        return null;
    }

    public static Boolean formatValidationException(String message)
    {
        formatException(message);
        return false;
    }

    public static PageReference formatExceptionAndRollback(Savepoint sp, String message)
    {
        if(sp != null)
        {
            Database.rollback(sp);
        }
        return formatException(message);
    }

    public static PageReference formatExceptionAndRollback(Savepoint sp, Exception e)
    {
        if(sp != null)
        {
            Database.rollback(sp);
        }
        return formatException(e);
    }

    public static String getExceptionMessage(Exception e)
    {
        String msg = e.getMessage();        
        if(msg.contains('insufficient access rights on object id'))
        {
            return 'You cannot edit this record.';
        }
        if(e instanceof DMLException)
        {
           return ((DMLException)e).getDmlMessage(0);
        }
        if(!(e instanceof CustomException))
        {                       
            msg = ' Line:' + e.getLineNumber().format() + ' ' +  msg;         
        }
        return msg;
    }
    
    public static String getExceptionMessage(Exception e, Integer maxLength)
    {
        String msg = getExceptionMessage(e);        
        if(msg.length() > maxLength)
        {
            msg = msg.substring(0, maxLength);
        }
        return msg;
    }
}