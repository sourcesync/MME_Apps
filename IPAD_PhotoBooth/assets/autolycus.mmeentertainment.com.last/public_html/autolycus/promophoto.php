<?php

/* 

hercules favorite photo web page generator 2.0 
written by ron stone (ronstone@gmail.com) 

do not remove this header


*/

$viewing = $_GET["viewing"];

if (!$viewing || strrpos($viewing, '_') < 0) {
	header("location:http://www.photomationphotobooth.com");
	die();
}

$id = substr($viewing, strrpos($viewing, '_') + 1, strlen($viewing));
$skin = substr($viewing, 0, strrpos($viewing, '_'));

$html = "";

/* init */

$server = "autolycus.mmeentertainment.com";

$subject = "I took this favorite photo at an event!";
$emaildefault = "Check out this fun picture I had taken at a recent event!";
$emailbody = "";

$facebooktitle = "This is my favorite photo taken from a recent event!";
$facebookdesc = "";
$facebooklike = "";

$usetwitter = 1;
$followtwitter = "";

$usefacebook = 1;
$uselink = 1;
$useemail = 1;



/* load web config */


if ((file_exists("event/$skin/web2.xml"))) {

		$xml = simplexml_load_file("event/$skin/web2.xml");

		$results = $xml->xpath("//add[@key='UseTweet']");
		if ($results && $results[0] && $results[0]['value'])
			$usetwitter = $results[0]['value'];

		$results = $xml->xpath("//add[@key='UseShareFacebook']");
		if ($results && $results[0] && $results[0]['value'])
			$usefacebook = $results[0]['value'];

		$results = $xml->xpath("//add[@key='UseSendEmail']");
		if ($results && $results[0] && $results[0]['value'])
			$useemail = $results[0]['value'];

		$results = $xml->xpath("//add[@key='FacebookLike']");
		if ($results && $results[0] && $results[0]['value'])
			$facebooklike = $results[0]['value'];

		$results = $xml->xpath("//add[@key='FollowTwitter']");
		if ($results && $results[0] && $results[0]['value'])
			$followtwitter = $results[0]['value'];

		$results = $xml->xpath("//add[@key='Server']");
		if ($results && $results[0] && $results[0]['value'])
			$server = $results[0]['value'];

		$results = $xml->xpath("//add[@key='subject']");
		if ($results && $results[0] && $results[0]['value'])
			$subject = $results[0]['value'];

		$results = $xml->xpath("//add[@key='EmailDefaultMessage']");
		if ($results && $results[0] && $results[0]['value'])
			$emaildefault = $results[0]['value'];


		$results = $xml->xpath("//add[@key='EmailBody']");
		if ($results && $results[0] && $results[0]['value'])
			$emailbody = $results[0]['value'];


		$results = $xml->xpath("//add[@key='TweetDefault']");
		if ($results && $results[0] && $results[0]['value'])
			$tweetdefault = $results[0]['value'];

		$results = $xml->xpath("//add[@key='FacebookTitle']");
		if ($results && $results[0] && $results[0]['value'])
			$facebooktitle = $results[0]['value'];

		$results = $xml->xpath("//add[@key='FacebookDesc']");
		if ($results && $results[0] && $results[0]['value'])
			$facebookdesc = $results[0]['value'];
	}


if ((file_exists("event/$skin/webpromo.html"))) {

	$filename = "event/$skin/webpromo.html";
	$handle = fopen($filename, "r");
	$html = fread($handle, filesize($filename));
	fclose($handle);

	$html = str_replace("%event%", $skin, $html);
	$html = str_replace("%id%", $id, $html);

	$tinyurl = getTinyUrl("http://" . $server . "/promophoto.php?viewing=" . $skin . "_" . $id);
        
        if ($tinyurl == "")
            $tinyurl = "http://" . $server . "/promophoto.php?viewing=" . $skin . "_" . $id;

        $html = str_replace("%tinyurl%", str_replace('"', '\"', $tinyurl), $html);
	$html = str_replace("%tweetdefault%", str_replace('"', '\"', $tweetdefault), $html);
	$html = str_replace("%emaildefault%", str_replace('"', '\"', $emaildefault), $html);
	$html = str_replace("%subject%", str_replace('"', '\"', $subject), $html);
	$html = str_replace("%emailbody%", str_replace('"', '\"', $emailbody), $html);
	$html = str_replace("%facebooktitle%", str_replace('"', '\"', $facebooktitle), $html);
	$html = str_replace("%facebookdesc%", str_replace('"', '\"', $facebookdesc), $html);
        $html = str_replace("%usetwitter%", $usetwitter, $html);
        $html = str_replace("%usefacebook%", $usefacebook, $html);
        $html = str_replace("%useemail%", $useemail, $html);
        $html = str_replace("%server%", $server, $html);
        $html = str_replace("%facebooklike%", $facebooklike, $html);
        $html = str_replace("%followtwitter%", $followtwitter, $html);

	echo ($html);

} else if ((file_exists("event/$skin/web.html"))) {

	$filename = "event/$skin/web.html";
	$handle = fopen($filename, "r");
	$html = fread($handle, filesize($filename));
	fclose($handle);

	$html = str_replace("%event%", $skin, $html);
	$html = str_replace("%id%", $id, $html);

	echo ($html);
}










function getTinyUrl($s) {
	// tiny url
	$url = file_get_contents("http://tinyurl.com/api-create.php?url=" . urlencode($s));

	return $url;
}





?>
