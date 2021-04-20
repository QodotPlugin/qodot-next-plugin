class_name QuakeWadImportPlugin
extends EditorImportPlugin
tool

func get_importer_name() -> String:
    return "qodot.quake_wad"

func get_visible_name() -> String:
    return "Quake WAD"

func get_resource_type() -> String:
    return "Resource"

func get_recognized_extensions() -> Array:
    return ["wad"]

func get_save_extension() -> String:
    return "tres"

func get_import_options(_preset: int) -> Array:
    return []

func get_preset_count() -> int:
    return 0

func import(_source_file: String, save_path: String, _options: Dictionary, _platform_variants: Array, _gen_files: Array) -> int:
    var save_path_str = save_path + "." + get_save_extension()

    var existing_resource = load(save_path_str) as QuakeWad

    if not existing_resource:
        var resource = QuakeWad.new()
        var save_err = ResourceSaver.save(save_path_str, resource, 0)
        if save_err:
            printerr("Error writing WAD resource: %s" % [save_err]);
            return ERR_FILE_CANT_WRITE;

    return OK
