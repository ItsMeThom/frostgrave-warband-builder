extends Node

# Singleton pattern autoload node

var l18n_keys = {} # keys for localisation file refs
const DATA_PATH = "res://Resources/data/"
const USR_APP_CONFIG = "user://config.json"
var app_config = {} # app config


@export var schoolColours = {
	"Chronomancy": "#C69658",
	"Elementalism": "#F70004",
	"Summoning": "#FF66EA",
	"Enchanting": "#02852D",
	"Illusion": "#E3C131",
	"Necromancy": "#755D43",
	"Sigilism": "#FF6A00",
	"Soothsaying": "#19EEA7",
	"Thaumaturgy": "#4DD4F3",
	"Witchcraft": "#744F9D",
}


var schoolSelectDefaultText = "Select School"
var spellSelectDefaultText = "Select Spell"
var schools = null

# template JSON used to save wizards to disk
var wizardSaveTemplate = null

# soldiers data store
var soldiers = null

# weapons data store
var weapons = null


func load_core_data():
	var school_json_text = FileAccess.get_file_as_string(localise_filepath("schools.json"))
	schools = JSON.parse_string(school_json_text)
	var soldier_json_text = FileAccess.get_file_as_string(localise_filepath("soldiers.json"))
	soldiers = JSON.parse_string(soldier_json_text)
	for soldierName in soldiers.keys():
		soldiers[soldierName]["name"] = soldierName
	var weapon_json_text = FileAccess.get_file_as_string(localise_filepath("arms.json"))
	weapons = JSON.parse_string(weapon_json_text)
	var template_text = FileAccess.get_file_as_string(localise_filepath("saveTemplateWizard.json"))
	wizardSaveTemplate = JSON.parse_string(template_text)
	

func load_localisations():
	var l18n_json_text = FileAccess.get_file_as_string("res://Resources/data/l18n.json")
	l18n_keys = JSON.parse_string(l18n_json_text)
	print(l18n_keys)


# load config from user://config.json or create the default if not set
func load_app_config():
	if not FileAccess.file_exists(USR_APP_CONFIG):
		var config_json_text = FileAccess.get_file_as_string(DATA_PATH + "defaultConfig.json")
		app_config = JSON.parse_string(config_json_text)
		save_app_config()

	var prefs_json_text = FileAccess.get_file_as_string(USR_APP_CONFIG)
	app_config = JSON.parse_string(prefs_json_text)
	# set default localisation value


func save_app_config():
	var json_str = JSON.stringify(app_config, "  ")
	var usr_config = FileAccess.open(USR_APP_CONFIG, FileAccess.WRITE)
	usr_config.store_string(json_str)


# return a path str to a localised file
func localise_filepath(file_name):
	var path = DATA_PATH + app_config.get("lang") + "/" + file_name
	print(path)
	return path

func _ready():
	load_app_config()
	load_localisations()
	load_core_data()
