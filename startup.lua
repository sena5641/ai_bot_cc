
local hasExternalMonitor = false
local monitor = peripheral.find("monitor")
downlold = fs.exists(ai/load.lua)
if download == true then
    shell.run("ai/load")
else 
    shell.run("wget run https://raw.githubusercontent.com/sena5641/ai_bot_cc/refs/heads/main/download.lua")
end
