<?php

/* maximus web page generator 2.0 written by ron stone (ronstone@gmail.com) */


$viewing = $_GET["viewing"];

if (!$viewing || strrpos($viewing, '_') < 0) {
	header("location:http://www.photomationphotobooth.com");
	die();
}

$id = substr($viewing, strrpos($viewing, '_') + 1, strlen($viewing));
$skin = substr($viewing, 0, strrpos($viewing, '_'));

$html = "";

if ((file_exists("event/$skin/web.html"))) {

	$filename = "event/$skin/web.html";
	$handle = fopen($filename, "r");
	$html = fread($handle, filesize($filename));
	fclose($handle);

	$html = str_replace("%event%", $skin, $html);
	$html = str_replace("%id%", $id, $html);

	echo ($html);
}

?>
