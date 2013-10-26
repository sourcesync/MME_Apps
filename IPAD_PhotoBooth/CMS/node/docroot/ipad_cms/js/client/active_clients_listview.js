var acl_Y = null;
var acl_datatable = null;
var acl_parentName = null;
var acl_event_id = null;
var acl_data = null;
var acl_guid = null;
var acl_paging = null;
var acl_clientid = null;

function acl_cb_new_client()
{
	new_client_wizard_show();
}


function acl_cb_edit_client()
{
	if ( acl_clientid )
        	update_client_panel_show(acl_clientid)
	else
		alert("No client selected");
}


function acl_cb_edit_client_accounts()
{
        if ( acl_clientid )
                update_client_accounts_panel_show( acl_clientid)
        else
                alert("No client selected");
}

function acl_cb_delete_client()
{
        if ( acl_clientid )
                acl_delete_client( acl_clientid );
        else
                alert("No client selected.");
}

function acl_delete_client( accountid )
{
        var cb_success = function( status )
                {
                        if ( status && status['status'] )
                        {
                                common_notify_selected_clientid( acl_event_id, null );
                                common_notify_clients_changed( acl_event_id );

				// force local update because events above get filtered, because its same id...
				active_clients_listview_show(acl_Y,null,null,null,null);
                        }
                        else alert( "Could not delete client." );
                };

        var obj = comm_get_sync( "clients",
                { 'delete':'true', 'clientid': acl_clientid },
                cb_success, null );
}


function active_clients_listview_init(Y, parentName)
{
	acl_Y = Y;
	acl_parentName = parentName;

	//	id for events...
	acl_event_id = Y.guid();

	//	create the html for the region...
	var html = 	'<div style="height:100%;" id="acl_parent" class="pure-skin-mine4">' +
				'<div id="acl_datatable" ></div>' +
				'<ul id="acl_paginator" style="margin-bottom:10px;margin-right:12px;position:fixed;right:0px;bottom:0px;" class="pure-paginator"></ul>' +
				'<div style="position:fixed;bottom:0px;height:40px;" class="pure-skin-mine4" >' +
                                        '<div id="acl_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >' +
                                                '<button style="margin-left:10px;" class="pure-button" onclick="acl_cb_new_client();" >New Client</button>' +
                                                '<button style="margin-left:10px;" class="pure-button" onclick="acl_cb_edit_client();" >Edit Client</button>' +
                                                '<button style="margin-left:10px;" class="pure-button" onclick="acl_cb_delete_client();" >Delete Client</button>' +
                                                '<button style="margin-left:10px;" class="pure-button" onclick="acl_cb_edit_client_accounts();" >Edit Accounts</button>' +
                                        '</div>' +
                                '</div>' +
			'</div>';
	var el = Y.Node.create(html);
	var parent = Y.Node('#' + parentName);
	parent.append( el );	

	//	listen to tab changes in parent...
	common_subscribe_event( Y, "clients_listviews_tabs", acl_event_id, function(e)
        {
                var tab = e.message;
		active_clients_listview_show(acl_Y,null,null,null,null);
        });

	//	listen to clients changes...
	common_subscribe_event( Y, "clients_changed", acl_event_id, function(e)
        {
		active_clients_listview_show(acl_Y,null,null,null,null);
        });

        //      listen to new client...
        common_subscribe_event( Y, "new_client", acl_event_id, function(e)
        {
                var new_clientid = e.message;
		acl_clientid = new_clientid;
                active_clients_listview_show(acl_Y,null,null,new_clientid,null);

		common_notify_selected_clientid( acl_event_id, acl_clientid );
        });

       	//      listen to deviceuid changes...
        common_subscribe_event( Y, "selected_serviceuid", acl_event_id, function(e)
        {
		var serviceuid = e.message;
                active_clients_listview_show(acl_Y, serviceuid, null, null,null);
        });

       	//      listen to deviceuid changes...
        common_subscribe_event( Y, "selected_deviceuid", acl_event_id, function(e)
        {
		var serviceuid = e.message[0];
		var deviceuid = e.message[1];
                active_clients_listview_show(acl_Y, serviceuid, deviceuid, null,null);
        });

	//	catch html window resize so that we can resize the datatable, the parent, move the paginator...
	Y.on("windowresize", function(e) {
		//acl_window_resize();
	});

}

function acl_window_resize()
{
                var mi = Y.one( "#middle" );
                var misz = mi.get("offsetHeight");

                var ut = Y.one("#upper_tabs_parent");
                var utsz = ut.get("offsetHeight");

                //      resize the parent...
                el = Y.one( "#" + acl_parentName );
                el.setStyle("height", misz - utsz- 40 );

}


function acl_page( page )
{
	active_clients_listview_show(acl_Y, 
		common_selected_serviceuid, 
		common_selected_deviceuid,
		null,
		page);

}


function active_clients_listview_show(Y, serviceuid, deviceuid, findclient, page)
{
        //acl_window_resize();

	acl_data = acl_get_data(Y, serviceuid, deviceuid, findclient, page);

}

