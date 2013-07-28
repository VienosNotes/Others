<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">

<html lang="JA">

<head>
 <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
 <title>メディア情報検索の基礎 課題2-3 sample</title>
</head>

<body bgcolor="white" text="black">


<h1 align="center">メディア情報検索の基礎　課題2-3</h1>
<hr align="center" noshade width="80%"/>
<div align="center">

<script type="text/javascript">
     function search() {
     var query = window.document.getElementById("form").value;
     window.open("./search.php?query=" + encodeURIComponent(query));
 }
</script>

<form>
<input type="text" name="KEYWORD" size="15" id="form" />
</form>
<button type="button" name="button" value="button" onClick="search()">search</button>

</div>

<hr align="center" noshade width="80%"/>


<div align="center">
<caption>検索対象データ</caption>

<?php
print("<table border=\"1\" cellPadding=\"5\" align=\"center\">");
$fileName = "resource/vector.txt";
$file = fopen($fileName, "r");

while ($line = fgetcsv($file)) {
   print "<tr><td><a href=\"" . $line[1] . "\">" . $line[0] . "</a></td></tr>";
}

fclose($file);
?>

</table>
<form action="add.php" method="post">
 追加: <input type="text" name="content" />
 <input type="submit" />
</form>
</div>
<hr align="center" noshade width="80%"/>

<div align="center">
<a href="../text.html">戻る</a>
</div>

</body>

</html>
