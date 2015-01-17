waitUntil{ !(isNull player) };

_initUnit = player getVariable ["initUnit", ["white", "blufor", "rifleman"]];

_groupColor = _initUnit select 0;
_faction = _initUnit select 1;
_role = _initUnit select 2;
_groupName = _initUnit select 3;
_groupID = _initUnit select 4;

player_is_jip = (time > 30);

[player, _faction, _role] spawn BRM_fnc_assignLoadout;

if (!mission_allow_jip && player_is_jip) exitWith {
    0 spawn {
        if ("respawn_system" in usedPlugins) then {
            waitUntil{!isNil "BRM_fnc_killPlayer"};
            titletext ["This mission does not allow for joining in progress. \n\n You will be sent to spectator mode.", "BLACK FADED",0];
            sleep 5;
            [player] call BRM_fnc_killPlayer;
        } else {
            player setdamage 1;
        };
    };
};

(group player) setGroupId [_groupName];
call compile format ["%1 = group player; publicVariable '%1'", _groupID];

player addEventHandler ["Respawn", {[_this] call BRM_fnc_onRespawn}];
player addEventHandler ["Killed", {[_this] call BRM_fnc_onKilled}];
["onDisconn", "onPlayerDisconnected", { [_uid,_name] call BRM_fnc_onDisconnected }] call BIS_fnc_addStackedEventhandler;

[] spawn BRM_fnc_syncTime;

[player, _role, toUpper(_groupColor)] spawn {
_player = _this select 0;
_role = _this select 1;
_color = _this select 2;

sleep 1;

if ("agm_plugin" in usedPlugins) then {
    switch (_role) do {
        case "medic": { _player setVariable ["AGM_IsMedic", true, true] };
        case "pilot": { _player setVariable ["AGM_GForceCoef", 0.75, true] };
        case "engineer": { _player setVariable ["AGM_IsEOD", true, true] };
    };
};

sleep 10;

waitUntil{!(isNull _player)}; (_player) assignTeam (_color);
    
};