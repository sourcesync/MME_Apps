var cjo_panel = null;

//	state...
var cjo_Y = null;
var cjo_datatable = null;
var cjo_state = null;
var cjo_search_results = [];
var cjo_state_clientid = null;
var cjo_state_netid = null;
var cjo_state_name = null;
var cjo_state_dept = null;

//      defs...
var cjo_definition_dct= {
    'VV_CSPPARENT':'',
    'VT_CSPSEARCH':{'default':'Department or Name'}
};

function client_search_panel_return()
{
        common_setglobalstate( cjo_state, null );

        cjo_panel.show();
}

function client_search_panel_show()
{
	cjo_state_dept = null;
	cjo_state_name = null;
	cjo_state_netid = null;

	if (cjo_panel)
	{
		cjo_panel.destroy();
		cjo_panel = null;
	}

	if (cjo_Y)
	{
		cjo_create_and_show(cjo_Y);
		common_setglobalstate( cjo_state, null );
	}
	else
	{
	       YUI( {  filter:'raw', combine:false, gallery: 'gallery-2012.12.19-21-23' })
                	.use(   "io-xdr", "json-parse",
                        	"node",
                        	"datatable-sort",  'cssfonts', "cssbutton",
                        	"datatype", 'gallery-datatable-selection', 'event-custom', 'event-mouseenter',
                        	"panel", "datatable-base", "dd-plugin",
                function(Y)
                {
			cjo_Y = Y;
			cjo_create_and_show(Y);
			common_setglobalstate( cjo_state, null );
		});
	}

}

var client_search_template_html = '\
                <div id="{VV_CSPPARENT}">\
			<div>\
                		<div style="float:left;" >Search Clients:</div>\
				<div style="float:right;top:0px;"><a onclick="cjo_new_client();" href="#">new client</a></div>\
				<div style="clear:both;width:0px;"></div>\
			</div>\
			<div>\
                		<input style="float:left;margin-right:5px;height:28px;" id="{VT_CSPSEARCH}" type="text" size=30 value="{VT_CSPSEARCH_VAL}">\
				<button style="float"left;" type="button" id="client_search_go" class="yui3-button">go</button>\
				<div style="clear:both;width:0px;"></div>\
			</div>\
                </div>\
		<div style="margin-top:20px;">\
			<div style="overflow:auto;" id="cjo_datatable"></div>\
		</div>';

function cjo_new_client()
{
	cjo_panel.hide();
	new_client_panel_show(true);
}


function cjo_create_panel(Y)
{
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="client_search_panel"></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);
        var c = Y.Node.create('<div id="cjo_lhs" style="float:left;" ></div>');
        b.append(c);
        var d = Y.Node.create('<div style="float:left;overflow:auto;" ></div>');
        b.append(d);
        var e = Y.Node.create('<div style="clear:both;width:0px;" ></div>');
        b.append(e);

	//      initialize various state from definition...
        cjo_state = common_instantiate_definition( cjo_definition_dct, "VV_CSPSEARCH", "", null );

        //      create the content area via substitution...
        var str = Y.Lang.sub( client_search_template_html, cjo_state['html'] );
        var el = Y.Node.create( str );
        d.append(el);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

        //      do DOM-related state initialization...
        common_dom_configure( Y, cjo_state );

        //      do some custom config...
        cjo_state['validate']['VT_CSPSEARCH'] = [
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
			var txt = cjo_state['values']['VT_CSPSEARCH'];
			cjo_search( cjo_Y, txt );
		});
}

function cjo_validate()
{
	if ( ! cjo_state_netid )
		return false;
	else
		return true;
}

function cjo_search(Y, txt)
{
        var handleSuccess = function(id, o, a)
        {
        	var resp = Y.JSON.parse(o.responseText);
        	Y.log(resp);
		console.log(resp);

		if ( resp['status'] )
			cjo_search_results = resp['data'];
		else  //TODO: deal with error
			cjo_search_results = [];
		
		cjo_make_datatable(Y);
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
	cjo_Y = Y;	
}

function cjo_make_datatable(Y)
{
	//	create the cols...
	var cols = [
		{'key':'dept', 'label':'Department', sortable:false },
		{'key':'name', 'label':'Name', sortable:false },
		{'key':'netid', 'label':'NetID', sortable:false } ];

        //      make the datatable...
	if ( cjo_datatable != null )
	{
		cjo_datatable.destroy();
		cjo_datatable = null;
	}

	console.log("sr", cjo_search_results );

	//	make the datable...
        cjo_datatable = new Y.DataTable(
		{
                	columns: cols,
                        data:cjo_search_results,
                        summary:"Client Search",
                        width:"100%",

                	highlightMode: 'row',
                	selectionMode: 'row',
                	selectionMulti: false,

			//scrollable: true,
			//height: 200
                }).render("#cjo_datatable");

        cjo_datatable.on("selected",
                function(obj)
                {
                        if (obj.record)
                        {
				cjo_state_clientid = obj.record.get("clientid");
				cjo_state_netid = obj.record.get('netid');
				cjo_state_name = obj.record.get('name');
				cjo_state_dept = obj.record.get('dept');
                        }
                });

}

function cjo_create_and_show(Y)
{
	//	create the panel contents...
	cjo_create_panel(Y);

	var width = NCW_WIDTH;
	var height = NCW_HEIGHT;

	//	make the panel...
        cjo_panel = new Y.Panel({
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
	cjo_make_datatable(Y);

	//	add back button...
	cjo_panel.addButton({
        			value  : 'Back',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						cjo_panel.hide();

						if ( (njw_class == 0 ) || ( njw_class == 1) )
						{
                                                	if ( cjp_state_type == "3")
								wac_panel_return();
							else if ( ( cjp_state_type == "4" ) &&
								( cjp_state_device == "1") )
								rac_panel_return();	
						}
						else if ( njw_class == 2 )
							;	
        				}});

	//	add next buttons...
	cjo_panel.addButton({
        			value  : 'Next',
        			section: Y.WidgetStdMod.FOOTER,
        			action : function (e) {
            					e.preventDefault();
						
						var test = cjo_validate();
						if (test)
						{
							cjo_panel.hide();
							if ( njw_class == 0 ) // job
								summary_submit_panel_show();
							else if ( njw_class == 1 ) // estimate
								summary_submit_panel_show();
							else if ( njw_class == 2 ) // consultation
								consultation_parameters_panel_show();
						}
        				}});


	//	show it...
	cjo_panel.show();
}

