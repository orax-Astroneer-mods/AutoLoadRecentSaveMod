---@meta _

---@class LoadSaveMod_Options
---@field backup_string string
---@field commands LoadSaveMod_Options_Commands
---@field directory_SaveGames string
---@field extension string
---@field filter string
---@field hook string

---@class LoadSaveMod_Options_Commands
---@field backup_latest_game_save LoadSaveMod_Options_CommandSpec
---@field get_latest_game_save_name LoadSaveMod_Options_CommandSpec
---@field load_latest_game_save LoadSaveMod_Options_CommandSpec
---@field open_SaveGames_directory LoadSaveMod_Options_CommandSpec
---@field quit LoadSaveMod_Options_CommandSpec
---@field quit_game LoadSaveMod_Options_CommandSpec

---@class LoadSaveMod_Options_CommandSpec
---@field name string
---@field parameters table
