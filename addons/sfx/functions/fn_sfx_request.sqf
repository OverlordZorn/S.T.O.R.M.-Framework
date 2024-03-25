/*
https://community.bistudio.com/wiki/CfgSFX
https://community.bistudio.com/wiki/createSoundSource

the old shit
[] spawn {
	
	diag_log ("[CVO] [SandStorm] (Wind 1) - Init");
	
	while {cvo_ss_running} do {
		["strong_wind"] remoteExec ["playSound"];
		sleep 67;
	};

	diag_log ("[CVO] [SandStorm] (Wind 1) - End");
};

// #########
// SOUND - WIND 2 (Phase 3 to 8)

[] spawn {
	waitUntil {sleep 1; cvo_ss_phase >= 3};
	diag_log ("[CVO] [SandStorm] (Wind 2) - Init");

	while {cvo_ss_running && (cvo_ss_phase <= 8)} do {
		_rafale = ["windburst_1","windburst_2","windburst_3_dr","windburst_4_st"] call BIS_fnc_selectRandom;
		[_rafale] remoteExec ["playSound"];
		sleep 15+random 60;
	};
	diag_log ("[CVO] [SandStorm] (Wind 2) - End");
};

// #########
// SOUND - WIND 3 (Phase 5,6,7)

[] spawn {
	waitUntil {sleep 1; (cvo_ss_phase >= 5)};
	diag_log ("[CVO] [SandStorm] (Wind 3) - Init");

	while {cvo_ss_running && (cvo_ss_phase <= 7)} do {
		["hurricane"] remoteExec ["playSound"];
		sleep 50;
	};

	diag_log ("[CVO] [SandStorm] (Wind 3) - End");
};
*/


_intensity = _intensity max 0 min 1;
_duration = _duration * 60;
