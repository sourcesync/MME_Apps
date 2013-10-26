var CONFIG_BASE_URL = "http://127.0.0.1/";
var CONFIG_BASE_URL_NO_SLASH = "http://127.0.0.1";

var common_panel_active_state = null;
var common_panel_active_validator = null;
var common_panel_error_message = "Please the problem in highlighted section(s) below.";
var common_Y = null;
var common_active_wizard = null;

//
//	events...
//


//	job...
var selected_jobid_event = null;
var common_selected_jobid = null;
var jobs_search_event = null;
var common_job_search = null;
var new_job_event = null;
var jobs_changed_event = null;

//	client...
var selected_clientid_event = null;
var common_selected_clientid = null;
var clients_changed_event = null;
var new_client_event = null;

//	service...
var selected_serviceid_event = null;
var common_selected_serviceid = null;

//	device...
var selected_deviceid_event = null;
var common_selected_deviceid = null;
var devices_changed_event = null;

//	project...
var selected_projid_event = null;
var common_selected_projid = null;
var common_project_search = null;
var projects_search_event = null;
var projects_changed_event = null;
var new_project_event = null;

//	quotes...
var quotes_changed_event = null;

//	consultations...
var consultations_changed_event = null;

//	materials changed...
var materials_changed_event = null;

//	account...
var selected_accountid_event = null;
var common_selected_accountid = null;
var accounts_changed_event = null;

//	teir and paper type...
var selected_tierid_event = null;
var tiers_changed_event = null;
var selected_papertypeid_event = null;
var papertypes_changed_event = null;

//	laser and materials...
var laser_materials_changed_event = null;

//	full view...
var full_view_event = null;
var common_full_view = false;

function yui_initialize( cb )
{
        YUI( {  filter:'raw',
                combine:false
                //gallery: 'gallery-2012.12.19-21-23'
                }).use( "io-xdr", 
			"json-parse", "json-stringify",
			"node", 
			'cssfonts', "cssbutton",
                        "datatype", 
			'event', 'event-custom', 'event-mouseenter','event-resize',"event-key",
			'tabview',
			'panel',
			'datatable-base', 'datatable-sort','gallery-datatable-selection', 
			"datatable-scroll",
			"datatable-message",
			'dd-plugin',
			"event-valuechange",
                        "uploader",
			"button",
			"gallery-base64",
			"datatype-date", 
			"querystring-parse",
			"charts",
	function(Y)
        {
		common_Y = Y;
		common_events_init(Y);
		cb(Y);
	});
}

