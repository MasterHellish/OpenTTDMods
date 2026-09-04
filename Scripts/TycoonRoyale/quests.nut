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

		// TODO: Re do this, we can't do IDS like this they cannot be guaranteed to be sequential so we need to get a random town and pull its ID
		local town_id_1 = GSBase.RandRange(number_of_towns);
		local town_id_2 = GSBase.RandRange(number_of_towns);
		local town_1_location = GSTown.GetLocation(town_id_1);
		local town_2_location = GSTown.GetLocation(town_id_2);
		local manhattan_distance = GSMap.DistanceManhattan(town_1_location, town_2_location);
		// GSLog.Info("manhattan_distance: " + manhattan_distance);
		// GSLog.Info("manhattan_map_size: " + manhattan_map_size);
		// GSLog.Info("min_distance_per: " + manhattan_map_size * min_distance_per);
		// GSLog.Info("max_distance_per: " + manhattan_map_size * max_distance_per);
		// GSLog.Info("-----------------------------");

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

			break;
		}
	}
}

function MainClass::CreateDeliveryQuest(town_id, cargo_id, quantity)
{

	this.quantity = quantity;
	this.town_id = town_id;
	this.cargo_id = cargo_id;

	// Create the LT
	this.table_id = GSLeagueTable.New(
		"Delivery Quest",
		GSText(GSText.STR_CARGO_TRACKED, 1 << cargo_id),
		""
	);

	// Create the LT companyies
	for (local company_id = GSCompany.COMPANY_FIRST; company_id < GSCompany.COMPANY_LAST; company_id++) {

		if (GSCompany.ResolveCompanyID(company_id) == GSCompany.COMPANY_INVALID) {
			continue;
		}

		local company_name = GSCompany.GetName(company_id);

		this.company_league_table_element_ids[company_id] <- GSLeagueTable.NewElement(
		this.table_id, // table
		0, // rating
		company_id, // company
		company_name, // text
		"" + 0, // score
		GSLeagueTable.LINK_COMPANY, // link_type
		company_id // link_target
		);

		this.company_delivery_quest_cargo[company_id] <- 0;
	}

	// NEWS
	local news_text = "New Quest: Deliver " + quantity + " " + GSCargo.GetName(cargo_id) + " to " + GSTown.GetName(town_id) + ".";
	GSNews.Create(
		GSNews.NT_GENERAL,
		GSText(GSText.STR_EMPTY1, news_text),
		GSCompany.COMPANY_INVALID,
		GSNews.NR_TOWN,
		town_id
	);

}

function MainClass::CheckingDeliveryQuest()
{
	for (local company_id = GSCompany.COMPANY_FIRST; company_id < GSCompany.COMPANY_LAST; company_id++) {
		if (GSCompany.ResolveCompanyID(company_id) != GSCompany.COMPANY_INVALID) {

			// Get delivery amount
			local cargo_delivery_amount = GSCargoMonitor.GetTownDeliveryAmount(
				company_id,
				this.cargo_id,
				town_id,
				true
			);

			// Update the league table
			local previous_deliverd_cargo = this.company_delivery_quest_cargo[company_id];
			local new_cargo_delivery_amount = previous_deliverd_cargo + cargo_delivery_amount;
			this.company_delivery_quest_cargo[company_id] <- new_cargo_delivery_amount;
			GSLeagueTable.UpdateElementScore(
				this.company_league_table_element_ids[company_id],
				this.company_delivery_quest_cargo[company_id],
				"" + this.company_delivery_quest_cargo[company_id]
			);

			if (new_cargo_delivery_amount >= this.quantity){
				// NEWS
				local news_text = "You did it!";
				GSNews.Create(
					GSNews.NT_GENERAL,
					GSText(GSText.STR_EMPTY1, news_text),
					GSCompany.COMPANY_INVALID,
					GSNews.NR_NONE,
					0
				);
			}
		}
	}
}