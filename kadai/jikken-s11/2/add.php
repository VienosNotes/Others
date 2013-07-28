<?php
$fh = fopen("resource/2_1_data.csv", "a");
fwrite($fh, htmlspecialchars($_POST['content'] . "\n"));
fclose($fh);
  header("HTTP/1.1 301 Moved Permanently");
  header("Location: ./index.php");
?>