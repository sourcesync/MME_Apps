//	controls...
var action_bar = null;

//	state...
var ac_Y = null;
var ac_page = null;
var ac_event_id = null;

function action_bar_show(Y)
{
	if (action_bar)
	{
		action_bar.show();
	}
}

var ac_projects_html = '\
	<div id="projects_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="ac_projects_new_consultation" class="pure-button">New Consultation</button>\
		<button type="button" id="ac_projects_new_session" class="pure-button">New Session</button>\
		<button type="button" id="ac_projects_new_order" class="pure-button">New Order</button>\
		<button type="button" id="ac_projects_upload_files" class="pure-button">Upload Files</button>\
		<button type="button" id="ac_projects_create_new" class="pure-button">Create New</button>\
	</div>';

var ac_active_html = '\
	<div id="active_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_job_order" class="pure-button">New Job Order</button>\
		<button type="button" id="action_pay" class="pure-button">Pay</button>\
		<button type="button" id="action_inactive" class="pure-button">Make Inactive</button>\
		<button type="button" style="display:none;" id="action_test" class="pure-button">Test Add Material</button>\
		<button type="button" style="display:none;" id="action_test_search_mat" class="pure-button">Test Search Material</button>\
	</div>';

var ac_inactive_html = '\
	<div id="inactive_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_active" class="pure-button">Make Active</button>\
	</div>';

var ac_estimates_html = '\
	<div id="estimates_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_estimate" class="pure-button">New Estimate</button>\
		<button type="button" id="action_open" class="pure-button">Open</button>\
		<button type="button" id="action_delete" class="pure-button">Delete</button>\
	</div>';

var ac_consultations_html = '\
        <div id="consultations_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
                <button type="button" id="act_new_consultations" class="pure-button">New Consultation</button>\
                <button type="button" id="act_consultations_open" class="pure-button">Open</button>\
                <button type="button" id="act_consultations_delete" class="pure-button">Delete</button>\
        </div>';

var ac_papertypes_html = '\
	<div id="papertypes_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_papertype" class="pure-button">New PaperType</button>\
		<button type="button" id="action_change_papertype" class="pure-button">Edit PaperType</button>\
		<button type="button" id="action_delete_papertype" class="pure-button">Delete PaperType</button>\
		<button type="button" id="action_change_tier" class="pure-button">Edit Tier</button>\
	</div>';

var ac_rapid_html = '\
	<div id="admin_rapid_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_edit_rapid" class="pure-button">Edit Parameters</button>\
		<button type="button" id="action_new_rapid" class="pure-button">New Material</button>\
		<button type="button" id="action_change_rapid" class="pure-button">Edit Material</button>\
		<button type="button" id="action_delete_rapid" class="pure-button">Delete Material</button>\
		<button type="button" id="action_save_rapid" class="pure-button" disabled>Save</button>\
	</div>';

var ac_laser_html = '\
	<div id="admin_laser_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_edit_laser" class="pure-button">Edit Parameters</button>\
		<button type="button" id="action_save_laser" class="pure-button" disabled>Save</button>\
		<button type="button" id="action_sync_laser_materials" class="pure-button">Sync</button>\
	</div>';

var ac_admin_finance_html = '\
	<div id="admin_finance_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_admin_finance" class="pure-button">New Account</button>\
	 	<button type="button" id="action_change_admin_finance" class="pure-button">Edit Account</button>\
               	<button type="button" id="action_delete_admin_finance" class="pure-button">Delete Account</button>\
               	<button type="button" id="action_view_checks_admin_finance" class="pure-button">View Checks</button>\
               	<button type="button" id="action_manage_checks_admin_finance" class="pure-button">Manage Checks</button>\
	</div>';

var ac_admin_audit_html = '\
        <div id="admin_audit_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
        </div>';

var ac_admin_settings_html = '\
        <div id="admin_settings_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
                <button type="button" id="action_edit_settings" class="pure-button">Edit Settings</button>\
	</div>';

var ac_admin_metrics_html = '\
        <div id="admin_metrics_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
                <button type="button" id="action_metrics_sync" class="pure-button">Sync Calendar</button>\
                <button type="button" id="action_metrics_print" class="pure-button">Print Report</button>\
        </div>';

var ac_admin_users_html = '\
        <div id="admin_users_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
                <button type="button" id="action_new_user" class="pure-button">New User</button>\
                <button type="button" id="action_change_user" class="pure-button">Edit User</button>\
                <button type="button" id="action_deactivate_user" class="pure-button">Deactivate User</button>\
                <button type="button" id="action_activate_user" class="pure-button">Activate User</button>\
        </div>';

