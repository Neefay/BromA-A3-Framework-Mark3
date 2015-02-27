scriptName "headless_client";

// =============================================================================
//  Headless Client parameters
// =============================================================================

waitUntil{!isNil"param_hc_enabled"};

switch (param_hc_enabled) do {
    case 0: { mission_enable_hc = false };
    case 1: { mission_enable_hc = true };
};
publicVariable "mission_enable_hc";

// =============================================================================

if (mission_enable_hc && (isServer || hasInterface)) then { mission_AI_controller = false };
if (!mission_enable_hc && !isServer) then { mission_AI_controller = false };

if (!mission_enable_hc && isServer) then { mission_AI_controller = true; mission_HC_enabled = true; publicVariable "mission_HC_enabled" };
if (mission_enable_hc && (!isServer && !hasInterface)) then { mission_AI_controller = true; mission_HC_enabled = true; publicVariable "mission_HC_enabled" };

HeadlessController = mission_AI_controller;
HeadlessVariable = mission_HC_enabled;

if (HeadlessVariable) then { publicVariable "HeadlessVariable" };

if (mission_AI_controller && !isServer) then {
    ["ALL","CHAT", format ["Headless Client ENABLED as %1.", player]] call BRM_fnc_doLog;
};

if (mission_AI_controller) then {
    
    #include "core_functions.sqf"

    [] call hc_fnc_loadMissionObjects;
};