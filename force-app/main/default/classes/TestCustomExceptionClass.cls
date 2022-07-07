@isTest
public class TestCustomExceptionClass
{
    public static testMethod void myUnitTest()
    {
        CustomException.formatException(new CustomException());   
        CustomException.formatWarning('Test Exception');
        CustomException.formatMessage('Test Exception');
        CustomException.formatWarning(ApexPages.Severity.WARNING, 'Test Exception');
        CustomException.formatException(ApexPages.Severity.ERROR, new CustomException());
        CustomException.formatException('Test Exception');
        CustomException.formatException(ApexPages.Severity.ERROR, 'Test Exception');
        CustomException.formatValidationException('Test Exception');
        CustomException.formatExceptionAndRollback(Database.setSavepoint(), 'Test Exception');
        CustomException.formatExceptionAndRollback(Database.setSavepoint(), new CustomException());
        CustomException.getExceptionMessage(new CustomException());
        CustomException.getExceptionMessage(new CustomException(), 0);                                       
    }
}