function common_events_init(Y)
{
	var id = Y.guid();

	full_view_event = common_create_event(Y,"full_view");
	common_subscribe_event( Y, "full_view", id, function(e) 
		{
			common_full_view = e.message;
		});

        //      global selected projid...
        selected_projid_event = common_create_event(Y,"selected_projid");
        common_subscribe_event( Y, "selected_projid", id, function(e)
                {
                        common_selected_projid = e.message;
                });

	//	global selected jobid...
	selected_jobid_event = common_create_event(Y,"selected_jobid");
	common_subscribe_event( Y, "selected_jobid", id, function(e) 
		{
			common_selected_jobid = e.message;
		});
	
	//	global selected clientid...
	selected_clientid_event = common_create_event(Y,"selected_clientid");
	common_subscribe_event( Y, "selected_clientid", id, function(e) 
		{
			common_selected_clientid = e.message;
		});
        
	//      global selected serviceid...
        selected_serviceid_event = common_create_event(Y,"selected_serviceid");
        common_subscribe_event( Y, "selected_serviceid", id, function(e)
                {
                        common_selected_serviceid = e.message;
                });

	//
	//	devices...
	//

        //      global selected deviceid...
        selected_deviceid_event = common_create_event(Y,"selected_deviceid");
        common_subscribe_event( Y, "selected_deviceid", id, function(e)
                {
                        common_selected_serviceid = e.message[0];
                        common_selected_deviceid = e.message[1];
                });
	// devices changed...
	devices_changed_event = common_create_event(Y,"devices_changed");


	//      global projects changed...
        projects_changed_event = common_create_event(Y,"projects_changed");

	//      global quotes changed...
        quotes_changed_event = common_create_event(Y,"quotes_changed");
	
	//      global consultations changed...
        consultations_changed_event = common_create_event(Y,"consultations_changed");
	
	//      global jobs changed...
        jobs_changed_event = common_create_event(Y,"jobs_changed");
	
	//      global materials changed...
        materials_changed_event = common_create_event(Y,"materials_changed");
	
	//      global new jobs...
        new_job_event = common_create_event(Y,"new_job");
	
	//      global new projects...
        new_project_event = common_create_event(Y,"new_project");
	
	//      global jobs search...
        jobs_search_event = common_create_event(Y,"jobs_search");
	common_subscribe_event( Y, "jobs_search", id, function(e) 
		{
			common_job_search = e.message;
		});

 	projects_search_event = common_create_event(Y,"projects_search");
        common_subscribe_event( Y, "projects_search", id, function(e)
                {
                        common_project_search = e.message;
                });

	//      global clients changed...
        clients_changed_event = common_create_event(Y,"clients_changed");
	
	//      global new client...
        new_client_event = common_create_event(Y,"new_client");
	

	//	global selected accountid...
	selected_accountid_event = common_create_event(Y,"selected_accountid");
	common_subscribe_event( Y, "selected_accountid", id, function(e) 
		{
			common_selected_accountid = e.message;
		});

	//      global accounts changed...
        accounts_changed_event = common_create_event(Y,"accounts_changed");
        common_subscribe_event( Y, "accounts_changed", id, function(e)
                {
                });
	
	//	global selected tierid...
	selected_tierid_event = common_create_event(Y,"selected_tierid");
	common_subscribe_event( Y, "selected_tierid", id, function(e) 
		{
			//common_selected_accountid = e.message;
		});
	
	//	global selected papertypeid...
	selected_papertypeid_event = common_create_event(Y,"selected_papertypeid");
	common_subscribe_event( Y, "selected_papertypeid", id, function(e) 
		{
			//common_selected_accountid = e.message;
		});

        //      global tiers changed...
        tiers_changed_event = common_create_event(Y,"tiers_changed");
        
	//      global papertypes changed...
        papertypes_changed_event = common_create_event(Y,"papertypes_changed");
        
	//      global laser materials changed...
        laser_materials_changed_event = common_create_event(Y,"laser_materials_changed");
}

function common_create_event(Y,name)
{
        function Character()
        {
                this.publish(name, { broadcast: 2 });
        }
        Y.augment(Character, Y.EventTarget, true, null,
        {
                emitFacade: true
        });
        var murdock = new Character();
	return murdock;
}

function common_subscribe_event(Y,name,id,handler)
{
        Y.Global.on(name,
                function (e)
                {
                        if (e.origin !== id)
                        {
				handler(e);
                        };
                });
}

function common_notify_selected_projid(id, projid)
{
	common_selected_projid = projid;
	selected_projid_event.fire("selected_projid", {
                                        message: projid,
                                        origin: id } );
}

function common_notify_selected_jobid(id, jobid)
{
	common_selected_jobid = jobid;
	selected_jobid_event.fire("selected_jobid", {
                                        message: jobid,
                                        origin: id } );
}

function common_notify_selected_clientid(id, clientid)
{
        common_selected_clientid = clientid;
        selected_clientid_event.fire("selected_clientid", {
                                        message: clientid,
                                        origin: id } );
}


function common_notify_selected_serviceid(id, serviceid )
{
        common_selected_serviceid = serviceid;
        selected_serviceid_event.fire("selected_serviceid", {
                                        message: serviceid ,
                                        origin: id } );
}

function common_notify_selected_deviceid(id, serviceid,  deviceid)
{
        common_selected_serviceid = serviceid;
        common_selected_deviceid = deviceid;
        selected_deviceid_event.fire("selected_deviceid", {
                                        message: [ serviceid, deviceid ],
                                        origin: id } );
}

function common_notify_quotes_changed(id,jobid)
{
        quotes_changed_event.fire("quotes_changed", {
                                        message: jobid,
                                        origin: id } );
}



