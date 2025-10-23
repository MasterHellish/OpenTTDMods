class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName() 			{return "MH Hellish Royale";}
	function GetDescription() 	{ return "Coming Soon"; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHHR"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
		AddSetting({
			name = "enable_debug",
			description = "Enable debug messages in the script log?",
			default_value = 0,
			flags = CONFIG_NONE | CONFIG_INGAME | CONFIG_BOOLEAN
		});
	}
}

RegisterGS(FMainClass());
