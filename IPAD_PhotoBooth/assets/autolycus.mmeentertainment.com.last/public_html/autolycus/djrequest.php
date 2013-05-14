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

$to = $_POST['email'];
$subject = $_POST['song'];
$from = "djrequestor@photomationphotobooth.com";
$htmlbody = $_POST['song'];
$textbody = $_POST['song'];


// Temp variables
$success = true;


// If we saved a favorite photo and there is an email, send email out
if ($success)
{
	//$textbody = "hello";
	//$htmlbody = "hello";
	//$subject = "Your_photo_from_todays_event";
	//$to="george.williams@gmail.com";
	$ret = sendHTMLemail($textbody,$htmlbody,$from,$to,$subject);

	echo("_sendemail=" . $ret . "_");
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