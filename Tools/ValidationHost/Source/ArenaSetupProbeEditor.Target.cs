using UnrealBuildTool;
public class ArenaSetupProbeEditorTarget : TargetRules
{
	public ArenaSetupProbeEditorTarget(TargetInfo Target) : base(Target)
	{
		Type = TargetType.Editor;
		DefaultBuildSettings = BuildSettingsVersion.V7;
		IncludeOrderVersion = EngineIncludeOrderVersion.Unreal5_8;
		ExtraModuleNames.Add("ArenaSetupProbe");
	}
}
