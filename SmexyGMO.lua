SmexyGMOdb = {};
local name = "SmexyGMO";
local version = "Retail & Classic";
local f = CreateFrame("Frame", nil, UIParent);
local GC = "|cFF1EFF00";
local token = "|cFF00CCFF";
local lego = "|cFFFF8000";
local original = ChatFrame_DisplayGMOTD;
local Fired = false;
local LastGMO
local NowGMO

DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMO(SGMO)" .. lego .. version .. "|r Load Complete!");

local function SlashCommandHandler(arg)
	if (arg == "") then
		DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMOD" .. lego .. version .. "|r Set a delay for GMOTD with this command:");
		DEFAULT_CHAT_FRAME:AddMessage("     /sgmo seconds");
		DEFAULT_CHAT_FRAME:AddMessage("     Example: /sgmo 15");
		DEFAULT_CHAT_FRAME:AddMessage("     This will delay the GMOTD 15 seconds.");
		DEFAULT_CHAT_FRAME:AddMessage("     Valid delays: 1-120");
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage("     /sgmo popup");
		DEFAULT_CHAT_FRAME:AddMessage("     Will give you the GMOTD in a popup instead.")
		DEFAULT_CHAT_FRAME:AddMessage("     Use this command to toggle this option on/off.")
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage("     /sgmo show");
		DEFAULT_CHAT_FRAME:AddMessage("     Will will show you the current configuration.")
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage("     Check out my other addons:") 
		DEFAULT_CHAT_FRAME:AddMessage("     SmexyMats(Retail)");
		DEFAULT_CHAT_FRAME:AddMessage("     SmexyMats(Classic)");
		DEFAULT_CHAT_FRAME:AddMessage("     SmexyScaleUI(SSUI)");
		DEFAULT_CHAT_FRAME:AddMessage(" ");
		DEFAULT_CHAT_FRAME:AddMessage(token .. "BattleTag: Lunixia#1530");
		DEFAULT_CHAT_FRAME:AddMessage(token .. "Discord: Lunixia#1530");
	end;
	local s = tostring(arg)
	if type(s) == "string" then
		if s == "popup" then
			SmexyGMOdb.popup = not SmexyGMOdb.popup
			DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMOD " .. lego .. version .. "|r GMOTD use pop-up is set to: " .. tostring(SmexyGMOdb.popup));
		end;
		if s == "show" then
			DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMOD " .. lego .. version .. "|r Delay is set to: " .. tonumber(SmexyGMOdb.delay));
			DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMOD " .. lego .. version .. "|r Pop-up is set to: " .. tostring(SmexyGMOdb.popup));
		end;
	end;
	local i = tonumber(arg);
	if type(i) == "number" then
		if(i > 0) and (i < 120) then
			SmexyGMOdb.delay = i;
			DEFAULT_CHAT_FRAME:AddMessage(token .. "SmexyGMOD " .. lego .. version .. "|r Delay has been set to: " .. i);
		end;
	end;
end;

SlashCmdList["SGMO"] = SlashCommandHandler;
SLASH_SGMO1 = "/sgmo";
if not SmexyGMOdb.delay then SmexyGMOdb.delay = 10; end;
if not SmexyGMOdb.popup then SmexyGMOdb.popup = false; end;
ChatFrame_DisplayGMOTD = function(frame, gmotd) NowGMO = GetGuildRosterMOTD(); end;

local function SGMOD_wait(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then return false; end;
	local wF, wT = nil, {};
	wF = CreateFrame("Frame","wF", UIParent);
	wF:SetScript("onUpdate", function(self,elapse)
		local count, i = #wT, 1;
		while(i <= count) do
			local wR = tremove(wT,i);
			local d, ff, p = tremove(wR,1), tremove(wR,1), tremove(wR,1);
			if(d > elapse) then
				tinsert(wT,i,{d-elapse,ff,p});
				i = i + 1;
			else
				count = count - 1;
				ff(unpack(p));
			end;
		end;
	end);
	tinsert(wT,{delay,func,{...}});
	return true;
end;

local function ShowMOTD()
	local strGM = GetGuildRosterMOTD()
	DEFAULT_CHAT_FRAME:AddMessage("Guild Message of the Day: " .. GC .. strGM); 
end;

local function PopupMOTD()
	local strGM = GetGuildRosterMOTD()
	message("Guild Message of the Day: " .. GC .. strGM);
end;

f:RegisterEvent("GUILD_MOTD")
f:SetScript("OnEvent", function(self, event)
	Fired = false;
end)

f:SetScript("OnUpdate", function(self, elapsed)
	if Fired == false then
		local x, y = GetCursorPosition();
		if x and y then	
			if(NowGMO == LastGMO) then
				NowGMO = GetGuildRosterMOTD();
				return;
			end;		
			if not SmexyGMOdb.popup then
				SGMOD_wait(tonumber(SmexyGMOdb.delay), ShowMOTD);
			else
				SGMOD_wait(tonumber(SmexyGMOdb.delay), PopupMOTD);
			end;
			Fired = true;
			LastGMO = NowGMO;
		end;
	end;
end)