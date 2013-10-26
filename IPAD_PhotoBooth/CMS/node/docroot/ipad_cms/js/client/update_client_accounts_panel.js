var ucap_panel 		= null;
var ucap_Y 		= null;
var ucap_event_id	= null;
var ucap_datatable 	= null;
var ucap_state 		= null;
var ucap_search_results 	= [];
var ucap_accountid	= null;
var ucap_data		= null;
var ucap_clientid	= null;

//      defs...
var ucap_definition_dct= {
    'VV_UCAPPARENT':'',
    'VT_UCAPSEARCH':{'default':'Department or Name','init':""}
};

function update_client_accounts_panel_show(clientid)
{
	ucap_clientid = clientid;
	ucap_search_results = [];

	if (ucap_panel)
	{
		ucap_panel.destroy();
		ucap_panel = null;
	}

	if (ucap_datatable) 
	{
		ucap_datatable.destroy();	
		ucap_datatable = null;
	}

	if (ucap_Y)
	{
		ucap_create_and_show(ucap_Y);

		ucap_refresh();

		common_setglobalstate( ucap_state, null );
	}

}

function ucap_submit()
{
        //      get date now...
        var dt = new Date();
        dt = dt.getTime();

	//	modify the last object...
	var clobj = ucap_data['overview'];
        clobj['updated'] =  dt;
        clobj['accounts']  = [ucap_accountid];

        //      callbacks...
        var cb_success = function(a)
        {
                if (a && a['status'])
                {
                        // notify for the listview...
                        common_notify_clients_changed( ucap_event_id, ucap_clientid );

                        // notify for the summary tabs...
                        common_notify_selected_clientid( ucap_event_id, ucap_clientid );
                }
                else
                {
                        alert('ERROR: update failed.');
                }
        };
        var cb_fail = function(a) { alert('ERROR: update accounts failed.'); };

        //      make the post call...
        comm_post_sync( "uploads", { "client":"update" ,'clientid':ucap_clientid }, clobj, cb_success, cb_fail );

        return true;
}

function ucap_refresh()
{
        var cb_success = function( status )
                {
                        ucap_data = null;
                        if ( status && status['status'] ) ucap_data = status;
                        //ucap_show( );
                };

        var obj = comm_get_sync( "clients",
                { 'get':'true', 'clientid':ucap_clientid },
                cb_success, null );

}

var ucap_search_template_html = '\
		<div>\
			<div style="margin-top:10px;" >To which grant account does this client belong?</div>\
			<div style="margin-top:10px;margin-left:10px;">\
                		<div id="{VV_UCAPPARENT}">\
                			<div style="float:left;" >Search grant accounts:</div>\
                			<input style="margin-left:5px;float:left;" id="{VT_UCAPSEARCH}" type="text" value="{VT_UCAPSEARCH_VAL}">\
					<button style="margin-left:5px;float:left;"  id="ucap_search_go" class="pure-button">go</button>\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:20px;">\
					<div style="overflow:auto;" id="ucap_datatable"></div>\
				</div>\
			</div>\
		</div>';

function ucap_create_panel(Y)
{
	var html = '<div id="ucap_search_panel">' +
        		'<div class="yui3-widget-bd">' +
        			'<div id="ucap_lhs" style="float:left;" ></div>' +
        			'<div style="float:left;">' + 
        				'<div style="margin-top:10px;" id="ucap_search_parent" ></div>' +
				'</div>' +
        			'<div style="clear:both;width:0px;" ></div>' +
			'</div>' + 
		    '</div>';

        //      add to body...
	var el = Y.Node.create(html);
        var bodyNode = Y.one(document.body);
        bodyNode.append( el );
 
	//      initialize various state from definition...
        ucap_state = common_instantiate_definition( ucap_definition_dct, "VV_UCAPSEARCH", "", null );

        //      create the content area via substitution...
        var str = Y.Lang.sub( ucap_search_template_html, ucap_state['html'] );
        el = Y.Node.create( str );
	var parent = Y.Node('#ucap_search_parent');
        parent.append(el);

        //      do DOM-related state initialization...
        common_dom_configure( Y, ucap_state, 
		function(el,status)
		{
		} );

        //      do some custom config...
        ucap_state['validate']['VT_UCAPSEARCH'] = [
                                        function(obj)
                                        {
                                                var vl = obj.get("value");
                                                if ( (vl==null) || (vl=="") )
                                                        return false;
                                                else
                                                        return true;
                                        },
                                        'VV_UCAPPARENT' ];

	//	config the go button...
	Y.Node("#ucap_search_go").on("click", function(e)
		{
			var txt = ucap_state['values']['VT_UCAPSEARCH'];
			ucap_search( ucap_Y, txt );
		});
}

