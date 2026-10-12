/*
###########################################
Basic Modifications
###########################################
*/
Godmode()
{
    self.godmode = isDefined(self.godmode) ? undefined : true;
 
    if(isDefined(self.godmode))
    {
        self endon("disconnect");
 
        while(isDefined(self.godmode)) 
        {
            self EnableInvulnerability();
            wait 0.1;
        }
    }
    else
        self DisableInvulnerability();
}

NoclipToggle1(player)
{
    player.Noclip = isDefined(player.Noclip) ? undefined : true;
    
    if(isDefined(player.Noclip))
    {
        player endon("disconnect");
        self S("Noclip ^2Enabled");
        if(player hasMenu() && player isInMenu())
            player closeMenu1();
        player DisableWeapons();
        player DisableOffHandWeapons();
        player.nocliplinker = spawnSM(player.origin, "tag_origin");
        player PlayerLinkTo(player.nocliplinker, "tag_origin");
        
        while(isDefined(player.Noclip) && isAlive(player))
        {
            if(player AttackButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin + (AnglesToForward(player GetPlayerAngles()) * 60));
            else if(player AdsButtonPressed())
                player.nocliplinker.origin = (player.nocliplinker.origin - (AnglesToForward(player GetPlayerAngles()) * 60));
            if(player MeleeButtonPressed())
                break;
            
            wait 0.01;
        }

        if(isDefined(player.Noclip))
            player NoclipToggle1(player);
    }
    else
    {
        player Unlink();
        player.nocliplinker delete();
        player EnableWeapons();
        player EnableOffHandWeapons();
        self S("Noclip ^1Disabled");
    }
}


UnlimitedAmmo()
{
    self.UnlimitedAmmo = isDefined(self.UnlimitedAmmo) ? undefined : true;
    if(isDefined(self.UnlimitedAmmo))
    {
        while(isDefined(self.UnlimitedAmmo))
        {
            self GiveMaxAmmo(self GetCurrentWeapon());
            self SetWeaponAmmoClip(self GetCurrentWeapon(), self GetCurrentWeapon().clipsize);
            wait .05;
        }
    }
}

ClientOpts(func, player)
{
    switch(func)
    {
        case 0: break;
        case 1: break;
    }
}

TestOption()
{
    self iPrintLn("Test");
}

S(Message)
{
    self iPrintLn(Message);
}
UnlimitedGameTime()
{
    level.unlimitedGame = isDefined(level.unlimitedGame) ? undefined : true;
    if(isDefined(level.unlimitedGame)){
        level thread globallogic_utils::pausetimer();
    }
    else{
        level thread globallogic_utils::resumetimer();
    }
}

