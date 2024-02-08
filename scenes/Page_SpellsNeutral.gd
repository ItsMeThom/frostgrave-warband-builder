extends BoxContainer

@onready var schoolMenuButton_1 = $VBoxContainer/ScrollContainer/VBoxContainer/MenuButton_SpellSchool_1
@onready var schoolMenuButton_2 = $VBoxContainer/ScrollContainer/VBoxContainer/MenuButton_SpellSchool_2
@onready var schooMenuButtons: Array[MenuButton] = [schoolMenuButton_1, schoolMenuButton_2]
var currentlySelectedSchoolIDs = [-1,-1]

@onready var spellMenuButton_1 = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/MenuButton_Spell_1
@onready var spellMenuButton_2 = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/MenuButton_Spell_2

@onready var spell1Desc = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/Desc_Spell_1
@onready var spell2Desc = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/Desc_Spell_2

@onready var spell1RangeLabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/Range_Spell1
@onready var spell2RangeLabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/Range_Spell2
@onready var spellRangeLabels = [spell1RangeLabel, spell2RangeLabel]

@onready var buttonToWarband = $VBoxContainer/VBoxContainer/MarginContainer/Button_toWarband

var spell1Selected = false
var spell2Selected = false


signal signal_any_spell_selected
signal signal_school_selected

func populate():
	reset_page()
	ready_spellschool_menus(UsrData.selectedSchool.neutral)
	
	
func ready_spellschool_menus(neutralSchools):
	for menuButton in schooMenuButtons:
		var menuPopup = menuButton.get_popup()
		menuPopup.clear()
		for school in neutralSchools:
			menuPopup.add_item(school)

func ready_neutral_school_dropdowns():
	schoolMenuButton_1.get_popup().id_pressed.connect(_on_school_1_pressed)
	schoolMenuButton_2.get_popup().id_pressed.connect(_on_school_2_pressed)
	spellMenuButton_1.get_popup().id_pressed.connect(_on_spell_1_pressed)
	spellMenuButton_2.get_popup().id_pressed.connect(_on_spell_2_pressed)

func _ready():
	ready_neutral_school_dropdowns()
	spell1Desc.text = ""
	spell2Desc.text = ""
	spell1RangeLabel.text = ""
	spell2RangeLabel.text = ""
	signal_any_spell_selected.connect(_on_any_spells_selected)
	signal_school_selected.connect(_on_spell_school_selected)


func set_spell_range(spellNumber, rangeText):
	var rangeLabel: RichTextLabel = spellRangeLabels[spellNumber - 1]
	rangeLabel.clear()
	rangeLabel.append_text("[b]Range:[/b] " + rangeText + " ")



func reset_page():
	currentlySelectedSchoolIDs = [-1,-1]
	spell1Desc.text = ""
	spell2Desc.text = ""
	spell1RangeLabel.clear()
	spell2RangeLabel.clear()
	schoolMenuButton_1.text = Data.schoolSelectDefaultText
	schoolMenuButton_2.text = Data.schoolSelectDefaultText
	spellMenuButton_1.text = Data.spellSelectDefaultText
	spellMenuButton_2.text = Data.spellSelectDefaultText
	spell1Selected = false
	spell2Selected = false
	buttonToWarband.disabled = true


#####
# Signals
#####

func _on_school_1_pressed(id):
	emit_signal("signal_school_selected", 0, id)
	spell1Desc.text = ""
	spell1RangeLabel.text = ""
	spell1RangeLabel.clear()
	spellMenuButton_1.text = Data.spellSelectDefaultText
	
	var selectedSchoolName = schoolMenuButton_1.get_popup().get_item_text(id)
	schoolMenuButton_1.text = selectedSchoolName
	var school = Data.schools.get(selectedSchoolName)
	var spellList = school.spells
	var spell1_Popup = spellMenuButton_1.get_popup()
	spell1_Popup.clear()
	var idx = 0
	for spell in spellList:
		var spellMenuName = str(spell.name + " (" + str(spell.cast + 4) + ")")
		spell1_Popup.add_item(spellMenuName)
		spell1_Popup.set_item_metadata(idx, spell)
		idx += 1
	# catch a change of school happening AFTER a school + spell were already selected.
	spell1Selected = false
	emit_signal("signal_any_spell_selected")
	
func _on_school_2_pressed(id):
	emit_signal("signal_school_selected", 1, id)
	spell2Desc.text = ""
	spell2RangeLabel.text = ""
	spell2RangeLabel.clear()
	spellMenuButton_2.text = Data.spellSelectDefaultText
	
	var selectedSchoolName = schoolMenuButton_2.get_popup().get_item_text(id)
	schoolMenuButton_2.text = selectedSchoolName
	var school = Data.schools.get(selectedSchoolName)
	var spellList = school.spells
	var spell2_Popup = spellMenuButton_2.get_popup()
	spell2_Popup.clear()
	var idx = 0
	for spell in spellList:
		var spellMenuName = str(spell.name + "(" + str(spell.cast + 4) + ")")
		spell2_Popup.add_item(spellMenuName)
		spell2_Popup.set_item_metadata(idx, spell)
		idx += 1
	spell2Selected = false
	emit_signal("signal_any_spell_selected")
	
func _on_spell_1_pressed(id):
	var spellSelected = spellMenuButton_1.get_popup().get_item_text(id) 
	var spellMetadata = spellMenuButton_1.get_popup().get_item_metadata(id)
	spellMenuButton_1.text = spellSelected
	spell1Desc.text = spellMetadata.descr
	spell1Selected = true
	UsrData.spellSummarylist[6] = spellSelected
	set_spell_range(1, spellMetadata.range)
	emit_signal("signal_any_spell_selected")
	
func _on_spell_2_pressed(id):
	var spellSelected = spellMenuButton_2.get_popup().get_item_text(id)
	var spellMetadata = spellMenuButton_2.get_popup().get_item_metadata(id)
	spellMenuButton_2.text = spellSelected
	spell2Desc.text = spellMetadata.descr
	spell2Selected = true
	UsrData.spellSummarylist[7] = spellSelected
	set_spell_range(2, spellMetadata.range)
	emit_signal("signal_any_spell_selected")


func _on_any_spells_selected():
	if spell1Selected and spell2Selected:
		buttonToWarband.disabled = false
	else:
		buttonToWarband.disabled = true
		

func _on_spell_school_selected(menuIdx, schoolID):
	# disables spell school selection in the other dropdown
	# see: _on_spell_selected() signal handler
	currentlySelectedSchoolIDs[menuIdx] = schoolID
	for menuButton in schooMenuButtons:
		var popup = menuButton.get_popup()
		var idx = 0
		while idx < popup.item_count:
			var currentID = popup.get_item_id(idx)
			if currentlySelectedSchoolIDs.has(currentID):
				popup.set_item_disabled(idx, true)
			else:
				popup.set_item_disabled(idx, false)
			idx += 1
