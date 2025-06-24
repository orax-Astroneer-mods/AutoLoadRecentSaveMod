---@class FOutputDevice
---@field Log function

local UEHelpers = require("UEHelpers")
local logging = require("lib.lua-mods-libs.logging")

local format = string.format

local currentModDirectory = debug.getinfo(1, "S").source:gsub("\\", "/"):match("@?(.+)/[Ss]cripts/")

---@param filename string
---@return boolean
local function isFileExists(filename)
    local file = io.open(filename, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

---@return AutoLoadRecentSaveMod_Options
local function loadOptions()
    local file = format([[%s\options.lua]], currentModDirectory)

    if not isFileExists(file) then
        local cmd = format([[copy "%s\options.example.lua" "%s\options.lua"]],
            currentModDirectory,
            currentModDirectory)

        print("Copy example options to options.lua. Execute command: " .. cmd .. "\n")

        os.execute(cmd)
    end

    return dofile(file)
end

local function loadDevOptions()
    local file = format([[%s\options.dev.lua]], currentModDirectory)

    if isFileExists(file) then
        dofile(file)
    end
end

--------------------------------------------------------------------------------

-- Default logging levels. They can be overwritten in the options file.
LOG_LEVEL = "INFO" ---@type _LogLevel
MIN_LEVEL_OF_FATAL_ERROR = "ERROR" ---@type _LogLevel

local options = loadOptions()
OPTIONS = options
loadDevOptions()

Log = logging.new(LOG_LEVEL, MIN_LEVEL_OF_FATAL_ERROR)
local log = Log
LOG_LEVEL, MIN_LEVEL_OF_FATAL_ERROR = nil, nil

--------------------------------------------------------------------------------

local function openSaveGamesDirectory()
    local handle = io.popen(string.format('explorer "%s"', options.directory_SaveGames))
    if handle then
        handle:close()
    end
end

local function getLatestGameSaveName()
    local saveGames = options.directory_SaveGames .. "\\" .. options.filter
    local handle = io.popen(string.format('dir "%s" /B /O:-D', saveGames))
    if handle then
        local fileName = handle:lines()() ---@type string
        handle:close()
        return fileName:gsub([[%.[^%.]+$]], "")
    end
end

---@return string?
local function loadLatestSave()
    local astroStatics = StaticFindObject("/Script/Astro.Default__AstroStatics")
    assert(astroStatics:IsValid()) ---@cast astroStatics UAstroStatics

    local saveName = getLatestGameSaveName()
    if saveName ~= "" then
        ---@diagnostic disable-next-line: param-type-mismatch
        astroStatics:LoadGame(saveName, UEHelpers.GetWorld())

        return saveName
    end
end

---Command: getsavename
RegisterConsoleCommandHandler(options.commands.get_latest_game_save_name.name,
    ---@param fullCommand string
    ---@param parameters table
    ---@param outputDevice FOutputDevice
    ---@return boolean
    function(fullCommand, parameters, outputDevice)
        local saveName = getLatestGameSaveName()

        local msg = format("Latest game save: %q.", saveName)
        log.info(msg)
        outputDevice:Log(msg)

        return true
    end)

---Command: load
RegisterConsoleCommandHandler(options.commands.load_latest_game_save.name,
    ---@param fullCommand string
    ---@param parameters table
    ---@param outputDevice FOutputDevice
    ---@return boolean
    function(fullCommand, parameters, outputDevice)
        local saveName = loadLatestSave()

        local msg = format("Loading latest game save: %q.", saveName)
        log.info(msg)
        outputDevice:Log(msg)

        return true
    end)

---Command: backup
RegisterConsoleCommandHandler(options.commands.backup_latest_game_save.name,
    ---@param fullCommand string
    ---@param parameters table
    ---@param outputDevice FOutputDevice
    ---@return boolean
    function(fullCommand, parameters, outputDevice)
        local saveName = getLatestGameSaveName()

        local src = format("%s\\%s.%s",
            options.directory_SaveGames, saveName, options.extension)
        local dst = format("%s\\%s%s.%s",
            options.directory_SaveGames, options.backup_string, saveName, options.extension)
        local cmd = format('copy /B /V %s %s', src, dst)

        log.info(format("Backup file: %q. %s => %s", saveName, src, dst))
        log.debug("Backup command: %s", cmd)
        outputDevice:Log(format("Backup file: %q.", saveName))

        local handle = io.popen(cmd)
        if handle then
            local success = handle:close()
            if success ~= true then
                local msg = "Backup command failed."
                log.warn(msg)
                outputDevice:Log(msg)
            end
        end

        return true
    end)

---Command: open
RegisterConsoleCommandHandler(options.commands.open_SaveGames_directory.name,
    ---@param fullCommand string
    ---@param parameters table
    ---@param outputDevice FOutputDevice
    ---@return boolean
    function(fullCommand, parameters, outputDevice)
        local msg = format("Open directory: %q.", options.directory_SaveGames)
        log.info(msg)
        outputDevice:Log(msg)

        openSaveGamesDirectory()

        return true
    end)

ExecuteInGameThread(function()
    -- Auto load latest game save.
    if not UEHelpers.GetPlayerController():IsValid() then
        local preId, postId
        ---@diagnostic disable-next-line: redundant-parameter
        preId, postId = RegisterHook(options.hook, function() end, function()
            IsLoadScreenLoaded = true

            if preId then
                -- Unhook once the function has been called.
                UnregisterHook(options.hook, preId, postId)
            end

            local saveName = loadLatestSave()

            log.info("Loading... %q.", saveName)
        end)
    end
end)