var ac_devices_html = '\
	<div id="devices_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
        </div>';

var ac_clients_html = '\
        <div id="clients_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_client" class="pure-button">New Client</button>\
        </div>';

var ac_admin_tdscan_html = '\
        <div id="admin_tdscan_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
                <button type="button" id="action_edit_tdscan" class="pure-button">Edit Parameters</button>\
                <button type="button" id="action_save_tdscan" class="pure-button" disabled>Save</button>\
        </div>';

function ac_create( parentName, page )
{
	if ( page=="jobs") ac_create_jobs_page( ac_Y, parentName );
	else if ( page=="projects" ) ac_create_projects_page( ac_Y, parentName );
	else if ( page=="clients" ) ac_create_clients_page( ac_Y, parentName );
	else if ( page=="devices" ) ac_create_devices_page( ac_Y, parentName );
	else if ( page=="admin" ) ac_create_admin_page( ac_Y, parentName );
	else alert("Main Item Not Implemented");
}

function ac_create_projects_page(Y, parentName )
{
	ac_create_projects(Y, parentName);
}	

function ac_create_jobs_page(Y, parentName )
{
	ac_create_active(Y, parentName);
	ac_create_inactive(Y, parentName);
	ac_create_estimates(Y, parentName)
	ac_create_consultations(Y, parentName)
}

function ac_create_devices_page(Y, parentName)
{
        ac_create_devices(Y,parentName);
}

function ac_create_clients_page(Y, parentName)
{
        ac_create_clients(Y,parentName);
}

function ac_create_admin_page(Y, parentName)
{
        ac_create_papertypes(Y, parentName);
        ac_create_rapid(Y, parentName);
        ac_create_laser(Y, parentName);
        ac_create_admin_finance(Y, parentName);
        ac_create_admin_audit(Y, parentName);
        ac_create_admin_users(Y, parentName);
        ac_create_admin_settings(Y, parentName);
        ac_create_admin_metrics(Y, parentName);
        ac_create_admin_tdscan(Y, parentName);
}

function hide_all(Y)
{
	var node = Y.Node("#active_action_box");
	if (node) node.setStyle("display","none");
	
	var node = Y.Node("#inactive_action_box");
	if (node)  node.setStyle("display","none");

	var node = Y.Node("#estimates_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#consultations_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#papertypes_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_finance_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_audit_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_users_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#devices_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_rapid_action_box");
	if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_laser_action_box");
	if (node)  node.setStyle("display","none");

        var node = Y.Node("#admin_settings_action_box");
        if (node)  node.setStyle("display","none");
        
	var node = Y.Node("#admin_metrics_action_box");
        if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#admin_tdscan_action_box");
        if (node)  node.setStyle("display","none");
	
	var node = Y.Node("#clients_action_box");
        if (node)  node.setStyle("display","none");
}

function ac_show_box( name, show )
{
	var node = Y.Node('#' + name );
	if (!node) alert("ERROR: Cannot find ac box->", name);
	else if (show) node.setStyle('display','block');
	else node.setStyle('display','none');
}

function ac_show( tab )
{
	return;

	hide_all( ac_Y );

	var page = ac_page;

	if ( page=="jobs") ac_jobs_show( tab );
	else if ( page=="projects" ) ac_projects_show( tab );
	else alert("Not implemented");
}

function ac_projects_show( tab )
{
	ac_show_box( 'projects_action_box', true );
}

