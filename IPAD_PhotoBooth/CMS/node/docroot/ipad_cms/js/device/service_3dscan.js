//	private, state...
var std_Y = null;
var std_event_id = null;
var std_parent = null;
var std_current_tab = null;
var std_device = null;

function std_change_status(jobid, partid)
{
}

function std_checkout(jobid)
{
        //      show the make payment wizard...
        make_payment_wizard_show( jobid );
}


function std_selectdevice()
{
	var el = Y.Node("#std_device");
	std_device = el.get("value");

	std_refresh();
}

function std_getdevicebyuid(devices, uid)
{
	for ( var i=0;i<devices.length;i++)
	{
		if ( (devices[i]["serviceid"]=="3") && (devices[i]["uid"] == uid ))
			return devices[i];
	}
}

function std_show( services, devices, overview )
{
	var html = 	'<div style="min-height:100px;" >\
					<div></div>\
					<div style="float:left;">\
						<div style="float:left;" ><textpan style="font-weight:bold">Device Name:&nbsp;</textspan></div>\
						<select style="float:left;" name="std" id="std_device" onchange="std_selectdevice();">\
							<option value="0" {V0}>All Devices</option>\
							<option value="1" {V1}>Peaches</option>\
        						<option value="2" {V2}>Sweet Zombie</option>\
        						<option value="3" {V3}>Bertha</option>\
						</select>\
						<div style="clear:both;"></div>\
					</div>';
	
	var dct = {};	
	dct["V0"] = (std_device==null||std_device=="0") ? "selected":"" ;
	dct["V1"] = (std_device=="1")?"selected":"" ;
	dct["V2"] = (std_device=="2")?"selected":"" ;
	dct["V3"] = (std_device=="3")?"selected":"" ;
	html = Y.Lang.sub( html, dct );

	//	Possibly append more stuff to right of DEVICE NAME...
	if ( devices )
	{
		if ( (std_device == null) || (std_device=="0") )
		{
		}
		else
		{
			var device = std_getdevicebyuid( devices, std_device );
			if (device)
			{	
				html += '<div style="float:left;">' +
                               			'<div style="margin-left:10px; float:left;" ><textpan style="font-weight:bold">Device Tier Type:&nbsp;</textspan></div>' + 
						'<div style="float:left;" >' + device["wa"] + '</div>' +
                                                '<div style="clear:both;"></div>' +
                                    	'</div>';
			}
		}
	}
	else
	{
	}
		
	html += '<div style="clear:both;width:0px;"></div>';
	//	end HEADER

	if ( overview )
	{	
/*
		var html = 	'<div style="height:20px;">\
					<div style="top:0px;float:left;">\
                                		<textpan style="font-weight:bold">Order Number:&nbsp;</textspan>\
							<textspan style="font-weight:normal;">' + overview['jid'] + '</textspan><br>\
					</div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
					<div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Service:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['type'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
					<div style="top:0px;float:left;">\
                                		<textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Device:&nbsp;</textspan>\
							<textspan style="font-weight:normal;">' + overview['device'] + '</textspan><br>\
					</div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
					<div style="top:0px;float:left;">\
                                		<textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;</textspan>\
							<textspan style="font-weight:normal;">' + overview['clientname'] + '</textspan><br>\
					</div>\
				</div>';
*/

		html += //'<div style="min-height:100px;" >' +
			'<div>' +
			'<img style="float:left;" src="' + overview['icon'] + '"></img>' +
		 	'<div style="top:0px;float:left; margin-left:10px;padding-left:10px;">' +
				'<textpan style="font-weight:bold">Total Parts:&nbsp;</textspan>' + 
					'<textspan style="font-weight:normal;">' + overview['no_parts'] + '</textspan><br>' +
				'<textpan style="font-weight:bold">Units:&nbsp;</textspan>' + 
					'<textspan style="font-weight:normal;">' + overview['units'] + '</textspan><br>' +
				'<textpan style="font-weight:bold">Progress:&nbsp;</textspan><br>';
		

		//	parts widget...
		var parts = overview['parts'];
		html += '<div style="float:left;" >';
		var w = 0;
		for (var i=0;i< overview['no_parts'];i++)
		{
			var part_no =i + 1;
			var path = parts[i]['status']['icon'];
                	var onclick = "std_change_status(" + common_selected_jobid + "," + part_no + " );";
                	html += '<div style="float:left;position:relative;" >' +
                        	'	<img onclick=' + onclick + ' style="max-width:20px;" src="' + path + '" ></img>' +
                        	'	<div onclick=' + onclick + ' style="z-index:10;position:absolute;top:0px;left:0px;color:black;margin-left:7px;margin-top:2px;">' +
                                		part_no + '</div>' +
				'</div>';
			w += 0;
		}
		html += "</div>";
		html += "</div>";  // done first column

/*
		//	second column	
		html += '<div style="margin-left:20px;float:left;" >';
		var account = overview['acct'];

		html += '<textpan style="font-weight:bold">Total Available Grants:&nbsp;</textspan>' +
                                        '<textspan style="font-weight:normal;">' + account['sa'] + '</textspan><br>';
		var payments = account['sa'] - account['ca'];
		html += '<textpan style="font-weight:bold">Total Grant Payments:&nbsp;</textspan>' +
                                        '<textspan style="font-weight:normal;">' + payments + '</textspan><br>'
		html += '<textpan style="font-weight:bold">Total Grant Payments:&nbsp;</textspan>' +
                                        '<textspan style="font-weight:normal;">' + 0 + '</textspan><br>'
		html += "</div>"; // done second column


                //      third column
                html += '<div style="margin-left:20px;float:left;" >';
                var account = overview['acct'];

                html += '<textpan style="font-weight:bold">Total Cost::&nbsp;</textspan>' +
                                        '<textspan style="font-weight:normal;">' + overview['total_cost'] + '</textspan><br>';
                html += '<textpan style="font-weight:bold">Balance Due:&nbsp;</textspan>' +
                                        '<textspan style="font-weight:normal;">' + overview['balance_due'] + '</textspan><br>'
                html += "</div>"; // done third column
*/

		//	fourth column
                html += '<div style="margin-left:20px;float:left;" >';
                var onclick = 'std_checkout("' + common_selected_jobid + '");'
                var width = 70;
                var fpr = overview['progress'];
                var pr = Math.round( overview['progress'] * width );
                if (fpr<0) // error
                        html += '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:red;">'+
                                '<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       		'</div></div>';
                else if (fpr==1.0) //paid !!
                        html += '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:lightgreen;">'+
                                '<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       		'</div></div>';
                else if (fpr>1.0) //overpaid !!
                        html += '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:pink;">'+
                                '<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       		'</div></div>';
                else
                        html += '<div style="width:' + width + 'px;height:30px"><div style="width:' + pr + 'px;height:30px;background-color:lightgreen;">'+
                                '<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       		'</div></div>';
                html += "</div>"; // done third column

		//	done with columns...
		html += '<div style="clear:both;width:0px;"></div>';

		html += '</div>';
		
	}
		

	std_parent.set("innerHTML",html);
}

function std_refresh()
{
	Y = std_Y;

        var handleSuccess = function(id, o, a)
        {
        	std_data = Y.JSON.parse(o.responseText);
		if ( std_data && std_data['status'] )
			std_show( std_data['data'] , std_data['devices'], std_data['overview'] );
		else 
			std_show( null, null,null);
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: std"); }
            }
        };
        
	var url = CONFIG_BASE_URL + "services?sessionid=" + page_sessionid + "&3dscan=true";
	if ( common_selected_jobid )
		url += ("&jobid=" + common_selected_jobid);
	
        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function service_3dscan_init(Y, parentName)
{
	std_Y = Y;

	std_event_id = Y.guid();

	std_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "service_summary_tabs", std_event_id, function(e)
        {
                std_current_tab = e.message;
		if ((std_current_tab=="3D_Scan")) 
			std_refresh();
        });

        //      listen to selected jobid...
        common_subscribe_event( Y, "selected_jobid", std_event_id, function(e)
        {
                console.log("service_3dscan: selected_jobid event sink->", e.message);
                var new_jobid = e.message;
                if ((std_current_tab=="3D_Scan") && (new_jobid))
                        std_refresh( );
                else
                        std_show(null, null,null);
        });
        
	std_show(null,null,null);


}
