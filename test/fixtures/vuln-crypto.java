import javax.crypto.Cipher;
import java.security.MessageDigest;
class P {
  void go() throws Exception {
    Cipher c = Cipher.getInstance("RSA/ECB/PKCS1Padding");
    Cipher c2 = Cipher.getInstance("AES/ECB/PKCS5Padding");
    byte[] iv = "hardcodediv12".getBytes();
    MessageDigest.getInstance("MD5").update(password.getBytes());
  }
}
