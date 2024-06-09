local lp: Player = game.Players.LocalPlayer;
--local plrs: {Player} = (function() local self: {Player} = game.Players:GetPlayers(); task.spawn(function() while (task.wait(1)) do self = game.Players:GetPlayers() end end); return self end)();

local prefix = (function() local fenv = getfenv(0); local n = 0; while (fenv) do if (fenv["prefix"]) then return fenv["prefix"] end; fenv = getfenv(n + 1); n += 1; end end)() or ',';
type command = {["Callback"]: ({string}) -> never, ["Aliases"]: {string}, ["Description"]: string};
local commands: {command} = {};

local function addCommand(aliases: {string}, callback: (string...) -> never, description: string)
  commands[#commands + 1] = {["Callback"]  = callback, ["Aliases"] = aliases, ["Description"] = description};
end

lp.Chatted:Connect(function(msg: string)
    local cmd, args: (string, string | {string}) = msg:split(`%s*{prefix}(.*)%s*(.*)`);
    if (not cmd) then
      return;
    end
    args = args and args:split(" ");
    for _,v: Command in pairs(commands) do
      if (table.find(v["Aliases"], cmd:lower())) then
        local suc, no = pcall(v["Callback"], args);
        if (not suc) then
          if (no and type(no) == "table") then game:GetService("StarterGui"):SetCore("ChatMakeSystemSayMessage", no); return; end
          game:GetService("StarterGui"):SetCore("ChatMakeSystemSayMessage", {
              ["Text"] = `{cmd} returned error\n{no}`
              ["Color"] = BrickColor.new("Really Red").Color;
          });
        elseif (no) then
          if (no and type(no) == "table") then game:GetService("StarterGui"):SetCore("ChatMakeSystemSayMessage", no); return; end
          game:GetService("StarterGui"):SetCore("ChatMakeSystemSayMessage", {
              ["Text"] = `{cmd} returned\n{no}`
              ["Color"] = BrickColor.new("Really Red").Color;
          });
        end
      end
  end
end);

return addCommand;
