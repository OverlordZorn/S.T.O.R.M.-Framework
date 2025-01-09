class CfgFunctions
{
	class PREFIX            // Tag, usually this would be ADDON
	{
		class debug
        {
            file = PATH_TO_FUNC_SUB(debug);
        };
        class COMPONENT
		{
			file = PATH_TO_FNC;
			class request_transition {};
		};
        class jip
        {
            file = PATH_TO_FUNC_SUB(jip);
			class jipMonitor {};
			class jipExists {};
        };
        class common
        {
            file = PATH_TO_FUNC_SUB(common);
            class hashFromConfig {};
        };
	}; 
};