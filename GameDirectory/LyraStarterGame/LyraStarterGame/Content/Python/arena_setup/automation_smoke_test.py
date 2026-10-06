"""Create, save, verify and remove only a uniquely named temporary float curve."""
import uuid
import unreal

asset_tools = unreal.AssetToolsHelpers.get_asset_tools()
asset_api = unreal.get_editor_subsystem(unreal.EditorAssetSubsystem)
name = "SetupSmoke_" + uuid.uuid4().hex
folder = "/Game/Developers/ArenaSetupSmoke"
path = folder + "/" + name
if asset_api.does_asset_exist(path):
    raise RuntimeError(f"Refusing to overwrite existing asset: {path}")
asset = None
try:
    factory = unreal.CurveFloatFactory()
    asset = asset_tools.create_asset(name, folder, unreal.CurveFloat, factory)
    if asset is None or not asset_api.save_loaded_asset(asset):
        raise RuntimeError("Temporary asset creation/save failed")
    if not asset_api.does_asset_exist(path) or asset_api.load_asset(path) is None:
        raise RuntimeError("Saved temporary asset could not be loaded")
    unreal.log(f"ARENA_ASSET_SMOKE_VERIFIED: {path}")
finally:
    if asset is not None:
        if not asset_api.delete_asset(path) or asset_api.does_asset_exist(path):
            raise RuntimeError(f"Temporary test asset cleanup failed: {path}")
unreal.log("ARENA_ASSET_SMOKE_CLEANUP_PASS")
