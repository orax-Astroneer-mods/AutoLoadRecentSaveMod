---@meta _

---@class AutoLoadRecentSaveMod_Options
---@field backup_string string
---@field commands AutoLoadRecentSaveMod_Options_Commands
---@field directory_SaveGames string
---@field extension string
---@field filter string
---@field hook string

---@class AutoLoadRecentSaveMod_Options_Commands
---@field backup_latest_game_save AutoLoadRecentSaveMod_Options_CommandSpec
---@field get_latest_game_save_name AutoLoadRecentSaveMod_Options_CommandSpec
---@field load_latest_game_save AutoLoadRecentSaveMod_Options_CommandSpec
---@field open_SaveGames_directory AutoLoadRecentSaveMod_Options_CommandSpec
---@field quit AutoLoadRecentSaveMod_Options_CommandSpec
---@field quit_game AutoLoadRecentSaveMod_Options_CommandSpec

---@class AutoLoadRecentSaveMod_Options_CommandSpec
---@field name string
---@field parameters table
