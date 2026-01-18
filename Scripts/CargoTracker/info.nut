class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Cargo Tracker"; }
	function GetDescription() {
		return "Tracks how much of a chosen cargo is delivered to the town nearest each company's HQ, shown in a league table."
	}
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/08/15"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHCT"; }
	function GetAPIVersion()	{ return "15"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/CargoTracker"; }

	function GetSettings() {
		AddSetting({
			name = "cargo_id",
			description = "ID of the cargo to track",
			default_value = 0,
			min_value = 0,
			max_value = 99,
			flags = CONFIG_NONE | CONFIG_INGAME
		});
	}
}

RegisterGS(FMainClass());