function common_notify_new_project(id,projid)
{
        new_project_event.fire("new_project", {
                                        message: projid,
                                        origin: id } );
}

function common_notify_projects_changed(id, projid)
{
        projects_changed_event.fire("projects_changed", {
					message: projid,
                                        origin: id } );
}


function common_notify_projects_search(id,txt)
{
        projects_search_event.fire("projects_search", {
                                        message: txt,
                                        origin: id } );
}

function common_notify_consultations_changed(id,jobid)
{
        consultations_changed_event.fire("consultations_changed", {
                                        message: jobid,
                                        origin: id } );
}



function common_notify_materials_changed(id,mid)
{
        materials_changed_event.fire("materials_changed", {
                                        message: mid,
                                        origin: id } );
}

function common_notify_jobs_search(id,txt)
{
        jobs_search_event.fire("jobs_search", {
                                        message: txt,
                                        origin: id } );
}

function common_notify_jobs_changed(id,jobid)
{
        jobs_changed_event.fire("jobs_changed", {
                                        message: jobid,
                                        origin: id } );
}


function common_notify_devices_changed(id,deviceid)
{
        devices_changed_event.fire("devices_changed", {
                                        message: deviceid,
                                        origin: id } );
}

function common_notify_new_job(id,jobid)
{
        new_job_event.fire("new_job", {
                                        message: jobid,
                                        origin: id } );
}

function common_notify_clients_changed(id,clientid)
{
        clients_changed_event.fire("clients_changed", {
                                        message: clientid,
                                        origin: id } );
}

function common_notify_new_client(id,clientid)
{
        new_client_event.fire("new_client", {
                                        message: clientid,
                                        origin: id } );
}


function common_notify_selected_accountid(id, accountid)
{
	common_selected_accountid = accountid;
	selected_accountid_event.fire("selected_accountid", {
                                        message: accountid,
                                        origin: id } );
}

function common_notify_accounts_changed(id,jobid)
{
        accounts_changed_event.fire("accounts_changed", {
                                        message: jobid,
                                        origin: id } );
}

function common_notify_selected_tierid(id, tierid)
{
        //common_selected_tierid = tierid;
        selected_tierid_event.fire("selected_tierid", {
                                        message: tierid,
                                        origin: id } );
}

function common_notify_selected_papertypeid(id, ptid)
{
        //common_selected_papertypeid = ptid;
        selected_papertypeid_event.fire("selected_papertypeid", {
                                        message: ptid,
                                        origin: id } );
}


function common_notify_tiers_changed(id,tid)
{
        tiers_changed_event.fire("tiers_changed", {
                                        message: tid,
                                        origin: id } );
}

function common_notify_papertypes_changed(id,ptid)
{
        papertypes_changed_event.fire("papertypes_changed", {
                                        message: ptid,
                                        origin: id } );
}

function common_notify_laser_materials_changed(id,lmid)
{
        laser_materials_changed_event.fire("laser_materials_changed", {
                                        message: lmid,
                                        origin: id } );
}


function common_setglobalstate( state, validator )
{
	common_panel_active_state = state;
	common_panel_active_validator = validator;
}

function common_el_set( state, elid, val, dontinvoke )
{
	var el = Y.Node('#' + elid );
	if ( elid.substring(0,2) == 'VT' )
	{
		el.set("value",val);
		state['values'][elid] = val;

		var handler = state['handler'];
		if (handler && !dontinvoke) handler( elid, val );
	}	
	else if ( elid.substring(0,2) == 'VD' )
	{
		el.set("selectedIndex",val);
		state['values'][elid] = val + "";
		
		var handler = state['handler'];
		if (handler  && !dontinvoke) handler( elid, val + "" );
	}
	else if ( elid.substring(0,2) == 'VI' )
        {
                el.set("innerHTML",val);
                state['values'][elid] = val + "";

                var handler = state['handler'];
                if (handler  && !dontinvoke) handler( elid, val + "" );
        }	
}

function common_invoke_test( state )
{
        for (var prop in state['values'] ) // enumerate all properties...
        {
		var testval = state['test'][prop];
		if (testval) common_el_set( state, prop, testval );
	}
}

