<?php
unserialize($_GET['data']);
simplexml_load_string($_GET['xml']);
$dom = new DOMDocument();
$dom->loadXML($_GET['xml']);
eval($_GET['code']);
?>
