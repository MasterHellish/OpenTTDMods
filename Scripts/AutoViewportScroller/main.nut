class MainClass extends GSController
{
	// Used to load saved data (currently unused)
	_load_data = null;

	known_stations = {}; // station_id is the key
	known_depots   = {}; // key = TileIndex (depot tile)
	known_bridges  = {}; // key = BridgeID or TileIndex (see note)
	known_signs    = {}; // key = SignID
	known_vehicles = {}; // key = VehicleID

    // Cooldown tracking variables
    days_since_last_scroll = 0;

	// Constructor – runs once at the start of the script
	constructor()
	{
	}
}

function MainClass::Start()
{
	this.Sleep(1);

	this.PostInit();

	while (true) {
		local loopStartTick = GSController.GetTick();
		this.HandleEvents();
		this.DoLoop();
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep((74 - ticksPassed) > 1 ? (74 - ticksPassed) : 1);
	}
}

function MainClass::HandleEvents()
{
	while(GSEventController.IsEventWaiting())
	{
		local ev = GSEventController.GetNextEvent();

		if(ev == null)
			return;
	}
}

function MainClass::PostInit()
{
	GSLog.Info("You can get a list of current connected clients using the command clients in OpenTTD console. Which you can open with ` key");
}

function MainClass::DoLoop()
{
    local client_id = GSController.GetSetting("client_id");

    this.days_since_last_scroll++;
    local can_scroll = (this.days_since_last_scroll >= GSController.GetSetting("scroll_cooldown_days"));

    local station_tile = CheckForNewStationAndReturnTile();
    if (GSController.GetSetting("scroll_on_station") && can_scroll && station_tile != GSMap.TILE_INVALID) {
        GSViewport.ScrollClientTo(client_id, station_tile);
        this.days_since_last_scroll = 0;
        return;
    }

    local depot_tile = CheckForNewDepotAndReturnTile();
    if (GSController.GetSetting("scroll_on_depot") && can_scroll && depot_tile != GSMap.TILE_INVALID) {
        GSViewport.ScrollClientTo(client_id, depot_tile);
        this.days_since_last_scroll = 0;
        return;
    }

    local vehicle_tile = CheckForNewVehicleAndReturnTile();
    if (GSController.GetSetting("scroll_on_vehicle") && can_scroll && vehicle_tile != GSMap.TILE_INVALID) {
         GSViewport.ScrollClientTo(client_id, vehicle_tile);
         this.days_since_last_scroll = 0;
         return;
    }

}

function MainClass::CheckForNewStationAndReturnTile()
{
    local current_stations = {};
    local new_stations = [];
    local total_scanned = 0;

    for (local company_id = GSCompany.COMPANY_FIRST;
         company_id < GSCompany.COMPANY_LAST;
         company_id++)
    {
        if (GSCompany.ResolveCompanyID(company_id) == GSCompany.COMPANY_INVALID)
            continue;
        {

            local mode = GSCompanyMode(company_id);

            local station_list = GSStationList(GSStation.STATION_ANY);
            local company_station_count = 0;

            foreach (station_id, value in station_list)
            {
                company_station_count++;
                total_scanned++;

                current_stations[station_id] <- true;

                if (!(station_id in this.known_stations))
                {
                    GSLog.Info("New station detected -> ID: " + station_id +
                               " (Company " + company_id + ")");
                    new_stations.append(station_id);
                }
            }

            GSLog.Info("Company " + company_id +
                       " station count: " + company_station_count);
        }
    }

    // Update snapshot BEFORE returning
    this.known_stations = current_stations;

    if (new_stations.len() == 0)
    {
        return GSMap.TILE_INVALID;
    }

    local picked_station_id = new_stations[0];
    local tile = GSStation.GetLocation(picked_station_id);

    return tile;
}

function MainClass::CheckForNewDepotAndReturnTile()
{
    local current = {};
    local new_tiles = [];
    local total_scanned = 0;

    local transport_types = [
        GSTile.TRANSPORT_RAIL,
        GSTile.TRANSPORT_ROAD,
        GSTile.TRANSPORT_WATER,
        GSTile.TRANSPORT_AIR
    ];

    for (local company = GSCompany.COMPANY_FIRST; company < GSCompany.COMPANY_LAST; company++)
    {
        local resolved = GSCompany.ResolveCompanyID(company);
        if (resolved == GSCompany.COMPANY_INVALID) continue;

        {
            local mode = GSCompanyMode(resolved);

            foreach (tt in transport_types)
            {
                local depot_list = GSDepotList(tt);
                local count = 0;

                foreach (tile, v in depot_list)
                {
                    count++;
                    total_scanned++;

                    current[tile] <- true;

                    if (!(tile in this.known_depots))
                    {
                        GSLog.Info("New depot detected -> Tile: " + tile + " (Company " + resolved + " TT " + tt + ")");
                        new_tiles.append(tile);
                    }
                }

                GSLog.Info("Company " + resolved + " depots for TT " + tt + ": " + count);
            }
        }
    }

    this.known_depots = current;

    if (new_tiles.len() == 0)
    {
        return GSMap.TILE_INVALID;
    }

    local picked = new_tiles[0];

    return picked;
}

function MainClass::CheckForNewVehicleAndReturnTile()
{
    local current = {};
    local new_ids = [];
    local total_scanned = 0;

    for (local c = GSCompany.COMPANY_FIRST; c < GSCompany.COMPANY_LAST; c++)
    {
        local company_id = GSCompany.ResolveCompanyID(c);
        if (company_id == GSCompany.COMPANY_INVALID) continue;

        {
            local mode = GSCompanyMode(company_id);

            local vehicle_list = GSVehicleList();

            local company_count = 0;
            foreach (vehicle_id, v in vehicle_list)
            {
                company_count++;
                total_scanned++;

                current[vehicle_id] <- true;

                if (!(vehicle_id in this.known_vehicles))
                {
                    new_ids.append(vehicle_id);
                }
            }
        }
    }

    this.known_vehicles = current;

    if (new_ids.len() == 0)
    {
        return GSMap.TILE_INVALID;
    }

    local picked_vehicle_id = new_ids[0];
    local tile = GSVehicle.GetLocation(picked_vehicle_id);

    return tile;
}
