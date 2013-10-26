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

	//print_r( $_GET );
	//print_r( $_FILES );
	//print_r( $HTTP_RAW_POST_DATA );

	$EVENT = $_GET['event'];
	$EVENTS_TOP = '/Users/gwilliams/Projects/MME/MME_Apps/github/MME_Apps/IPAD_PhotoBooth/CMS/node/docroot/event/';
	$EVENT_TOP = $EVENTS_TOP . 'ipad_' . $EVENT . '/';

	//echo $EVENT;
	//echo $EVENTS_TOP;
	//echo $EVENT_TOP;
	//echo 'done';

	$st = 0;
	$data = '';

	if ( $HTTP_RAW_POST_DATA )
	{
		//echo 'NEW CONFIG';

		$fname = $EVENT . '.json';	
		$target = $EVENT_TOP . $fname;
		$st = file_put_contents ( $target, $HTTP_RAW_POST_DATA );
		
		$data = $target;
		//echo $target;
		//echo $st;
	}
	else
	{
		$asset = $_GET['asset'];
		$fname = $_FILES['Filedata']['name'];
		$tmp_name = $_FILES['Filedata']['tmp_name'];
		$target = $EVENT_TOP . $asset . '/' . $fname;

		//echo $fname . '\n';
		//echo $tmp_name . '\n';
		//echo $target . '\n';

		$st = move_uploaded_file( $tmp_name, $target );
	
		$data = $fname;
	
		//echo 'NEW FILE';
		//echo 'ST-';
		//print_r( $st );
	}

	if ( $st ) echo '{"status":true,"data":"' . $data . '"}';
	else echo "{'status':false}";
?>
