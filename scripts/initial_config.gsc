/* SURTR INITIAL CONFIG FILE

    Here is where the initial config values are set.
    If you want to create your own version of Surtr with custom starting values, this is the file you should modify.
    Remember to save the file, check the hash and send it for verification once you are done.
*/



// Surtr Dvars
function load_full_cfg(){

    setdvar(DVAR_DEBUG_MSG_SPEED, 1.0); // Time between debug messages
    setdvar(DVAR_LOG_FILENAME, "surtr.log"); // File name for debug prints
    setdvar(DVAR_SCR_FIRSTGUMFREE, true ); // Free first gum every round

    setdvar(DVAR_COM_PAUSESUPPORTED, true); // Default game behaviour is pausing enabled
    setdvar(DVAR_RTA, false); // By default, we ignore pausing time
	setdvar(DVAR_FORCE_FULL_EASTER_EGG, false); // Default game behaviour is not forcing these EEs to be doable on solo
	setdvar(DVAR_DE_EE_RANKED, false); // Default game behaviour is deciding if DE EE should need all bows upgraded depending if the game is ranked


    // Practice state
    setdvar(DVAR_PRACTICE, false);

    // When in DEV mode, force it to start as enabled
    #ifdef dev
        setdvar(DVAR_PRACTICE, true);
    #endif


    // Set lobby to instant start
    setdvar( DVAR_LOBBYTIMERSTARTINTERVAL, 0 );

    // TODO: Only disable hud obituaries while changing camo. Does this work for NON HOST players?
    setdvar( DVAR_UI_HUD_OBITUARIES, false); // Hide text when using method "<player> NextPlayerRenderOption( str_optionname, b_forward )" . Default is 1.

	// Enable Livesplit autosplits
	setdvar( DVAR_SV_CHEATS, "1" );

	// Allow Livesplit autosplits
	setdvar( DVAR_AUTOSPLITS, "0" );

	// Allow Livesplit to autosplit on round splits
	setdvar( DVAR_SPLIT_ROUNDS, "0" );

	// Set initial Livesplit is paused state
	SetDvar( DVAR_LIVESPLIT_PAUSED, "0" );

	// Give an initial warning if game is not updated to latest version
	SetDvar( DVAR_WARNING_VERSION, "1" );

	// Give an initial warning if t7 patch is not being applied (or using a custom client)
	SetDvar( DVAR_WARNING_T7PATCH, "1" );


	// Surtr World vars
    load_new_session_mode_cfg();
	

    // Sets the general cfg to loaded
    SetDvar(DVAR_SURTR_CFG_LOADED, true);
}

// Surtr World vars
function load_new_session_mode_cfg(){

    SetDvar(DVAR_SHOW_SURTR, true); // Display Surtr message, will be true until the message is displayed
    SetDvar(DVAR_MAP_LOAD, true); // True only for this very map load
    SetDvar(DVAR_CURRENT_MAP_LOAD_TIMESTAMP, GetUTC() );
    SetDvar(DVAR_NEXTMAP, "surtr"); // Not updated on fast restarts

    // To store initial values of the DVARS that we want to change
    world.surtr_dvars = [];

    // Init toggle commands data
    world.toggles = [];

    // For gsc_speed_ignores_z
    world.toggle_z_speed_values = [];

    // Flags for weapon's attachments config
    FLAG_SAVED_WEAPON_SETTINGS = 0;
    if( IS_ZOMBIES && ( IS_OFFLINE || USING_MODS ) ){
        enable_weapon_flag_bit( FLAG_AUTOMATIC_ATTACHMENTS ); // By default, we DO give attachments to weapons when offline
        enable_weapon_flag_bit( FLAG_GIVE_CAMO ); // By default, we DO give random camo to weapons when offline
    }

    // Let's assume player is going to play always on Offline sessionmode, let's make the game more secure
    if( IS_OFFLINE ){
        setDvar( DVAR_NODW, true ); // Disable DemonWare
        setDvar( DVAR_LIVE_USEUNO, false ); // Disable Uno Account features
        setDvar( DVAR_LIVE_USEUMBRELLA, false ); // Disable Umbrella Account features
    }

    // Default show EE splits
    FLAG_SAVED_SHOW_EE_SPLITS = true;

    // Toggle god, noclip... etc
    #ifdef dev
        level.first_surtr_load = true;
		if( IS_SURTR_CFG_LOADED ) level thread debug_message("Session mode change detected!");
    #endif

    // Commands that you want to run automatically as soon as the game starts
    // SOME OF THEM MAY NEED A FAST_RESTART TO APPLY EFFECTS
    world.initial_shared_commands = "Autosplit;Hud Game_Identifier;Hud Game";
    world.initial_zm_commands = "Toggle_DE_Easter_Egg_Ranked;Toggle_Hide_EE_Splits;Hud Ice_Craft;Hud Wind_Craft;Hud Fire_Enter;Hud Electric_Enter;Hud Electric_Craft;Hud Ice_Exit;Hud Secure_The_Keys_Leave;Hud Wield_A_Fist_Of_Iron_Enter;Hud Little_Lost_Girl";

    // Sets the sessionmode CFG to true
    world.surtr_cfg_loaded = true;
}  

function execute_initial_shared_commands(){

    // Not a real initial command
    if( world.initial_shared_commands == "" ) world.initial_shared_commands = undefined;

    // Wait for commands to be fully registered
    while( !isdefined( level.commands_register_completed ) ) wait 0.05;

    player = undefined;
    while( !isdefined( player ) ){
        wait 0.05;
        a_players = GetPlayers();
        if( a_players.size > 0 ) player = GetPlayers()[0];
    }

    a_str_commands = StrTok( world.initial_shared_commands, ";");
    foreach( str_command in a_str_commands ) player thread execute_command( str_command );

    // Remove used commands
    world.initial_shared_commands = undefined;
}

function execute_initial_zm_commands(){

    // Not a real initial command
    if( world.initial_zm_commands == "" ) world.initial_zm_commands = undefined;

    // Wait for commands to be fully registered
    while( !isdefined( level.commands_register_completed ) ) wait 0.05;

    player = undefined;
    while( !isdefined( player ) ){
        wait 0.05;
        a_players = GetPlayers();
        if( a_players.size > 0 ) player = GetPlayers()[0];
    }

    a_str_commands = StrTok( world.initial_zm_commands, ";");
    foreach( str_command in a_str_commands ) player thread execute_command( str_command );

    // Remove used commands
    world.initial_zm_commands = undefined;
}