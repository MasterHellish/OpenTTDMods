/**
 * Create a custom subsidy between two towns.
 *
 * Usage:
 *   this.CreateCustomSubsidy(0, 0.15, 0.50);
 *
 * @param cargo_id         Cargo type (e.g. 0 = passengers)
 * @param min_distance_per Minimum distance as fraction of manhattan map size (e.g. 0.15 = 15%)
 * @param max_distance_per Maximum distance as fraction of manhattan map size (e.g. 0.50 = 50%)
 */
function MainClass::CreateCustomSubsidy(cargo_id, min_distance_per, max_distance_per)
{
	local number_of_towns = GSTown.GetTownCount();
	local manhattan_map_size = GSMap.GetMapSizeX() + GSMap.GetMapSizeY();

	for (local i = 0; i < 100; i++) {

		local town_id_1 = GSBase.RandRange(number_of_towns);
		local town_id_2 = GSBase.RandRange(number_of_towns);
		local town_1_location = GSTown.GetLocation(town_id_1);
		local town_2_location = GSTown.GetLocation(town_id_2);
		local manhattan_distance = GSMap.DistanceManhattan(town_1_location, town_2_location);
		this.Debug("manhattan_distance: " + manhattan_distance, 1);
		this.Debug("manhattan_map_size: " + manhattan_map_size, 1);
		this.Debug("min_distance_per: " + manhattan_map_size * min_distance_per, 1);
		this.Debug("max_distance_per: " + manhattan_map_size * max_distance_per,1);
		this.Debug("-----------------------------",1);

		if (
			manhattan_distance > manhattan_map_size * min_distance_per
			&& manhattan_distance < manhattan_map_size * max_distance_per
		)
		{
			GSSubsidy.Create(
				cargo_id,
				GSSubsidy.SPT_TOWN,
				town_id_1,
				GSSubsidy.SPT_TOWN,
				town_id_2
			)

			// TO DO: IsValidSubsidy check

			// TO DO: Update this with better info
			local news_text = "New Quest: Connect " + GSTown.GetName(town_id_1) + " to " + GSTown.GetName(town_id_2) + " with " + GSCargo.GetName(cargo_id);
			GSNews.Create(
				GSNews.NT_GENERAL,
				GSText(GSText.STR_EMPTY1, news_text),
				GSCompany.COMPANY_INVALID,
				GSNews.NR_NONE,
				0
			);
			this.Debug("New Quest Created: Connect " + GSTown.GetName(town_id_1) + " and " + GSTown.GetName(town_id_2) + " with " + GSCargo.GetName(cargo_id), 1);
			break;
		}
	}
}