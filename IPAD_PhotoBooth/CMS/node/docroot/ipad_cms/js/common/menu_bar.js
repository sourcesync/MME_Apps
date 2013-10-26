//	controls...
var menu_bar = null;

//	state...
var mb_Y = null;
var mb_state = null;
var mb_data = null;
var mb_parentName = null;
var mb_selected = null;

function menu_bar_show(Y)
{
	if (menu_bar)
	{
		menu_bar.show();
	}
}


function mb_refresh(sessionid)
{
        Y = mb_Y;

        var handleSuccess = function(id, o, a)
        {
                mb_data = Y.JSON.parse(o.responseText);
                if ( mb_data['status'] )
                        mb_create( mb_Y, mb_parentName );
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: mb"); }
            }
        };

        var url = CONFIG_BASE_URL + "sessions?sessionid=" + sessionid + '&getsession=true';

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

//<li id="mbhome" ><a href="../home/home.html">Home</a></li>\
//<li id="mbdevices" ><a href="../device/devices.html">Devices</a></li>\

var func = "alert('This feature is locked or not yet ready for review.');";

var mb_html = '\
	<div style="margin-left:10px;width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<div style="float:left;height:40px;background-color:rgb(245,245,245);">\
    			<div style="float:left;margin-top:5px;vertical-align:middle;">\
            			<div class="pure-menu pure-menu-open pure-menu-horizontal">\
                			<ul>\
        					<li id="mbhome" ><div style="margin-left:10px;margin-right:10px;" onclick="' + func + '" >Home</div></li>\
        					<li id="mbprojects" ><div style="margin-left:10px;margin-right:10px;" onclick="' + func + '" >Projects</a></li>\
        					<li id="mbjobs" ><a href="../job/jobs.html">Orders</a></li>\
        					<li id="mbdevices" ><div style="margin-left:10px;margin-right:10px;" onclick="' + func + '" >Devices</div></li>\
        					<li id="mbclients" ><div style="margin-left:10px;margin-right:10px;" onclick="' + func + '" >Clients</a></li>\
        					<li id="mbadmin" ><a href="../admin/admin.html">Admin</a></li>\
        				</ul>\
				</div>\
			</div>\
		</div>\
		<div style="float:right;height:40px;background-color:rgb(245,245,245);margin-right:10px;">\
			<a style="position:relative;top:5px;float:right;vertical-align:middle;margin-right:5px;" \
				id="blogout" href="../login.html" \ class="pure-button notice">logout</a>\
    			<div style="position:relative;top:5px;float:right;vertical-align:middle;">\
            			<font size="2">\
            			<div style="float:right;" class="pure-menu pure-menu-open pure-menu-horizontal">\
            				<ul>\
                				<li ><a id="mblogin" href="#">Logged in as: Leo Martinez</a></li>\
                				<li ><a id="mbnetid" href="#">NetID: lm2637 </a></li>\
                				<li ><a id="mbdate" href="#">06/11/2013 15:28:35</a></li>\
            				</ul>\
            			</div>\
            			</font>\
			</div>\
			<div style="clear:both;width:0px;"></div>\
    		</div>\
		<div style="clear:both;width:0px;"></div>\
	</div>';

function mblogout()
{
		var ok = false;
                var handleSuccess = function(id, o, a)
                {
                        var status = mb_Y.JSON.parse(o.responseText);
                        if (status && status['status'])
                        {
				ok = true;
                        }
                        else
                        {
				ok = true;
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
                                failure: function(id,o,a) { mb_Y.log(id,o,a); }
                        }
                };

                var url = CONFIG_BASE_URL + "logout=true&sessionid=" + page_sessionid;

                mb_Y.io.header('X-Requested-With');
                var obj = mb_Y.io( url, cfg );
}

function mb_create(Y, parentName)
{
	var parent = Y.Node('#' + parentName);

	parent.set("innerHTML", mb_html );

	if (mb_data&&mb_data['status'])
	{
		var el = Y.Node("#mblogin");
		el.set("innerHTML", "Logged in as: " + mb_data["name"]);
		
		var el = Y.Node("#mbnetid");
		el.set("innerHTML", "NetID: " + mb_data["netid"]);
                
		var vl = new Date(mb_data["date"]);
                var dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M"});
		var el = Y.Node("#mbdate");
		el.set("innerHTML", "Login: " + dt);
		
		el = Y.Node("#blogout");
		el.on("click", function(e) 
			{
				mblogout();
			});	
	}

	if (mb_selected)
	{
		var el = Y.Node("#mb" + mb_selected);
		el.set("className","pure-menu-selected");
	}
}

function menu_bar_init(Y, parentName, selected )
{
	//	stash ref to sandbox...
	mb_Y = Y; 

	mb_parentName = parentName;

	mb_selected = selected;

	//	create the contents dynamically...
	//mb_create(Y, parentName);


	mb_refresh(page_sessionid);
}

