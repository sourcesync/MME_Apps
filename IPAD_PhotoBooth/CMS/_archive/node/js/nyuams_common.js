
var CONFIG_BASE_URL = "http://127.0.0.1/";

var common_panel_active_state = null;
var common_panel_active_validator = null;
var common_panel_error_message = "Please the problem in highlighted section(s) below.";

//
//	events...
//

//	selected_jobid...
var selected_jobid_event = null;
var common_selected_jobid = null;

//	selected_clientid...
var selected_clientid_event = null;
var common_selected_clientid = null;

//	selected serviceuid...
var selected_serviceuid_event = null;
var common_selected_serviceuid = null;

//	selected_deviceuid...
var selected_deviceuid_event = null;
var common_selected_deviceuid = null;

//	quotes_changed...
var quotes_changed_event = null;

//	quotes_changed...
var consultations_changed_event = null;

//	jobs changed...
var jobs_changed_event = null;

//	materials changed...
var materials_changed_event = null;

//	new jobs...
var new_job_event = null;

//	jobs search...
var jobs_search_event = null;
var common_job_search = null;

//	clients changed...
var clients_changed_event = null;

//	new client...
var new_client_event = null;

//	selected account id...
var selected_accountid_event = null;
var common_selected_accountid = null;

//	tier and papertype...
var selected_tierid_event = null;
var tiers_changed_event = null;
var selected_papertypeid_event = null;

//	laser and materials...
var laser_materials_changed_event = null;

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
		common_events_init(Y);
		cb(Y);

	});
}

