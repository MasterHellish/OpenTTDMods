class FMainClass extends GSInfo {
	function GetAuthor()		{ return "DJ_egg"; }
	function GetName()			{ return "Rainbow Company"; }
	function GetDescription() 	{ return "Rainbow company script by DJ_egg"; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "RACO"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "None"; }

	function GetSettings() {
			AddSetting({
			name = "ticks_between_colours",
			description = "Amount of ticks between colours",
			min_value = 5, max_value = 30000,
			easy_value = 15, medium_value = 15, hard_value = 15, custom_value = 15,
			flags = CONFIG_NONE,
		});
	}
}

RegisterGS(FMainClass());
