"""Load Lyra's actual startup map and its impact emitter; never save assets."""
import unreal

map_path = "/Game/System/DefaultEditorMap/L_DefaultEditorOverview"
emitter_path = "/Game/Effects/Particles/Impacts/Emitters/NE_ImpactSparks"
level_api = unreal.get_editor_subsystem(unreal.LevelEditorSubsystem)
unreal.log("ARENA_STARTUP_MAP_LOADING: " + map_path)
if not level_api.load_level(map_path):
    raise RuntimeError("Lyra startup map failed to load")
world = unreal.get_editor_subsystem(unreal.UnrealEditorSubsystem).get_editor_world()
if world is None or not world.get_path_name().startswith(map_path + "."):
    raise RuntimeError("Unexpected editor world after startup map load")
emitter = unreal.load_asset(emitter_path)
if emitter is None or not isinstance(emitter, unreal.NiagaraEmitter):
    raise RuntimeError("Lyra impact emitter failed to load")
unreal.log("ARENA_STARTUP_MAP_VERIFIED: " + world.get_path_name())
unreal.log("ARENA_IMPACT_EMITTER_VERIFIED: " + emitter.get_path_name())
