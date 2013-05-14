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

//print_r($_POST);
//print_r($_GET);

$skin = $_POST["event"];
$subject = "Your promotional offer from the photobooth!";
$from = "photos@photomationphotobooth.com";
$photopath = "./photo";
$to = $_POST["email"];
$htmlbody = "Thank you for visiting our booth today!  Please <a href='%url%'>click here</a> to view your promotional offer.";
$textbody = "Thank you for visiting our booth today!  Please visit %url% to view your promotional offer.";
$url = "http://autolycus.mmeentertainment.com/promophoto.php?viewing=%id%";

// Temp variables
$success = true;
$filesaved = "";

if (!$_POST["event"]) {
	echo("0");
	die();
}


// If we saved a favorite photo and there is an email, send email out
if ($success && $_POST["email"] && $skin)
{
	$url = str_replace("%id%", $skin . "_" . "0001", $url);
	//echo("_url=" . $url . "_" );

	// $url = getTinyUrl($url);

	// Override Defaults email settings
	if ((file_exists("event/$skin/emailpromo.xml"))) {

		$xml = simplexml_load_file("event/$skin/emailpromo.xml");

		$results = $xml->xpath("//add[@key='subject']");

		if ($results && $results[0] && $results[0]['value'])
			$subject = $results[0]['value'];

		$results = $xml->xpath("//add[@key='from']");

		if ($results && $results[0] && $results[0]['value'])
			$from = $results[0]['value'];
	}

	// Load Html Body
	if (file_exists("event/$skin/emailpromo.html")) {
		$fh = fopen("event/$skin/emailpromo.html", 'r');
		$theData = fread($fh, filesize("event/$skin/emailpromo.html"));
		fclose($fh);

		if ($theData)
			$htmlbody = str_replace("%url%", $url, $theData);
	}

	// Load Text Body
	if (file_exists("event/$skin/emailpromo.txt")) {
		$fh = fopen("event/$skin/email.txt", 'r');
		$theData = fread($fh, filesize("event/$skin/emailpromo.txt"));
		fclose($fh);

		if ($theData)
			$textbody = str_replace("%url%", $url, $theData);
	}

	$ret = sendHTMLemail($textbody,$htmlbody,$from,$to,$subject);

	//echo("_sendemail=" . $ret . "_");
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

    return $ret;
}


function getTinyUrl($s) {
	// tiny url
	$url = file_get_contents("http://tinyurl.com/api-create.php?url=" . urlencode($s));

	return $url;
}


?>