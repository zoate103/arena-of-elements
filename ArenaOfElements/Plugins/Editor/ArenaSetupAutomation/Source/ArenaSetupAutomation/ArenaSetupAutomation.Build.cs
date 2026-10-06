using UnrealBuildTool;
public class ArenaSetupAutomation : ModuleRules
{
	public ArenaSetupAutomation(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
		PrivateDependencyModuleNames.AddRange(new[] { "Core", "CoreUObject", "Engine" });
	}
}
