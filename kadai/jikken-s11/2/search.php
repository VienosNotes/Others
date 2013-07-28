
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
     $fileName = "resource/2_1_data.csv";
$file = fopen($fileName, "r");
print("query is ");
print($_GET['query']);
print("<table border=\"1\" cellPadding=\"5\">");
while ($line = fgetcsv($file)) {
    $output = "";
    $flag = false;
    $output .= "<tr>";
    
    $tag = $line[0];
    if (preg_match("/" . $_GET['query'] . "/i", $tag) == 1) {
        $target = $line;
        foreach ($line as $data) {
            $output .= "<td>";
            if (preg_match("/^http/", $data)) {
                $output .= "<img src=\"" .$data. "\">";
            } else {
                $output .= $data;            
            }
            $output .= "</td>";

        }
    }
    print $output . "</tr>";
}
print("</table>");
fclose($file);

print"<hr>";

$fileName = "resource/2_1_data.csv";
$file = fopen($fileName, "r");
while ($current = fgetcsv($file)) {
    $similarity = ($target[1] * $current[1]) + ($target[2] * $current[2]) + ($target[3] * $current[3]);
    $ans[$current[0]] = $similarity;
}
array_multisort($ans, SORT_NUMERIC);
$ans = array_reverse($ans);
print "<table>";
print "<tr><th>id</th><th>Similarity</th></tr>";
foreach ($ans as $key => $value) {
    print "<tr><td>" . $key . "</td><td>" . $value . "</td></tr>";
}
print "</table>";


?>
</body>
</html>
