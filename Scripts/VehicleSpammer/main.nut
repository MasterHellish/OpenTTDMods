class MainClass extends GSController {
    _load_data = null;

    constructor() {}
}

function MainClass::Save() {
    return {};
}

function MainClass::Load(version, tbl) {}

function max(x1, x2) {
    return x1 > x2 ? x1 : x2;
}

function MainClass::Start() {
    this.Sleep(1);
    this.PostInit();

    while (true) {
        local loopStartTick = GSController.GetTick();

        this.HandleEvents();
        this.DoLoop();

        local ticksPassed = GSController.GetTick() - loopStartTick;
        this.Sleep(max(1, 74 - ticksPassed));
    }
}

function MainClass::HandleEvents() {
    while (GSEventController.IsEventWaiting()) {
        local ev = GSEventController.GetNextEvent();
        if (ev == null) return;
    }
}

function MainClass::PostInit() {
    GSLog.Info("Auto-Clone Script Initialized.");
}

function MainClass::DoLoop() {
    GSLog.Info("========================================");
    GSLog.Info("--- DoLoop Start ---");

    // Initialize state variables
    local target_limit = 5000;
    local cloned_count = 0;
    local depot_index = 0;
    local vehicles_in_depots = [];
    local depot_list = {};
    local depot_tiles = [];

    // Retrieve target company ID
    local target_company;
    try {
        target_company = GSController.GetSetting("target_company_id");
    } catch (e) {
        target_company = 0;
    }

    // Validate company resolution
    if (GSCompany.ResolveCompanyID(target_company) == GSCompany.COMPANY_INVALID) {
        GSLog.Error("CRITICAL: Company ID " + target_company + " could not be resolved.");
        return;
    }

    local mode = GSCompanyMode(target_company);
    local vehicle_list = GSVehicleList();

    // Filter vehicles and map compatible types to depots
    foreach (vehicle_id, _ in vehicle_list) {
        if (GSVehicle.IsPrimaryVehicle(vehicle_id) && GSVehicle.GetState(vehicle_id) == GSVehicle.VS_IN_DEPOT) {
            local v_type = GSVehicle.GetVehicleType(vehicle_id);
            local tile = GSVehicle.GetLocation(vehicle_id);

            vehicles_in_depots.append({ id = vehicle_id, type = v_type });

            // Map depot to type if not already mapped
            if (!(tile in depot_list)) {
                depot_list[tile] <- v_type;
            }
        }
    }

    // Build a flat list of tiles for indexing
    foreach (tile, type in depot_list) {
        depot_tiles.append(tile);
    }

    // Execute balanced cloning
    for (local i = 0; i < target_limit; i++) {
        if (depot_tiles.len() == 0) break;

        local current_depot = depot_tiles[depot_index];
        local required_type = depot_list[current_depot];

        // Find candidates matching this depot's required type
        local candidates = [];
        foreach (v in vehicles_in_depots) {
            if (v.type == required_type) {
                candidates.append(v.id);
            }
        }

        // Move to the next depot if no candidates are found
        if (candidates.len() == 0) {
            depot_index = (depot_index + 1) % depot_tiles.len();
            continue;
        }

        // Select a random candidate and attempt to clone
        local target_vehicle = candidates[GSBase.RandRange(candidates.len())];
        local new_vehicle = GSVehicle.CloneVehicle(current_depot, target_vehicle, true);

        if (GSVehicle.IsValidVehicle(new_vehicle)) {
            cloned_count++;
            depot_index = (depot_index + 1) % depot_tiles.len();

            if (cloned_count % 100 == 0) {
                GSLog.Info("Successfully cloned " + cloned_count + " vehicles...");
                this.Sleep(1);
            }
        } else {
            GSLog.Warning("Cloning halted: " + GSError.GetLastErrorString() + ". Ending pass.");
            break;
        }
    }

    GSLog.Info("--- DoLoop Pass Complete. Total cloned this tick: " + cloned_count + " ---");
    GSLog.Info("========================================");
}