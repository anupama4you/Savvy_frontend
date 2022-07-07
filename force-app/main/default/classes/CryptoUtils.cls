public with sharing class CryptoUtils {
	
	private static final String KEYB64 = 'IEOmCqnHSNtQs6V4toenXw==';

	public static String encrypt(String data) {
		if (data == null) return null;
		Blob key = EncodingUtil.base64Decode(KEYB64);
		Blob blobData = Blob.valueOf(data);
		Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, blobData);
		return EncodingUtil.base64Encode(encrypted);
	}

	public static String decrypt(String data) {
		if (data == null) return null;
		Blob key = EncodingUtil.base64Decode(KEYB64);
		Blob encrypted = EncodingUtil.base64Decode(data);
		Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, encrypted);
		return decrypted.toString();
	}

}