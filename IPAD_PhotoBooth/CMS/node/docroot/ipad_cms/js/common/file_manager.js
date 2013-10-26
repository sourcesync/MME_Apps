
                        
//<div id="{PREFIX}_selectFilesButtonContainer" style="float:left;" ></div>\

var file_manager_part_template_html = '\
                <div id="{PREFIX}uploaderContainer" >\
                        <div id="{PREFIX}_selectFilesButtonContainer" style="margin-left:auto; margin-right:0px;" ></div>\
                        <div id="{PREFIX}_overallProgress" style="display:none;float:left;"></div>\
			<div id="{PREFIX}_thumbnailContainer" style="float:left;display:none;">\
				<img alt="yo" id="{PREFIX}_thumbnailImage" src="" style="max-height:40px;"  ><img>\
			</div>\
                        <div id="{PREFIX}_opContainer" style="display:none;float:left;">\
				<button type="button" id="{PREFIX}_opButton" style="width:55px; height:25px;">Delete</button>\
			</div>\
			<div style="clear:both;width:0px" ></div>\
                </div>';
        
function file_manager_restore(Y, prefix, url)
{
	Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
        Y.one('#' + prefix + '_overallProgress').setStyle("display","none");
        Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","block");
        Y.one('#' + prefix + '_opContainer').setStyle("display","block");

        //      set thumbnail url...
        Y.one('#' + prefix + '_thumbnailImage').set("src",url);

        //      set op button text...
        Y.one('#' + prefix + '_opButton').setHTML("delete");
}
               
