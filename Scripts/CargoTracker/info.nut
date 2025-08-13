class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Cargo Tracker"; }
	function GetDescription() 	{ return "Description"; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/25"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHHT"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
		AddSetting({
			name = "cargo_id",
			description = "ID of the cargo to track",
			default_value = 0,
			min_value = 0,
			max_value = 99,
			flags = CONFIG_NONE | CONFIG_INGAME
		});

		// This is for a possable future feature
		// AddSetting({
		// 	name = "use_points_scoring",
		// 	description = "Count the cargo or score points?",
		// 	default_value = 0,
		// 	min_value = 0,
		// 	max_value = 1,
		// 	flags = CONFIG_NONE | CONFIG_INGAME
		// });
		// AddLabels("use_points_scoring", {_0 = "Count the cargo", _1 = "Score points"});

		// AddSetting({
		// 	name = "pt_first",
		// 	description = "Number of points for 1st place in a month",
		// 	default_value = 3,
		// 	min_value = 0,
		// 	max_value = 100,
		// 	flags = CONFIG_NONE | CONFIG_INGAME
		// });

		// AddSetting({
		// 	name = "pt_second",
		// 	description = "Number of points for 2nd place in a month",
		// 	default_value = 2,
		// 	min_value = 0,
		// 	max_value = 100,
		// 	flags = CONFIG_NONE | CONFIG_INGAME
		// });

		// AddSetting({
		// 	name = "pt_third",
		// 	description = "Number of points for 3rd place in a month",
		// 	default_value = 1,
		// 	min_value = 0,
		// 	max_value = 100,
		// 	flags = CONFIG_NONE | CONFIG_INGAME
		// });
	}
}

RegisterGS(FMainClass());
