class MainClass extends GSController
{
	_loaded_data = null;
	data = null; //data to save
	last_year = 0;
	stat_bankrupt = 0;
	stat_crashes = 0;
	stat_merger = 0;
	show_news_article = 0;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Called once the script is fully initialized
function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first

	this.Init();

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

	}
}

function MainClass::Init()
{
	this.show_news_article = GSController.GetSetting("show_news_article");

	if (this._loaded_data != null) {
		this.last_year = this._loaded_data["last_year"];
		this.stat_bankrupt = this._loaded_data["stat_bankrupt"];
		this.stat_crashes = this._loaded_data["stat_crashes"];
		this.stat_merger = this._loaded_data["stat_merger"];
		GSLog.Info("Loaded last year: " + this.last_year);
		GSLog.Info("Loaded crashes: " + this.stat_crashes);
		GSLog.Info("Loaded bankruptcies: " + this.stat_bankrupt);
		GSLog.Info("Loaded mergers: " + this.stat_merger);
	}
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	//Check for new year
	local current_year = GSDate.GetYear(GSDate.GetCurrentDate());
	if(current_year == this.last_year) {
		return;
	}
	this.last_year = current_year;

	// Get vehicle count
	local count = 0;
	local vehicles= GSVehicleList();
	foreach(id, _ in vehicles) {
		count++;
	}

	// Log it
	GSLog.Info("");
	GSLog.Info("*** " + current_year + " ***");
	GSLog.Info("Number of vehicles in game: " + count);
	GSLog.Info("Number of crashes: " + stat_crashes);
	GSLog.Info("Number of bankruptcies: " + stat_bankrupt);
	GSLog.Info("Number of mergers: " + stat_merger);

	// Notification
	if (this.show_news_article){
		local text_to_diplay = "Vehicles in game: " + count + ". Crashes: " + stat_crashes + ". Bankruptcies: " + stat_bankrupt + ". Mergers: " + stat_merger;
		GSNews.Create(
			GSNews.NT_GENERAL,
			GSText(GSText.STR_EMPTY1, text_to_diplay),
			GSCompany.COMPANY_INVALID,
			GSNews.NR_NONE,
			0
		);
	}
}

function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {
		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		local ev_type = ev.GetEventType();
		switch (ev_type) {
			case GSEvent.ET_COMPANY_BANKRUPT: {
				stat_bankrupt++;
				break;
			}
			case GSEvent.ET_VEHICLE_CRASHED: {
				stat_crashes++;
				break;
			}
			case GSEvent.ET_COMPANY_MERGER: {
				this.stat_merger++;
				break;
			}
		}
	}
}

function MainClass::Save() {
	this.data = {
		last_year = this.last_year,
		stat_bankrupt = this.stat_bankrupt,
		stat_crashes = this.stat_crashes,
		stat_merger = this.stat_merger,
	};
	return this.data;
}

function MainClass::Load(version, tbl) {
	this._loaded_data = {}
   	foreach(key, val in tbl) {
		this._loaded_data.rawset(key, val);
	}
}