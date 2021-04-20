class_name QodotEditorPlugin
extends EditorPlugin
tool

# Enums
enum Types {
	QuakeMap,
	QuakeWad,
	QuakeWadDebug,
	QodotEntity,
	QodotWorldspawnLayer,
	QodotMaterialData,
	QodotGameData,
	QodotMap,
	ForgeGameData,
	ForgeEntity
}

# Constants
const RESOURCE_CLASS_NAME := "Resource"
const SPATIAL_CLASS_NAME := "Spatial"

const QODOT_SPATIAL_ICON := preload("res://addons/qodot/icons/qodot_spatial.svg")
const QODOT_RESOURCE_ICON := preload("res://addons/qodot/icons/qodot_resource.svg")
const FORGE_RESOURCE_ICON := preload("res://addons/qodot/icons/forge_resource.svg")

const TYPE_SCRIPTS := {
	Types.QuakeMap: QuakeMap,
	Types.QuakeWad: QuakeWad,
	Types.QuakeWadDebug: QuakeWadDebug,

	Types.ForgeGameData: ForgeGameData,
	Types.ForgeEntity: ForgeEntity,

	Types.QodotGameData: QodotGameData,
	Types.QodotEntity: QodotEntity,
	Types.QodotWorldspawnLayer: QodotWorldspawnLayer,
	Types.QodotMaterialData: QodotMaterialData,

	Types.QodotMap: QodotMap,
}

const TYPE_BASES := {
	Types.QuakeMap: RESOURCE_CLASS_NAME,
	Types.QuakeWad: RESOURCE_CLASS_NAME,
	Types.QuakeWadDebug: RESOURCE_CLASS_NAME,

	Types.QodotMaterialData: RESOURCE_CLASS_NAME,

	Types.ForgeGameData: RESOURCE_CLASS_NAME,
	Types.ForgeEntity: RESOURCE_CLASS_NAME,

	Types.QodotGameData: RESOURCE_CLASS_NAME,
	Types.QodotEntity: RESOURCE_CLASS_NAME,
	Types.QodotWorldspawnLayer: RESOURCE_CLASS_NAME,

	Types.QodotMap: SPATIAL_CLASS_NAME,
}

const TYPE_ICONS := {
	Types.QuakeMap: QODOT_RESOURCE_ICON,
	Types.QuakeWad: QODOT_RESOURCE_ICON,
	Types.QuakeWadDebug: QODOT_RESOURCE_ICON,

	Types.QodotMaterialData: QODOT_RESOURCE_ICON,

	Types.ForgeGameData: FORGE_RESOURCE_ICON,
	Types.ForgeEntity: FORGE_RESOURCE_ICON,

	Types.QodotGameData: QODOT_RESOURCE_ICON,
	Types.QodotEntity: QODOT_RESOURCE_ICON,
	Types.QodotWorldspawnLayer: QODOT_RESOURCE_ICON,

	Types.QodotMap: QODOT_SPATIAL_ICON,
}

const IMPORT_PLUGINS := [
	QuakeMapImportPlugin,
	QuakeWadImportPlugin,
	QuakePaletteImportPlugin
]

# Private Members
var quake_map_import_plugin
var quake_wad_import_plugin
var import_plugins: Array

# Getters
func get_type_name(type: int) -> String:
	return Types.keys()[type]

func get_type_base(type: int) -> String:
	return TYPE_BASES[type]

func get_type_script(type: int):
	return TYPE_SCRIPTS[type]

func get_type_icon(type: int):
	return TYPE_ICONS[type]

# Overrides
func _init() -> void:
	import_plugins = []

func _enter_tree() -> void:
	setup_project_settings()

	for key in Types:
		var val = Types[key]
		add_custom_type(get_type_name(val), get_type_base(val), get_type_script(val), get_type_icon(val))

	for import_plugin in IMPORT_PLUGINS:
		import_plugins.append(import_plugin.new())
		add_import_plugin(import_plugins[-1])

func _exit_tree() -> void:
	for key in Types:
		var val = Types[key]
		remove_custom_type(get_type_name(val))

	for import_plugin in import_plugins:
		remove_import_plugin(import_plugin)

const TEXTURE_TOKEN := "$TEXTURE"
const SETTING_PATTERN := "qodot/textures/%s_pattern"
const TEXTURE_PATTERN := "%s_%s"
const TEXTURE_SETTINGS := [
	'albedo',
	'metallic',
	'roughness',
	'emission',
	'normal',
	'rim',
	'clearcoat',
	'flowmap',
	'ambient_occlusion',
	'depth',
	'subsurface_scattering',
	'transmission',
	'refraction',
	'detail_mask',
	'detail_albedo',
	'detail_normal'
]

func setup_project_settings() -> void:
	for key in TEXTURE_SETTINGS:
		try_add_project_setting(SETTING_PATTERN % [key], TYPE_STRING, TEXTURE_PATTERN % [TEXTURE_TOKEN, key])

func try_add_project_setting(name: String, type: int, value, info: Dictionary = {}) -> void:
	if not ProjectSettings.has_setting(name):
		add_project_setting(name, type, value, info)

func add_project_setting(name: String, type: int, value, info: Dictionary = {}) -> void:
	ProjectSettings.set(name, value)

	var info_dict := info.duplicate()
	info_dict['name'] = name
	info_dict['type'] = type

	ProjectSettings.add_property_info(info_dict)
	ProjectSettings.set_initial_value(name, value)
