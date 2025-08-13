class FMainClass extends GSInfo {
	function GetAuthor()		{ return "Master Hellish"; }
	function GetName()			{ return "Stat Tracker"; }
	function GetDescription() 	{ return "A simple script that tracks a number of statistics and logs them each year In the script log."; }
	function GetVersion()		{ return 0; }
	function GetDate()			{ return "2025/07/19"; }
	function CreateInstance()	{ return "MainClass"; }
	function GetShortName()		{ return "MHST"; }
	function GetAPIVersion()	{ return "13"; }
	function GetUrl()			{ return "https://masterhellish.net"; }

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

RegisterGS(FMainClass());
