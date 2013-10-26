//	private, state...
var sw_Y = null;
var sw_event_id = null;
var sw_parent = null;
var sw_current_tab = null;
var sw_device = null;
var sw_jobid = null;

function sw_change_status(jobid, partid)
{
}

function sw_checkout(jobid)
{
        //      show the make payment wizard...
        make_payment_wizard_show( jobid );
}


function sw_selectdevice()
{
	var el = Y.Node("#sw_device");
	sw_device = el.get("value");

	if ( sw_device=="0")  // select all devices in wide service ?
		common_notify_selected_serviceuid( sw_event_id, "3" );	
	else  // or specific device...
		common_notify_selected_deviceuid( sw_event_id, "3", sw_device );	

	//	reset job id here...
	sw_jobid = null;

	sw_refresh( );
}

function sw_getdevicebyuid(devices, uid)
{
	for ( var i=0;i<devices.length;i++)
	{
		if ( (devices[i]["serviceid"]=="3") && (devices[i]["uid"] == uid ))
			return devices[i];
	}
}

function sw_show( services, devices, overview )
{
	var html = 	'<div style="min-height:120px;" >\
				<div>\
					<div style="float:left;">\
						<div style="float:left;" ><textpan style="font-weight:bold">Device Name:&nbsp;</textspan>\
						</div>\
						<select style="float:left;" name="sw" id="sw_device" onchange="sw_selectdevice();">\
							<option value="0" {V0}>All Devices</option>\
							<option value="1" {V1}>Peaches</option>\
        						<option value="2" {V2}>Sweet Zombie</option>\
        						<option value="3" {V3}>Bertha</option>\
						</select>\
						<div style="clear:both;">\
						</div>\
					</div>';

	var dct = {};	
	dct["V0"] = (sw_device==null||sw_device=="0") ? "selected":"" ;
	dct["V1"] = (sw_device=="1")?"selected":"" ;
	dct["V2"] = (sw_device=="2")?"selected":"" ;
	dct["V3"] = (sw_device=="3")?"selected":"" ;
	html = Y.Lang.sub( html, dct );

	//	Possibly append more stuff to right of DEVICE NAME...
	if ( devices )
	{
		if ( (sw_device == null) || (sw_device=="0") )
		{
		}
		else
		{
			var device = sw_getdevicebyuid( devices, sw_device );
			if (device)
			{	
				html += '<div style="float:left;">' +
                               			'<div style="margin-left:10px; float:left;" ><textpan style="font-weight:bold">Device Tier Type:&nbsp;</textspan></div>' + 
						'<div style="float:left;" >' + device["wa"] + '</div>' +
                                                '<div style="clear:both;"></div>' +
                                    	'</div>';
				html += '<div style="float:left;">' +
                               			'<div style="margin-left:10px; float:left;" ><textpan style="font-weight:bold">Model:&nbsp;</textspan></div>' + 
						'<div style="float:left;" >' + device["model"] + '</div>' +
                                                '<div style="clear:both;"></div>' +
                                    	'</div>';
			}
		}
	}
	else
	{
	}
	
	html += 			'<div style="clear:both;width:0px;"></div>';
	html +=			'</div>';

	//	end DEVICE HEADER

	if ( overview )
	{	
		//	job header...
		html +=  	'<div style="height:30px;">'+ 
					'<div style="top:0px;float:left;">' +
                                		'<textpan style="font-weight:bold">Order Number:&nbsp;</textspan>' +
							'<textspan style="font-weight:normal;">' + overview['jid'] + '</textspan><br>'+
					'</div>' +
					'<textspan>&nbsp;&nbsp;&nbsp;</textspan>' +
					'<div style="top:0px;float:left;">' +
                                                '<textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Service:&nbsp;</textspan>' +
                                                        '<textspan style="font-weight:normal;">' + overview['type'] + '</textspan><br>' +
                                        '</div>' +
					'<textspan>&nbsp;&nbsp;&nbsp;</textspan>' +
					'<div style="top:0px;float:left;">' +
                                		'<textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Device:&nbsp;</textspan>' +
							'<textspan style="font-weight:normal;">' + overview['device'] + '</textspan><br>' +
					'</div>' +
					'<textspan>&nbsp;&nbsp;&nbsp;</textspan>' +
					'<div style="top:0px;float:left;">' +
                                		'<textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;</textspan>' +
					'</div>' +
					'<div style="clear:both;width:0px;"></div>' +
				'</div>';

				//	END JOB HEADER


	//	A bunch of columns...
	html += 	'<div>';

				//	first column is the image...
	html +=			'<div style="float:left;width:60px;height:60px;"><img src="' + overview['icon'] + '"></img></div>';
	//html +=			'<div style="float:left;width:60px;height:10px;"></div>';


	html += 
				//	second column is some job info...
		 		'<div style="top:0px;float:left; margin-left:10px;padding-left:10px;">' +
					'<textpan style="font-weight:bold">Total Parts:&nbsp;</textspan>' + 
						'<textspan style="font-weight:normal;">' + overview['no_parts'] + '</textspan><br>' +
					'<textpan style="font-weight:bold">Units:&nbsp;</textspan>' + 
						'<textspan style="font-weight:normal;">' + overview['units'] + '</textspan><br>' +
					'<textpan style="font-weight:bold">Progress:&nbsp;</textspan><br>';


		//	parts widget...
		var parts = overview['parts'];
		html += 		'<div style="float:left;" >';
		var w = 0;
		for (var i=0;i< overview['no_parts'];i++)
		{
			var part_no =i + 1;
			var path = parts[i]['status']['icon'];
                	var onclick = "sw_change_status(" + sw_jobid + "," + part_no + " );";
                	html += 		'<div style="float:left;position:relative;" >' +
                        				'<img onclick=' + onclick + ' style="max-width:20px;" src="' + path + '" ></img>' +
                        				'<div onclick=' + onclick + ' style="z-index:10;position:absolute;top:0px;left:0px;color:black;margin-left:7px;margin-top:2px;">' +
                                				part_no + 
							'</div>' +
						'</div>';
			w += 0;
		}
		html += 		"</div>";


		html +=			'<div style="clear:both;"></div>';
		html += 	"</div>";  // done second column

/*
		//	third column	
		html += 	'<div style="margin-left:20px;float:left;" >';
		var account = overview['acct'];

		html += 		'<textpan style="font-weight:bold">Total Available Grants:&nbsp;</textspan>' +
                                       	'<textspan style="font-weight:normal;">' + account['sa'] + '</textspan><br>';
		var payments = account['sa'] - account['ca'];
		html += 		'<textpan style="font-weight:bold">Total Grant Payments:&nbsp;</textspan>' +
                                       	'<textspan style="font-weight:normal;">' + payments + '</textspan><br>'
		html += 		'<textpan style="font-weight:bold">Total Grant Payments:&nbsp;</textspan>' +
                                       	'<textspan style="font-weight:normal;">' + 0 + '</textspan><br>'
		html += 	"</div>"; // done third column


                //     fourth column
                html += 	'<div style="margin-left:20px;float:left;" >';
                var account = overview['acct'];

                html += 		'<textpan style="font-weight:bold">Total Cost::&nbsp;</textspan>' +
                                       	'<textspan style="font-weight:normal;">' + overview['total_cost'] + '</textspan><br>';
                html += 		'<textpan style="font-weight:bold">Balance Due:&nbsp;</textspan>' +
                                       	'<textspan style="font-weight:normal;">' + overview['balance_due'] + '</textspan><br>'
                html += 	"</div>"; // done fourth column
*/

		//	fifth column
                html += 	'<div style="margin-left:20px;float:left;" >';
                var onclick = 'sw_checkout("' + sw_jobid + '");'
                var width = 70;
                var fpr = overview['progress'];
                var pr = Math.round( overview['progress'] * width );
                if (fpr<0) // error
                        html += 	'<div style="width:' + width + 'px;height:30px">' + 
						'<div style="width:' + width + 'px;height:30px;background-color:red;">'+
                                			'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       				'</div>' + 
					'</div>';
                else if (fpr==1.0) //paid !!
                        html += 	'<div style="width:' + width + 'px;height:30px">' +
						'<div style="width:' + width + 'px;height:30px;background-color:lightgreen;">'+
                                			'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       				'</div>' +
					'</div>';
                else if (fpr>1.0) //overpaid !!
                        html += 	'<div style="width:' + width + 'px;height:30px">' + 
						'<div style="width:' + width + 'px;height:30px;background-color:pink;">'+
                                			'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       				'</div>' +
					'</div>';
                else
                        html += 	'<div style="width:' + width + 'px;height:30px">' + 
						'<div style="width:' + pr + 'px;height:30px;background-color:lightgreen;">'+
                                			'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       				'</div>' +
					'</div>';
                
		html += 	"</div>"; // done fifth column


		//	done with columns...
		html += 	'<div style="clear:both;width:0px;"></div>';
		html +=	'</div>';	

	}
		
	html += '</div>';
	

	sw_parent.set("innerHTML",html);
}

