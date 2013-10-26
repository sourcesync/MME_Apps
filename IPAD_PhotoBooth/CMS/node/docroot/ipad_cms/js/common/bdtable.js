
var common_current_bdtable = null;

var bdt_Y;
var bdt_id_field = null;
var bdt_current_selectionid = null;
var bdt_current_selection_tr = null;
var bdt_current_selection_model = null;
var bdt_manual_selection_tr = null;
var bdt_sel_func = null;
var bdt_datatable = null;
var bdt_last_sortby = null;

//  HERE'S WHERE WE GET THE SELECTION MODEL, IF WE NEED TO RETAIN SELECTION ACROSS TABLE REFRESH
var bdt_formatter = function(o) {
                if ( bdt_current_selectionid )
                {
console.log("TRYING sel", o.data, bdt_id_field, bdt_current_selectionid );
                        if ( o.data[ bdt_id_field ] == bdt_current_selectionid )
                        {
console.log("GOT MODEL!");
                                bdt_current_selection_model = o.record;
                        }
                }
                return "";
        };

function bdtable_init( Y, table, id_field, sel_func )
{
	common_current_bdtable = table;
	
	bdt_Y = Y;
	bdt_datatable = table;
	bdt_id_field = id_field;
	bdt_sel_func = sel_func;

	table.addAttr("selectedRow", { value: null });

        table.delegate('click', function (e) {
                this.set('selectedRow', e.currentTarget);
        }, '.yui3-datatable-data tr', table);

        table.after('selectedRowChange',
                function (e)
                {
                        var tr = e.newVal,              // the Node for the TR clicked ...
                        last_tr = e.prevVal,        //  "   "   "   the last TR clicked ...
                        rec = table.getRecord(tr);   // the current Record for the clicked TR

                        //      remember new selection tr...
                        bdt_current_selection_tr = tr;

                        //      if there is a manual selection in effect...
                        if ( bdt_manual_selection_tr )
                        {
                                // get newly selected data id...
                                var selid = rec.get( bdt_id_field );

                                // remove selection classes if new selection != last one...
                                if (selid != bdt_current_selectionid )
                                {
                                        bdt_manual_selection_tr.removeClass("yui3-datatable-sel-selected");
                                        bdt_manual_selection_tr.removeClass("yui3-datatable-sel-highlighted");
                                }

                                bdt_manual_selection_tr = null;
                        }

                        if ( !last_tr )
                        {
                        }
			else
                        {
                                last_tr.removeClass("yui3-datatable-sel-selected");
                                last_tr.removeClass("yui3-datatable-sel-highlighted");
                        }

                        tr.addClass("yui3-datatable-sel-selected");
                        tr.addClass("yui3-datatable-sel-highlighted");

                        var val_id = rec.get(bdt_id_field);

                        // track selection across refreshes...
                        bdt_current_selectionid = val_id;
                        bdt_current_selection_model = rec;

			
                        //      notify globally current accountid...
                        //common_notify_selected_accountid( adf_event_id, accountid );

			if ( bdt_sel_func) bdt_sel_func( val_id );
                });


        table.after("sort",
                function(obj)
                {
			bdt_last_sortby  = bdt_datatable.get("sortBy");
                        Y.later(100, bdt_datatable,
                                function()
                                {
                                        if ( bdt_current_selection_tr )
                                        {
                                                bdt_recalcit();
                                        }
                                });
                        return true;
                });

        bdt_recalcit();

}


function bdt_recalcit()
{
        // perform manual selection if needed...
        if (bdt_current_selectionid && bdt_current_selection_model )
        {
                var tr = bdt_datatable.getRow(bdt_current_selection_model);
		if (!tr)
		{
			// its no longer here, reset everything...
console.log("not found, resetting selection.");
			bdt_current_selectionid = null;
			bdt_current_selection_model = null;
			return false;
		}	
		else
		{
                	tr.addClass("yui3-datatable-sel-selected");
                        tr.addClass("yui3-datatable-sel-highlighted");
                        bdt_manual_selection_tr = tr;
		}
        }

	return true;
}

function bdt_pre_setdata(override_id)
{
	if (override_id) bdt_current_selectionid = override_id;
}

function bdt_post_setdata()
{
	return bdt_recalcit();
}
