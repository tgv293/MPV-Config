local inited = 0
local function platform_is_windows()
    return mp.get_property_native("platform") == "windows"
end

local function getOS()
    local BinaryFormat = package.cpath
    --print(BinaryFormat)
    if platform_is_windows() == "windows" then
        return "Windows"
    end
    if BinaryFormat:match("dll$") then
        return "Windows"
    elseif BinaryFormat:match("so$") then
        if BinaryFormat:match("homebrew") then
            return "MacOS"
        else
            return "Linux"
        end
    elseif BinaryFormat:match("dylib$") then
        return "MacOS"
    end
end

local function init()
    if inited == 0 then
        local url = mp.get_property("stream-open-filename")
        local osv = getOS()
        local args
        -- check for youtube link
        if url:find("^https:") == nil or url:find("youtu") == nil then
            return
        end
    
        local proxy = mp.get_property("http-proxy")
        if proxy and proxy ~= "" and proxy ~= "http://127.0.0.1:12081" then
            return
        end
        if getOS == 'Windows' then  
            -- launch mitm proxy Win
            args = {
                mp.get_script_directory() .. "/http-ytproxy.exe",
                "-c", mp.get_script_directory() .. "/cert.pem",
                "-k", mp.get_script_directory() .. "/key.pem",
                "-r", "10485760", -- range modification
                "-p", "12081" -- proxy port
            }
        elseif getOS == 'MacOS' then  
            -- launch mitm proxy Mac
            args = {
                mp.get_script_directory() .. "/http_ytproxy",
                "-c", mp.get_script_directory() .. "/cert.pem",
                "-k", mp.get_script_directory() .. "/key.pem",
                "-r", "10485760", -- range modification
                "-p", "12081" -- proxy port
            }
        else
            -- launch mitm proxy Lin
            args = {
                mp.get_script_directory() .. "/http-ytproxy",
                "-c", mp.get_script_directory() .. "/cert.pem",
                "-k", mp.get_script_directory() .. "/key.pem",
                "-r", "10485760", -- range modification
                "-p", "12081" -- proxy port
            }
        end
    
        mp.command_native_async({
            name = "subprocess",
            capture_stdout = false,
            playback_only = false,
            args = args,
        });
        inited = 1
    end
    
    mp.set_property("http-proxy", "http://127.0.0.1:12081")
    mp.set_property("tls-verify", "no")
    -- this is not really needed
    --mp.set_property("tls-verify", "yes")
    --mp.set_property("tls-ca-file", mp.get_script_directory() .. "/cert.pem")
end

mp.register_event("start-file", init)
--[[mp.add_hook("on_load", 1, function()
    init()
end)--]]
