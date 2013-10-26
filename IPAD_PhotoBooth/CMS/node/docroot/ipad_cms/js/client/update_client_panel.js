var ucp_Y = null;
var ucp_panel = null;
var ucp_state = null;
var ucp_wizard = null;
var ucp_event_id = null;
var ucp_clientid = null;
var ucp_fn = null;
var ucp_ln = null;
var ucp_name = null;
var ucp_netid = null;
var ucp_dept = null;
var ucp_ustatus = null;
var ucp_ph = null;
var ucp_aph = null;
var ucp_em = null;
var ucp_aem = null;
var ucp_data = null;
var ucp_lasterr = null;
var ucp_created = null;
var ucp_accounts = null;

//	TODO: this should all be server side...
var ucp_depts_arr = ['Gallatin','Steinhardt','ITP','P&I','Design','CS','Physics','Poly','Stern','GSAS','NYU C','S'];
var ucp_ustatus_arr = [ 'undergraduate','graduate','faculty','alumni','other' ];

//      defs...
var ucp_definition_dct= {
    'VV_UCP_PARENT':'',
    'VD_UCP_DEPT': {'options':['Choose...','Gallatin','Steinhardt','ITP','P&I','Design','CS','Physics','Poly','Stern','GSAS','NYU C','S'], 
				'err':'Please choose the department.'},
    'VD_UCP_UNIV': {'options':['Choose...','undergraduate','graduate','faculty','alumni','other'],
				'err':'Please choose a university status.'},
    'VT_UCP_FN'	: {'default':'First Name', 'err':'First Name is not valid.', 'disabled':true},
    'VT_UCP_LN': {'default':'Last Name','err':'Last Name is not valid.','disabled':true},
    'VT_UCP_NETID': {'default':'NetID','err':'NetID is not valid.','disabled':true},
    'VT_UCP_EM': {'default':'Email','err':'Email is not valid.'},
    'VT_UCP_AEM': {'default':'Alternate Email','err':'Alt Email is not valid.','optional':true},
    'VT_UCP_PH': {'default':'Phone','err':'Phone Number is not valid.'},
    'VT_UCP_APH': {'default':'Alternate Phone','err':'Alt Phone is not valid.','optional':true}
};

function update_client_panel_show(clientid)
{
	ucp_clientid = clientid;
	if (ucp_panel)
	{
		ucp_panel.destroy();
		ucp_panel = null;
	}

	ucp_create_panel( ucp_Y )

	ucp_panel.show();

	common_setglobalstate( ucp_state, null );
	
	// init values from server...
	ucp_refresh();
}

function ucp_refresh()
{
        var cb_success = function( status )
                {
                        ucp_data = null;
                        if ( status && status['status'] ) ucp_data = status;
                        ucp_show( );
                };

        var obj = comm_get_sync( "clients",
                { 'get':'true', 'clientid':ucp_clientid },
                cb_success, null );
	
}

function ucp_submit()
{
        //      get date now...
        var dt = new Date();
        dt = dt.getTime();

        //      prepare the new client object...
        var obj = { 'name':ucp_name, 'fn':ucp_fn, 'ln':ucp_ln,
                'netid': ucp_netid, 'dept': ucp_dept, 'us': ucp_ustatus,
                'ph': ucp_ph, 'aph': ucp_aph,
                'em': ucp_em, 'aem': ucp_aem,
                'updated': dt,
		'created': ucp_created,
                'accounts': ucp_accounts };

        //      callbacks...
        var cb_success = function(a)
        {
                if (a && a['status'])
                {
                        // notify for the listview...
                        common_notify_clients_changed( ucp_event_id, ucp_clientid );

                        // notify for the summary tabs...
                        common_notify_selected_clientid( ucp_event_id, ucp_clientid );
                }
                else
                {
                        alert('ERROR: update failed.');
                }
        };
        var cb_fail = function(a) { alert('ERROR: new client wizard add failed.'); };

        //      make the post call...
        comm_post_sync( "uploads", { "client":"update" ,'clientid':ucp_clientid }, obj, cb_success, cb_fail );

        return true;
}

