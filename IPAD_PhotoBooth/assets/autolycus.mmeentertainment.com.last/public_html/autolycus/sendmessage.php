<html>
<head>
<title>Favorite photo shared!</title>

<style type="text/css">

body {
    text-align:center;
    font-family:arial;
    margin:0;
    padding:0;
    background:#333 url(/images/bg-grey2.png) repeat;
}

#container {
	background:#fff;
	width:600px;
	margin:100px auto;
	padding:5px 20px 20px 20px;
	-webkit-border-radius: 15px;
	-moz-border-radius: 15px;
        text-align:left;
	border-radius: 15px;
}

</style>


</head>
<body>

<div id="container">

<h3>Thanks for sharing!</h3>

<?php

 $from = "From: no-reply@photomationphotobooth.com";
 $emailto = $_POST["emailto"];
 $subject = $_POST["subject"];
 $body = $_POST["body"] . " " . $_POST["returnurl"];

 if (mail($emailto, $subject, $body, $from)) {
   echo("<p>Your Favorite Photo has been emailed to " . $emailto . "!</p>");
  } else {
   echo("<p>Your Favorite Photo failed to send.  Please try again.</p>");
  }

?>

<script type="text/javascript">

function goback()
{
    document.location.href = '<?php echo ($_POST["returnurl"]) ?>';
    return false;
}


</script>


<button onclick="return goback()">Return to Favorite Photo</button>


</div>

</body>
</html>