function common_events_init(Y)
{
	var id = Y.guid();

	//	global selected jobid...
	selected_jobid_event = common_create_event(Y,"selected_jobid");
	common_subscribe_event( Y, "selected_jobid", id, function(e) 
		{
			console.log("global selected_jobid", e.message);
			common_selected_jobid = e.message;
		});
	
	//	global selected clientid...
	selected_clientid_event = common_create_event(Y,"selected_clientid");
	common_subscribe_event( Y, "selected_clientid", id, function(e) 
		{
			console.log("global selected_clientid", e.message);
			common_selected_clientid = e.message;
		});
        
	//      global selected serviceuid...
        selected_serviceuid_event = common_create_event(Y,"selected_serviceuid");
        common_subscribe_event( Y, "selected_serviceuid", id, function(e)
                {
                        console.log("global selected_serviceuid", e.message);
                        common_selected_serviceuid = e.message;
                });

        //      global selected deviceuid...
        selected_deviceuid_event = common_create_event(Y,"selected_deviceuid");
        common_subscribe_event( Y, "selected_deviceuid", id, function(e)
                {
                        console.log("global selected_deviceuid", e.message);
                        common_selected_serviceuid = e.message[0];
                        common_selected_deviceuid = e.message[1];
                });


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
	
	//      global jobs search...
        jobs_search_event = common_create_event(Y,"jobs_search");
	common_subscribe_event( Y, "jobs_search", id, function(e) 
		{
			common_job_search = e.message;
		});

	//      global clients changed...
        clients_changed_event = common_create_event(Y,"clients_changed");
	
	//      global new client...
        new_client_event = common_create_event(Y,"new_client");
	

	//	global selected accountid...
	selected_accountid_event = common_create_event(Y,"selected_accountid");
	common_subscribe_event( Y, "selected_accountid", id, function(e) 
		{
			console.log("global selected_accountid", e.message);
			common_selected_accountid = e.message;
		});
	
	//	global selected tierid...
	selected_tierid_event = common_create_event(Y,"selected_tierid");
	common_subscribe_event( Y, "selected_tierid", id, function(e) 
		{
			console.log("global selected_tierid", e.message);
			//common_selected_accountid = e.message;
		});
	
	//	global selected papertypeid...
	selected_papertypeid_event = common_create_event(Y,"selected_papertypeid");
	common_subscribe_event( Y, "selected_papertypeid", id, function(e) 
		{
			console.log("global selected_papertypeid", e.message);
			//common_selected_accountid = e.message;
		});

        //      global tiers changed...
        tiers_changed_event = common_create_event(Y,"tiers_changed");
        
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


function common_notify_selected_serviceuid(id, serviceuid )
{
        common_selected_serviceuid = serviceuid;
        selected_serviceuid_event.fire("selected_serviceuid", {
                                        message: serviceuid ,
                                        origin: id } );
}

function common_notify_selected_deviceuid(id, serviceuid, deviceuid)
{
        common_selected_serviceuid = serviceuid;
        common_selected_deviceuid = deviceuid;
        selected_deviceuid_event.fire("selected_deviceuid", {
                                        message: [ serviceuid, deviceuid ],
                                        origin: id } );
}

function common_notify_quotes_changed(id,jobid)
{
        quotes_changed_event.fire("quotes_changed", {
                                        message: jobid,
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

function common_textbox_check_with_color(obj)
{
        var val = obj.get("value");
        if ( isNaN( val ) || ( val=="") || (val==null) )
        {
                obj.setStyle('background-color','pink');
        }
        else
        {
                obj.setStyle('background-color','');
        }
}

function common_textbox_check_remove_default_text(obj)
{
        var elid = obj.get("id");
	var def_val = common_panel_active_state['default'][elid];
        if ( def_val )
        {
                var val = obj.get("value");
                if (val==def_val) obj.set("value","");
        }
}

function common_validate_one( prop, state )
{
	common_panel_active_state = state;

        var tfunc = state['validate'][prop][0];
        var obj = state['node'][prop];
        if ( !tfunc(obj,prop) )
        {
                var parent_name = state['validate'][prop][1];
                var parent_obj = state['node'][parent_name];
                parent_obj.setStyle("background-color","pink");
                return false;
        }
        else
        {
                var parent_name = state['validate'][prop][1];
                var parent_obj = state['node'][parent_name];
                parent_obj.setStyle("background-color","");
                return true;
        }
}

function common_dom_configure(Y, state, handler)
{
	var disabled_dct = state['disabled'];
	var values_dct = state['values'];
	var validate_dct = state['validate'];
        var node_dct = state['node'];
	var check_dct = state['check'];
	var partno_dct = state['partno'];
	var jobid = state['jobid'];

	for ( var elid in values_dct )
        {
		//	get the node...
		var node = Y.one('#' + elid );
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
						var dt = { 'name': fname, 'thumb': status['url'], 'x': status['width'], 'y': status['height'], 'asset': status['asset'] };
						if (status['status']) common_panel_active_state['values'][prefix] = dt;
						else common_panel_active_state['values'][prefix] = null;
						if (handler) handler( prefix, status );
					}
					else
					{
						common_panel_active_state['values'][prefix] = null;
						if (handler) handler( prefix, status );
					}
				});
			node_dct[elid] = obj;
		}
                //      is it drop down?...
                else if ( tp == "VD" )
                {
			check_dct[elid] = function(el_id)
				{
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );
				};

                	node.on('change',
                                function(e)
                                {
					//	get/store the value...
					var elid = this.get("id");
					var val = this.get("value");
					common_panel_active_state['values'][elid] = val;
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );
					if (handler) handler( elid, val );
                                });
		}
		else if ( tp == "VC" ) // a checkbox
		{
                	node.on('change',
                                function(e)
                                {
					//	get/store the value...
					var elid = this.get("id");
					var val = this.get("checked");
					common_panel_active_state['values'][elid] = val;

					if (handler) handler( elid, val );
                                });
		}
		else if ( tp == "VT" ) // a text box
		{
			//	possible set disabled from init state...
			var disv = disabled_dct[elid];
			if (disv==true)
			{
				node.set("disabled","disabled");
			}

			check_dct[elid] = function(el_id)
				{
					var obj = common_panel_active_state['node'][el_id];
					var val = this.get("value");

					//	do value check...
                                        common_textbox_check_with_color(obj);

					//	possibly deal with validation...
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );

					//if (handler) handler( el_id, val );
				};

			node.on('keyup',
                                function(e)
                                {
					console.log("vt keyup");

					//	get/store the value...
                                        var elid = this.get("id");
                                        var val = this.get("value");
                                        common_panel_active_state['values'][elid] = val;

					//	do value check...
                                        common_textbox_check_with_color(this);

					//	possibly deal with validation...
                                        if (common_panel_active_validator) common_validate_one( common_panel_active_validator, common_panel_active_state );

					if (handler) handler( elid, val );
                                });
                        node.on('focus',
                                function(e)
                                {
					console.log("vt focus");

					//	possibly remove default/hint text...	
                                        common_textbox_check_remove_default_text(this);
                                        common_textbox_check_with_color(this);
                                });
		}
	}
}

