<?php
include($_GET['file']);
unlink($_GET['file']);
printf($_GET['fmt']);
?>
