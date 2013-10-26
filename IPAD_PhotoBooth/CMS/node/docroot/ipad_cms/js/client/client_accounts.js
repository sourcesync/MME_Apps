//	private, state...
var cla_Y = null;
var cla_event_id = null;
var cla_parent = null;
var cla_current_tab = null;
var cla_clientid = null;
var cla_datatable = null;
var cla_data = null;

function cla_show()
{
	if (cla_clientid && cla_data && cla_data['status'] )
	{
		var ov = cla_data['overview'];

                var html =      '<div style="height:120px;">';

		//      header...
                html +=         '<div style="height:20px;">\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">Client Name:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + ov['name'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Total Accounts::&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + cla_data['data'].length + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                </div>';
/*
		html +=		'<div>\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Device:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['device'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['clientname'] + '</textspan><br>\
                                        </div>\
                                </div>';

		html +=		'<div>';	
*/

		html +=        		'<div style="float:left;margin-top:10px;margin-left:20px;max-height:80px;overflow:auto;" id="cla_datatable"></div>';
		html +=         	'<div style="float:left;margin-left:20px;">' +
                                       		//'<button style="width:130px;" class="pure-button" id="cla_full" onclick="cla_fullview(' + common_selected_jobid + ');" >Full View</button><br>' +
                                	'</div>';
		html +=		'</div>';
		html +=		'</div>';

		cla_parent.set("innerHTML",html);

		cla_create_table(cla_Y);
	}
	else
	{
		cla_parent.set("innerHTML",'<div style="min-height:100px;"></div>');
	}
}

function cla_fullview(clientid)
{
	alert("Not implemented");
}

function cla_pay(jobid)
{
	make_payment_wizard_show(jobid);
}


function cla_cb_edit_client_accounts(clientid)
{
        if ( clientid )
                update_client_accounts_panel_show(clientid)
        else
                alert("No client selected");
}

function cla_remove_account( clientid, acctid )
{
        Y = cla_Y;

        var handleSuccess = function(id, o, a)
        {
                cla_data = Y.JSON.parse(o.responseText);
                if ( cla_data && cla_data['data'] )
                        cla_show();
                else
                        cla_show();
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: client accounts."); }
            }
        };

        var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&removeacct=" + acctid + "&clientid=" + clientid;

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function cla_cb_remove_account( clientid, acctid )
{
	if ( !clientid )
		alert("No client selected.");
	else
		cla_remove_account(clientid, acctid);
}

function cla_cb_edit_client(clientid)
{
        if ( clientid )
                update_client_panel_show(clientid)
        else
                alert("No client selected");
}

function cla_create_table(Y)
{
	if ( cla_datatable )
	{
		cla_datatable.destroy();
		cla_datatable = null;
	}

	var nifunc = "alert('Not Implemented.');";

	var rFormatter = function(o)
	{
		var func = 'cla_cb_remove_account(' + common_selected_clientid + ',' + o.data['acctid'] + ');';
		return '<button onclick="' + func + '" >Remove</button>';
	};
	
	var eFormatter = function(o)
	{
		var func = 'cla_cb_edit_client_accounts( ' + common_selected_clientid + ');';
		return '<button onclick="' + func + '" >Edit</button>';
		//return '<button onclick="' + nifunc + '" >Edit</button>';
	};

	var cols = [
		{ key:"dept", label:"Department", sortable:false },
		{ key:"code", label:"Dept Code", sortable:false },
	 	{ key:'rm',  label:'Remove', allowHTML:true, formatter: rFormatter } ,
	 	{ key:'edit',  label:'Edit', allowHTML:true, formatter: eFormatter } 
	];

	var data = ( cla_data && cla_data['data'] ) ? cla_data['data']: [];

	/*
	var rev_data = [];
	for (var i=data.length-1;i>=0;i--)
	{
		var item = data[i];
		rev_data.push(item);
	}
	*/
	
        cla_datatable = new Y.DataTable({
                columns:cols,
                data:data,
                summary:"Client Accounts"

                // "selection" config stuff begins here ...
                //highlightMode: 'row',
                //selectionMode: 'row',
                //selectionMulti: false

                }).render("#cla_datatable");


}

function cla_refresh(clientid)
{
	Y = cla_Y;

	cla_clientid = clientid;

        var handleSuccess = function(id, o, a)
        {
            	cla_data = Y.JSON.parse(o.responseText);
		if ( cla_data && cla_data['data'] )
			cla_show();
		else
			cla_show();
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: client accounts."); }
            }
        };
        
	var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&accounts=true&clientid=" + clientid;

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function client_accounts_init(Y, parentName)
{
	cla_Y = Y;

	cla_event_id = Y.guid();

	cla_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "client_summary_tabs", cla_event_id, function(e)
        {
                cla_current_tab = e.message;
		if ((cla_current_tab=="accounts") && (common_selected_clientid))
			cla_refresh(common_selected_clientid);
		else
			cla_show();
		
        });
        
	//      listen to selected clientid...
        common_subscribe_event( Y, "selected_clientid", cla_event_id, function(e)
        {
		var new_clientid = e.message;
		cla_clientid = new_clientid;

                if ( (cla_current_tab=="accounts") && ( new_clientid ) )
                        cla_refresh(new_clientid);
		else
			cla_show();
        });

        //      listen to clients changes...
        common_subscribe_event( Y, "clients_changed", cla_event_id, function(e)
        {
                if ((cla_current_tab=="accounts") && (common_selected_clientid) )
                        cla_refresh(common_selected_clientid);
		else
			cla_show();

        });
        

	cla_show();
}
