// TO DO
// we need a function that works out what companies need points
// we need a function that updates the table correctly with the create points
// we need to be able to load and save
// need to be able to handle events (new company for example)
// a parameter for choosing if we assign points or just accumulate cargo count
// Check for moving HQ's, maybe a param to alow it?
class MainClass extends GSController
{
	_load_data = null;
	last_month = 0;
	cargo_id = 0;
	table_id = 0;
	el_id = 0;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Helper function to get the maximum of two values
function max(x1, x2)
{
	return x1 > x2 ? x1 : x2;
}

// Called once the script is fully initialized
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
		this.Sleep(max(1, 74 - ticksPassed));
	}
}

function MainClass::Init()
{
	GSLog.Info("****************************");
	GSLog.Info("*** Master Hellish Cargo Tracker ***");
	GSLog.Info("****************************");
	GSLog.Info("");

	this.cargo_id = GSController.GetSetting("cargo_id");

	local list = GSCargoList()
	GSLog.Info("*** List of Cargos ***");
	foreach(key, value in list){
        GSLog.Info("ID: " + key + ", " + GSCargo.GetName(key));
    }

	this.table_id = GSLeagueTable.New("Cargo Delivary Table", "Test Header", "Test Footer");
	this.el_id = GSLeagueTable.NewElement(
		this.table_id,
		1,
		0,
		"Company: " + "Placeholder company name",
		" Delivered: " + 0,
		GSLeagueTable.LINK_COMPANY,
		0
	);
}

function MainClass::HandleEvents()
{
	if(GSEventController.IsEventWaiting()) {

		local ev = GSEventController.GetNextEvent();
		if (ev == null) return;

		// We are going to need to do some things when there are some events
		// for now we will just have this empty one here
		local ev_type = ev.GetEventType();
		switch (ev_type) {
			case GSEvent.ET_COMPANY_BANKRUPT: {
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
			local company_name = GSCompany.GetName(company_id);
			GSLeagueTable.UpdateElementData(
				this.el_id,
				company_id,
				company_name,
				GSLeagueTable.LINK_COMPANY,
				company_id
			)

			// Get and log Town Delivery Amount
			local town_id = GSTile.GetClosestTown(tile_index);
			local cargo_delivery_amount = GSCargoMonitor.GetTownDeliveryAmount(
				company_id,
				this.cargo_id,
				town_id,
				true
			);
			GSLog.Info(company_name + " delivered " + cargo_delivery_amount);
			GSLeagueTable.UpdateElementScore(
				this.el_id,
				0,
				"Cargo: " + cargo_delivery_amount
			);
		}
	}
}
