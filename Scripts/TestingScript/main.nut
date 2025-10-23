class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;

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

	local x = GSIndustry.SetExclusiveSupplier(0, 999999);
	local y = GSIndustry.SetExclusiveConsumer(0, 999999);

	GSLog.Info("SetExclusiveSupplier:" + x);
	GSLog.Info("SetExclusiveConsumer:" + y);

	local i = GSIndustry.GetExclusiveSupplier(0);
	local j = GSIndustry.GetExclusiveConsumer(0);

	GSLog.Info("GetExclusiveSupplier:" + i);
	GSLog.Info("GetExclusiveConsumer:" + j);

	GSNews.Create(
		GSNews.NT_GENERAL,
		GSText(GSText.STR_EMPTY1, "SetExclusiveSupplier"),
		GSCompany.COMPANY_INVALID,
		GSNews.NR_INDUSTRY,
		0
	);

	// local x = 0;
	// local y = 0;

	// for (local i = 0; i < 500; i++) {
	// 	// Pick random step size between 1 and 5
	// 	local stepX = GSBase.RandRange(3) + 1;  // gives 1..5
	// 	local stepY = GSBase.RandRange(3) + 1;  // gives 1..5

	// 	// Randomly decide to add or subtract
	// 	if (GSBase.RandRange(2) == 0) stepX = -stepX;
	// 	if (GSBase.RandRange(2) == 0) stepY = -stepY;

	// 	// Apply step
	// 	x += stepX;
	// 	y += stepY;

	// 	// Get map center offset by x,y
	// 	local middleTile = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2 + x, GSMap.GetMapSizeY() / 2 + y);

	// 	// Scroll viewport
	// 	GSViewport.ScrollEveryoneTo(middleTile);
	// }

	// local middleTile = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2, GSMap.GetMapSizeY() / 2);
	// GSSign.BuildSign(
	// 	middleTile,
	// 	"Dig Here"
	// );

}

// Your custom logic that runs each loop goes here
function MainClass::DoLoop()
{

	// // LowerTile
	// 		local companyMode = GSCompanyMode(0);
	// 		local middleTilea = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2 -20 , GSMap.GetMapSizeY() / 2 +20);
	// 		local middleTileb = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2 +20, GSMap.GetMapSizeY() / 2 - 20);
	// 		GSTile.LowerTile(middleTilea,GSTile.SLOPE_N);
	// 		GSTile.LowerTile(middleTileb,GSTile.SLOPE_N);
	// 		GSTile.LevelTiles(middleTilea, middleTileb);
	// // •

	// // LowerTile
	// for (local x = 25; x >= -25; x--) {
	// 	for (local y = 25; y >= -25; y--) {
	// 		local middleTile = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2 + x, GSMap.GetMapSizeY() / 2 + y);
	// 		GSTile.DemolishTile(middleTile);
	// 		local companyMode = GSCompanyMode(0);
	// 		GSTile.LowerTile(
	// 			middleTile,
	// 			GSTile.SLOPE_N
	// 		);
	// 		//companyMode = null; < not needed ?
	// 	}
	// }
	// // • Cant do it if stull in the way
	// // • Cost money and needs to be in CompanyMode

	// // DemolishTile
	// for (local x = 25; x >= -25; x--) {
	// 	for (local y = 25; y >= -25; y--) {
	// 		local middleTile = GSMap.GetTileIndex(GSMap.GetMapSizeX() / 2 + x, GSMap.GetMapSizeY() / 2 + y);
	// 		GSTile.DemolishTile(middleTile)
	// 	}
	// }
	// // • 1 per tic
	// // • Does water land, farm, road buidings
	// // • NOT do, company stuff or industries
	// // • Can't be done in CompanyMode


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
