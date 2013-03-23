<?php

/**
 * Hercules Photobooth Photo Processor
 * This takes incoming requests from MME photo booths for facebook and email processing
 * Written by Ron Stone
 *
 * @version 1.0
 * @copyright MME Enterainment Company
 */

// Configuration
$photopath = "./photo";

$filesaved = "";
$success = true;


$myFile = "transfer.log.txt";
$fh = fopen($myFile, 'a') or die("can't open file");
$stringData = $_FILES[0]["name"] . "\n";
fwrite($fh, $stringData);
fclose($fh);


// is there a file?
if ($_FILES[0])
{
	if ($_FILES[0]["error"] > 0)
	{
		echo "error: " . $_FILES[0]["error"] . "<br />";
		$success = false;
	}
	else
	{
		move_uploaded_file($_FILES[0]["tmp_name"],
		$photopath . "/" . $_FILES[0]["name"]);
	}
}

if ($success)
	echo "1";
else
	echo "0";


?>
