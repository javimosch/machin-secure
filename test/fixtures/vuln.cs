using System.Diagnostics;
using System.Security.Cryptography;
using System.Data.SqlClient;
class P {
  void go(string s) {
    Process.Start("cmd /c " + s);
    MD5.Create();
    new SqlCommand("SELECT * FROM u WHERE id=" + s);
  }
}