function ucp_idx(arr,item)
{
	for (var i=0;i<arr.length;i++)
		if ( arr[i] == item ) return i;
	return -1;
}	

function ucp_show()
{
	if (ucp_data)
	{
		var obj = ucp_data['overview'];
		ucp_fn = obj['fn'];
		ucp_ln = obj['ln'];
		ucp_netid = obj['netid'];
		ucp_dept = obj['dept'];
		//ucp_dept_idx = ucp_idx(ucp_depts_arr, ucp_dept) + 1; // take into acct 'choose...'
		ucp_ustatus = obj['us'];
		//ucp_ustatus_idx = ucp_idx(ucp_ustatus_arr, ucp_ustatus) + 1;
		ucp_ph = obj['ph'];
		ucp_aph = obj['aph'];
		ucp_em = obj['em'];
		ucp_aem = obj['aem'];
		ucp_created = obj['created'];
		ucp_accounts = obj['accounts'];

	        common_set_val( ucp_state, 'VT_UCP_FN', ucp_fn);
        	common_set_val( ucp_state, 'VT_UCP_LN', ucp_ln );
        	common_set_val( ucp_state, 'VT_UCP_NETID', ucp_netid );
        	common_set_val( ucp_state, 'VD_UCP_DEPT', ucp_dept );
        	common_set_val( ucp_state, 'VD_UCP_UNIV', ucp_ustatus );
	        common_set_val( ucp_state, 'VT_UCP_PH', ucp_ph);
	        common_set_val( ucp_state, 'VT_UCP_APH', ucp_aph);
	        common_set_val( ucp_state, 'VT_UCP_EM', ucp_em);
	        common_set_val( ucp_state, 'VT_UCP_AEM', ucp_aem);
	}
	else
	{
	}
}

function ucp_validate()
{
        for (var prop in ucp_state['validate'] )
        {
                if ( ! common_validate_one( prop, ucp_state) )
                {
                        common_panel_active_validator = prop;
                        return false;
                }
        }

        //      got here, all tests passed...
        common_panel_active_validator = null;
        return true;
}

