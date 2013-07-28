
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
     $fileName = "target.txt";
$file = fopen($fileName, "r");
print("query is ");
print($_GET['query']);
print("<table border=\"1\" cellPadding=\"5\">");
while ($line = fgetcsv($file)) {
    $output = "";
    $flag = false;
    $output .= "<tr>";

    foreach($line as $data) {
        
        if (preg_match("/". $_GET['query'] . "/i", $data) == 1) {
            $flag = true;
            $output .= "<td bgcolor=\"#FF0000\">";
            $output .= "<b><i>";
            $output .= $data;
            $output .= "</i></b>";
        } else {
            $output .= "<td>";
            $output .= $data;
        }
        $output .= "</td>";
    }
    $output .= "</tr>";
    if ($flag) {
        print($output);
    }

    
}
print("</table>");
fclose($file);
?>
</body>
</html>