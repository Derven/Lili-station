proc/wiki_text(var/idesc, var/iname, var/note = "no notes")
	var/wtext = {"
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>Название сайта</title>
<style>
a{
  text-decoration: none;
  color: #000 !important;
 }
</style>
</head>
<body>
<table
border="1"
rules="rows"
style="width:100%;">
<tr>
<td>
<table
border="0"
background="images/168.png"
bgcolor="#0095CC"
cellpadding="10"
style="width:100%">
<tr>
<th>
<h1><font color="white">ISOMETRIC WIKI</font></h1>
<h3><font color="white">Page: [iname]</font></h3>
</th>
</tr>
</table>
<table
border="0"
cellpadding="10"
style="width:100%; border-radius:5px;">
<tr>
<td
rowspan="2"
style="width:80%">
<h2>Page [iname]</h2>
<p style="text-indent:20px">
[idesc]</p>
</td>
<td bgcolor="#E0EAF1">
<h3>Pages</h3>
</p>
</td>
</tr>
<tr>
<td
bgcolor="#E0EAF1">
<h3>Notes</h3>
<p>[note]</p>
</td>
</tr>
</table>
<table
border="0"
bgcolor="#0095CC"
height="100"
cellpadding="10"
style="width:100%; border-radius:5px;">
<tr>
<th>
<h3><font color="white">
<a href="https://discord.gg/5K2VQEq">DISCORD</a>
</font></h3>
</th>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>

"}

	return wtext