function ucp_create_panel(Y)
{
	 var html = '<div id="update_client_panel">' +
                        '<div class="yui3-widget-bd">' +
                                '<div id="ucp_lhs" style="float:left;" ></div>' +
                                '<div style="float:left;">' +
                                        '<div id="ucp_parent" ></div>' +
                                '</div>' +
                                '<div style="clear:both;width:0px;" ></div>' +
                        '</div>' +
                    '</div>';

        //      add to body...
        var el = Y.Node.create(html);
        var bodyNode = Y.one(document.body);
        bodyNode.append( el );

	//	create the main panel...
	html = 	'<div class="yui3-skin-mine" >\
			<div id="{VV_UCP_PARENT}">\
				<div style="margin-top:10px;" >Update Client Information:</div>\
				<div style="margin-top:10px;margin-left:10px;">\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">First Name:</div>\
					<input type="text" style="width:200px;float:left;" id="{VT_UCP_FN}" value="{VT_UCP_FN_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Last Name:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_LN}" value="{VT_UCP_LN_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">NetID:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_NETID}" value="{VT_UCP_NETID_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Department:</div>\
					<select style="float:left;width:200px;" id="{VD_UCP_DEPT}" >{VD_UCP_DEPT_VAL}</select>\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">University Status:</div>\
					<select style="float:left;width:200px;" id="{VD_UCP_UNIV}" >{VD_UCP_UNIV_VAL}</select>\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Email:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_EM}" value="{VT_UCP_EM_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Alt Email:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_AEM}" value="{VT_UCP_AEM_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Phone Number:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_PH}" value="{VT_UCP_PH_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
				<div style="margin-top:5px;" >\
					<div style="float:left;width:150px;">Alt Phone Number:</div>\
					<input type="text" style="float:left;width:200px;" id="{VT_UCP_APH}" value="{VT_UCP_APH_VAL}">\
					<div style="clear:both;width:0px;"></div>\
				</div>\
			</div>\
		</div>';


        //      initialize various state from definition...
        ucp_state = common_instantiate_definition( ucp_definition_dct, "VV_UCP_PARENT", "", null );

        //      create the content area via substitution...
        var str = Y.Lang.sub( html, ucp_state['html'] );
        var el = Y.Node.create( str );

        //      add to body...
        var parent = Y.one('#ucp_parent');
        parent.append( el );

        //      do DOM-related state initialization...
        common_dom_configure( Y, ucp_state, function( el, st )
                {
                });

                //      make the panel...
                ucp_panel = new Y.Panel({
                        srcNode      : '#update_client_panel',
                        headerContent: 'Edit Client',
                        width        : CLW_WIDTH,
			height		: CLW_HEIGHT,
                        zIndex       : 10,
                        centered     : true,
                        modal        : true,
                        visible      : false,
                        render       : true,
                        plugins      : [Y.Plugin.Drag]
                });

		ucp_panel.addButton({
                        value  : 'Cancel',
                        enabled: false,
                        visible: false,
                        section: Y.WidgetStdMod.FOOTER,
                        action : function (e) {
                                        e.preventDefault();
                                        ucp_panel.hide();
                                }});

                ucp_panel.addButton({
                        value  : 'Submit',
                        enabled: false,
                        visible: false,
                        section: Y.WidgetStdMod.FOOTER,
                        action : function (e) {
                                        e.preventDefault();
					var test = ucp_validate();
					if (test)
					{
						ucp_fn = ucp_state['values']['VT_UCP_FN'];
                                                ucp_ln = ucp_state['values']['VT_UCP_LN'];
                                                ucp_name = ucp_fn + " " + ucp_ln;
                                                ucp_netid = ucp_state['values']['VT_UCP_NETID'];

                                                var dept = parseInt( ucp_state['values']['VD_UCP_DEPT'] );
						ucp_dept = ucp_definition_dct['VD_UCP_DEPT']['options'][dept];

                                                var ustatus = parseInt( ucp_state['values']['VD_UCP_UNIV'] );
                                                ucp_ustatus = ucp_definition_dct['VD_UCP_UNIV']['options'][ustatus];

                                                ucp_ph = ucp_state['values']['VT_UCP_PH'];
                                                ucp_aph = ucp_state['values']['VT_UCP_APH'];
                                                ucp_em = ucp_state['values']['VT_UCP_EM'];
                                                ucp_aem = ucp_state['values']['VT_UCP_AEM'];

						if ( ucp_submit() )
							ucp_panel.hide();
						else
							alert("ERROR: There was a problem updating the client.");
					}
					else
					{
						if (ucp_lasterr) alert(ucp_lasterr);
						else alert('A field is invalid.');
					}
                                }});

	//	post dom config...
	for ( var prop in ucp_state['node'] )
	{
		if ( prop.substring(0,2)=="VT")
		{
			//      do some custom config...
        		ucp_state['validate'][prop] = [
                                       function(obj)
                                        {
                                                var vl = obj.get("value");
                                                if ( (vl==null) || (vl=="") )
                                                        return false;
                                                else
                                                        return true;
                                        },
                                        'VV_UCP_PARENT' ];
		}
		else if ( prop.substring(0,2)=="VD")
		{
			//      do some custom config...
        		ucp_state['validate'][prop] = [
                                       function(obj)
                                        {
                                                var vl = obj.get("value");
                                                if ( (vl==null) || (vl=="") || (vl=="0") )
                                                        return false;
                                                else
                                                        return true;
                                        },
                                        'VV_UCP_PARENT' ];
		}
	
	}

	// err message func...
	ucp_state['errmsg_func'] = function(msg) { 
		ucp_lasterr = msg;
	};

}

function update_client_panel_init(Y)
{
	if (Y)
	{
		ucp_init(Y);
	}
}


function ucp_init(Y)
{	
	//	stash ref to sandbox...
	ucp_Y = Y; 

	ucp_event_id = Y.guid();
}

