
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
print "search with " . $s;
print "<hr>";
exec("./add_list.pl " . escapeshellarg($s) . " SEARCH", $output, $ret);
print "<table><tr><th>document</th><th>similarity</th></tr>";
foreach ($output as $line) {
    print $line;
}
print "</table>";

?>
</body>
</html>
