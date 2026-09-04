class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName() 			{return "Tycoon Royale";}
	function GetDescription() 	{ return ""; }
	function GetVersion()		{ return 0.1; }
	function GetDate()			{ return "2025/07/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHTR"; }
	function GetAPIVersion()	{ return "14"; }
	function GetURL()			{ return ""; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
