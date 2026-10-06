#include "Modules/ModuleManager.h"
#include "Misc/AutomationTest.h"

IMPLEMENT_MODULE(FDefaultModuleImpl, ArenaSetupAutomation)

#if WITH_DEV_AUTOMATION_TESTS
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FArenaModuleSmoke, "ArenaOfElements.Setup.ModuleLoads",
	EAutomationTestFlags::EditorContext | EAutomationTestFlags::EngineFilter)

bool FArenaModuleSmoke::RunTest(const FString& Parameters)
{
	TestTrue(TEXT("Lyra or explicitly selected validation host module is loaded"),
		FModuleManager::Get().IsModuleLoaded("LyraGame") ||
		FModuleManager::Get().IsModuleLoaded("ArenaSetupProbe"));
	TestNotNull(TEXT("Arena runtime module loads"),
		FModuleManager::Get().LoadModulePtr<IModuleInterface>("ArenaOfElementsRuntime"));
	return !HasAnyErrors();
}
#endif
