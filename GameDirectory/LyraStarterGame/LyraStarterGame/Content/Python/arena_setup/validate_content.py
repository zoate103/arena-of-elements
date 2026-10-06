"""Read-only source/config/content and asset-registry validation."""
from pathlib import Path
import unreal

root = Path(unreal.Paths.convert_relative_path_to_full(unreal.Paths.project_dir()))
for name in ("Source", "Config", "Content"):
    if not (root / name).is_dir():
        raise RuntimeError(f"Missing project directory: {root / name}")
registry = unreal.AssetRegistryHelpers.get_asset_registry()
registry.search_all_assets(synchronous_search=True)
assets = registry.get_assets_by_path("/Game", recursive=True)
invalid = [str(asset.package_name) for asset in assets if not str(asset.package_name).startswith("/Game/")]
if invalid:
    raise RuntimeError(f"Unexpected package paths: {invalid[:10]}")
unreal.log(f"ARENA_CONTENT_VALIDATION: {len(assets)} project assets queried safely")