function common_instantiate_definition(definition_dct, parentName, idx, state)
{
	if (state==null)
		state = { 'html':{}, 'values':{}, 'default':{}, 'validate':{}, 'node':{}, 'parent':{}, 'partno':{}, 'check':{} ,'disabled':{} };
	
	state['html'] = {};	//always a fresh subst gets generated...

	//	get refs to state dcts...
	html_subst  = state['html'];
	values_dct = state['values'];
	default_dct = state['default'];
	node_dct = state['node'];
	parent_dct = state['parent'];
	partno_dct = state['partno'];
	check_dct = state['check'];
	disabled_dct = state['disabled'];

	for ( var prop in definition_dct )
	{
		//	create id subst...
		val = prop+idx;
		html_subst[prop] = val;

		//	initialize partno_dct here...
		partno_dct[val] = idx;

		//	initialize values_dct here...
		values_dct[val] = null;

		//	create default val subst...
		if (definition_dct[prop]!=null)
		{
			var tp = prop.substring(0,2);

			//	is it drop down?...
			if ( tp == "VD" )
			{
				//	create the html substitution...
				str = "";
				for (var i=0;i<definition_dct[prop]['options'].length;i++)
				{
					item = definition_dct[prop]['options'][i];
					str += '<option style="height:20px;" value="' + i + '">' + item + '</option>';
				}
				vprop = prop+"_VAL";
				html_subst[vprop] = str;
				
				//	create a parent entry...
				parent_dct[val] = parentName + idx;
				
			}
			else if ( tp == "VT" ) // numeric entry text box...
			{
				//	set the substitution for this el...	
				vprop = prop+"_VAL";
				vval = definition_dct[prop]['default'];
				html_subst[vprop] = vval;

				//	set the default val for this el...
				default_dct[val] = vval;

				//	set the disabled val for this el...
				disabled_dct[val] = definition_dct[prop]['disabled'];

				//	create a parent entry...
				parent_dct[val] = parentName + idx;

			}
			else if ( tp == "VC" ) // checkbox box...
                        {
                                //      set the substitution for this el...
                                vprop = prop+"_VAL";
                                vval = definition_dct[prop]['default'];
                                html_subst[vprop] = vval;

                                //      set the default val for this el...
                                default_dct[val] = vval;

				//	initialize state...
				if ( vval == "checked" ) values_dct[val] = true;
				else values_dct[val] = false;

                                //      create a parent entry...
                                parent_dct[val] = parentName + idx;

                        }
			else if ( tp == "VV" ) // parent div...
			{	
				//	create substitution entry...
				vprop = prop+"_VAL";
				vval = definition_dct[prop];
				html_subst[vprop] = vval;

			}
			else if ( tp == "VI" )
			{
				vprop = prop+"_VAL";
				vval = definition_dct[prop]['default'];
				html_subst[vprop] = vval;
			}
			else // everything else...
			{	
				//	create subst entry...
				vprop = prop+"_VAL";
				vval = definition_dct[prop];
				html_subst[vprop] = vval;

				 //      create a parent entry...
                                parent_dct[val] = parentName + idx;
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
