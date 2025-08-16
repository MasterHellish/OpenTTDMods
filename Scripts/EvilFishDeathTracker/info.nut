class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Cookie"; }
	function GetName()			{ return "Evil Fish Death Tracker"; }
	function GetDescription() 	{ return "A fun script which displays a news article each year with the number of evil fish which have been killed by bombing river tiles"; }
	function GetVersion()		{ return 1; }
	function GetDate()			{ return "2025/08/16"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "EFDT"; }
	function GetAPIVersion()	{ return "14"; }
	function GetUrl()			{ return ""; }

	function GetSettings() {
	}
}

RegisterGS(FMainClass());
