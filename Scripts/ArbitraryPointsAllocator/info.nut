class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Arbitrary Points Allocator"; }
	function GetDescription() {
		return "Manually sets company points each in-game day based on configured values, enabling custom league table scoring."
	}
	function GetVersion()		{ return 2; }
	function GetDate()			{ return "2026/01/23"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHAP"; }
	function GetAPIVersion()	{ return "15"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/ArbitraryPointsAllocator"; }

	function GetSettings() {
		AddSetting({
			name = "Company 0",
			description = "Company ID #0",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 1",
			description = "Company ID #1",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 2",
			description = "Company ID #2",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 3",
			description = "Company ID #3",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 4",
			description = "Company ID #4",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 5",
			description = "Company ID #5",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 6",
			description = "Company ID #6",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 7",
			description = "Company ID #7",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 8",
			description = "Company ID #8",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 9",
			description = "Company ID #9",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 10",
			description = "Company ID #10",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 1",
			description = "Company ID #11",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 12",
			description = "Company ID #12",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 13",
			description = "Company ID #13",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddSetting({
			name = "Company 14",
			description = "Company ID #14",
			default_value = 0,
			min_value = 0,
			max_value = 10000
			flags = CONFIG_NONE | CONFIG_INGAME
		});
	}
}

RegisterGS(FMainClass());
