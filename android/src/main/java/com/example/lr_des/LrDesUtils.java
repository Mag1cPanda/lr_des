package com.example.lr_des;

import android.util.Base64;

import java.security.Key;
import javax.crypto.Cipher;

public class LrDesUtils {
    private Cipher encryptCipher = null;
    private Cipher decryptCipher = null;

    public LrDesUtils(String strKey) throws Exception {
        //Security.addProvider(new com.sun.crypto.provider.SunJCE());
        Key key = getKey(strKey.getBytes());
        encryptCipher = Cipher.getInstance("DES");
        encryptCipher.init(Cipher.ENCRYPT_MODE, key);
        decryptCipher = Cipher.getInstance("DES");
        decryptCipher.init(Cipher.DECRYPT_MODE, key);
    }

    private Key getKey(byte[] arrBTmp) {
        byte[] arrB = new byte[8];
        for (int i = 0; i < arrBTmp.length && i < arrB.length; i++) {
            arrB[i] = arrBTmp[i];
        }
        Key key = new javax.crypto.spec.SecretKeySpec(arrB, "DES");   //原始的，未作加工过的
        return key;
    }

    public String encrypt(String strIn) throws Exception {
        return byteArr2Base64Str(encrypt(strIn.getBytes()));
    }

    public byte[] encrypt(byte[] arrB) throws Exception {
        return encryptCipher.doFinal(arrB);
    }

    public String decrypt(String strIn) throws Exception {
        return new String(decrypt(base64Str2ByteArr(strIn)),"UTF-8");
    }

    public byte[] decrypt(byte[] arrB) throws Exception {
        return decryptCipher.doFinal(arrB);
    }

    public static String byteArr2Base64Str(byte[] arrB) {
        String base64String = Base64.encodeToString(arrB, Base64.DEFAULT);
        return base64String;
    }

    public static byte[] base64Str2ByteArr(String strIn) {
        byte [] byteArray = Base64.decode(strIn, Base64.DEFAULT);
        return byteArray;
    }

}
