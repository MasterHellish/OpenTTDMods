class MainClass extends GSController
{
	game_was_loaded=0;
	last_month = 0;

	// Settings
	cargo_id = 0;

	// Data
	company_delivered_cargo = {};
	company_names = {};

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
	GSLog.Info("*********************");
	GSLog.Info("*** MH Cargo Tracker ***");
	GSLog.Info("*********************");
	GSLog.Info("");

	this.cargo_id = GSController.GetSetting("cargo_id");
	GSLog.Info("Selected cargo id: " + this.cargo_id);
	GSLog.Info("");

	local cargo_list = GSCargoList()
	GSLog.Info("*** List of Cargos ***");
	foreach(key, value in cargo_list){
        GSLog.Info("ID: " + key + ", " + GSCargo.GetName(key));
    }
	GSLog.Info("");

	if (!this.game_was_loaded) {
		// Create the league table
		this.table_id = GSLeagueTable.New(
			GSText(GSText.STR_TABLE_TITLE),
			GSText(GSText.STR_CARGO_TRACKED, 1 << this.cargo_id),
			""
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
			//  this.company_names[company_id] <- company_name;
			// 	break;
			// }
			case GSEvent.ET_COMPANY_NEW : {
				local new_company_event = GSEventCompanyNew.Convert(event);
				local company_id = new_company_event.GetCompanyID()
				local company_name = GSCompany.GetName(company_id);

				this.company_league_table_element_ids[company_id] <- GSLeagueTable.NewElement(
					this.table_id, // table
					0, // rating
					company_id, // company
					company_name, // text
					"" + 0, // score
					GSLeagueTable.LINK_COMPANY, // link_type
					company_id // link_target
				);

				this.company_delivered_cargo[company_id] <- 0;
				this.company_names[company_id] <- company_name;

				GSGoal.Question(
					0,
					company_id,
					GSText(GSText.STR_WELCOME),
					GSGoal.QT_INFORMATION,
					GSGoal.BUTTON_OK
				);

				break;
			}
			case GSEvent.ET_COMPANY_BANKRUPT : {
				local bankrupt_company_event = GSEventCompanyBankrupt.Convert(event);
				local company_id = bankrupt_company_event.GetCompanyID()
				GSLog.Info("Company " + this.company_names[company_id] + " went bankrupt. They had a score of: " + this.company_delivered_cargo[company_id]);
				GSLeagueTable.RemoveElement(
					this.company_league_table_element_ids[company_id]
				);
				delete this.company_league_table_element_ids[company_id]
				delete this.company_delivered_cargo[company_id]
				delete this.company_names[company_id]
				break;
			}

			case GSEvent.ET_COMPANY_MERGER : {
				local merger_company_event = GSEventCompanyMerger.Convert(event);
				local company_id = merger_company_event.GetOldCompanyID()
				GSLog.Info("Company " + this.company_names[company_id] + " got bought out. They had a score of: " + this.company_delivered_cargo[company_id]);
				GSLeagueTable.RemoveElement(
					this.company_league_table_element_ids[company_id]
				);
				delete this.company_league_table_element_ids[company_id]
				delete this.company_delivered_cargo[company_id]
				delete this.company_names[company_id]
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
	this.DoMonthLoop();
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
			this.company_names[company_id] <- company_name;

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
			local previous_deliverd_cargo = this.company_delivered_cargo[company_id];
			local new_cargo_delivery_amount = previous_deliverd_cargo + cargo_delivery_amount;
			this.company_delivered_cargo[company_id] <- new_cargo_delivery_amount;
			GSLeagueTable.UpdateElementScore(
				this.company_league_table_element_ids[company_id],
				this.company_delivered_cargo[company_id],
				"" + this.company_delivered_cargo[company_id]
			);
		}
	}
}

function MainClass::Save() {
	GSLog.Info("Saving settings and data...");
	return {
		sv_cargo_id = this.cargo_id,
		sv_last_month = this.last_month,
		sv_table_id = this.table_id,
		sv_company_delivered_cargo = this.company_delivered_cargo,
		sv_company_league_table_element_ids = this.company_league_table_element_ids,
		sv_company_names = this.company_names
	};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading settings and data from savegame made with version " + version + " of the script...");
	foreach (key, val in data) {
		if (key == "sv_cargo_id" ) this.cargo_id = val;
		if (key == "sv_last_month") this.last_month = val;
		if (key == "sv_table_id") this.table_id = val;
		if (key == "sv_company_delivered_cargo") this.company_delivered_cargo = val;
		if (key == "sv_company_league_table_element_ids") this.company_league_table_element_ids = val;
		if (key == "sv_company_names") this.company_names = val;
	}
	game_was_loaded = 1;
}
