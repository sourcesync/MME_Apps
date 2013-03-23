<html>
<head>
<title>FacebookLogoff</title>
<body>
<div id="fb-root">
</div>

<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>


<div id="fb-root"></div>

<script>

ls = "https://graph.facebook.com/oauth/authorize?client_id=119375921469000&redirect_uri=https://graph.facebook.com/oauth/authorize&client_id=119375921469000&type=user_agent&display=popup&scope=publish_stream";


  FB.init({
    appId  : '119375921469000',
    status : false, // check login status
    cookie : false, // enable cookies to allow the server to access the session
    xfbml  : true  // parse XFBML
  });

FB.logout(function(response) {
alert('whoop there it is');
});

window.location = ls;


</script>

</body>
</html>
