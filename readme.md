<p align="center">
<img alt="STORM Framework Logo" src="extras\branding\logo+storm+framework.png" width="300" height="300">

<p align="center">
<a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework">
<img alt="GitHub Repository" src="https://img.shields.io/badge/github_repository-S.T.O.R.M._Framework-darkgreen?style=for-the-badge&logo=github"><img alt="GitHub Commit Activity" src="https://img.shields.io/github/commit-activity/t/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"><img alt="Github Created At" src="https://img.shields.io/github/created-at/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"></a>
<p align="center">
<a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework/releases/latest"><img alt="GitHub Release" src="https://img.shields.io/github/v/release/overlordzorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"></a><a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework/blob/based/LICENSE"><img alt="GitHub License" src="https://img.shields.io/badge/license-APL%20SA-darkgreen?style=for-the-badge"></a><a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework/issues"><img alt="GitHub Issues or Pull Requests" src="https://img.shields.io/github/issues/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"></a><a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework/fork"><img alt="GitHub Repo forks" src="https://img.shields.io/github/forks/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"></a><a href="https://github.com/OverlordZorn/S.T.O.R.M.-Framework/stargazers"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"></a>

<p align="center">
<a href="https://steamcommunity.com/sharedfiles/filedetails/?id=3224327412"><img alt="Static Badge" src="https://img.shields.io/badge/steamworkshop-DEV%20%22Closed%22%20Beta-darkgreen?style=for-the-badge&logo=steam&label=Steam%20Workshop"></a>
<p align="center">
<a href=""><img alt="Contributions Welcome" src="https://img.shields.io/badge/CONTRIBUTIONS-WELCOME-darkgreen?style=for-the-badge"></a>
<p align="center">
<a href="https://discord.com/invite/B6pNcSSR5X"><img alt="Discord" src="https://img.shields.io/discord/1230123144334016543?style=for-the-badge&logo=discord&label=Discord&color=darkgreen"></a>

# S.T.O.R.M. Framework

The **S.T.O.R.M. Framework** is an effort to make technically complex, but dynamic and immersive weather events easily available. 

The framework takes care of the complexity that comes with the Arma 3's engine and handles everything needed: be it global, serverside weather parameters and AI SubSkills or local, clientside post processing, particle and sound sources.

It is Join In Progress & Dedicated Server compatible and aims to be as performance efficient as possible.


Mission Makers or Zeus Game Masters can ether, simply apply a `MainPresets` which has all details for an individual storm defined, or craft their own experience by directly requesting individual `Module Presets`.

It comes with several `MainPresets` and `Module Presets` and can easily be expanded on. Those Presets are stored as Config Classes, to be found ![here!](addons/framework/Storm_MainPresets.inc.hpp)

The following classnames are currently included as `MainPresets`:
- `STORM_Sandstorm`
- `STORM_Sandstorm_Light`
- `STORM_Sandstorm_Green`

- `STORM_Duststorm_Green`

- `STORM_SnowStorm`
- `STORM_SnowStorm_Bleak`
- `STORM_SnowStorm_Calm`
- `STORM_SnowStorm_Calm_Bleak`
- `STORM_Snowstorm_lessFog`


### Weather Effects Module
- Handles Execution of relevant Weather Systems, for example:
- Fog, including adaptation of the "Fogbase" based on the Average Altitude of all players to aim for a consistent experience even on maps with high elevation.
- Wind Transition beyond the simple "setWind 1" values.
- Comes with the handling of Rain Parameters, be it Snow or Rain.

### Particle Effects
- Handles the creation of multiple Particle Effect Spawners on each individual client and updating their position based on player movementspeed and Wind.

### Post Processes
- Handles the creation of multiple Post Processing Effects
- Currently Supports: Color Corrections, FilmGrain, Dynamic Blur. 
- Can handle Multiple layers of said effect, so future special effects like blinking can be supported on a seperate later while maintaining the original ones.

### Spacial Sound Effects
- Handles and maintains muliple different types of Sound Sources in 3D Space locally on each individual client.

### AI Skill Adaptation
- Handles and Scales the SubSkills of all present AI's in the Mission during the Storm including newly created entities, ether via Script or by Zeus and returns to their previous skill Levels after a reset of the Storm.

### Unscheduled Environment
It is optimised with the help of CBA Functions to be soley executed in Unscheduled Environment.

### Join in Progress
Handles and Maintains JIP Handles for individual client side effects and deletes them once the Effect has been set back to 0.
(I bet there are still some edge cases which I havent covered, but thats a problem for future me.)

## How to Use
### Request Transition
Currently, there is only one Main Function implemented, but there is more to follow.  

`[presetName, duration in minutes, intensity] call storm_fnc_request_transition`.
- PresetName: String of desired MainPreset classname
- Duration: In minutes, minimum is 1 minute.
- Intensity: Target Intensity - from 0 to 1 where 1 stands for 100% Intensity


This function will request a transition from "current" state (0 intensity if no active storm), to the desired state over the provided duration.

To reset the storm, remove all effects and return to the previous conditions, simply request a transition with the same parameters, but have 0 as the target Intensity.