function acl_create_table(Y)
{
	//	destroy last table...	
	if ( acl_datatable)
	{

                bdt_pre_setdata( acl_clientid );
                acl_datatable.set("data",acl_data['data'] );
                bdt_post_setdata();

                return;
	}

	//	reconfig paginator...
	//var base_url = window.location.href.split("?")[0];

	var gen_onclick = function(i)
	{
		//return 'alert(' + i + '); acl_page(' + i +');';
		return 'acl_page(' + i +');';
	};
	common_config_paginator('acl_paginator', acl_data['paging'], null, gen_onclick);

	var serviceFormatter = function(o)
	{
		return '<img style="max-height:25px;" src="' + CONFIG_BASE_URL + 'assets/symbol_wf.png"></img>';
	};

	var paymentFormatter =  function (o)
        {
        	var onclick = 'acl_checkout("' + o.data['jobid'] + '");'
		var width = 70;
		var fpr = o.data['progress'];
		var pr = Math.round( o.data['progress'] * width );
		if (fpr<0) // error
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:red;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' + 
                       '</div>';
		else if (fpr==1.0) //paid !!
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:lightgreen;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       '</div>';
		else if (fpr>1.0) //overpaid !!
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:pink;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       '</div>';
		else
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + pr + 'px;height:30px;background-color:lightgreen;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       '</div>';
        };

        var iconFormatter =  function (o)
        {
                var path = o.data['status']['icon'];
                return '<div><img style="max-width:20px;" src="' + path + '" ></img></div>';
        };

	var getmsname = function(num)
	{
	        if (num=="1") return "Job Created";
                else if (num=="2") return "Awaiting Administrator Approval For Test";
                else if (num=="3") return "Ready For Test";
                else if (num=="4") return "Test Completed";
                else if (num=="5") return "Awaiting Client Approval";
                else if (num=="6") return "Test Approved";
                else if (num=="7") return "Awaiting Administrator Approval For Final";
                else if (num=="8") return "Ready For Final";
                else if (num=="9") return "Final Completed";
                else return "Unknown";
	};

        function formatDatesCreated(o) {
                var vl = new Date(o.data['created']);
                var dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M"});
		return dt;
        };
        function formatDatesUpdated(o) {
                var vl = new Date(o.data['updated']);
                var dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M"});
		return dt;
        };

        var selectionFormatter = function(o) {

                //if ( o.data['clientid'] == acl_current_selectionid )
                //        o.rowClass = "yui3-datatable-sel-selected manual";
                //else
                //        o.rowClass = "";

                return o.data['name'];
        };

	var clFormatter = function(o) {
		bdt_formatter(o);
		return o.data['clientid'];
	};

        var cols = [
		{ key:  'clientid', label: 'ClientID', sortable:true, formatter:clFormatter },
		{ key:	'name', label:	"Name", sortable:true, formatter:selectionFormatter },
		{ key:	'netid', label:	'NetID', sortable:true },
		{ key:	'created', label:'Date Created', sortable:true, formatter:	formatDatesCreated },
		{ key:	'updated', label:'Date Updated', sortable:true, formatter:	formatDatesUpdated },
		{ key:	'dept', label:	'Department', sortable:	true }
	 ];

	acl_datatable = new Y.DataTable({
                columns:cols,
                data:acl_data['data'],
                summary:"Clients",
                width:"100%",

                // "selection" config stuff begins here ...
                //highlightMode: 'row',
                //selectionMode: 'row',
                //selectionMulti: false

                //}).render("#" + acl_parentName);
                }).render("#acl_datatable");

	var selfunc = function( val_id )
        {
                //      store here...
                acl_clientid = val_id;

                //      notify global order selection !!!
                common_notify_selected_clientid( acl_event_id, val_id );
        }

        bdtable_init( acl_Y, acl_datatable, "clientid", selfunc  );

/*
        acl_datatable.on("selected",
                function(obj)
                {
                        if (obj.record)
                        {
                                var clientid = obj.record.get('clientid');

				// possibly reset manually selected row...
				//var nodes = Y.Node(".manual");
				//if (nodes)
				//{
				//	alert(obj.rowClass);
				//}	

				acl_datatable.set("selectedRecords",[3]);

				// track it for possible manual selection across refreshes...
				acl_current_selectionid = clientid;

				//	notify globally current clientid...
				common_notify_selected_clientid( acl_event_id, clientid );	
                        }
                });

	acl_datatable.set("selectedRecords",[3]);
*/

	//acl_window_resize();

}

function acl_get_data(Y, serviceuid, deviceuid, findclient, page)
{
	// prepare web service config...
        var handleSuccess = function(id, o, a)
        {
            var resp = Y.JSON.parse(o.responseText);
	    if (resp && resp['status'])
	    {
            	acl_data = resp;
	    	acl_create_table(Y);
	    }
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { Y.log("ERROR",id,o,a); }
            }
        };

        //      append paging...
        var page_no=1;
        var page_no = 1;  //default to first page...
        if (page) page_no = page;

        //      possibly override/append page size based on available size...
        var page_size = 1;  // default to some number...
        //var el = Y.Node('#acl_parent');

        el = Y.Node("#lower_tabs_parent");
        //var act_el = Y.Node("#action_bar");
        var ht = el.get("offsetHeight"); // - act_el.get("offsetHeight");

        //var ht = el.get("offsetHeight");
        page_size = Math.floor( ( ht -20) /25);
	if (page_size<=0) page_size = 1;
	
        var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&active=true&page_no=" + page_no + "&page_size=" + page_size;
	if (serviceuid && (serviceuid!="0") )
		url += "&serviceuid=" + serviceuid;
	if (deviceuid && (deviceuid!="0"))
		url += "&deviceuid=" + deviceuid;
	if (findclient && findclient!="")
		url += "&find=" + findclient;

        Y.io.header('X-Requested-With');
	Y.io(url, cfg );
	
	
	//	TODO: check error...
	return acl_data;
}