function sw_refresh()
{
	//if (!devid && !jobid)
	//{
	//sw_show(null,null,null);
	//}
	//else
	{
		Y = sw_Y;

        	var handleSuccess = function(id, o, a)
        	{
        		sw_data = Y.JSON.parse(o.responseText);
			if ( sw_data && sw_data['status'] )
				sw_show( sw_data['data'] , sw_data['devices'], sw_data['overview'] );
			else 
				sw_show( null, null,null);
		}
        	var cfg =
        	{
            
			sync: true,
            		method: "GET",
            		xdr: { use:'native' },
            		on: {
                		start: function(id,a) {},
                		success: handleSuccess,
                		failure: function(id,o,a) { console.log("ERROR: sw"); }
            			}
        		};
        
			var url = CONFIG_BASE_URL + "services?sessionid=" + page_sessionid + "&wide=true";
			if ( sw_jobid )
				url += ("&jobid=" + sw_jobid);
	
        		Y.io.header('X-Requested-With');
        		var obj = Y.io( url, cfg );

	}
}

function service_wide_init(Y, parentName)
{
	sw_Y = Y;

	sw_event_id = Y.guid();

	sw_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "service_summary_tabs", sw_event_id, function(e)
        {
                sw_current_tab = e.message;
		if ((sw_current_tab=="Wide_Format") )
		{
			//sw_refresh();
			sw_selectdevice();
		}
        });

        //      listen to selected jobid...
        common_subscribe_event( Y, "selected_jobid", sw_event_id, function(e)
        {
                var new_jobid = e.message;
                if ((sw_current_tab=="Wide_Format") && (new_jobid))
		{
			sw_jobid = new_jobid;
		}
                sw_refresh();
        });
        
	sw_show(null,null,null);


}