BO4Level55(player)
{
    oldrank = player.pers[ #"rank" ];
    rankid = player.pers[ #"rank" ];
    newrankid = 54;
    player.pers[ #"rank" ] = newrankid;
    while ( rankid <= newrankid )
    {
        player stats::set_stat_global( #"rank", rankid, 1 );
        player stats::set_stat_global( #"minxp", int( player rank::getrankinfominxp( rankid ) ), 1 );
        player stats::set_stat_global( #"rankxp", int( player rank::getrankinfomaxxp( rankid ) - 1 ), 1 );
        player stats::set_stat_global( #"maxxp", int( player rank::getrankinfomaxxp( rankid ) ), 1 );
        rankid++;
    }
    player.rankupdatetotal = rankid;
    player.cur_ranknum = newrankid;
    self.pers[ #"summary" ][ #"xp" ] += 25160000;
    uploadstats(player);
    player iPrintLnBold("XP Set to Max");
}

CompleteActiveContracts(player)
{
    if(isDefined(player.pers[#"contracts"]))
    {
        for(slot=0;slot<3;slot++)
        {
            contract = player stats::function_ff8f4f17( #"loot_contracts", slot, #"contracthash" );
            if(isDefined(contract)){
                targetVal = player stats::function_ff8f4f17( #"loot_contracts", slot, #"target" );
                player stats::set_stat(#"loot_contracts", slot, #"progress", targetVal);
                wait .1;
            }
        }
    }
    self iPrintLnBold("All Contracts Completed");
}

MP_UnlockAll(player)
{
    if(isDefined(player.UnlockAll))
        return;
    player.UnlockAll = true;

    player endon("disconnect");
    player iPrintLnBold("Unlock All ^2Started");
    if(player != self)
        self iPrintLnBold(player getName() + ": Unlock All ^2Started");
    //player thread UnlockAchievs();
    idx=0;
    for(z=1;z<6;z++)
    {
        if(z == 6) z++; //StatMileStones6.csv is empty, so we skip it.
        switch(z)
        {
            case 1:
                start=1;
                end=256;
                break;
            case 2:
                start=256;
                end=512;
                break;
            case 3:
                start = 512;
                end = 748;
                break;
            case 4:
                start = 768;
                end = 1024;
                break;
            case 5: 
                start = 1024;
                end = 1369;
                break;
            default:
                start=0;
                end=0;
                break;
        }
        for(value=start;value<end;value++)
        {
            stat         = SpawnStruct();
            stat.value   = Int(TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 2));
            stat.type    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 3);
            stat.name    = TableLookup("gamedata/stats/mp/statsmilestones" + z + ".csv", 0, value, 4);            
            switch(stat.type)
            {
                case "global":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Global");
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"StatValue", stat.value);
                    player stats::set_stat(#"PlayerStatsList", stat.name, #"Challengevalue", stat.value);
                    break;
                case "killstreak":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Killstreak");
                    player stats::function_dad108fa(stat.name,stat.value);
                    break;
                case "attachment":
                    idx++;
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Attachment");
                    player stats::function_dad108fa(stat.name,stat.value);
                    break;
                 case "gamemode":
                    idx++;
                    player stats::function_81f5c0fe(stat.name,stat.value);
                    player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Gamemode");
                    break;
                case "group":
                    idx++;
                    groups = Array(#"weapon_pistol", #"weapon_smg", #"weapon_assault", #"weapon_lmg", #"weapon_cqb", #"weapon_sniper", #"weapon_tactical", #"weapon_launcher", #"weapon_cqb", #"weapon_knife", #"weapon_special");
                    foreach(group in groups)
                    {
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Group");
                        //player stats::function_eec52333(getweapon(group),stat.name,stat.value * 2,undefined,undefined,undefined);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"StatValue", stat.value);
                        player stats::set_stat(#"GroupStats", group, #"stats", stat.name, #"Challengevalue", stat.value);
                        wait 0.01;
                    }
                    break;
                default:
                    for(x=0;x<level._AllWeaps.size;x++)
                    {
                        idx++;
                        weap = getweapon(level._AllWeaps[x]);
                        if(!isDefined(weap) || stat.name == "") continue;//check for blank stats, so we don't set incorrect data here
                        //these are questionable, pulled from StatMilestones3.csv. Should be weapon Camos, untested.
                        player iPrintLnBold("Name: "+stat.name+", Value: "+stat.value+", Type: Weapon");
                        player addweaponstat(weap, stat.name, 5000);
                        player stats::function_e24eec31(weap,stat.name,stat.value);
                        player addweaponstat(weap, #"kills", 5000);
                        player addweaponstat(weap, #"headshots", 5000);//india camo
                        player addweaponstat(weap, #"longshot_kill", 5000);//juliett camo
                        player addweaponstat(weap, #"hash_72add9adadcd524b", 5000);//kilo camo
                        player addweaponstat(weap, #"hash_48fa9e0371c0697a", 5000);//kills loaded
                        player addweaponstat(weap, #"multikill_2", 5000);//mike camo
                        player addweaponstat(weap, #"killstreak_5", 5000);//november camo
                        player addweaponstat(weap, #"revenge_kill", 5000);//knife revenge
                        player addweaponstat(weap, #"backstabber_kill", 5000);//knife backstabber
                        player addweaponstat(weap, #"hash_43fcbe340404e167", 5000);//knife kill when injured
                        player addweaponstat(weap, #"hash_5d2e5d136376f573",5000);//knife kills with enemy weap
                        player addweaponstat(weap, #"hash_6d1ab256c84ca772", 5000);
                        wait .1;
                    }
                    break;
            }
            wait 0.1;
            UploadStats(player);
        }
    }
    player iPrintLnBold("^5Unlock All ^2Complete");
}

bo4_AddBotsToGame() 
{
    AddTestClient();
}

AddEnemyBot()
{
    BotNames = array(
        "xXGhostXx","V1p3r","R0gu3","Reap3r_99","Sh4d0w",
        "H4v0c","Str1k3r","Bulle7","Fr0stBite","V3n0mX",
        "B1aze","Rapt0r_77","Hunt3rX","C0brA","Ph03n1x",
        "DrakeXx","F4lc0n","St0rm99","Tit4n_21","Mav3rickX",
        "Band1t_OG","Kn0x","N0vaX","Ra1der77","EchoX",
        "SkullCr4sh","NightH4wk","ZeroCool","Bl4ck0ut","Sn1perWolf",
        "IronCl4d","GhostUnit","R3dF0x","Cry0tic","VoidRunn3r",
        "D34dSh0t","StormBr1ng3r","H3llR4z0r","ShadowSix","OmegaX",
        "Vortex99","SilentF4ng","DarkR1der","NoMercyX","KillSw1tch",
        "BlitzKr13g","GrimShot","IceV3in","RuinX","Spectr4",
        "Deadlock","Phantomz","R3apX","BlackFang","ZeroSignal",
        "SavageOne","NovaPulse","Skirmish","R0cketMan","HavocUnit",
        "RazorEdge","KillZone","Crossh4ir","Ghosted","WarpDrive",
        "T0xicRain","FrostByteX","ArcWarden","Shad0wByte","TitanRage",
        "V1rtu0so","Cr1msonFox","DuskReaper","Gh0stM4sk","NeonR1ot",
        "S1lentStorm","W1d0wM4ker","AshenWolf","M1dn1ghtOps","R3dC0m3t",
        "NullVector","CipherX","R4venClaw","HyperNova","PulseR1der",
        "SkullV0lt","Gr1mF4ng","N1ghtShift","M0d3rnW4r","D3lt4Viper",
        "ClutchK1ng","QuickSc0pe","Sh0ckWav3","B1ackoutKid","F0xH0und",
        "Z3r0Mercy","SpectralX","VantaRay","R1otM0de","LethalEcho"
    );
    name = BotNames[randomint(BotNames.size)];
    enemyTeam = teams::getenemyteam(self.pers[#"team"]);
    bot::add_bot(enemyTeam, name);
    self iPrintLnBold("Spawned Enemy Bot");
}
AddFriendlyBot()
{
    BotNames = array(
        "xXGhostXx","V1p3r","R0gu3","Reap3r_99","Sh4d0w",
        "H4v0c","Str1k3r","Bulle7","Fr0stBite","V3n0mX",
        "B1aze","Rapt0r_77","Hunt3rX","C0brA","Ph03n1x",
        "DrakeXx","F4lc0n","St0rm99","Tit4n_21","Mav3rickX",
        "Band1t_OG","Kn0x","N0vaX","Ra1der77","EchoX",
        "SkullCr4sh","NightH4wk","ZeroCool","Bl4ck0ut","Sn1perWolf",
        "IronCl4d","GhostUnit","R3dF0x","Cry0tic","VoidRunn3r",
        "D34dSh0t","StormBr1ng3r","H3llR4z0r","ShadowSix","OmegaX",
        "Vortex99","SilentF4ng","DarkR1der","NoMercyX","KillSw1tch",
        "BlitzKr13g","GrimShot","IceV3in","RuinX","Spectr4",
        "Deadlock","Phantomz","R3apX","BlackFang","ZeroSignal",
        "SavageOne","NovaPulse","Skirmish","R0cketMan","HavocUnit",
        "RazorEdge","KillZone","Crossh4ir","Ghosted","WarpDrive",
        "T0xicRain","FrostByteX","ArcWarden","Shad0wByte","TitanRage",
        "V1rtu0so","Cr1msonFox","DuskReaper","Gh0stM4sk","NeonR1ot",
        "S1lentStorm","W1d0wM4ker","AshenWolf","M1dn1ghtOps","R3dC0m3t",
        "NullVector","CipherX","R4venClaw","HyperNova","PulseR1der",
        "SkullV0lt","Gr1mF4ng","N1ghtShift","M0d3rnW4r","D3lt4Viper",
        "ClutchK1ng","QuickSc0pe","Sh0ckWav3","B1ackoutKid","F0xH0und",
        "Z3r0Mercy","SpectralX","VantaRay","R1otM0de","LethalEcho"
    );
    name = BotNames[randomint(BotNames.size)];
    Team = self.pers[#"team"];
    bot::add_bot(Team,name);
    self iPrintLnBold("Spawned Teammate Bot");
}
EndTheGame()
{
    level thread globallogic::forceend();
    foreach(client in level.players) client iPrintLn("^2Sorry, "+level.hostname+" Ended The Game");
}

GivePlayerKeys(player)//doesnt work yet, but correct func, confirmed via challenges_shared;//see gamedata/ae/generated_ae_gameevents.csv for vals
{
    player.keysLoop = isDefined(player.keysLoop) ? undefined : true;
    while(isDefined(player.keysLoop)){
    player function_cce105c8( #"hash_b9d992688034e59", 1, 250, 2, 3, 3, 1000000 );
    player iPrintLnBold("XP Awarded");
    wait 1;
    }
}

GivePlayerCrates(player)//doesnt work yet, but correct func, confirmed via challenges_shared;//see gamedata/ae/generated_ae_gameevents.csv for vals
{
    player.crateLoop = isDefined(player.crateLoop) ? undefined : true;
    while(isDefined(player.crateLoop)){
        player function_cce105c8( #"hash_680a99fa024dd073", 1, 1000000, 2, 3, 3, 1000000 );
        player iPrintLnBold("XP Awarded");
        wait 1;
    }
}

unfair_aimbot()
{
    self.unfairAimbot = isDefined(self.unfairAimbot) ? undefined : true;

    if(isDefined(self.unfairAimbot))
    {
        self endon("disconnect");
        aimingAt = undefined;
        while(isdefined(self.unfairAimbot)) 
        {
            self waittill(#"weapon_fired");

            start = self geteye();
            end = start + anglestoforward(self getplayerangles()) * 1000000;
            trace = bullettrace(start, end, false, self)["position"];
            foreach(player in level.players)
            {   
                if(player != self && player.pers["team"] != self.pers["team"])
                {
                    wait .1;
                    player dodamage(player.health + 100, player.origin, self, self, "head", "MOD_RIFLE_BULLET", 2, self getCurrentWeapon());
                }
            }
        }

    }
}

ChangeBotDiff(which){
    switch(which)
    {
        case 0:level.var_df0a0911 = "bot_tacstate_mp_easy";break;
        case 1:level.var_df0a0911 = "bot_tacstate_mp_normal"; break;
        case 2: level.var_df0a0911 = "bot_tacstate_mp_hard";break;
        case 3: level.var_df0a0911 = "bot_tacstate_mp_veteran";break;
    }self iprintlnbold(which);
}