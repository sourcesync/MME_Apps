<?php

$success = true;
$filesaved = "";

if ($_FILES["photo"])
{
	echo "got photo file ";
	if ($_FILES["photo"]["error"] > 0)
	{
		echo "error: " . $_FILES["photo"]["error"] . "<br />";
		$success = false;
	}
	else
	{
		move_uploaded_file($_FILES["photo"]["tmp_name"],
		"./temp/" . $_FILES["photo"]["name"]);

		$filesaved = $_FILES["photo"]["name"];
		echo($filesaved);
	}
}

echo ($success) ? " success" : " fail";

?>
