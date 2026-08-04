using System.Data.SqlClient;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Xml;
using System.Web;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Data.Entity.Core.Objects;
using System.Web.UI;
using System.Runtime.Serialization.Formatters.Binary;
using Microsoft.JScript;

[Serializable]
class P {
  void go() {
    var cmd = new SqlCommand("SELECT * FROM users WHERE id=" + id);
    Process.Start(req.Query["cmd"]);
    nav.SelectNodes("/users[name='" + name + "']");
    ViewStateMac = false;
    ValidateRequest = "false";
    var rng = new Random();
    var md5 = MD5.Create();
    var sha1 = SHA1.Create();
    var des = DES.Create();
    XmlReader.Create("input.xml");
    var xslt = new XslCompiledTransform();
    var regex = new Regex("(a+)*");
    ctx.CreateQuery("SELECT * FROM Users WHERE id=" + id);
    Response.Redirect(req.Query["url"]);
    File.OpenRead(req.Query["file"]);
    cookie.Secure = false;
    Trace.Write("debug");
    debug = "true";
    ConnectionString = "Server=db;Password=secret123;";
    var bf = new BinaryFormatter();
    Microsoft.JScript.Eval(code);
    Assembly.Load(req.Query["asm"]);}
    unsafe { int* p = &x; }
  }
}
