class InfoClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Stat Tracker"; }
	function GetDescription() {
	    return "Tracks a number of statistics (vehicles, crashes (total, train, road, flood, planes) bankruptcies, mergers, towns, industries). Logs them each year/period in the AI/Game Script Debug log or news feed (if enabled)."
	}
	function GetVersion()		{ return 7; }
	function GetDate()			{ return "2025/07/19"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHST"; }
	function GetAPIVersion()	{ return "13"; }
	function GetURL()			{ return "https://github.com/MasterHellish/OpenTTDMods/tree/main/Scripts/StatTracker"; }

	function GetSettings() {
		AddSetting({
			name = "show_news_article",
			description = "Show yearly news article with stats?",
			default_value = 0,
			min_value = 0,
			max_value = 1,
			flags = CONFIG_NONE | CONFIG_INGAME
		});
		AddLabels("show_news_article", {_0 = "No", _1 = "Yes"});
	}
}

RegisterGS(InfoClass());
