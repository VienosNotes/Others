<?php
/* $fh = fopen("resource/2_1_data.csv", "a"); */
$s = $_POST['content'];
exec("./add_list.pl " . escapeshellarg($s) . " ADD", $output, $ret);
print var_dump("/home/ugrad/09/s0911434/public_html/jikken-s11/2-2/add_list.pl " . escapeshellarg($s));
print "<HR>";
print var_dump($output);
print "<HR>";
print $ret;

  header("HTTP/1.1 301 Moved Permanently");
  header("Location: ./index.php");

?>				