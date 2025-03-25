-- ALL TRACE DEBUG INFO WARN ERROR FATAL OFF
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

---@type AutoLoadRecentSaveMod_Options
return {
    directory_SaveGames = [[%LocalAppData%\Astro\Saved\SaveGames]],
    filter = "*.savegame",
    extension = "savegame",
    backup_string = "BACKUP_",
    hook = "/Script/Astro.AstroGameInstance:NotifyLoadScreenFadeoutComplete",

    --[[
    You can change commands name if you want.
    You CANNOT use "quit" as a command name. This command already exists and appears to close the game without saving.
    ]]
    commands = {
        backup_latest_game_save = {
            name = "backup",
            parameters = {}
        },
        get_latest_game_save_name = {
            name = "getsavename",
            parameters = {}
        },
        load_latest_game_save = {
            name = "load",
            parameters = {}
        },
        open_SaveGames_directory = {
            name = "open",
            parameters = {}
        },
        quit = {
            name = "qq",
            parameters = {}
        },
        quit_game = {
            name = "qg",
            parameters = {}
        }
    }
}
