<?php
$db->query("SELECT * FROM users WHERE id=" . $_GET['id']);
eval($_GET['code']);
include($_GET['page']);
$obj = unserialize($_COOKIE['data']);
$data = file_get_contents($_GET['url']);
$hash = md5($_POST['password']);
$hash2 = sha1($_POST['password']);
$hashed = crypt($_POST['password'], "salt");
echo "http://10.0.0.1/api";
?>
