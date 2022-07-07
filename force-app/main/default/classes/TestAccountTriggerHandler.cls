@isTest
private class TestAccountTriggerHandler {
	
	@isTest static void testTriggerOptions() {
		Test_DataGeneratorHelper.createAccount();
		Account a = Test_DataGeneratorHelper.tstAccount;
		a.FirstName = 'New Name';
		update a;
	}

	@isTest static void testAccountShareService() {
		Test_DataGeneratorHelper.createAccount();
		Account a = Test_DataGeneratorHelper.tstAccount;
		Set<Id> lst = new Set<Id>();
		lst.add(a.Id);
		AccountShareService.createShares(lst);
		AccountShareService.deleteShares(lst);
	}

	@isTest static void testAccountService() {
    Test.startTest();
		List<Account> accs = new List<Account>();
		Account a = getDummyAccount();
		accs.add(a);
		a = getDummyAccount();
    a.PersonMobilePhone = '0415888997';
		accs.add(a);
    insert a;

    a.PersonMobilePhone = '0415888996';
    update a;

    a.PersonEmail = 'test-45454546@gmail777.com';
    update a;



    
    // Validating Account has the same Mobile number and email address.
    accs = new List<Account>{a};
    a = getDummyAccount();
    accs.add(a);
    AccountService.checkAccEmailMobileDuplicate(accs);

    // Validating An Account with this email address already exists.
    accs = new List<Account>{a};
    AccountService.checkAccEmailMobileDuplicate(accs);

    AccountService.setDefaultOwnership(null);
    
    Test.stopTest();
		// try {
			
		// } catch(Exception e) {
		// 	Boolean expectedExceptionThrown = e.getMessage().contains('Another new Account has the same email address');
		// 	System.AssertEquals(expectedExceptionThrown, true);
		// }
		// accs.get(0).PersonEmail = 'new-' + accs.get(0).PersonEmail;
		// try {
		// 	insert accs;
		// } catch(Exception e) {
		// 	Boolean expectedExceptionThrown = e.getMessage().contains('Another new Account has the same Mobile number');
		// 	System.AssertEquals(expectedExceptionThrown, true);
		// }
		/*
		accs.get(0).PersonMobilePhone = '0499888999';
		upsert accs;
		accs = new List<Account>();
		a = getDummyAccount();
		try {
			insert a;
		} catch(Exception e) {
			Boolean expectedExceptionThrown = e.getMessage().contains('An Account with this email address already exists');
			System.AssertEquals(expectedExceptionThrown, true);
		}
		a = getDummyAccount();
		a.PersonEmail = 'new2-' + a.PersonEmail;
		try {
			insert a;
		} catch(Exception e) {
			System.debug(e.getMessage());
			Boolean expectedExceptionThrown = e.getMessage().contains('An Account with this Mobile number already exists');
			System.AssertEquals(expectedExceptionThrown, true);
		}
		*/
	}

	public static Account getDummyAccount() {
		return new Account(RecordTypeId = SOQLSingletonQueries.recs().recordTypes.get('Person Account'), 
                        FirstName = 'Testsdf', LastName = 'Teshhtwf', 
                        PersonOtherStreet = 'Test', PersonOtherCity = 'Test', 
                        PersonOtherState = 'Test', PersonOtherPostalCode = 'Test',
                        PersonMobilePhone = '0415888999', PersonEmail = 'test-45454545@gmail777.com',
                        OwnerId = SOQLSingletonQueries.recs().sysGenUser.Id);
	}

}