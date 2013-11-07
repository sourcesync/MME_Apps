<?php
function recurse_copy($src,$dst) { 
    $dir = opendir($src); 

    $st = 1;
//echo $src;
//echo $dst;
//echo $dir;
    @mkdir($dst); 
    while(false !== ( $file = readdir($dir)) ) { 
        if (( $file != '.' ) && ( $file != '..' )) { 
            if ( is_dir($src . '/' . $file) ) { 
                recurse_copy($src . '/' . $file,$dst . '/' . $file); 
            } 
            else { 
                $st = copy($src . '/' . $file,$dst . '/' . $file); 
		if (!$st) break;
		//if ($st) echo "st=ok " . $st . "\n";
		//else echo "st=false " . $st . "\n";
            } 
        } 
    } 
    closedir($dir); 
    return $st;
} 
?>

<?php

	/*
	if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') 
	{
		header('Access-Control-Allow-Origin: *');
		exit;
	}
	else 
	{
		header('Access-Control-Allow-Origin: *');
	}
	*/
	
	$EVENTS_TOP = '../event/';

	$NEW_EVENT = htmlspecialchars($_GET["event"]);

	$SRC = $EVENTS_TOP . "ipad_basic";

	$TARGET = $EVENTS_TOP . "ipad_" . $NEW_EVENT;
	//echo $SRC;
	//echo $TARGET;
	
	$msg = "";
	if ( file_exists( $TARGET ) )
	{
		$st = 0; 
		$msg = "Event Exists";
	}
	else
	{
		$st = recurse_copy( $SRC, $TARGET );
		if ( $st )
		{
			$SRC  = $TARGET . "/basic.json";
			$TARGET = $TARGET . "/" . $NEW_EVENT . ".json";
			//echo $SRC . "\n";
			//echo $TARGET . "\n";
			$st = rename( $SRC, $TARGET );
			if ($st) ;
			else $msg = "renaming config failed";
		}
		else
		{
			$msg = "copy failed";	
		}
	}

	if ( $st ) echo '{"status":true }';
	else echo '{"status":false ,"message":"' . $msg . '" }';
?>
