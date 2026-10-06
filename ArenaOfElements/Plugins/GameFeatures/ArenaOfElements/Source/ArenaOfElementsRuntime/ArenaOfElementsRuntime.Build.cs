using UnrealBuildTool;

public class ArenaOfElementsRuntime : ModuleRules
{
	public ArenaOfElementsRuntime(ReadOnlyTargetRules Target) : base(Target)
	{
		PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
		PrivateDependencyModuleNames.AddRange(new[] {
			"Core", "CoreUObject", "Engine", "GameplayAbilities", "GameplayTags",
			"GameplayTasks", "GameFeatures", "Niagara"
		});
	}
}
