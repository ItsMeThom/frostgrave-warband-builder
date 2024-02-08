extends Node

# Singleton pattern autoload node

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
	var school_json_text = FileAccess.get_file_as_string("res://Resources/data/schools.json")
	schools = JSON.parse_string(school_json_text)
	var soldier_json_text = FileAccess.get_file_as_string("res://Resources/data/soldiers.json")
	soldiers = JSON.parse_string(soldier_json_text)
	for soldierName in soldiers.keys():
		soldiers[soldierName]["name"] = soldierName
	var weapon_json_text = FileAccess.get_file_as_string("res://Resources/data/arms.json")
	weapons = JSON.parse_string(weapon_json_text)
	var template_text = FileAccess.get_file_as_string("res://Resources/data/saveTemplateWizard.json")
	wizardSaveTemplate = JSON.parse_string(template_text)
	
	
func _ready():
	load_core_data()