function common_validate( state )
{
        for (var prop in state['values'] ) // enumerate all properties...
        {
                if ( ! common_validate_one( prop, state) )
                {
                        common_setglobalstate( state, prop );
                        return false;
                }
        }

        //      got here, all tests passed...
        common_setglobalstate( state, null );

        return true;
}

function common_validate_one( prop, state )
{
	common_panel_active_state = state;

	// get optional...
	var vopt = state['optional'][prop];
	if (vopt) return true;
      
	// if not optional but disabled...
	var vdis = state['disabled'][prop];
	if (vdis) return true;
 
	// get the node... 
	var obj = state['node'][prop];

	//
	// perform internal validation as needed...
	//
	var dfunc = state['dvalidate'][prop];
	if ( dfunc && !dfunc( obj, prop ) )
	{
		// internal validation failed...
		
		// possibly call err message func...
                var errv = state['err'][prop];
                if (errv==undefined) errv= 'A field is invalid.';
                var errfunc = state['errmsg_func'];
                if ( errfunc!=undefined  ) errfunc(errv);
                return false;
	}

	//
	// perform custom validation if set...
	//
        if (state['validate'][prop])
	{
        	var tfunc = state['validate'][prop][0];
        	if ( tfunc && !tfunc(obj,prop) )
        	{
			// possibly call err message func...
			var errv = state['err'][prop];
			if (errv==undefined) errv= 'A field is invalid.';
			var errfunc = state['errmsg_func'];
			if ( errfunc!=undefined  ) errfunc(errv);
                	return false;
		}
        }

	//
	// got here, clear the global error msg...
	//
	var errfunc = state['errmsg_func'];
        if ( errfunc!=undefined ) errfunc(null);
        return true;
}

function _vd_check_notfirst(el, elid)
{
	var val = el.get("value");
	if (val=="0") return false;
	else return true;
}
	

function _vt_check_nonempty(el, elid)
{
	var val = el.get("value");
	if ( val==null || val=="" ) return false
	else return true;
}	

function _vt_check_float(el, elid)
{
	var val = el.get("value");
	val = parseFloat(val);
	if (isNaN(val)) return false;
	else return true;
}	

function _vt_check_int(el, elid)
{
	var val = el.get("value");
	val = parseInt(val);
	if (isNaN(val)) return false;
	else return true;
}	

