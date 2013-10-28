<?php

	if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') 
	{
		header('Access-Control-Allow-Origin: *');
		exit;
	}
	else 
	{
		header('Access-Control-Allow-Origin: *');
	}

	//$EVENTS_TOP = '/Users/gwilliams/Projects/MME/MME_Apps/github/MME_Apps/IPAD_PhotoBooth/CMS/node/docroot/event/';
	$EVENTS_TOP = '../event/';

	$data = array();
	$dirs = array_filter(glob( $EVENTS_TOP . "*" ), 'is_dir');
	foreach($dirs as $dir)
	{
		$parts = pathinfo( $dir );
//print_r( $parts );
		$fname = $parts['filename'] .  $parts['extension'];

		$ff = 'a' . $fname;

		$ret = strpos( $ff, "ipad_" );
		if ( $ret == 1 )
		{
			$item = array( "name" => $fname );
			$data[] = $item;	
		}
	}	

	$json = json_encode( $data );
	$st = 1;
	//$data = '[ {"name":"ipad_test" }, {"name":"ipad_mme"} ]';

	if ( $st ) echo '{"status":true,"data":' . $json . '}';
	else echo "{'status':false}";
?>
