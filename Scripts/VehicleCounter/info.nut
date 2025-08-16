class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Vehicle Counter"; }
	function GetDescription() 	{ return "Every month counts the number of vehicles in the game and makes a log in the script logs"; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/07/19"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHVC"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
