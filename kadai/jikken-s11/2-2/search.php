
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
     <title></title>
     </head><body>
<style type="text/css">
table, td, th { border: 1px #1b1b1b solid ;
                border-collapse: collapse ; }
     </style>

 <?php 
$s = urldecode($_GET['query']);
exec("./add_list.pl " . escapeshellarg($s) . " SEARCH", $output, $ret);
$target = str_getcsv($output[0]);
print "ID:" . $target[0] . "<br>";
print "<img src=\"" . $s . "\">";

print"<hr>";

$fileName = "resource/2_1_data.csv";
$file = fopen($fileName, "r");
while ($current = fgetcsv($file)) {
    if (!strcmp($target[0], $current[0])) { continue; }
    $similarity = ($target[1] * $current[1]) + ($target[2] * $current[2]) + ($target[3] * $current[3]);
    $ans[$current[0]] = $similarity;
}
array_multisort($ans, SORT_NUMERIC);
$ans = array_reverse($ans);
print "<table>";
print "<tr><th>id</th><th>Similarity</th><th>Image</th></tr>";
foreach ($ans as $key => $value) {
    print "<tr><td>" . $key . "</td><td>" . $value . "</td><td><img src=\"./resource/" . $key .  "\"></td></tr>";
}
print "</table>";


?>
</body>
</html>
