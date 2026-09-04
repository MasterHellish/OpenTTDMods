function MainClass::DoEarthquake(epicentre, severity, duration)
{
	// Example usage: this.DoEarthquake({ x = 200, y = 200 }, 2, 50);
	// epicentre = { x = 10, y = 20 }; coordinates
	// severity 1+ (recommended: 2–4)
	// duration number eg: 100 - 500

	local current_x = epicentre.x;
	local current_y = epicentre.y;

	local max_x = GSMap.GetMapSizeX();
	local max_y = GSMap.GetMapSizeY();

	for (local i = 0; i < duration; i++) {
		// Pick random step size between 1 and severity +1
		local stepX = GSBase.RandRange(severity) + 1;
		local stepY = GSBase.RandRange(severity) + 1;

		// Randomly flip direction
		if (GSBase.RandRange(2) == 0) stepX = -stepX;
		if (GSBase.RandRange(2) == 0) stepY = -stepY;

		// Apply step
		current_x += stepX;
		current_y += stepY;

		// Keep within map bounds
		if (current_x < 0) current_x = 0;
		if (current_y < 0) current_y = 0;
		if (current_x > max_x) current_x = max_x;
		if (current_y > max_y) current_y = max_y;

		// Scroll viewport to new position
		local tile = GSMap.GetTileIndex(current_x, current_y);
		GSViewport.ScrollEveryoneTo(tile);
	}
}

function MainClass::TownGrowthExplosion(town_id, amount, looper)
{
	// Exmaple usage: this.TownGrowthExplosion(0, 1, 1000);
	// town_id: ID of the town
	// amount: growth amount per step
	// looper: how many times to apply growth

	for (local i = 0; i < looper; i++) {
		GSTown.ExpandTown(town_id, amount);
	}
}

function MainClass::EMP() // In Prograss
{
	local vehicle_list = GSVehicleList();
	foreach(key, value in vehicle_list){
		local companyMode = GSCompanyMode(GSVehicle.GetOwner(key));
		GSVehicle.StartStopVehicle(key);
    }

}