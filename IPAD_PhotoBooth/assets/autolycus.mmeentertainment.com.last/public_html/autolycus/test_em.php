<?php

/**
 * Hercules Photobooth Photo Processor
 * This takes incoming requests from MME photo booths for facebook and email processing
 * Written by Ron Stone
 *
 * @version 1.0
 * @copyright MME Enterainment Company
 */

// Default Configuration

$skin = "WhiteCastle";
$subject = "Your favorite photo from today's event!";
$from = "photos@photomationphotobooth.com";
$photopath = "./photo";
$to = "george.williams@gmail.com";
$htmlbody = "Thank you for visiting our booth today!  Please click here to view your favorite photo.";
$textbody = "Thank you for visiting our booth today!  Please visit to view your favorite photo.";
$url = "http://autolycus.mmeentertainment.com/favoritephoto.php?viewing=id";

echo "1";

// Temp variables
$success = true;
$filesaved = "";

/*
if (!$_POST["event"]) {
	echo("0");
	die();
}


if ($_FILES["photo"])
{

	if ($_FILES["photo"]["error"] > 0)
	{
		echo "error: " . $_FILES["photo"]["error"] . "<br />";
		$success = false;
	}
	else
	{
		move_uploaded_file($_FILES["photo"]["tmp_name"],
		"./event/" . $skin ."/photo/" . $_FILES["photo"]["name"]);

		$filesaved = $_FILES["photo"]["name"];
	}
}
*/

echo "2";

// If we saved a favorite photo and there is an email, send email out
//if ($success && $filesaved != "" && $_POST["email"] && $skin)
if (true)
{
	/*
	$url = str_replace("%id%", $skin . "_" . str_replace(".jpg", "", $filesaved), $url);

	// $url = getTinyUrl($url);

	// Override Defaults email settings
	if ((file_exists("event/$skin/email.xml"))) {

		$xml = simplexml_load_file("event/$skin/email.xml");

		$results = $xml->xpath("//add[@key='subject']");

		if ($results && $results[0] && $results[0]['value'])
			$subject = $results[0]['value'];

		$results = $xml->xpath("//add[@key='from']");

		if ($results && $results[0] && $results[0]['value'])
			$from = $results[0]['value'];
	}

	// Load Html Body
	if (file_exists("event/$skin/email.html")) {
		$fh = fopen("event/$skin/email.html", 'r');
		$theData = fread($fh, filesize("event/$skin/email.html"));
		fclose($fh);

		if ($theData)
			$htmlbody = str_replace("%url%", $url, $theData);
	}

	// Load Text Body
	if (file_exists("event/$skin/email.txt")) {
		$fh = fopen("event/$skin/email.txt", 'r');
		$theData = fread($fh, filesize("event/$skin/email.txt"));
		fclose($fh);

		if ($theData)
			$textbody = str_replace("%url%", $url, $theData);
	}

	*/

	$subject = 'test';

	sendHTMLemail($textbody,$htmlbody,$from,$to,$subject);

	echo "2";
}

// Finished

echo ($success) ? "3" : "0";



/* Functions *************************************************************/

function sendHTMLemail($textbody, $htmlbody,$from,$to,$subject)
{
// First we have to build our email headers
// Set out "from" address

    $headers = "From: $from\r\n";

// Now we specify our MIME version

    $headers .= "MIME-Version: 1.0\r\n";

// Create a boundary so we know where to look for
// the start of the data

    $boundary = uniqid("HTMLEMAIL");

// First we be nice and send a non-html version of our email

    $headers .= "Content-Type: multipart/alternative;".
                "boundary = $boundary\r\n\r\n";

    $headers .= "This is a MIME encoded message.\r\n\r\n";

    $headers .= "--$boundary\r\n".
                "Content-Type: text/plain; charset=ISO-8859-1\r\n".
                "Content-Transfer-Encoding: base64\r\n\r\n";

    $headers .= chunk_split(base64_encode(strip_tags($textbody)));

// Now we attach the HTML version

    $headers .= "--$boundary\r\n".
                "Content-Type: text/html; charset=ISO-8859-1\r\n".
                "Content-Transfer-Encoding: base64\r\n\r\n";

    $headers .= chunk_split(base64_encode($htmlbody));

// And then send the email ....

    $ret = mail($to,$subject,"",$headers);
    echo $ret;

}


function getTinyUrl($s) {
	// tiny url
	$url = file_get_contents("http://tinyurl.com/api-create.php?url=" . urlencode($s));

	return $url;
}


?>