class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;

	// TODO: Try and move theas later to some place in the quest area
	company_delivery_quest_cargo = {};
	table_id = 0;
	company_league_table_element_ids = {};
	cargo_id = 0;
	town_id = 0;
	quantity = 0;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

// Called when the script state is saved (e.g., during a savegame)
function MainClass::Save()
{
	GSLog.Info("This is the log for when we are saving");
	return {}; // You can return a table of data here to persist
}

// Called when the script state is loaded
function MainClass::Load(version, tbl)
{
	GSLog.Info("This is the log for when we are loading");

	// You can restore saved data from 'tbl' here
	foreach(key, val in tbl)
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

	this.PostInit(); // Do any setup actions here

	// Main loop – runs once per day
	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents(); // Process incoming events
		this.DoLoop();       // Your main game logic

		// Ensure consistent tick timing (1 day = 74 ticks)
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, 74 - ticksPassed));

		//this.EMP(); TESTING ONLY
	}
}

// Handle any queued events (e.g., bankruptcies, company changes)
function MainClass::HandleEvents()
{
	while(GSEventController.IsEventWaiting())
	{
		local ev = GSEventController.GetNextEvent();

		if(ev == null)
			return;

		// Handle your events here
	}
}

// Perform setup actions like logging and placing signs
function MainClass::PostInit()
{

	this.CreateDeliveryQuest(0, 0, 50);

	// TESTING ONLY
	//this.CreateCustomSubsidy(0, 0.15, 0.50);

	// TESTING ONLY
	// local town_tile = GSTown.GetLocation(0)
	// GSViewport.ScrollEveryoneTo(town_tile);
	// this.TownGrowthExplosion(0, 1000, 1000);

	// TESTING ONLY
	//this.DoEarthquake({ x = 200, y = 200 }, 2, 50);
}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{
	this.CheckingDeliveryQuest();
}

// Called when a new company is created
function MainClass::InitNewCompany(cid)
{
	// Example: set initial cash, assign goals, etc.
}

function MainClass::QueryMonitor(ind, cid, cargoType)
{
}

function MainClass::QueryMonitorMultiple(ind, cid, cargoType)
{
}

function MainClass::UpdateMonth(cid)
{
}

function MainClass::CancelMonitors(cid)
{
}

function MainClass::UpdateGoals(cid)
{
}

function MainClass::UpdateGlobal()
{
}

require("disasters.nut");
require("quests.nut");