function ucap_validate()
{
	if ( ! ucap_accountid )
	{
		alert("ERROR: No account found or selected.");
		return false;
	}
	else
	{
		return true;
	}
}

function ucap_search(Y, txt)
{
        var handleSuccess = function(id, o, a)
        {
        	var resp = Y.JSON.parse(o.responseText);

		if ( resp['status'] )
		{
			ucap_search_results = resp['data'];
		}
		else  //TODO: deal with error
		{
			alert("ERROR: ucap search failed");
			ucap_search_results = [];
		}
		
		ucap_make_datatable(Y);
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

	var etext = encodeURIComponent( txt );

        Y.io.header('X-Requested-With');
        var obj = Y.io( CONFIG_BASE_URL + "accounts?sessionid=" + page_sessionid + "&search=" + etext, cfg );
}

function update_client_accounts_panel_init(Y)
{
	ucap_Y = Y;	

	ucap_event_id = Y.guid();
}

function ucap_make_datatable(Y)
{
	//	create the cols...
	var cols = [
		{'key':'dept', 'label':'Department', sortable:false },
		{'key':'code', 'label':'Dept Code', sortable:false }
	];

        //      make the datatable...
	if ( ucap_datatable != null )
	{
		ucap_datatable.destroy();
		ucap_datatable = null;
	}

        //      compute/set containers dims...
        var width = CLW_WIDTH - CLW_LHS_WIDTH - 40;
        var height = CLW_HEIGHT - 165;
        Y.Node('#ucap_datatable').setStyle('height',height + "px");
        Y.Node('#ucap_datatable').setStyle('width',width + "px");

	//	make the datable...
        ucap_datatable = new Y.DataTable(
		{
                	columns: cols,
                        data:ucap_search_results,
                        summary:"Grant Account Search",
                        width:  "100%",

                	highlightMode: 'row',
                	selectionMode: 'row',
                	selectionMulti: false,

			//scrollable: true,
                }).render("#ucap_datatable");

        ucap_datatable.on("selected",
                function(obj)
                {
                        if (obj.record)
                        {
				ucap_accountid = obj.record.get("accountid");
                        }
                });

}

function ucap_create_and_show(Y)
{
	//	create the panel contents...
	ucap_create_panel(Y);

	//	make the panel...
        ucap_panel = new Y.Panel({
                		srcNode: 	'#ucap_search_panel',
                		headerContent: 	'Update Client Account',
                		width: 		CLW_WIDTH,
				height:		CLW_HEIGHT,		
                		zIndex:		10,
                		centered: 	true,
                		modal:		true,
                		visible:	false,
                		render:		true,
                		plugins:	[Y.Plugin.Drag]
        		});


	//	make the datatable based on search results
	ucap_make_datatable(Y);

	//	add back button...
	ucap_panel.addButton({
        			value  : 'Cancel',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						ucap_panel.destroy();
						ucap_panel.null;
        				}});

	//	add next buttons...
	ucap_panel.addButton({
        			value  : 'Submit',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						var test = ucap_validate();
						if (test)
						{
							if ( ucap_submit( ) )
							{
								ucap_panel.destroy();
								ucap_panel = null;
							}
							else
								alert("ERROR: update failed.");
						}
        				}});

	//	show it...
	ucap_panel.show();
}

