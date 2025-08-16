class MainClass extends GSController
{
	loaded_data = false;
	last_year = 0;
	river_tile_list = null;
	evil_fish_tile_list = null;
	single_width_setting = true;
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
	this.single_width_setting = GSController.GetSetting("single_width_setting");

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

	this.UpdateTileLists();

	GSLog.Info("Evil fish tile count: " + this.evil_fish_tile_list.Count());
}

function MainClass::DoLoop()
{
	if (this.evil_fish_tile_list.Count() == 0) {
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

	local previous_evil_fish_tile_count = this.evil_fish_tile_list.Count();

	this.evil_fish_tile_list.RemoveList(bombed_river_tile_list);
	this.river_tile_list.RemoveList(bombed_river_tile_list);

	local bombed_evil_fish_tiles = previous_evil_fish_tile_count - this.evil_fish_tile_list.Count();

	local dead_evil_fish = 0;

	for (local i = 0; i < bombed_evil_fish_tiles; i++) {
		dead_evil_fish += (GSBase.RandRange(10) + 1);
	}

	this.UpdateTileLists();

	GSLog.Info("Bombed river last year: " + bombed_river_tile_list.Count());
	GSLog.Info("Bombed evil fish river last year: " + bombed_evil_fish_tiles);
	GSLog.Info("Number of evil fish killed last year: " + dead_evil_fish);
	GSLog.Info("Remaining river tile count: " + this.river_tile_list.Count());
	GSLog.Info("Remaining evil fish river tile count: " + this.evil_fish_tile_list.Count());

	local news = null;

	if (this.evil_fish_tile_list.Count() == 0) {
		news = GSText(GSText.STR_ALL_EVIL_FISH_KILLED);
		this.river_tile_list = GSTileList();
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

// Returns 1 if the neighbouring tile at the given x/y coordinates is valid and is a river tile, otherwise 0
function MainClass::IsNeighbourValidRiverTile(tile, x, y) {
	local neighbour_tile = tile + GSMap.GetTileIndex(x, y);

	if (!GSMap.IsValidTile(neighbour_tile)) {
		return 0;
	} else {
		return GSTile.IsRiverTile(neighbour_tile) ? 1 : 0;
	}
}

function MainClass::UpdateEvilFishStatus(tile, single_width_setting) {
	if (!single_width_setting) {
		return 1; // All river tiles contain evil fish
	}

	// To determine if a river tile is single width:
	// - Check each 2x2 group containing the subject tile
	// - If all 4 tiles in any group are river, the subject tile is not single-width

	local n_tile  = MainClass.IsNeighbourValidRiverTile(tile, -1, -1);
	local ne_tile = MainClass.IsNeighbourValidRiverTile(tile, 0, -1);
	local e_tile  = MainClass.IsNeighbourValidRiverTile(tile, 1, -1);
	local se_tile = MainClass.IsNeighbourValidRiverTile(tile, 1, 0);
	local s_tile  = MainClass.IsNeighbourValidRiverTile(tile, 1, 1);
	local sw_tile = MainClass.IsNeighbourValidRiverTile(tile, 0, 1);
	local w_tile  = MainClass.IsNeighbourValidRiverTile(tile, -1, 1);
	local nw_tile = MainClass.IsNeighbourValidRiverTile(tile, -1, 0);

	local north_group = n_tile + ne_tile + nw_tile;
	local east_group = e_tile + ne_tile + se_tile;
	local south_group = s_tile + se_tile + sw_tile;
	local west_group = w_tile + nw_tile + sw_tile;

	if (north_group == 3 || east_group == 3 || south_group == 3 || west_group == 3) {
		return 0; // Tile is part of a 2x2 river group, so not single-width
	} else {
		return 1;
	}
}

function MainClass::UpdateTileLists() {
	this.river_tile_list.Valuate(this.UpdateEvilFishStatus, this.single_width_setting);

	this.evil_fish_tile_list = GSTileList();
	this.evil_fish_tile_list.AddList(this.river_tile_list);
	this.evil_fish_tile_list.RemoveValue(0);
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
		case 2:
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
