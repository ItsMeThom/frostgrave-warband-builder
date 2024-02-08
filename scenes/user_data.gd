extends Node
# Singleton pattern autoload node

const savePathWizard = "user://wizards/"
const defaultWizardName = "Wizardo the Magnificent"


var savedWizards = []

# userdata for in progress wizard/warband
var currentWizardName = defaultWizardName
var selectedSchool = null
var currentWizardSchoolName = ""
var currentSoldierRoster = [] # stores the soldierMetadata for each soldier selected
# holds the names of the spells selected, appended on each screen.
var spellSummarylist = ["", "", "", "", "", "", "", ""]

func reset_spell_summary_list():
	spellSummarylist = ["", "", "", "", "", "", "", ""]


func reset_selected_school():
	selectedSchool = null


func clear_temp_wizard():
	currentWizardName = defaultWizardName
	currentWizardSchoolName = ""
	currentSoldierRoster = []

func loadSavedWizards():
	savedWizards = []
	var dir = DirAccess.open(savePathWizard)
	var savedFiles = dir.get_files()
	print("there are " + str(len(savedFiles)) + " saved wizards")
	for save in savedFiles:
		var saveAsString = FileAccess.get_file_as_string(savePathWizard + save)
		var wizardDict = JSON.parse_string(saveAsString)
		savedWizards.append(wizardDict)

func save_wizard(wizardSaveData, fileName):
	fileName = escape_string(fileName)
	var json_str = JSON.stringify(wizardSaveData, "  ")
	var savedWizard = FileAccess.open(savePathWizard + fileName + ".json", FileAccess.WRITE)
	savedWizard.store_string(json_str)
	savedWizard.close()

func delete_saved_wizard(wizardName):
	var filename = escape_string(wizardName) + ".json"
	var dir = DirAccess.open(savePathWizard)
	var absPath = savePathWizard+filename
	if dir.file_exists(savePathWizard + filename):
		dir.remove(absPath)


func _create_save_directory():
	var dir = DirAccess.open("user://")
	if !dir.dir_exists_absolute(savePathWizard):
		dir.make_dir_absolute(savePathWizard)


func escape_string(input_string: String) -> String:
	var illegal_characters := "\\:*?\"<>|` " #should cover windows and android.
	var result_string := ""
	for char in input_string:
		if illegal_characters.find(char) != -1:
			result_string += "_"
		else:
			# Keep the character if it's not illegal
			result_string += char
	return result_string


func _ready():
	_create_save_directory()
