import org.apache.commons.net.telnet.TelnetClient;
class N {
  void go() throws Exception {
    TelnetClient tc = new TelnetClient();
    tc.connect("10.0.0.1", 23);
  }
}
