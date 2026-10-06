using UnrealBuildTool;
public class ArenaSetupProbe : ModuleRules
{
	public ArenaSetupProbe(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
		PrivateDependencyModuleNames.AddRange(new[] { "Core", "CoreUObject", "Engine" });
	}
}
