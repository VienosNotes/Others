
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

     $list = array("0_rfc6879.txt" => 0.238318,
                   "1_rfc6840.txt" => 0.093458,
                   "2_rfc6396.txt" => 0.070093,
                   "3_rfc5752.txt" => 0.126168,
                   "4_rfc5698.txt" => 0.191589,
                   "5_rfc5664.txt" => 0.065421,
                   "6_rfc5619.txt" => 0.214953);

print("query is ");
print($_GET['query']);

foreach($list as $doc => $pagerank) {
    $fp = fopen("documents/" . $doc, "r");
    $text = "";
    while(!feof($fp)) {
        $text .= fgets($fp);
    }
    fclose($fp);

    if (preg_match("/" . $_GET['query'] . "/i", $text)) {
        $match[$doc] = $pagerank;
    }
}    

if (count($match) == 0) {
    print "一致する検索結果はありませんでした。";
} else {
    array_multisort($match, SORT_NUMERIC);
    $ret = array_reverse($match);
    print("<table>");
    print "<tr><th>entry</th><th>pagerank</th></tr>";
    foreach ($ret as $doc => $pagerank) {
        print "<tr><td><a href=\"documents/" . $doc . "\">" . $doc . "</a></td><td>" . $pagerank . "</td></tr>";
    }
    print("</table>");
}

?>
</body>
</html>