function common_dom_configure(Y, state, handler, use_part)
{
	var disabled_dct = state['disabled'];
	var values_dct = state['values'];
	var validate_dct = state['validate'];
	var dvalidate_dct = state['validate'];
        var node_dct = state['node'];
	var partno_dct = state['partno'];
	var jobid = state['jobid'];
	var default_dct = state['default'];
	var check_dct = state['check'];
	var dep_dct = state['dep'];

	state['handler'] = handler;

	for ( var elid in values_dct )
        {
		//	possibly only process 1 item in the array...
		if (use_part && ( parseInt(partno_dct[elid]) != use_part )) continue;

		//	get the node...
		var node = Y.one('#' + elid );
		if ( !node ) alert("ERROR: invalid node for elid in def->" + elid);
		node_dct[elid] = node;

		//	get type of node based on prefix...		
		var tp = elid.substring(0,2);

		if ( tp == "VF" ) // special file uploader...
		{
			var partno = partno_dct[elid];
			var obj = file_manager_init( Y, elid, jobid, partno, function(uploader,prefix,status)
				{
					//	get the name of the file...
					var flist = uploader.get("fileList");
					if (flist && (flist.length==1))
					{
						var f = flist[0];
						var fname = f.get("name");
						if (status['status']) 
						{
							var data = status['data'];
							var dt = { 	'name': fname, 'fileid': data['fileid'], 
									'thumb': data['url'], 'x': data['width'], 
									'y': data['height'], 'asset': data['asset'] };
							common_panel_active_state['values'][prefix] = dt;
						}
						else 
						{
							common_panel_active_state['values'][prefix] = null;
						}

						var handler = common_panel_active_state['handler'];
						if (handler) handler( prefix, status );
					}
					else
					{
						common_panel_active_state['values'][prefix] = null;
						var handler = common_panel_active_state['handler'];
						if (handler) handler( prefix, status );
					}
				});
			node_dct[elid] = obj;
		}
                //      is it drop down?...
                else if ( tp == "VD" )
                {
			// init value...
			values_dct[elid] = "0";

                	node.on('change',
                                function(e)
                                {
					//	get/store the value...
					var elid = this.get("id");
					var val = this.get("value");
					common_panel_active_state['values'][elid] = val;
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );

					var handler = common_panel_active_state['handler'];
					if (handler) handler( elid, val );
                                });
		}
		else if ( tp == "VC" ) // a checkbox
		{
			//      possible set disabled from init state...
                        var disv = disabled_dct[elid];
                        if (disv==true) node.set("disabled","disabled");

			//  possibly deal with deps..
			if (dep_dct[elid])
			{
			var partno = partno_dct[elid];
                        for (var v=0;v<dep_dct[elid].length;v++)
                        {
                        	var depid = dep_dct[elid][v];
                                if ( disv )
                                {
                                	disabled_dct[depid] = true; 
                                        Y.Node('#' + depid).set("disabled","disabled");
                                }
                                else
                                {
                                        disabled_dct['disabled'][depid] = false;
                                        Y.Node('#' + depid).set("disabled","");
                                }
                        }
			}

                	node.on('change',
                                function(e)
                                {
					// get/store the value...
					var elid = this.get("id");
					var val = this.get("checked");
					common_panel_active_state['values'][elid] = val;

					// deal with any dependencies...
					if (dep_dct[elid]) 
					{
						var partno = common_panel_active_state['partno'][elid];
						for (var v=0;v<dep_dct[elid].length;v++)
						{
							var depid = dep_dct[elid][v];
							if ( val )
							{
								common_panel_active_state['disabled'][depid] = false;
								Y.Node('#' + depid).set("disabled","");
							}
							else
							{
								common_panel_active_state['disabled'][depid] = true;
								Y.Node('#' + depid).set("disabled","disabled");
							}
						}
					}

					// invoke custom handler if any...
					var handler = common_panel_active_state['handler'];
					if (handler) handler( elid, val );
                                });
		}
		else if ( tp == "VV" )
		{

		}
		else if ( tp == "VT" ) // a text box
		{
			// possible set disabled from init state...
			var disv = disabled_dct[elid];
			if (disv==true) node.set("disabled","disabled");

			// possibly set default...
			var defv = default_dct[elid];
			if (defv) node.set("placeholder",defv);				
			
			// init stashed value from policy or dom...
			if ( check_dct[elid] == 'int') values_dct[elid] = isNaN;
			else if ( check_dct[elid] == 'float') values_dct[elid] = isNaN;
			else values_dct[elid] = node.get("value");
			
			// dep on vc ? - set disabled based on vc initval or disabled by default...
			if ( dep_dct[elid] ) 
				node.set("disabled","disabled");
	
			node.on('keyup',
                                function(e)
                                {
					// get/store the value...
                                        var elid = this.get("id");
                                        var val = this.get("value");

					// possible conversion...
					var vcheck = common_panel_active_state['check'][elid];
					if (vcheck=='float') val = parseFloat(val);
                                	else if (vcheck=='int') val = parseInt(val);

					// stash it...
                                        common_panel_active_state['values'][elid] = val;
					
					// possibly deal with validation...
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );

					// invoke custom handler, if any...
					var handler = common_panel_active_state['handler'];
					if (handler) handler( elid, val );
                                });
		}
	}
}


function common_idx(arr,item)
{
        for (var i=0;i<arr.length;i++)
                if ( arr[i] == item ) return i;
        return -1;
}

function common_set_val( state, elid, val )
{
	var prefix = elid.substring(0,2);
	if (prefix=="VT")
	{
		var el = Y.Node('#' + elid);
		el.set("value", val );
		state['values'][elid] = val;
	}
	else if (prefix=='VD')
	{
		var el = Y.Node('#' + elid);
		var options = el.get("options");
		for ( var i=0;i< options._nodes.length;i++)
		{
			if (options._nodes[i]['innerHTML'] == val )
			{
				el.set("selectedIndex", i );
				var oval = options._nodes[i]['value'];
				state['values'][elid] = oval;
				break;
			}
		}
	}
	else
	{
		alert("ERROR: Unknown element type", elid);
	}
}

