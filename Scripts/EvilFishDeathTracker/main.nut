class MainClass extends GSController
{
	loaded_data = false;
	last_year = 0;
	river_tile_list = null;
}

function MainClass::Start()
{
	this.Sleep(1); // Let the game initialize first
	this.Init();

	while (true) {
		local loopStartTick = GSController.GetTick();
		this.DoLoop();
	}
}

function MainClass::Init()
{
	if (this.loaded_data) {
		GSLog.Info("Loaded last year: " + this.last_year);
		GSLog.Info("Loaded river tile count: " + this.river_tile_list.Count());
	} else {
		this.last_year = GSDate.GetYear(GSDate.GetCurrentDate());
		GSLog.Info("Starting year: " + this.last_year);

		this.river_tile_list = GSTileList();
		for (local x = 0; x < GSMap.GetMapSizeX(); x++) {
			for (local y = 0; y < GSMap.GetMapSizeY(); y++) {
				local tile = GSMap.GetTileIndex(x, y);
				if (GSTile.IsRiverTile(tile)) {
					GSLog.Info("Tile " + tile + " is river");
					this.river_tile_list.AddTile(tile);
				}
			}
		}
		GSLog.Info("Initial river tile count: " + this.river_tile_list.Count());
	}
}

function MainClass::DoLoop()
{
	if (this.river_tile_list.Count() == 0) {
		return;
	}

	local current_year = GSDate.GetYear(GSDate.GetCurrentDate());
	if (current_year == this.last_year) {
		return;
	}
	this.last_year = current_year;

	local bombed_river_tile_list = GSTileList();
	foreach (tile, _ in this.river_tile_list){
		if (!GSTile.IsRiverTile(tile)) {
			GSLog.Info("Tile " + tile + " is no longer river");
			bombed_river_tile_list.AddTile(tile);
		}
    }

	this.river_tile_list.RemoveList(bombed_river_tile_list);

	local dead_evil_fish = 0;

	for (local i = 0; i < bombed_river_tile_list.Count(); i++) {
		dead_evil_fish += (GSBase.RandRange(10) + 1);
	}

	GSLog.Info("Bombed river last year: " + bombed_river_tile_list.Count());
	GSLog.Info("Number of evil fish killed last year: " + dead_evil_fish);
	GSLog.Info("Remaining river tile count: " + this.river_tile_list.Count());

	local news = null;

	if (this.river_tile_list.Count() == 0) {
		news = GSText(GSText.STR_ALL_EVIL_FISH_KILLED);
	} else {
		news = (dead_evil_fish == 0) ? GSText(GSText.STR_NO_EVIL_FISH_KILLED) : GSText(GSText.STR_EVIL_FISH_KILLED, dead_evil_fish);
	}

	GSNews.Create(
		GSNews.NT_GENERAL,
		news,
		GSCompany.COMPANY_INVALID,
		GSNews.NR_NONE,
		0
	);
}

function MainClass::Save() {
	local river_tile_array = [];
	foreach (tile, _ in this.river_tile_list){
		river_tile_array.append(tile);
    }

	GSLog.Info("Saving year: " + this.last_year);
	GSLog.Info("Saving river count: " + river_tile_array.len());

	return {
		last_year = this.last_year,
		river_tile_array = river_tile_array,
	};
}

function MainClass::Load(version, data) {
	GSLog.Info("Loading settings and data from savegame made with version " + version + " of the script...");

	local loaded_data = false;

	switch (version) {
		case 1:
			local loaded_keys = 0;
			foreach (key, val in data) {
				switch (key) {
					case "last_year":
						this.last_year = val;
						loaded_keys++;
						break;
					case "river_tile_array":
						this.river_tile_list = GSTileList();
						while (val.len() > 0) {
							this.river_tile_list.AddTile(val.pop());
						}
						loaded_keys++;
						break;
					default:
						GSLog.Warning("Unhandled save data key: " + key);
						break;
				}
			}
			if (loaded_keys == 2) {
				loaded_data = true;
			} else {
				GSLog.Warning("Failed to load all the expected keys for version " + version);
			}
			break;
		default:
			GSLog.Warning("Unhandled version: " + version);
			break;
	}

	this.loaded_data = loaded_data;
}