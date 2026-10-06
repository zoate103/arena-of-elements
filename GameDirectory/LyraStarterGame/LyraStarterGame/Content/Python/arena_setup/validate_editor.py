"""Read-only editor API and project identity checks; run through Run-Python.ps1."""
import json
import os
from pathlib import Path
import unreal

project = Path(unreal.Paths.convert_relative_path_to_full(unreal.Paths.get_project_file_path()))
expected = os.environ.get("ARENA_EXPECTED_PROJECT")
if not expected or project.stem != expected:
    raise RuntimeError(f"Unexpected project: {project}; expected {expected!r}")
for name in ("GameplayAbility", "GameplayEffect", "GameplayTag", "GameplayTask", "NiagaraSystem"):
    if not hasattr(unreal, name):
        raise RuntimeError(f"Required Unreal API is not loaded: {name}")
for subsystem in (unreal.EditorAssetSubsystem, unreal.LevelEditorSubsystem, unreal.UnrealEditorSubsystem):
    if unreal.get_editor_subsystem(subsystem) is None:
        raise RuntimeError(f"Missing editor subsystem: {subsystem}")
registry = unreal.AssetRegistryHelpers.get_asset_registry()
assets = registry.get_assets_by_path("/Game", recursive=False)
unreal.log("ARENA_EDITOR_VALIDATION=" + json.dumps({"project": str(project), "root_assets": len(assets)}))
