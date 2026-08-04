import javax.naming.*;
import javax.xml.xpath.*;
import java.net.*;
import javax.xml.transform.*;
class P {
  void go() throws Exception {
    Context ctx = new InitialContext();
    ctx.lookup(req.getParameter("name"));
    SpelExpressionParser parser = new SpelExpressionParser();
    parser.parseExpression(req.getParameter("expr"));
    XPath xpath = XPathFactory.newInstance().newXPath();
    xpath.evaluate("/users[name='" + req.getParameter("name") + "']", doc);
    URL url = new URL(req.getParameter("url"));
    TransformerFactory tf = TransformerFactory.newInstance();
  }
}
