state("momo1_v151")
{

	//32 In Main Menu, 0 InGame
	byte MainMenu: 0x018B624, 0x20, 0x26;

	//Keeps track of the current room number
	short room : 0x018A014, 0x0;

	//Keeps track of the X and Y position of the character (real coordinates)
	double xPos : 0x001AF2F4, 0x80, 0x4, 0x0, 0x58;
	double yPos : 0x001AF2F4, 0x80, 0x4, 0x0, 0x60;

	//Keeps track of the Boss health
	//Starts at 180 in both phases, shotgun does 5 damage
	//Boss changes phase and dies when Health <= 11
	double bossHealth : 0x001AF2F4, 0x80, 0x20C, 0x24, 0x10C, 0x4, 0x10;
}


startup
{

	settings.Add("splits", true, "Splits");

	settings.Add("zone1", true, "Zone 1", "splits");
	settings.Add("zone2", true, "Zone 2", "splits");
	settings.Add("zone3", true, "Zone 3", "splits");
	settings.Add("zone4", true, "Zone 4", "splits");
	settings.Add("zone5", true, "Zone 5", "splits");
	settings.Add("zone6", true, "Zone 6", "splits");
	settings.Add("zone7", true, "Zone 7", "splits");
	settings.Add("zone8", true, "Zone 8", "splits");
	settings.SetToolTip("zone8", "This split activates when you enter the boss room");
	settings.Add("boss", true, "Boss", "splits");
}


init
{

	// HashSet to hold splits already hit
	// It prevents Livesplit from splitting on the same split multiple times
	vars.Splits = new HashSet<string>();

	//To keep track of current boss phase
	vars.bossPhase = 1;
}


update
{	

	// Clear any hit splits and the boss current phase if timer stops
	if (timer.CurrentPhase == TimerPhase.NotRunning)
	{

		vars.Splits.Clear();
		vars.bossPhase = 1;
	}


	//Reset BossPhase in case of dying or exitting to main menu
	if (old.room == 80 && current.room == 2)
	{

		vars.bossPhase = 1;
	}
}


start
{
	return (old.MainMenu == 32 && current.MainMenu == 0);
}


reset
{

    	if (current.room == 73)
    	{

        	return true;
    	}
}


split
{

    	if (current.room == 14 && current.xPos >= 281)
    	{

		if (vars.Splits.Contains("one"))
		{

			return false;
		}

		vars.Splits.Add("one");
		return settings["zone1"];
    	}
    

    	if (current.room == 20 && current.xPos >= 281)
    	{

		if (vars.Splits.Contains("two"))
		{

			return false;
		}

		vars.Splits.Add("two");
		return settings["zone2"];
    	}

    	if (current.room == 42 && current.xPos >= 281)
    	{

		if (vars.Splits.Contains("three"))
		{

			return false;
		}

		vars.Splits.Add("three");
		return settings["zone3"];
    	}


    	if (current.room == 52 && current.xPos <= 167)
    	{

		if (vars.Splits.Contains("four"))
		{

			return false;
		}

		vars.Splits.Add("four");
		return settings["zone4"];
    	}


    	if (current.room == 58 && current.xPos <= 327)
    	{

		if (vars.Splits.Contains("five"))
		{

			return false;
		}

		vars.Splits.Add("five");
		return settings["zone5"];
    	}
    

    	if (current.room == 65 && current.yPos < 35 && current.xPos <= 102)
    	{

		if (vars.Splits.Contains("six"))
		{

			return false;
		}

		vars.Splits.Add("six");
		return settings["zone6"];
    	}
    

    	if (current.room == 72 && current.xPos >= 121)
    	{

		if (vars.Splits.Contains("seven"))
		{

			return false;
		}

		vars.Splits.Add("seven");
		return settings["zone7"];
    	}
    

    	if (current.room == 80 && old.room == 79)
    	{

		if (vars.Splits.Contains("eight"))
		{

			return false;
		}

		vars.Splits.Add("eight");
		return settings["zone8"];
    	}
 

	//"old.bossHealth > 11" is necesary to prevent a false split from happening. From entering the boss room until Cheeoko (big white balloon we call boss) appears
    	if (current.room == 80 && current.bossHealth <= 11 && old.bossHealth > 11)
    	{

		if (vars.bossPhase == 1){

			vars.bossPhase = 2;
			return false;
		}

		else if(vars.Splits.Contains("boss")){

			return false;
		}

		vars.Splits.Add("boss");
		return settings["boss"];
    	}
}
