var csp_panel = null;

//	state...
var csp_Y = null;
var csp_datatable = null;
var csp_state = null;
var csp_search_results = [];
var csp_state_clientid = null;
var csp_state_netid = null;
var csp_state_name = null;
var csp_state_dept = null;
var csp_class = null;

//      defs...
var csp_definition_dct= {
    'VV_CSPPARENT':'',
    'VT_CSPSEARCH':{'default':'Department or Name'}
};

function client_search_panel_return()
{
        common_setglobalstate( csp_state, null );

        csp_panel.show();
}

function client_search_panel_show()
{
	csp_state_dept = null;
	csp_state_name = null;
	csp_state_netid = null;

	if (csp_panel)
	{
		csp_panel.destroy();
		csp_panel = null;
	}

	if (csp_Y)
	{
		csp_create_and_show(csp_Y);
		common_setglobalstate( csp_state, null );
	}
}

var client_search_template_html = '\
                <div id="{VV_CSPPARENT}">\
			<div>\
                		<div style="float:left;" >Search Clients:</div>\
				<div style="float:right;top:0px;"><a onclick="csp_new_client();" href="#">new client</a></div>\
				<div style="clear:both;width:0px;"></div>\
			</div>\
			<div>\
                		<input style="float:left;margin-right:5px;height:28px;" name="csp" id="{VT_CSPSEARCH}" type="text" size=30 value="{VT_CSPSEARCH_VAL}">\
				<button style="float"left;" type="button" id="client_search_go" class="yui3-button">go</button>\
				<div style="clear:both;width:0px;"></div>\
			</div>\
                </div>\
		<div style="margin-top:20px;">\
			<div style="overflow:auto;" id="csp_datatable"></div>\
		</div>';

function csp_new_client()
{
	csp_panel.hide();
	new_client_panel_show(true);
}


function csp_create_panel(Y)
{
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="client_search_panel"></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);
        var c = Y.Node.create('<div id="csp_lhs" style="float:left;" ></div>');
        b.append(c);
        var d = Y.Node.create('<div style="float:left;overflow:auto;" ></div>');
        b.append(d);
        var e = Y.Node.create('<div style="clear:both;width:0px;" ></div>');
        b.append(e);

	//      initialize various state from definition...
        csp_state = common_instantiate_definition( csp_definition_dct, "VV_CSPSEARCH", "", null );

        //      create the content area via substitution...
        var str = Y.Lang.sub( client_search_template_html, csp_state['html'] );
        var el = Y.Node.create( str );
        d.append(el);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

        //      do DOM-related state initialization...
        common_dom_configure( Y, csp_state );

        //      do some custom config...
        csp_state['validate']['VT_CSPSEARCH'] = [
                                        function(obj)
                                        {
                                                var vl = obj.get("value");
                                                if ( (vl==null) || (vl=="") )
                                                        return false;
                                                else
                                                        return true;
                                        },
                                        'VV_CSPPARENT' ];

	//	config the go button...
	Y.Node("#client_search_go").on("click", function(e)
		{
			var txt = csp_state['values']['VT_CSPSEARCH'];
			csp_search( csp_Y, txt );
		});
}

function csp_validate()
{
	if ( ! csp_state_netid )
		return false;
	else
		return true;
}

function csp_search(Y, txt)
{
        var handleSuccess = function(id, o, a)
        {
        	var resp = Y.JSON.parse(o.responseText);
        	Y.log(resp);
		console.log(resp);

		if ( resp['status'] )
			csp_search_results = resp['data'];
		else  //TODO: deal with error
			csp_search_results = [];
		
		csp_make_datatable(Y);
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
        var obj = Y.io( CONFIG_BASE_URL + "clients?search=" + etext, cfg );
}

function client_search_panel_init(Y)
{
	csp_Y = Y;	
}

function csp_make_datatable(Y)
{
	//	create the cols...
	var cols = [
		{'key':'dept', 'label':'Department', sortable:false },
		{'key':'name', 'label':'Name', sortable:false },
		{'key':'netid', 'label':'NetID', sortable:false } ];

        //      make the datatable...
	if ( csp_datatable != null )
	{
		csp_datatable.destroy();
		csp_datatable = null;
	}

	console.log("sr", csp_search_results );

	//	make the datable...
        csp_datatable = new Y.DataTable(
		{
                	columns: cols,
                        data:csp_search_results,
                        summary:"Client Search",
                        width:"100%",

                	highlightMode: 'row',
                	selectionMode: 'row',
                	selectionMulti: false,

			//scrollable: true,
			//height: 200
                }).render("#csp_datatable");

        csp_datatable.on("selected",
                function(obj)
                {
                        if (obj.record)
                        {
				csp_state_clientid = obj.record.get("clientid");
				csp_state_netid = obj.record.get('netid');
				csp_state_name = obj.record.get('name');
				csp_state_dept = obj.record.get('dept');
                        }
                });

}

function csp_create_and_show(Y)
{
	//	create the panel contents...
	csp_create_panel(Y);

	var width = NCW_WIDTH;
	var height = NCW_HEIGHT;

	//	make the panel...
        csp_panel = new Y.Panel({
                		srcNode      : '#client_search_panel',
                		headerContent: 'Client Selection',
                		width        : NCW_WIDTH,
                		height       : NCW_HEIGHT,
                		zIndex       : 10,
                		centered     : true,
                		modal        : true,
                		visible      : false,
                		render       : true,
                		plugins      : [Y.Plugin.Drag]
        		});


	//	make the datatable based on search results
	csp_make_datatable(Y);

	//	add back button...
	csp_panel.addButton({
        			value  : 'Back',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						csp_panel.hide();

						if ( (ACTIVE_WIZARD == 0) || (ACTIVE_WIZARD == 1) )
						{
                                                	if ( cjp_state_type == "3")
								wac_panel_return();
							else if ( ( cjp_state_type == "4" ) &&
								( cjp_state_device == "1") )
								rac_panel_return();	
						}
						else if (ACTIVE_WIZARD == 2)
						{
							consultation_job_orders_return();
						}
        				}});

	//	add next buttons...
	csp_panel.addButton({
        			value  : 'Next',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						
						var test = csp_validate();
						if (test)
						{
							csp_panel.hide();
							if ( ACTIVE_WIZARD == 0 ) // job
								summary_submit_panel_show();
							else if ( ACTIVE_WIZARD == 1 ) // estimate
								summary_submit_panel_show();
							else if ( ACTIVE_WIZARD == 2 ) // consultation
								consultation_job_orders_panel_show();
						}
        				}});


	//	show it...
	csp_panel.show();
}

