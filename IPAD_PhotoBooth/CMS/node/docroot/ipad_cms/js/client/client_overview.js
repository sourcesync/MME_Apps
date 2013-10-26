//	private, state...
var co_Y = null;
var co_event_id = null;
var co_parent = null;
var co_current_tab = null;

function co_change_status(jobid, partid)
{
}

function co_checkout(jobid)
{
        //      show the make payment wizard...
        make_payment_wizard_show( jobid );	
}

function co_show( overview )
{
	if (overview)
	{
		var aem = (overview['aem']!=null)?overview['aem']:"";
		var aph = (overview['aph']!=null)?overview['aph']:"";

		var html = 	'<div style="height:120px;">';

		html +=		'<div style="margin-left:10px;margin-top:10px;float:left;" >';
		html += 		'<div>\
                                		<textspan style="width:90px;font-weight:bold;float:left;">Name:</textspan>\
							<textspan style="font-weight:normal;float:left;">' + overview['name'] + '</textspan>\
						<div style="clear:both;width:0px;"></div>\
					</div>\
					<div style="margin-top:5px;">\
                                                <textspan style="width:90px;float:left;font-weight:bold;float:left;">NetID:</textspan>\
                                                        <textspan style="font-weight:normal;float:left;">' + overview['netid'] + '</textspan>\
						<div style="clear:both;width:0px;"></div>\
                                        </div>\
					<div style="margin-top:5px;">\
                                		<textspan style="width:90px;font-weight:bold;float:left;">Department:</textspan>\
							<textspan style="font-weight:normal;float:left;">' + overview['dept'] + '</textspan>\
						<div style="clear:both;width:0px;"></div>\
					</div>';
		html +=		'</div>';

		html +=		'<div style="margin-left:20px;margin-top:10px;float:left;">';
		html += 		'<div>\
                                		<textspan style="width:80px;font-weight:bold;float:left;">Email:</textspan>\
							<textspan style="font-weight:normal;float:left;">' + overview['em'] + '</textspan>\
						<div style="clear:both;width:0px;"></div>\
					</div>\
					<div style="margin-top:5px;">\
                                                <textspan style="width:80px;font-weight:bold;float:left;">Alt Email:</textspan>\
                                                        <textspan style="font-weight:normal;float:left;">'  + aem + '</textspan><br>\
						<div style="clear:both;width:0px;"></div>\
                                        </div>'
		html +=		'</div>';


                html +=         '<div style="margin-left:20px;margin-top:10px;float:left;">';
                html += 		'<div>' +
                                                '<textspan style="width:80px;font-weight:bold;float:left;">Phone:</textspan>' +
							'<textspan style="font-weight:normal;float:left;">' + overview['ph'] + '</textspan>' +
						'<div style="clear:both;width:0px;"></div>' +
                                        '</div>' +
                                        '<div style="margin-top:5px;">' +
                                                '<textspan style="width:80px;font-weight:bold;float:left;">Alt Phone:</textspan>' +
							'<textspan style="font-weight:normal;float:left;">' + aph + '</textspan><br>' +
                                        '</div>';
                html +=         '</div>';


		html += 	'</div>';

		co_parent.set("innerHTML",html);
	}
	else
	{
		co_parent.set("innerHTML",'<div style="min-height:120px;" ></div>');
	}
}

function co_refresh(clientid)
{
	Y = co_Y;

        var handleSuccess = function(id, o, a)
        {
        	co_data = Y.JSON.parse(o.responseText);
		if ( co_data && co_data['status'] )
			co_show( co_data['overview'] );
		else 
			co_show(null);
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: client_overview"); }
            }
        };
        
	var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&overview=true&clientid=" + clientid;

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function client_overview_init(Y, parentName)
{
	co_Y = Y;

	co_event_id = Y.guid();

	co_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "client_summary_tabs", co_event_id, function(e)
        {
                co_current_tab = e.message;
		if ((co_current_tab=="overview") && (common_selected_clientid))
			co_refresh(common_selected_clientid);
        });
        
	//      listen to selected clientid...
        common_subscribe_event( Y, "selected_clientid", co_event_id, function(e)
        {
		var new_clientid = e.message;
                if ((co_current_tab=="overview") && (new_clientid))
                        co_refresh(new_clientid);
		else
			co_show(null);
        });

        //      listen to clients changes...
        common_subscribe_event( Y, "clients_changed", co_event_id, function(e)
        {
                if ((co_current_tab=="overview") && (common_selected_clientid))
                        co_refresh(common_selected_clientid);

        });
        
	co_show(null);

}