function file_manager_init(Y, parentName, jobid, partno, handler )
{
	//	Get the parent div which should already exist...
	var parent = Y.one( "#" + parentName );

	//	Instantiate the DOM child hiercharchy via template subst...
	var subst_dct = { "PREFIX": parentName }
	var substr = Y.Lang.sub( file_manager_part_template_html, subst_dct );
	var part = Y.Node.create( substr );
        parent.append(part);


	//	Create the YUI uploader....
	var uploader = null;
	var btn = null;
        if (Y.Uploader.TYPE != "none" && !Y.UA.ios)
        {
               	uploader = new Y.Uploader({
				      selectFilesButton: Y.Node.create('<button style="width:55px;">Browse</button>'),
				      width: "60px",
                                      height: "25px",
                                      multipleFiles: false,
                                      swfURL: "http://yui.yahooapis.com/3.10.3/build/uploader/assets/flashuploader.swf?t=" + Math.random(),
                                      //uploadURL: "http://yuilibrary.com/sandbox/upload/",
                                      uploadURL: CONFIG_BASE_URL + "uploads?sessionid=" + page_sessionid + 
						"&jobid=" + jobid + "&partid=" + partno,
                                      simLimit: 2,
                                      withCredentials: false,
					errorAction:Y.Uploader.Queue.STOP
                                     });
	       	uploader.addAttr("PREFIX");
	       	uploader.set("PREFIX",parentName);

		uploader.addAttr("VALUE");
		uploader.set("VALUE",null);

		uploader.addAttr("BASEURL");
		uploader.set("BASEURL", CONFIG_BASE_URL + "uploads?sessionid=" + page_sessionid +
                                                "&jobid=" + jobid + "&partid=" + partno);

		uploader.addAttr("MODE");
		uploader.set("MODE",1);

               	uploader.render("#" + parentName + "_selectFilesButtonContainer");

		// set click handler for operation...
		btn = new Y.one( '#' + parentName + "_opButton" );
		btn.setAttribute("PREFIX",parentName);
		btn.on("click", function (event)
		{
			var btn = event.target;
			var prefix = btn.getAttribute("PREFIX");

			Y.one('#' +prefix + '_selectFilesButtonContainer').setStyle("display","block");
                        Y.one('#' +prefix + '_overallProgress').setStyle("display","none");
                        Y.one('#' +prefix + '_thumbnailContainer').setStyle("display","none");
                        Y.one('#' +prefix + '_opContainer').setStyle("display","none");

			//	clear state...
                        var fileList = [];
			//var uploader = btn.getAttribute("UPLOADER");

			var pf = uploader.get("PREFIX");
                        uploader.set("fileList", fileList);
			
			if (handler) handler( btn, prefix, {"status":false} );	
		}
		);

		//
	       	// Set various upload event handlers....
		//
               	uploader.after("fileselect", function (event)
                {
			var up = event.target;
                        var prefix = up.get("PREFIX");

               		var fileList = event.fileList;
                        if (fileList.length ==1)
			{
				console.log(fileList);
				//	Show progress area...
				Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
				Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
				Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
				Y.one('#' + prefix + '_opContainer').setStyle("display","none");
                        	Y.one('#' + prefix + '_overallProgress').setHTML( "" );
				
				var filename = fileList[0].get("name");
				var url = up.get("OVERRIDEURL");
				if (url)
				{
					//alert("Not implemented here");
					url = CONFIG_BASE_URL + url;
					console.log(url);
				}
				else
				{
					url = up.get("BASEURL");
				}
				
				var ef = encodeURIComponent(filename);
				url += "&filename=" + ef;
				up.set("uploadURL", url);

				try
				{
					up.uploadAll();
				}
				catch (err)
				{
					alert( err.toString() );
				}
			}
			else
			{
				// print message, default to fileselect...
				Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","block");
				Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
				Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
				Y.one('#' + prefix + '_opContainer').setStyle("display","none");
                        	
				Y.one('#' + prefix + '_overallProgress').setHTML( "selected files <> 1" );
			}

                });

		uploader.on("uploaderror", function (event)
		{
			var up = event.target;
                        var prefix = up.get("PREFIX");

/*
			var newu = new Y.Uploader({
                                      selectFilesButton: Y.Node.create('<button style="width:55px;">Browse</button>'),
                                      width: "60px",
                                      height: "25px",
                                      multipleFiles: false,
                                      swfURL: "http://yui.yahooapis.com/3.10.3/build/uploader/assets/flashuploader.swf?t=" + Math.random(),
                                      //uploadURL: "http://yuilibrary.com/sandbox/upload/",
                                      uploadURL: CONFIG_BASE_URL + "uploads?sessionid=" + page_sessionid +
                                                "&jobid=" + jobid + "&partid=" + partno,
                                      simLimit: 2,
                                      withCredentials: false,
                                        errorAction:Y.Uploader.Queue.STOP
                                     });
                	newu.addAttr("PREFIX");
                	newu.set("PREFIX",parentName);
                	newu.addAttr("VALUE");
                	newu.set("VALUE",null);
                	newu.addAttr("BASEURL");
                	newu.set("BASEURL", CONFIG_BASE_URL + "uploads?sessionid=" + page_sessionid +
                                                "&jobid=" + jobid + "&partid=" + partno);

                	newu.addAttr("MODE");
                	newu.set("MODE",1);
                	newu.render("#" + parentName + "_selectFilesButtonContainer");
	*/

	/*
	        	// print message, default to fileselect...
                        Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
                        Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
                        Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
			Y.one('#' + prefix + '_opContainer').setStyle("display","block");

			//	set status text...
                        Y.one('#' + prefix + '_overallProgress').setHTML( "upload error" );

			//	set op button text...
			Y.one('#' + prefix + '_opButton').setStyle("display","block");
			Y.one('#' + prefix + '_opButton').setHTML("ok");

			//	clear state...
			//uploader.cancelUpload();
			//up.queue = null;
                        //var fileList = [];
                        //up.set("fileList", fileList);
	*/		
		});

                uploader.on("uploadprogress", function (event) 
		{
			var up = event.target;
                        var prefix = up.get("PREFIX");

			console.log( "_uploadprogress", event.percentLoaded )
		
			//	show progress with percent...	
			Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
                        Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
                        Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
			Y.one('#' + prefix + '_opContainer').setStyle("display","none");
                        
			Y.one('#' + prefix + '_overallProgress').setHTML( event.percentLoaded + "%" );

                });

                uploader.on("uploadstart", function (event)
                {
			var up = event.target;
                        var prefix = up.get("PREFIX");

			console.log("upload started");
		
                        Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
                        Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
                        Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
			Y.one('#' + prefix + '_opContainer').setStyle("display","none");

                        Y.one('#' + prefix + '_overallProgress').setHTML( "starting..." );
                });

                uploader.on("uploadcomplete", function (event) 
		{
			var up = event.target;
                        var prefix = up.get("PREFIX");

			console.log("upload complete");
			console.log(event.data);
		
                        var mode = up.get("MODE");
			var status = eval( '(' + event.data + ')' );


			//	in mode 1 and success, we go back to browse mode ( not delete )
			if ( (mode==1) && ( status['status'] ) )
			{
				Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","block");
                                Y.one('#' + prefix + '_overallProgress').setStyle("display","none");
                                Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
                                Y.one('#' + prefix + '_opContainer').setStyle("display","block");
                                Y.one('#' + prefix + '_opButton').setStyle("display","none");

                                //      stash the return value into the uploader...
                                uploader.set("VALUE",status);

                                //      invoke callback if set...
                                console.log("FILEMAN", prefix, status );
                                if (handler) handler( uploader, prefix, status );
			}
			else if ( status['status'] ) // in regular mode and success, go to delete mode...
			{
				Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
                        	Y.one('#' + prefix + '_overallProgress').setStyle("display","none");
                        	Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","block");
				Y.one('#' + prefix + '_opContainer').setStyle("display","block");

				//	set thumbnail url...
				var url = status["url"];
				Y.one('#' + prefix + '_thumbnailImage').set("src",url);

				//	set op button text...
				Y.one('#' + prefix + '_opButton').setHTML("delete");
			
				//	stash the return value into the uploader...
				uploader.set("VALUE",status);

				//	invoke callback if set...
				console.log("FILEMAN", prefix, status );
				if (handler) handler( uploader, prefix, status );
			}
			else
			{
                        	Y.one('#' + prefix + '_selectFilesButtonContainer').setStyle("display","none");
                        	Y.one('#' + prefix + '_overallProgress').setStyle("display","block");
                        	Y.one('#' + prefix + '_thumbnailContainer').setStyle("display","none");
				Y.one('#' + prefix + '_opContainer').setStyle("display","block");

				//	set status message...
				var msg = status["message"];
                        	Y.one('#' + prefix + '_overallProgress').setHTML( msg );

				//	change op button...
				Y.one('#' + prefix + '_opButton').setStyle("display","block");
				Y.one('#' + prefix + '_opButton').setHTML("ok");
			}
		
			//	clear state...	
			var fileList = [];
			up.set("fileList", fileList);	
                });

                uploader.on("totaluploadprogress", function (event)
                {
			console.log("total upload progress");
                });

                uploader.on("alluploadscomplete", function (event)
                {
			console.log("all uploads complete");
        	});

		return { "uploader": uploader, "button": btn };

	  }
          else
          {
          	Y.one("#" + parentName + "_uploaderContainer").set("text", "We are sorry, but to use the uploader, you either need\
                                         a browser that support HTML5 or have the Flash player installed on your computer.");
		return false;
          }
}