#### Example
```sqf
// Will request the "STORM_Sandstorm" Template, to transition from 0% to 30% over the duration of 10 Minutes.
["STORM_Sandstorm", 10, 0.30] call storm_fnc_request_transition;
```
```sqf
// Once the player reach the objective or sth you choose to start an increase of the storm to the choosen maximum and have them, for example, defend an outpost
["STORM_Sandstorm", 10, 0.75] call storm_fnc_request_transition;
```
```sqf
//after the firefight completed, the storm settles, and gets reduced down to 15% intensity, while remaining some cosmetical aspects of it etc.
["STORM_Sandstorm", 10, 0.30] call storm_fnc_request_transition;
```
```sqf
// this will fade the storm completely to 0 ofer 10 minutes. After 10 Minutes, all Variables and active systems will be terminated on both, the server and the clients.
["STORM_Sandstorm", 10, 0.00] call storm_fnc_request_transition;
```

### Reset to Previous / Stop the Storm
Requesting a Transition to 0 from a previously established Storm will result in the termination/cleanup of all used Variables, arrays, Handlers etc.


```sqf
/*
* Function to Start a Transition from Current (0 if no previous Storm occoured) to target intensity over the defined time. The longer it takes, the better, too short transitions can impact player experience.
*
* Arguments:
* 0: _stormPreset       <STRING>  Classname of Storm Preset - Capitalisation needs to be exact! - Defines which Effects to call - Currently implemented Presets can be found here: addons/framework/Storm_MainPresets.inc.hpp
*                       Example: "STORM_Sandstorm"
*                       Default: "" (will fail)
* 1: _duration          <NUMBER>  Time in Minutes for the transition to take place.
*                       Example: 15
*                       Default: 5
* 2: _Intensity         <NUMBER> from 0 to 1 where 1 stands for 100% - Intensity of the Storm Effects. The higher the intensity, the stronger the Effects etc.
*                       Example: 0.75
*                       Example: 0.5
*
* Return Value:
* array of applied effects and their return (mostly true/false dependend on success)
*
* Note: 
*
* Example:
* [_stormPreset,     _durationInMinutes, _Intensity] call storm_fnc_request_transition;
* ["STORM_Sandstorm",      10,               0.75  ] call storm_fnc_request_transition;
* 
* Public: Yes
*/
```

### Planned Features
- Monitor Client FPS and adjust Particle Droprate for each client.
- Zeus Gamemaster and Editor Modules.
- Support for various Special Effects - due to the potential complexity, they will require their own individual module/addon.
- Various Special Effects
- More Presets
- Mod Template for easy creation of Preset Extensions
- Zeus HUD during Active Storms displaying summary and/or detailed information of the currently active effects.


## Known Issues
### while technically possible, you can transition from one Storm Preset into another, but it is a bad idea.
- While some modules support only "on active effect" and therefore, can easily be overwritten by other MainPresets, the remaining Modules can have multiple, different effects be active at the same time. This can cause individual effects to remain active even after a transition back to 0. Manual cleanup would be neededj.

### Considerations due to Engine Limitations
- Snow/Rain will only occour above an overcast level of 0.5. Overcast transitions, unless using `forceWeatherChange`, can take up to ~45 ingame minutes.

### Join In Progress
- I bet i missed some JIP Edgecases

### Using Editor Mods can cause unexpected behavior regarding FOG
- During development i encountered multiple instances where i was not able to successfully apply the fog, but this only occoured on some specific Editor Mission Files and not on others.
- I think i could narrow it down to me using Editor Enhancing Mods like "Emitter 3Ditor" to test some Particle Effects, Saving the Editor Mission with this Module in place, then not loading it again and using this mission without Emitter 3Ditor.
- Coincidentally, i had a mate have similar issues (fog resets to a fogvalue of 0 repeatally) after he removed "LRG Fundamentals" from the modlist.

### ACE Nightvision FogScaling 
- can cause players to see further with NVG's on.
- https://github.com/acemod/ACE3/issues/9938


## Credits and Contributions
tba.

## Dependencies
cba


## Colaboration


## License
### ARMA PUBLIC LICENSE SHARE ALIKE (APL-SA) 
![APL-SA](https://data.bistudio.com/images/license/APL-SA.png)



With this license you are free to adapt (i.e. modify, rework or update) and share (i.e. copy, distribute or transmit) the material under the following conditions:

> Attribution - You must attribute the material in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the material).
> Noncommercial - You may not use this material for any commercial purposes.
> Arma Only - You may not convert or adapt this material to be used in other games than Arma.
> Share Alike - If you adapt, or build upon this material, you may distribute the resulting material only under the same license.

https://www.bohemia.net/community/licenses/arma-public-license-share-alike



## Thanks to
- Bohemia Interactive for creating not only Arma3 but a game Series that good me hooked since OFP showed up in my live via a Demo and Video in a Games Magazine
- Everyone in the ACE3 Discord for sharing their wealth of knowledge and experience
- Alias for creating his Stom Scripts, which have been a great inspiration


## Especially to Everyone in the 24th Chorni Voron
<p align="center">Thanks for enduring my absense while i was working nonstop on this mod
<p align="center">
<img alt="STORM Framework Logo" src="extras\branding\voron.png" width="300" height="300" href="http://discord.chornivoron.net">
