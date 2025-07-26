/*
 * This file is part of a game script for OpenTTD: Rainbow Company
 */

class MainClass extends GSController 
{
	index = 0;
	colours = [
		GSCompany.COLOUR_RED,
		GSCompany.COLOUR_ORANGE,
		GSCompany.COLOUR_YELLOW,
		GSCompany.COLOUR_GREEN,
		GSCompany.COLOUR_DARK_GREEN,
		GSCompany.COLOUR_PALE_GREEN,
		GSCompany.COLOUR_LIGHT_BLUE,
		GSCompany.COLOUR_BLUE,
		GSCompany.COLOUR_DARK_BLUE,
		GSCompany.COLOUR_MAUVE,
		GSCompany.COLOUR_PURPLE,
		GSCompany.COLOUR_BROWN,
		GSCompany.COLOUR_GREY,
		GSCompany.COLOUR_WHITE,
		GSCompany.COLOUR_CREAM,
		GSCompany.COLOUR_PINK];

	constructor()
	{
	}
}

function MainClass::Save()
{
	return {};
}

function MainClass::Load(version, tbl)
{
}

function max(x1, x2)
{
	return x1 > x2? x1 : x2;
}

function MainClass::Start()
{
	// Wait for the game to start
	this.Sleep(1);

	this.PostInit();

	while (true) {
		local loopStartTick = GSController.GetTick();

		this.HandleEvents();
		this.DoLoop();

		// Sleep for "12 ticks"
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, 1 * 15 - ticksPassed));
	}
}

function MainClass::HandleEvents()
{
	while(GSEventController.IsEventWaiting())
	{
		local ev = GSEventController.GetNextEvent();

		if(ev == null)
			return;
	}
}

function MainClass::PostInit()
{
	GSLog.Info("PostInit");
}

function MainClass::DoLoop()
{
	local companyMode = GSCompanyMode(0);
	local randomColour = this.colours[index];
	GSCompany.SetPrimaryLiveryColour(GSCompany.LS_DEFAULT, randomColour);
	index += 1;
	index = index % this.colours.len();

}