function ac_jobs_show(tab )
{
	if (tab=="active")
	{
		var node = Y.Node("#active_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="inactive")
	{
		var node = Y.Node("#inactive_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="estimates")
	{
		var node = Y.Node("#estimates_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="consultations")
	{
		var node = Y.Node("#consultations_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="papertypes")
	{
		var node = Y.Node("#papertypes_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="accounts")
	{
		var node = Y.Node("#admin_finance_action_box");
		node.setStyle("display","block");
	}
	else if (tab=="Wide_Format")
	{
		var node = Y.Node("#devices_action_box");
		node.setStyle("display","block");
	}
        else if (tab=="Rapid_Prototype")
        {
                var node = Y.Node("#devices_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="3D_Scan")
        {
                var node = Y.Node("#devices_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="Laser")
        {
                var node = Y.Node("#devices_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="clients")
        {
                var node = Y.Node("#clients_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="audit")
        {
                var node = Y.Node("#admin_audit_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="users")
        {
                var node = Y.Node("#admin_users_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="rapid")
        {
                var node = Y.Node("#admin_rapid_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="laser")
        {
                var node = Y.Node("#admin_laser_action_box");
                node.setStyle("display","block");
	}
	else if (tab=="settings")
        {
                var node = Y.Node("#admin_settings_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="metrics")
        {
                var node = Y.Node("#admin_metrics_action_box");
                node.setStyle("display","block");
        }
	else if (tab=="tdscan")
        {
                var node = Y.Node("#admin_tdscan_action_box");
                node.setStyle("display","block");
        }
}

function ac_create_projects(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_projects_html );
        parent.append(el);

        var btn = Y.Node('#ac_projects_new_consultation');
        btn.on("click", function(e)
                {
			new_consultation_wizard_show();
                });
        
	btn = Y.Node('#ac_projects_new_session');
        btn.on("click", function(e)
                {
			new_session_wizard_show();
                });
	
	btn = Y.Node('#ac_projects_new_order');
        btn.on("click", function(e)
                {
			new_job_wizard_show(null,0);
                });
	
	btn = Y.Node('#ac_projects_upload_files');
        btn.on("click", function(e)
                {
			if ( common_selected_projid )
				upload_files_wizard_show(common_selected_projid);
			else
				alert("No project selected");
                });
	
	btn = Y.Node('#ac_projects_create_new');
        btn.on("click", function(e)
                {
			create_new_wizard_show(common_selected_projid);
                });
}

function ac_create_inactive(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_inactive_html );
        parent.append(el);

        var btn = Y.Node('#action_active');
        btn.on("click", function(e)
                {
                        if ( common_selected_jobid )
                                make_active(ac_Y,common_selected_jobid, true);
                        else
                                alert("no job selected");
                });
}

function ac_create_active(Y, parentName)
{
	//	Create the dom hierarchy... 
	var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_active_html );
	parent.append(el);
        //parent.set("innerHTML", ac_active_html );

	//	Add button callbacks...
	var btn = Y.Node('#action_new_job_order');
	btn.on("click", function(e)
		{
			new_job_wizard_show(null, 0);
		});
	
	var btn = Y.Node('#action_pay');
	btn.on("click", function(e)
		{
			if ( common_selected_jobid )
				make_payment_wizard_show(common_selected_jobid);
			else
				alert("no job selected");
		});
        var btn = Y.Node('#action_inactive');
        btn.on("click", function(e)
                {
                        if ( common_selected_jobid )
                                make_active(ac_Y,common_selected_jobid, false);
                        else
                                alert("no job selected");
                });
	
	var btn = Y.Node('#action_test');
	btn.on("click", function(e)
		{
			consultation_file_manager_panel_show();
		});

/*	
	var btn = Y.Node('#action_test_add_mat');
	btn.on("click", function(e)
		{
			laser_material_add_panel_init( ac_Y );
			laser_material_add_panel_show( );
		});
	
	var btn = Y.Node('#action_test_search_mat');
	btn.on("click", function(e)
		{
			material_search_panel_init( ac_Y );
			material_search_panel_show( false, null );
		});
*/
}

function ac_create_consultations(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_consultations_html );
        parent.append(el);

        //      Add button callbacks...
        var btn = Y.Node('#act_new_consultations');
        btn.on("click", function(e)
                {
                        new_job_wizard_show( null, 2 );
                });

        var btn = Y.Node('#act_consultations_open');
        btn.on("click", function(e)
                {
                        console.log(e);
                        if ( common_selected_jobid )
                                new_job_wizard_show( common_selected_jobid, 2 );
                        else
                                alert("no job selected");
                });

        var btn = Y.Node('#act_consultations_delete');
        btn.on("click", function(e)
                {
                        console.log(e);
                        if (common_selected_jobid)
                                delete_consultation( ac_Y, common_selected_jobid );
                        else
                                alert("no job selected");
                });
}

function ac_create_estimates(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_estimates_html );
        parent.append(el);

/*
        //      Add button callbacks...
        var btn = Y.Node('#action_new_estimate');
        btn.on("click", function(e)
                {
                        console.log(e);
			alert("Not implemented!");
                });

        var btn = Y.Node('#action_open');
        btn.on("click", function(e)
                {
                        console.log(e);
                        if ( common_selected_jobid )
                                new_job_wizard_show( common_selected_jobid, 1 );
			else
				alert("no job selected");
                });

        var btn = Y.Node('#action_delete');
        btn.on("click", function(e)
                {
                        console.log(e);
                        if (common_selected_jobid)
                                delete_quote( ac_Y, common_selected_jobid );
			else
				alert("no job selected");
                });
*/
}

function ac_create_papertypes(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_papertypes_html );
        parent.append(el);
        

        //      Add button callbacks...
        var btn = Y.Node('#action_new_papertype');
        btn.on("click", function(e)
                {
                        console.log(e);
			alert("Not Implemented Yet.");
                });

        var btn = Y.Node('#action_change_papertype');
        btn.on("click", function(e)
                {
			if ( adp_selected_papertypeid)
                                papertype_edit_panel_show();
                        else
                                alert("No papertype selected."); 
                });

        var btn = Y.Node('#action_delete_papertype');
        btn.on("click", function(e)
                {
                        console.log(e);
			alert("Not Implemented Yet.");
                });

 	var btn = Y.Node('#action_change_tier');
        btn.on("click", function(e)
                {
			if ( adp_selected_tierid)
                                tier_edit_panel_show();
                        else
                                alert("No tier selected.");	
                });
}

function ac_create_laser(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_laser_html );
        parent.append(el);
       
	// 
	//      Add button callbacks...
	//
        var btn = Y.Node('#action_edit_laser');
        btn.on("click", function(e)
                {
			if (admin_laser_edit_parameters())
			{
				var bs = Y.Node('#action_save_laser');
				bs.set("disabled","");
			}
                });

 	var btn = Y.Node('#action_save_laser');
        btn.on("click", function(e)
                {
			if ( admin_laser_save_parameters() )
			{
				var bb = Y.Node('#action_save_laser');
				bb.set("disabled","true");
			}
                });	
 	
	var btn = Y.Node('#action_sync_laser_materials');
        btn.on("click", function(e)
                {
			if ( !admin_laser_sync_materials() )
			{
			}
                });	
}


function ac_create_rapid(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_rapid_html );
        parent.append(el);
        
	//      Add button callbacks...
        var btn = Y.Node('#action_edit_rapid');
        btn.on("click", function(e)
                {
			if (admin_rapid_edit_parameters())
			{
				var bs = Y.Node('#action_save_rapid');
				bs.set("disabled","");
			}
                });

        //      Add button callbacks...
        var btn = Y.Node('#action_new_rapid');
        btn.on("click", function(e)
                {
                        console.log(e);
                        alert("Not Implemented Yet.");
                });

        var btn = Y.Node('#action_change_rapid');
        btn.on("click", function(e)
                {
			if ( adr_selected_id)
				material_edit_panel_show();
			else
				alert("No material selected.");
                });

        var btn = Y.Node('#action_delete_rapid');
        btn.on("click", function(e)
                {
                        console.log(e);
                        alert("Not Implemented Yet.");
                });

 	var btn = Y.Node('#action_save_rapid');
        btn.on("click", function(e)
                {
			if ( admin_rapid_save_parameters() )
			{
				var bb = Y.Node('#action_save_rapid');
				bb.set("disabled","true");
			}
                });	
}


function ac_create_devices(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_devices_html );
        parent.append(el);
}


function ac_create_clients(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_clients_html );
        parent.append(el);

	//      Add button callbacks...
        var btn = Y.Node('#action_new_client');
        btn.on("click", function(e)
                {
                        console.log(e);
                        new_client_panel_show(false);
                });

}

function ac_create_admin_audit(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_audit_html );
        parent.append(el);
        //parent.set("innerHTML", ac_admin_audit_html );
}


function ac_create_admin_tdscan(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_tdscan_html );
        parent.append(el);
        //parent.set("innerHTML", ac_admin_audit_html );

       //      Add button callbacks...
        var btn = Y.Node('#action_edit_tdscan');
        btn.on("click", function(e)
                {
                        if (admin_tdscan_edit_parameters())
                        {
                                var bs = Y.Node('#action_save_tdscan');
                                bs.set("disabled","");
                        }
                });

        //      Add button callbacks...
        var btn = Y.Node('#action_save_tdscan');
        btn.on("click", function(e)
                {
                        if (admin_tdscan_save_parameters())
                        {
                                var bs = Y.Node('#action_save_tdscan');
                                bs.set("disabled",true);;
                        }
                });



/*
        //      Add button callbacks...
        var btn = Y.Node('#action_new_tdscan');
        btn.on("click", function(e)
                {
                        console.log(e);
                        alert("Not Implemented Yet.");
                });

*/



}

function ac_create_admin_metrics(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_metrics_html );
        parent.append(el);

        var btn = Y.Node('#action_metrics_sync');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
        
	var btn = Y.Node('#action_metrics_print');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
}


function ac_create_admin_settings(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_settings_html );
        parent.append(el);

        var btn = Y.Node('#action_edit_settings');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
}

function ac_create_admin_users(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_users_html );
        parent.append(el);
        //parent.set("innerHTML", ac_admin_users_html );

        var btn = Y.Node('#action_new_user');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
        
	btn = Y.Node('#action_change_user');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
	
	btn = Y.Node('#action_deactivate_user');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });
	
	btn = Y.Node('#action_activate_user');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });

}



function ac_create_admin_finance(Y, parentName)
{
        //      Create the dom hierarchy...
        var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_admin_finance_html );
        parent.append(el);
        //parent.set("innerHTML", ac_admin_finance_html );

        //      Add button callbacks...
        var btn = Y.Node('#action_new_admin_finance');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });

        var btn = Y.Node('#action_change_admin_finance');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });

        var btn = Y.Node('#action_delete_admin_finance');
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
                });

	var btn = Y.Node('#action_view_checks_admin_finance')
        btn.on("click", function(e)
                {
                        console.log(e);
			if ( common_selected_accountid )
				account_checks_panel_show( common_selected_accountid );
			else
				alert("no account selected");
                });
	var btn = Y.Node('#action_manage_checks_admin_finance')
        btn.on("click", function(e)
                {
                        alert("Not Implemented Yet.");
		});
}


