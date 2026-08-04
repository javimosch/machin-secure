import java.security.MessageDigest;
import java.io.ObjectInputStream;
import javax.xml.parsers.DocumentBuilderFactory;
class Pwn {
  void go(String id) throws Exception {
    Runtime.getRuntime().exec("sh -c " + id);
    new ProcessBuilder("sh", "-c", id).start();
    ObjectInputStream ois = new ObjectInputStream(in);
    MessageDigest.getInstance("MD5");
    MessageDigest.getInstance("SHA-1");
    stmt.executeQuery("SELECT * FROM u WHERE id=" + id);
    String password = "hardcoded12345";
    DocumentBuilderFactory.newInstance();
    TrustAllCerts t = new TrustAllCerts();
  }
}