function common_instantiate_definition(definition_dct, parentName, idx, state)
{
	if (state==null)
		state = { 	'html':{}, 	'values':{}, 
				'default':{}, 	'validate':{}, 
				'node':{}, 	'parent':{}, 
				'partno':{}, 	'check':{} , 
				'disabled':{}, 	'dvalidate':{}, 
				'err':{}, 	'optional':{},
				'test':{} ,	'dep':{} };
	
	state['html'] = {};	//always a fresh subst gets generated...

	//	get refs to state dcts...
	html_subst  	= state['html'];
	values_dct 	= state['values'];
	default_dct 	= state['default'];
	node_dct 	= state['node'];
	parent_dct 	= state['parent'];
	partno_dct 	= state['partno'];
	disabled_dct 	= state['disabled'];
	validate_dct 	= state['validate'];
	dvalidate_dct 	= state['dvalidate'];
	err_dct		= state['err'];
	optional_dct	= state['optional'];
	test_dct 	= state['test'];
	check_dct	= state['check'];
	dep_dct		= state['dep'];

	for ( var prop in definition_dct )
	{
		// create id subst...
		val = prop+idx;
		html_subst[prop] = val;

		// initialize partno_dct here...
		partno_dct[val] = idx;

		// initialize values_dct here...
		values_dct[val] = null;

		// init test if set...
		if ( definition_dct[prop]['test'] ) test_dct[val] = definition_dct[prop]['test'];

		// create default val subst...
		if (definition_dct[prop]!=null)
		{
			// set err if any...
			var verr = definition_dct[prop]['err'];
			if (verr!=undefined) err_dct[val] = verr;

			// get optional...
			var vopt = definition_dct[prop]['optional'];
			if (vopt==undefined) vopt = false;
			optional_dct[val] = vopt;

			// get check...
			var vcheck = definition_dct[prop]['check'];
			check_dct[val] = vcheck;

			// element type...
			var tp = prop.substring(0,2);

			//  is it drop down?...
			if ( tp == "VD" )
			{
				// create the html substitution...
				str = "";
				for (var i=0;i<definition_dct[prop]['options'].length;i++)
				{
					item = definition_dct[prop]['options'][i];
					str += '<option style="height:20px;" value="' + i + '">' + item + '</option>';
				}
				vprop = prop+"_VAL";
				html_subst[vprop] = str;
				
				// create a parent entry...
				parent_dct[val] = parentName + idx;

				// create a dvalidate entry...
				dvalidate_dct[val] = null;
                                if (vopt) dvalidate_dct[val] = function(el,elid) { return true; };
                                else if (vcheck=="notfirst") dvalidate_dct[val] = _vd_check_notfirst;
			}
			else if ( tp == "VT" ) // numeric entry text box...
			{
				// set the init...
				vprop = prop+"_VAL";
				vval = definition_dct[prop]['init'];
				if (vval==undefined) html_subst[vprop] = "";
				else html_subst[vprop] = vval;

				// set the default val for this el...
				var defv =  definition_dct[prop]['default'];
				if (defv!=undefined) default_dct[val] = defv;

				// set the disabled val for this el...
				disabled_dct[val] = definition_dct[prop]['disabled'];

				// create a parent entry...
				parent_dct[val] = parentName + idx;

	                        // dep entry...
                                dep_dct[val] = definition_dct[prop]['dep'] + idx;

				// create a dvalidate entry...
				dvalidate_dct[val] = null;
				if (vopt) dvalidate_dct[val] = function(el,elid) { return true; };
				else if (vcheck=='nonempty') dvalidate_dct[val] = _vt_check_nonempty;
				else if (vcheck=='float') dvalidate_dct[val] = _vt_check_float;
				else if (vcheck=='int') dvalidate_dct[val] = _vt_check_int;

			}
			else if ( tp == "VC" ) // checkbox box...
                        {
                                // set the substitution for this el...
                                vprop = prop+"_VAL";
                                vval = definition_dct[prop]['default'];
                                html_subst[vprop] = vval;

                                // set the default val for this el...
                                default_dct[val] = vval;

				// initialize state...
				if ( vval == "checked" ) values_dct[val] = true;
				else values_dct[val] = false;

                                // set the disabled val for this el...
                                disabled_dct[val] = definition_dct[prop]['disabled'];

                                // create a parent entry...
                                parent_dct[val] = parentName + idx;

				// dep entry...
				if (definition_dct[prop]['dep'])
				{	
					var items = [];
                                	for (var a=0;a<definition_dct[prop]['dep'].length;a++)
						items.push( definition_dct[prop]['dep'][a] + idx );	
					dep_dct[val] = items;
				}	
				
				// create a dvalidate entry...
                                dvalidate_dct[val] = null;
                        }
			else if ( tp == "VV" ) // parent div...
			{	
				// create substitution entry...
				vprop = prop+"_VAL";
				vval = definition_dct[prop];
				html_subst[vprop] = vval;
			
				// create a dvalidate entry...	
				dvalidate_dct[val] = null;
			}
			else if ( tp == "VI" )
			{
				vprop = prop+"_VAL";
				vval = definition_dct[prop]['default'];
				html_subst[vprop] = vval;
		
				// create a dvalidate entry...
                                dvalidate_dct[val] = null;
			}
			else // everything else...
			{	
				// create subst entry...
				vprop = prop+"_VAL";
				vval = definition_dct[prop];
				html_subst[vprop] = vval;

				// create a parent entry...
                                parent_dct[val] = parentName + idx;

                                // create a dvalidate entry...
                                dvalidate_dct[val] = null;
			}
		}
	}
	return state;
}


