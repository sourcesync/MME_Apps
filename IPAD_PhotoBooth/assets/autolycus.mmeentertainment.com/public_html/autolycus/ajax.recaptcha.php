<?php

require_once('recaptchalib.php');
$publickey = "6Lc8xccSAAAAALytqJIAxh5JHNM6nAR_JZK6H9eK"; 
$privatekey = "6Lc8xccSAAAAAGcQiaGpapiIQtRL3G1wONAesMDo";
 
$resp = recaptcha_check_answer ($privatekey,
                                $_SERVER["REMOTE_ADDR"],
                                $_POST["recaptcha_challenge_field"],
                                $_POST["recaptcha_response_field"]);
 
if ($resp->is_valid) {
	 ?>1<?	

}
else
{
   die("0");
}

?>
