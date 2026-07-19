class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Vehicle Spammer"; }
	function GetDescription() 	{ return "Automatically mass-clones vehicles for a specified company."; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/08/29"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHVS"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/VehicleSpammer"; }

	function GetSettings() {
		AddSetting({
			name = "target_company_id",
			description = "target_company_id",
			default_value = -1,
			min_value = -1,
			max_value = 100
			flags = CONFIG_NONE | CONFIG_INGAME
		});
	}
}

RegisterGS(FMainClass());
