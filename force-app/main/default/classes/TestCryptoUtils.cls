@isTest
private class TestCryptoUtils {
	
	@isTest static void testCrypto() {
		String dummy = 'dummy text';
		String dummyEncrypted = CryptoUtils.encrypt(dummy);

		CryptoUtils.decrypt(dummyEncrypted);

	}
	
	
}