function client_search(Y)
{
	client_search_panel_show();
}


function delete_quote(Y, jobid)
{
        var handleSuccess = function(id, o, a)
        {
            	var resp = Y.JSON.parse(o.responseText);
            	Y.log(resp);

		//      global notify quotes change...
                common_notify_quotes_changed( ac_event_id, common_selected_jobid );
	
		//	unset the selected jobid too..	
                common_notify_selected_jobid( ac_event_id, null );
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

        Y.io.header('X-Requested-With');
        var obj = Y.io( CONFIG_BASE_URL + "quotes?delete=true&jobid=" + jobid, cfg );
}


function make_active(Y, jobid, active)
{
        var handleSuccess = function(id, o, a)
        {
                var resp = Y.JSON.parse(o.responseText);
                Y.log(resp);

		//	notify orders changed...
                common_notify_jobs_changed( ac_event_id, common_selected_jobid );

                //      unset the selected jobid too..
                common_notify_selected_jobid( ac_event_id, null );
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

	active = (active)?"true":"false";

        Y.io.header('X-Requested-With');
        var obj = Y.io( CONFIG_BASE_URL + "jobs?makeactive=" + active + "&jobid=" + jobid, cfg );
}

function action_bar_init(Y, parentName, page)
{
	//	stash ref to sandbox...
	ac_Y = Y; 

	//	stash page name...
	ac_page = page;
	
	//	event id...
	ac_event_id = Y.guid();

	//	create the contents dynamically...
	ac_create(parentName, page);

        //      listen to tab changes in job_summary_tabs...
        common_subscribe_event( Y, "job_summary_tabs", ac_event_id, function(e)
        {
                Y.log( "action_bar: jobs_summary_tabs event sink->" + e.message );

        });
        
	//      listen to tab changes in jobs_listviews_tabs...
        common_subscribe_event( Y, "jobs_listviews_tabs", ac_event_id, function(e)
        {
                Y.log( "action_bar: jobs_listviews_tab event sink->" + e.message );
		var tab_name = e.message;

		ac_show( tab_name );
        });

        //      listen to tab changes in admin_summary_tabs...
        common_subscribe_event( Y, "admin_summary_tabs", ac_event_id, function(e)
        {
                Y.log( "action_bar: admin_summary_tab event sink->" + e.message );
                var tab_name = e.message;

                ac_show( tab_name );
        });
        
	//      listen to tab changes in service_summary_tabs...
        common_subscribe_event( Y, "service_summary_tabs", ac_event_id, function(e)
        {
                Y.log( "action_bar: service_summary_tab event sink->" + e.message );
                var tab_name = e.message;

                ac_show( tab_name );
        });
	
	//      listen to tab changes in client_summary_tabs...
        common_subscribe_event( Y, "client_summary_tabs", ac_event_id, function(e)
        {
                Y.log( "action_bar: client_summary_tab event sink->" + e.message );
                var tab_name = e.message;

                ac_show( );
        });

	//      listen to tab changes in common_selected_accountid...
        common_subscribe_event( Y, "selected_accountid", ac_event_id, function(e)
        {
        });

	//	init dependent objects...
	//new_job_wizard_init(Y);
	//account_checks_panel_init(Y);
}

