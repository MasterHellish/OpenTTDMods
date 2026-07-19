class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Auto Viewport Scroller"; }
	function GetDescription() 	{ return "Automatically scrolls a specific player's camera to newly built stations, depots, and vehicles."; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2026/07/19"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHVS"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/AutoViewportScroller"; }

	function GetSettings() {
		AddSetting({
			name = "client_id",
			description = "Client Id",
			default_value = 1,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "scroll_cooldown_days",
			description = "Scroll Cooldown Days",
			default_value = 5,
			min_value = 1,
			max_value = 50
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "scroll_on_station",
			description = "Scroll On New Station",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});
		AddSetting({
			name = "scroll_on_depot",
			description = "Scroll On New Depot",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});
		AddSetting({
			name = "scroll_on_vehicle",
			description = "Scroll On New Vehicle",
			default_value = 1,
			flags = CONFIG_NONE | CONFIG_BOOLEAN | CONFIG_INGAME
		});
	}
}

RegisterGS(FMainClass());
