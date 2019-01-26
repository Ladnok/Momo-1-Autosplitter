state("momo1_v151")
{
    sbyte room : 0x018A014, 0x0;

    int save : 0x0160250, 0x320;

    double boss : 0x018B624, 0x42C, 0x3B0, 0x71C, 0X5C8, 0x5C4;
    //boss does nothing
}

init
{
    int split;
}

start
{

    if (old.room == 12 && current.room == 9 )
    {
        return true;
    }

/*Starts a little bit later because of the time it takes to change the "room" from the moment you press new game.
(in this case, the main menu is considered a room by the game, and it changes when the intro starts).*/

    vars.split = 0;
}

split /*will split on every save point*/
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
/*    
    if (current.room == 80 && vars.split == 7)
    {
        if (current.boss <= 15)
        {
            return true;
        
        }

        return false;
    }*/
}

// The timer will reset everytime you go to the main menu.
reset
{
    if (old.room != current.room && current.room == 73 )
    {
        return true;
    }
}
