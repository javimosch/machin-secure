require("node-serialize").unserialize(data);
vm.runInNewContext(data);
var libxmljs = require("libxmljs");
libxmljs.parseXml(data);
eval(req.body);
