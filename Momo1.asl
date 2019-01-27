state("momo1_v151")
{
    //Gives the current room we are in
    short room : 0x018A014, 0x0;

    //Updates when we hit a savepoint
    int save : 0x0160250, 0x320;

    //boss health and current phase
    double boss : 0x0185424, 0x44, 0x38C, 0x5CC, 0x8, 0x28;

    double phase : 0X018580C, 0x23C, 0x28C, 0XDC, 0X4, 0X6DC;    
}

init
{
    int split = 0;
}

update
{
//resets the variable split.
    if (timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.split = 0;
	}
}

//will split on every save point and when the final boss dies
split
{
    if (current.room == 14 && vars.split == 0 && old.save != current.save)
    {
        vars.split++;
        return true;

    }
    
    if (current.room == 20 && vars.split == 1 && old.save != current.save)
    {
        vars.split++;
        return true;

    }

    if (current.room == 42 && vars.split == 2 && old.save != current.save)
    {
        vars.split++;
        return true;

    }

    if (current.room == 52 && vars.split == 3 && old.save != current.save)
    {
        vars.split++;
        return true;

    }

    if (current.room == 58 && vars.split == 4 && old.save != current.save)
    {
        vars.split++;
        return true;

    }
    
    if (current.room == 65 && vars.split == 5 && old.save != current.save)
    {
        vars.split++;
        return true;

    }
    
    if (current.room == 72 && vars.split == 6 && old.save != current.save)
    {
        vars.split++;
        return true;

    }
 
    if (current.room == 80 && current.boss <= 11 && current.phase == 1)
    {
        return true;
        
    }
}

//Will reset the timer when we leave to the main menu.
reset
{
    if (current.room == 73 )
    {
        return true;
    }
}
