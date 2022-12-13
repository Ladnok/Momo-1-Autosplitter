state("momo1_v151") {

	//Keeps track of whether the player can press a key on the main menu or not.
	double CanPress: 0x1AF2F4, 0x80, 0x7C, 0x0, 0x10C, 0x4, 0x60;

	//Keeps track of the current room number
	short room : 0x018A014, 0x0;

	//Keeps track of the "hasSaved" variable for the savePoint in the current room (if there is one)
	double hasSaved : 0x1AF2F4, 0x80, 0x8C, 0x0, 0x10C, 0x4, 0x10;

	//Keeps track of the Boss health
	double bossHealth : 0x001AF2F4, 0x80, 0x20C, 0x24, 0x10C, 0x4, 0x10;
}

startup {

	settings.Add("zone1", true, "Zone 1");
	settings.Add("zone2", true, "Zone 2");
	settings.Add("zone3", true, "Zone 3");
	settings.Add("zone4", true, "Zone 4");
	settings.Add("zone5", true, "Zone 5");
	settings.Add("zone6", true, "Zone 6");
	settings.Add("zone7", true, "Zone 7");
	settings.Add("zone8", true, "Zone 8");
	settings.Add("boss", true, "Boss");
	
	settings.SetToolTip("zone8", "This split activates when you enter the boss room");
}

init {

	// HashSet to hold splits already hit
	vars.Splits = new HashSet<string>();

	//To keep track of current boss phase
	vars.bossPhase = 1;

	//Dictionary to bind zone ends to their respective room number
	vars.rooms = new Dictionary<string, int> { {"zone1", 14}, {"zone2", 20}, {"zone3", 42}, {"zone4", 52}, {"zone5", 58}, {"zone6", 65}, {"zone7", 72} };
}

update {	

	// Clear any hit splits and boss phase if timer stops or boss phase the player leaves to main menu
	if (timer.CurrentPhase == TimerPhase.NotRunning) {
		vars.Splits.Clear();
		vars.bossPhase = 1;
	} else if (current.room == 2)
		vars.bossPhase = 1;
}

start {

	return (old.CanPress == 1 && current.CanPress == 0);
}

reset {

	return (current.room == 2);
}

split {

	if(current.hasSaved == 1 && old.hasSaved == 0) {
		foreach (var room in vars.rooms) {
			if (current.room == room.Value) {
				if (vars.Splits.Contains(room.Key))
					return false;

				vars.Splits.Add(room.Key);
				return settings[room.Key];
			}
		}
	}

	if (current.room == 80) {
		// Since the last zone doesnt have a save we use a room transition
		if(old.room == 79) {
			if (vars.Splits.Contains("zone8"))
				return false;

			vars.Splits.Add("zone8");
			return settings["zone8"];

		// "old.bossHealth > 11" is necesary to prevent false splits.
		} else if (current.bossHealth <= 11 && old.bossHealth > 11) {
			if (vars.bossPhase == 1) {
				vars.bossPhase = 2;
				return false;
			} else if(vars.Splits.Contains("boss"))
				return false;

			vars.Splits.Add("boss");
			return settings["boss"];
		}
	}
}
