class MainClass extends GSController
{
	_loaded_data = null;
	data = null;
	last_year = 0;
	stat_bankrupt = 0;
	stat_crashes = 0;
	stat_train_crashes = 0;
	stat_road_crashes = 0;
	stat_flood_crashes = 0;
	stat_plane_crashes = 0;
	stat_merger = 0;
	show_news_article = 0;

	constructor()
	{
	}
}

// Called once the script is fully initialized and ready to run
function MainClass::Start()
{
	this.Sleep(1); // Wait briefly to ensure the game world is fully loaded

	this.Init(); // Initialize variables and load saved data

	while (true) {
		local loopStartTick = GSController.GetTick();
		this.HandleEvents(); // Process any new game events
		this.DoLoop();       // Execute the main loop logic (runs once per in-game year)
	}
}

// Initializes script state and restores saved data if available
function MainClass::Init()
{
	this.show_news_article = GSController.GetSetting("show_news_article");

	if (this._loaded_data != null) {
		// Restore previously saved values, defaulting to 0 if missing
		this.last_year = this._loaded_data["last_year"];
		this.stat_bankrupt = this._loaded_data["stat_bankrupt"];
		this.stat_crashes = this._loaded_data["stat_crashes"];
		this.stat_train_crashes = this._loaded_data.rawin("stat_train_crashes") ? this._loaded_data["stat_train_crashes"] : 0;
		this.stat_road_crashes = this._loaded_data.rawin("stat_road_crashes") ? this._loaded_data["stat_road_crashes"] : 0;
		this.stat_flood_crashes = this._loaded_data.rawin("stat_flood_crashes") ? this._loaded_data["stat_flood_crashes"] : 0;
		this.stat_plane_crashes = this._loaded_data.rawin("stat_plane_crashes") ? this._loaded_data["stat_plane_crashes"] : 0;
		this.stat_merger = this._loaded_data["stat_merger"];

		// Log loaded statistics for debugging
		GSLog.Info("Loaded last year: " + this.last_year);
		GSLog.Info("Vehicles destroyed: " + stat_crashes);
		GSLog.Info(" - Trains destroyed: " + stat_train_crashes);
		GSLog.Info(" - Road vehicles destroyed: " + stat_road_crashes);
		GSLog.Info(" - Flooded vehicles destroyed: " + stat_flood_crashes);
		GSLog.Info(" - Aircraft destroyed: " + stat_plane_crashes);
		GSLog.Info("Loaded bankruptcies: " + this.stat_bankrupt);
		GSLog.Info("Loaded mergers: " + this.stat_merger);
	}
}

// Main yearly logic executed continuously during gameplay
function MainClass::DoLoop()
{
	// Check if a new in-game year has started
	local current_year = GSDate.GetYear(GSDate.GetCurrentDate());
	if(current_year == this.last_year) {
		return; // Skip processing until the year changes
	}
	this.last_year = current_year;

	// Count all vehicles currently active in the game
	local count = 0;
	local vehicles = GSVehicleList();
	foreach(id, _ in vehicles) {
		count++;
	}

	// Count the total number of towns
	local towns = GSTownList();
	local town_count = 0;
	foreach(id, _ in towns) {
		town_count++;
	}

	// Count the total number of industries
	local industries = GSIndustryList();
	local industry_count = 0;
	foreach(id, _ in industries) {
		industry_count++;
	}

	// Output yearly statistics to the log console
	GSLog.Info("");
	GSLog.Info("*** " + current_year + " ***");
	GSLog.Info("Number of vehicles in game: " + count);
	GSLog.Info("Vehicles destroyed: " + stat_crashes);
	GSLog.Info(" - Trains destroyed: " + stat_train_crashes);
	GSLog.Info(" - Road vehicles destroyed: " + stat_road_crashes);
	GSLog.Info(" - Flooded vehicles destroyed: " + stat_flood_crashes);
	GSLog.Info(" - Aircraft destroyed: " + stat_plane_crashes);
	GSLog.Info("Number of bankruptcies: " + stat_bankrupt);
	GSLog.Info("Number of mergers: " + stat_merger);
	GSLog.Info("Number of towns: " + town_count);
	GSLog.Info("Number of industries: " + industry_count);

	// Display an optional in-game news article summarizing yearly stats
	this.show_news_article = GSController.GetSetting("show_news_article");
	if (this.show_news_article) {
		local text_to_display = "Vehicles: " + count +
			". Vehicles destroyed: " + stat_crashes +
			" (Trains: " + stat_train_crashes +
			", Road: " + stat_road_crashes +
			", Flooded: " + stat_flood_crashes +
			", Aircraft: " + stat_plane_crashes + ")" +
			". Bankruptcies: " + stat_bankrupt +
			". Mergers: " + stat_merger +
			". Towns: " + town_count +
			". Industries: " + industry_count;

		GSNews.Create(
			GSNews.NT_GENERAL,
			GSText(GSText.STR_EMPTY1, text_to_display),
			GSCompany.COMPANY_INVALID,
			GSNews.NR_NONE,
			0
		);
	}
}

// Handles in-game events such as crashes, bankruptcies, and mergers
function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {
		local event = GSEventController.GetNextEvent();
		if (event == null) return;

		local ev_type = event.GetEventType();
		switch (ev_type) {
			// Company bankruptcy event
			case GSEvent.ET_COMPANY_BANKRUPT: {
				stat_bankrupt++;
				break;
			}
			// Vehicle crash event
			case GSEvent.ET_VEHICLE_CRASHED: {
				stat_crashes++;
				local crash = GSEventVehicleCrashed.Convert(event);
				local reason = crash.GetCrashReason();
				switch(reason) {
					case GSEventVehicleCrashed.CRASH_TRAIN: this.stat_train_crashes += 1; break;
					case GSEventVehicleCrashed.CRASH_RV_UFO: break;
					case GSEventVehicleCrashed.CRASH_RV_LEVEL_CROSSING: this.stat_road_crashes += 1; break;
					case GSEventVehicleCrashed.CRASH_AIRCRAFT_NO_AIRPORT: this.stat_plane_crashes += stat_plane_crashes; break;
					case GSEventVehicleCrashed.CRASH_PLANE_LANDING: this.stat_plane_crashes += stat_plane_crashes; break;
					case GSEventVehicleCrashed.CRASH_FLOODED: this.stat_flood_crashes += stat_flood_crashes; break;
				}
				break;
			}
			// Company merger event
			case GSEvent.ET_COMPANY_MERGER: {
				this.stat_merger++;
				break;
			}
		}
	}
}

// Saves all tracked statistics and relevant state to persistent storage
function MainClass::Save() {
	this.data = {
		last_year = this.last_year,
		stat_bankrupt = this.stat_bankrupt,
		stat_crashes = this.stat_crashes,
		stat_train_crashes = this.stat_train_crashes,
		stat_road_crashes = this.stat_road_crashes,
		stat_flood_crashes = this.stat_flood_crashes,
		stat_plane_crashes = this.stat_plane_crashes,
		stat_merger = this.stat_merger,
	};
	return this.data;
}

// Loads data from a previously saved game state into memory
function MainClass::Load(version, tbl) {
	this._loaded_data = {}
   	foreach(key, val in tbl) {
		this._loaded_data.rawset(key, val);
	}
}