function common_config_paginator( name, paging, base_url, gen_onclick )
{
	var el = Y.Node("#"+name);
	
	//	get paging info...
	var total_pages = paging["total_pages"];
	var page_no = paging['page_no'];

	//
	//	we show in blocks of 10 (max)...
	//
	
	//	figure out which block...
	var start = (Math.floor(page_no/10))*10+1;
	var end = start + 9;
	
	html = "";
	
	//	add prev button...
	if (base_url)
	{
		var url = (start-1>0)?( base_url + "?page_no=" + (start-1) ) : ( base_url + "?page_no=1" );
		html += '<li><a class="pure-button prev" href="' + url + '">&#171;</a></li>';
	}
	else
	{
		var idx = (start-1>0)?( start-1 ) :  1;
		var onclick = gen_onclick(idx);
                html += '<li><a class="pure-button prev" onclick="' + onclick + '" href="#">&#171;</a></li>';	
	}

	var last = start;
	for ( var i= start;(i<=end && i<=total_pages);i++)
	{
		if ( i != page_no )
		{	
			if (base_url)
			{
				url = base_url + "?page_no=" + i;
        			html += '<li><a class="pure-button" href="' + url + '">' + i + '</a></li>';
			}
			else
			{
                		var onclick = gen_onclick(i);
                		html += '<li><a class="pure-button " onclick="' + onclick + '" href="#">' + i + '</a></li>';	
			}
		}
       		else 
		{
			if (base_url)
			{
				url = base_url + "?page_no=" + i;
				html += '<li><a class="pure-button pure-button-selected" href="' + url + '">' + i + '</a></li>';
			}
			else
			{
                		var onclick = gen_onclick(i);
                		html += '<li><a class="pure-button pure-button-selected" onclick="' + onclick + '" href="#">' + i + '</a></li>';	
			}
		}

		last = i;
	}

	if ( base_url )
	{
		//	add next button...	
		url = (last+1<=total_pages) ? ( base_url + "?page_no=" + (last + 1) ) : ( base_url + "?page_no=" + last );
		html += '<li><a class="pure-button next" href="' + url + '">&#187;</a></li>';
	}
	else
	{
		var idx = (last+1<=total_pages) ? ( last + 1 ) :  last ;
                var onclick = gen_onclick(idx);
                html += '<li><a class="pure-button next" onclick="' + onclick + '" href="#">&#187;</a></li>';
	}

	el.set("innerHTML", html );
}	
