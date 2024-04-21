#include "../script_component.hpp"




private _terrainNames = configProperties [configFile >> "CfgWorlds", "true", true] apply { configName _x };
_terrainNames = _terrainNames - ["access","eastSign","westSign","eastFlag","westFlag","guerrilaSign","guerrilaFlag","groupNameFormat","GroupSquad","GroupPlatoon","GroupCompany","GroupNames","GroupColors","GenericNames","DefaultLighting","EnvSounds","CfgLensFlare","mapSize","mapZone","mapArea"];


ZRN_LOG_1(_terrainNames);



private _output = [];
{

    private _subEntry = createHashMap;

    _subEntry set ["TerrainName", _x];

    private _terrain = _x;
    _properties = configProperties [configFile >> "CfgWorlds" >> _terrain, "true", true] apply {configName _x };
    _properties = _properties select { "fog" in _x || "haze" in _x };
    _properties sort true;


    ZRN_LOG_MSG_1(############### Extracting Fog Data from Terrain ###############,_terrain);
    {
        _prop = _x;
        _value = getNumber (configFile >> "CfgWorlds" >> _terrain >> _prop);
        _arr = [_prop, _value];
        ZRN_LOG_1(_arr);
        _subEntry set _arr;
    } forEach _properties;
    _output pushback _subEntry;
} forEach _terrainNames;

// Output sorted by individual Properties
_eachProp = configProperties [configFile >> "CfgWorlds" >> "Altis", "true", true] apply {configName _x };
_eachProp = _eachProp select { "fog" in _x || "haze" in _x };
_eachProp sort true;

{
    private _property = _x;
    ZRN_LOG_MSG_1(############### Extracting Property from each Terrain ###############,_property);
    {
        private _hashMap = _x;
        private _terrain = _hashMap get "TerrainName";
        private _value = _hashMap getOrDefault [_property, "404"];
        ZRN_LOG_2(_value,_terrain);
    } forEach _output;
} forEach _eachProp;
