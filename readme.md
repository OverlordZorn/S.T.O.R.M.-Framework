<p align="center">
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/t/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"><img alt="Github Created At" src="https://img.shields.io/github/created-at/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen">


<p align="center">
<img alt="GitHub Release" src="https://img.shields.io/github/v/release/overlordzorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"><img alt="GitHub License" src="https://img.shields.io/badge/license-APL%20SA-darkgreen?style=for-the-badge&link=https%3A%2F%2Fgithub.com%2FOverlordZorn%2FS.T.O.R.M.-Weather-Framework%2Fblob%2Fbased%2FLICENSE"><img alt="GitHub Issues or Pull Requests" src="https://img.shields.io/github/issues/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen">

<p align="center">
<img alt="GitHub Repo stars" src="https://img.shields.io/github/forks/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/OverlordZorn/S.T.O.R.M.-Weather-Framework?style=for-the-badge&color=darkgreen">

<p align="center">
<img alt="Contributions Welcome" src="https://img.shields.io/badge/CONTRIBUTIONS-WELCOME-darkgreen?style=for-the-badge">


<p align="center">
<img alt="Discord" src="https://img.shields.io/discord/1230123144334016543?style=for-the-badge&logo=discord&label=Discord&color=darkgreen&link=https%3A%2F%2Fdiscord.com%2Finvite%2FB6pNcSSR5X">
<p align="center">
<img alt="Static Badge" src="https://img.shields.io/badge/steamworkshop-DEV%20%22Closed%22%20Beta-darkgreen?style=for-the-badge&logo=steam&label=Steam%20Workshop&link=https%3A%2F%2Fsteamcommunity.com%2Fsharedfiles%2Ffiledetails%2F%3Fid%3D3224327412">


## Dependencies
"cba_common"

## New Phone, who this?

This is the Github Repository for the **S.T.O.R.M. Framework** for Arma 3.

It is an easy and simple to use Framework to Request and Execute Extreme Weather Events like Sandstorms, Snowstorms, etc.

All Effects are Defined in Config as Presets, new Effects can be easily added or existing one can be slightly adjusted via Class Inheritance.
A simple storm can be defined by the Main Preset.

The Currently supported main presets can be found here:
https://github.com/OverlordZorn/S.T.O.R.M.-Weather-Framework/blob/based/addons/framework/Storm_MainPresets.inc.hpp
- `STORM_Sandstorm`
- `STORM_Sandstorm_Light`
- `STORM_Sandstorm_Green`
- `STORM_Duststorm_Green`
- `STORM_SnowStorm`
- `STORM_SnowStorm_Bleak`
- `STORM_SnowStorm_Calm`
- `STORM_SnowStorm_Calm_Bleak`

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
Currently, there is only one Main Function to rule them all. Execute this to request a simple Storm transition.

Once a transition is active, any further requests will be denied. 
You will have to wait until the transition is completed to execute the next transition, including a reset to 0 request.

Once you reached the end of the transition, you can ether readjust the intensity, for example from 0 to 10% to 30%.
OR, you can request a "Reset" by requesting the Same Storm to transition back to 0%.

#### Example
!! This is not a working code snippet, just example usages of the function. you would have to find your own ways to time the call of these Functions !!
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

### Planned, at some point
I am looking towards Zeus and Editor Modules and potentially more functions.

## Known Issues
### while technically, you can transition from one Storm Preset into another, it is not advised.
- Post Processing Effects are made for there to be always only one active per type(ColorCorrection, FilmGrain, Dynamic Blur) and layer (needed for multiple effects of the same type above each other, only really intended for Special effects like blinking etc)
- The cleanup process by transitioning back to 0 will hick up. some other and some effects from the previous storm will remain and not propperly cleaned up.

### Considerations due to Engine Limitations
- Snow/Rain will only occour above an overcast level of 0.5. Overcast transitions, unless using `forceWeatherChange`, can take up to ~50 minutes.

### Join In Progress
- I bet i missed some JIP Edgecases

### Using Editor Mods can cause unexpected behavior regarding FOG
- During development i encountered multiple instances where i was not able to successfully apply the fog, but this only occoured on some specific Editor Mission Files and not on others.
- I think i could narrow it down to me using Editor Enhancing Mods like "Emitter 3Ditor" to test some Particle Effects, Saving the Editor Mission with this Module in place, then not loading it again and using this mission without Emitter 3Ditor.
- Coincidentally, i had a mate have similar issues (fog resets to a fogvalue of 0 repeatally) after he removed "LRG Fundamentals" from the modlist.

### ACE Nightvision FogScaling can cause players to see further with NVG's on.
https://github.com/acemod/ACE3/issues/9938


## License
### ARMA PUBLIC LICENSE SHARE ALIKE (APL-SA) 
![APL-SA](https://data.bistudio.com/images/license/APL-SA.png)



With this license you are free to adapt (i.e. modify, rework or update) and share (i.e. copy, distribute or transmit) the material under the following conditions:

> Attribution - You must attribute the material in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the material).
> Noncommercial - You may not use this material for any commercial purposes.
> Arma Only - You may not convert or adapt this material to be used in other games than Arma.
> Share Alike - If you adapt, or build upon this material, you may distribute the resulting material only under the same license.

https://www.bohemia.net/community/licenses/arma-public-license-share-alike
