class MainClass extends GSController
{
	_load_data = null;
 	
	games_loaded=0;
	last_month = 0;

	// Settings
	cargo_id = 0;
	use_points_scoring = 0;

	// Data
	company_deliverd_cargo = {};

	// League table
	table_id = 0;
	company_league_table_element_ids = {};

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Called once the script starts
function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first

	this.Init(); // Do any setup actions here

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoDayLoop();       // Your main game logic

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep((74 - ticksPassed) > 1 ? (74 - ticksPassed) : 1);
	}
}

function MainClass::Init()
{
	GSLog.Info("****************************");
	GSLog.Info("*** Master Hellish Cargo Tracker ***");
	GSLog.Info("****************************");
	GSLog.Info("");

	this.cargo_id = GSController.GetSetting("cargo_id");
	this.use_points_scoring = GSController.GetSetting("use_points_scoring");
	GSLog.Info("cargo_id: " + this.cargo_id);
	GSLog.Info("use_points_scoring: " + this.use_points_scoring);
	GSLog.Info("");

	local cargo_list = GSCargoList()
	GSLog.Info("*** List of Cargos ***");
	foreach(key, value in cargo_list){
        GSLog.Info("ID: " + key + ", " + GSCargo.GetName(key));
    }

	if (games_loaded == 0) {
		// Create the league table
		this.table_id = GSLeagueTable.New(
			"Cargo Delivery Table",
			"Test Header",
			"Cargo being tracked: " + GSCargo.GetName(cargo_id)
		);
	};
}

function MainClass::HandleEvents()
{
	while(GSEventController.IsEventWaiting()) {

		local event = GSEventController.GetNextEvent();
		if (event == null) return;

		local event_type = event.GetEventType();
		switch (event_type) {
			// For V15
			// case GSEvent.ET_COMPANY_RENAMED: {
			// 	local company_name = event.GetNewName()
			// 	GSLeagueTable.UpdateElementData(
			// 		this.el_id,
			// 		company_id,
			// 		company_name,
			// 		GSLeagueTable.LINK_COMPANY,
			// 		company_id
			// 	)
			// 	break;
			// }
			case GSEvent.ET_COMPANY_NEW : {
				local new_company_event = GSEventCompanyNew.Convert(event);
				local company_id = new_company_event.GetCompanyID()
				this.company_league_table_element_ids[company_id] <- GSLeagueTable.NewElement(
					this.table_id, // table
					0, // rating
					company_id, // company
					GSCompany.GetName(company_id), // text
					"" + 0, // score
					GSLeagueTable.LINK_COMPANY, // link_type
					company_id // link_target
				);
				company_deliverd_cargo[company_id] <- 0;
				break;
			}
		}
	}
}

function MainClass::DoDayLoop()
{
	// Check for new month
	local current_month = GSDate.GetMonth(GSDate.GetCurrentDate());
	if(current_month == this.last_month) {
		return;
	}
	this.last_month = current_month;
	DoMonthLoop();
}

function MainClass::DoMonthLoop()
{
	this.cargo_id = GSController.GetSetting("cargo_id");

	for (local company_id = GSCompany.COMPANY_FIRST; company_id < GSCompany.COMPANY_LAST; company_id++) {
		if (GSCompany.ResolveCompanyID(company_id) != GSCompany.COMPANY_INVALID) {

			// Check company has HQ
			local tile_index  = GSCompany.GetCompanyHQ(company_id)
			if (tile_index == GSMap.TILE_INVALID){
				continue;
			}
			// Update the name
			// To-Do REMOVE AFTER V15
			local company_name = GSCompany.GetName(company_id);
			GSLeagueTable.UpdateElementData(
				this.company_league_table_element_ids[company_id],
				company_id,
				company_name,
				GSLeagueTable.LINK_COMPANY,
				company_id
			)

			// Get delivery amount
			local town_id = GSTile.GetClosestTown(tile_index);
			local cargo_delivery_amount = GSCargoMonitor.GetTownDeliveryAmount(
				company_id,
				this.cargo_id,
				town_id,
				true
			);

			// Debug cargo delivered info
			// GSLog.Info(company_name + " delivered " + cargo_delivery_amount);

			// Update the league table
			local previous_deliverd_cargo = this.company_deliverd_cargo[company_id];
			local new_cargo_delivery_amount = previous_deliverd_cargo + cargo_delivery_amount;
			this.company_deliverd_cargo[company_id] <- new_cargo_delivery_amount;
			GSLeagueTable.UpdateElementScore(
				this.company_league_table_element_ids[company_id],
				this.company_deliverd_cargo[company_id],
				"" + this.company_deliverd_cargo[company_id]
			);
		}
	}
}

function MainClass::Save() {
	GSLog.Info("Saving settings and data...");
	return {
		sv_cargo_id = this.cargo_id,
		sv_use_points_scoring = this.use_points_scoring,
		sv_last_month = this.last_month,
		sv_table_id = this.table_id,
		sv_company_deliverd_cargo = this.company_deliverd_cargo,
		sv_company_league_table_element_ids = this.company_league_table_element_ids
	};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading settings and data from savegame made with version " + version + " of the script...");
	foreach (key, val in data) {
		if ( key == "sv_cargo_id" ) this.cargo_id = val;
		if (key == "sv_use_points_scoring") this.use_points_scoring = val;
		if (key == "sv_last_month") this.last_month = val;
		if (key == "sv_table_id") this.table_id = val;
		if (key == "sv_company_deliverd_cargo") this.company_deliverd_cargo = val;
		if (key == "sv_company_league_table_element_ids") this.company_league_table_element_ids = val;
	}
	games_loaded = 1;
}
