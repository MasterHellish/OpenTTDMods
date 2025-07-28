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

	ticksBetweenColours = GSController.GetSetting("ticks_between_colours");

	constructor()
	{
	}
}

function max(x1, x2)
{
	return x1 > x2? x1 : x2;
}

function MainClass::Start()
{
	// Wait for the game to start
	this.Sleep(1);

	while (true) {
		local loopStartTick = GSController.GetTick();

		this.DoLoop();

		// Sleep for amount of ticks based on the setting
		local ticksPassed = GSController.GetTick() - loopStartTick;
		this.Sleep(max(1, ticksBetweenColours - ticksPassed));
	}
}

function MainClass::DoLoop()
{
	local companyMode = GSCompanyMode(0);
	local nextColour = this.colours[index];
	GSCompany.SetPrimaryLiveryColour(GSCompany.LS_DEFAULT, nextColour);
	index += 1;
	index = index % this.colours.len();
}