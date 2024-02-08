extends BoxContainer

@onready var wizardNameLineEdit = $VBoxContainer/ScrollContainer/VBoxContainer/PageHeader/MarginContainer/LineEdit_WizardName

@onready var spellSchoolMenuButton = $VBoxContainer/ScrollContainer/VBoxContainer/MenuButton_SpellSchool

@onready var mainSpell_1 = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector/MenuButton_Spell1
@onready var mainSpell_2 = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector2/MenuButton_Spell2
@onready var mainSpell_3 = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector3/MenuButton_Spell3

@onready var mainSpellMenuButtons = [mainSpell_1.get_popup(), mainSpell_2.get_popup(), mainSpell_3.get_popup()]

# spell description RichTextLabels
@onready var spell1Label = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector/Desc_Spell1
@onready var spell2Llabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector2/Desc_Spell2
@onready var spell3Label = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector3/Desc_Spell3
@onready var spellDescriptionLabels = [spell1Label, spell2Llabel, spell3Label]

@onready var spell1RangeLabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector/Range_Spell1
@onready var spell2RangeLabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector2/Range_Spell2
@onready var spell3RangeLabel = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector3/Range_Spell3
@onready var spellRangeLabels = [spell1RangeLabel, spell2RangeLabel, spell3RangeLabel]

@onready var alignmentLabel = $VBoxContainer/ScrollContainer/VBoxContainer/Label_Alignment

signal signal_any_spell_selected # signal to toggle the bools and enable the button for next page
signal spell_selected # signal to tell other dropdowns to disable the selected spell


var currentlySelectedSpellIDs = [-1,-1,-1]
var spell1_Selected = false
var spell2_Selected = false
var spell3_Selected = false

@onready var button_toAlignedSpells = $VBoxContainer/VBoxContainer/MarginContainer/Button_ToAlignedSpells


func populate():
	reset_page()
	ready_spell_dropdowns()
	ready_spellschool_menu()


# populated the dropdown with the school names, connect the selection signal to
# set the text on the button to the selected school
func ready_spellschool_menu():
	var spellMenuPopup = spellSchoolMenuButton.get_popup()
	spellMenuPopup.clear()
	for key in Data.schools.keys():
		spellMenuPopup.add_item(key)
	spellMenuPopup.id_pressed.connect(_on_popup_menu_spell_school_pressed)
	spellSchoolMenuButton.text = Data.schoolSelectDefaultText

# connect signal for selecting spell to individual dropdowns
func ready_spell_dropdowns():
	mainSpell_1.disabled = true
	mainSpell_2.disabled = true
	mainSpell_3.disabled = true
	mainSpell_1.text = Data.spellSelectDefaultText
	mainSpell_2.text = Data.spellSelectDefaultText
	mainSpell_3.text = Data.spellSelectDefaultText
	

func add_main_spells_to_dropdowns():
	for dropdown in mainSpellMenuButtons:
		var idx = 0
		for spell in UsrData.selectedSchool.spells:
			var menuItem = str(spell.name + " " + "(" + str(spell.cast) + ")")
			dropdown.add_item(menuItem)
			dropdown.set_item_metadata(idx, spell)
			idx += 1

func clear_spells_from_dropdowns():
	for dropdown in mainSpellMenuButtons:
		dropdown.clear()
	mainSpell_1.text = Data.spellSelectDefaultText
	mainSpell_2.text = Data.spellSelectDefaultText
	mainSpell_3.text = Data.spellSelectDefaultText
	spell1_Selected = false
	spell2_Selected = false
	spell3_Selected = false
	button_toAlignedSpells.disabled = true

func enable_main_spell_selection():
	mainSpell_1.disabled = false
	mainSpell_2.disabled = false
	mainSpell_3.disabled = false
	

func clear_spell_descriptions():
	for l in spellDescriptionLabels:
		if l is RichTextLabel:
			l.clear()


func clear_spell_ranges():
	for l in spellRangeLabels:
		if l is RichTextLabel:
			l.clear()


func set_spell_description(spellNumber, description):
	var descriptionLabel: RichTextLabel = spellDescriptionLabels[spellNumber-1]
	descriptionLabel.clear()
	descriptionLabel.add_text(description)
	
func set_spell_range(spellNumber, rangeText):
	var rangeLabel: RichTextLabel = spellRangeLabels[spellNumber - 1]
	rangeLabel.clear()
	rangeLabel.append_text("[b]Range:[/b] " + rangeText + " ")


func set_alignment_label():
	var aligned = UsrData.selectedSchool.aligned
	var neutral = UsrData.selectedSchool.neutral
	var opposed = UsrData.selectedSchool.opposed
	var alignedText = "[b]Aligned:[/b] "
	var neutralText = "[b]Neutral:[/b] "
	var opposedText = "[b]Opposed:[/b] "
	alignedText += ", ".join(aligned)
	neutralText += ", ".join(neutral)
	opposedText += ", ".join(opposed)
	alignmentLabel.clear()
	alignmentLabel.append_text(alignedText + "\n" + neutralText + "\n" + opposedText)
	
func clear_alignment_label():
	alignmentLabel.clear()

func _ready():
	# wire up signals
	mainSpell_1.get_popup().id_pressed.connect(_on_popup_menu_spell_1_pressed)
	mainSpell_2.get_popup().id_pressed.connect(_on_popup_menu_spell_2_pressed)
	mainSpell_3.get_popup().id_pressed.connect(_on_popup_menu_spell_3_pressed)
	signal_any_spell_selected.connect(_on_any_spell_selected)
	spell_selected.connect(_on_spell_selected)
	# disable spell selectors until a school is chosen
	

func reset_page():
	# clear selected school
	spellSchoolMenuButton.text = Data.schoolSelectDefaultText
	# clear selected spells
	mainSpell_1.text = Data.spellSelectDefaultText
	mainSpell_2.text = Data.spellSelectDefaultText
	mainSpell_3.text = Data.spellSelectDefaultText
	clear_spell_descriptions()
	clear_spell_ranges()
	clear_alignment_label()
	spell1_Selected = false
	spell2_Selected = false
	spell3_Selected = false
	button_toAlignedSpells.disabled = true

#force focus of the wizard name edit so people dont forget to add one
func force_focus_wizard_name_edit():
	wizardNameLineEdit.grab_focus()

#########
# signals
#########
func _on_popup_menu_spell_school_pressed(id):
	var selected = spellSchoolMenuButton.get_popup().get_item_text(id)
	UsrData.selectedSchool = Data.schools.get(selected)
	UsrData.currentWizardSchoolName = selected
	spellSchoolMenuButton.text = selected
	currentlySelectedSpellIDs = [-1, -1, -1]
	clear_spells_from_dropdowns()
	clear_spell_descriptions()
	clear_spell_ranges()
	clear_alignment_label()
	add_main_spells_to_dropdowns()
	set_alignment_label()
	enable_main_spell_selection()
	


func _on_popup_menu_spell_1_pressed(id):
	var selectedSpellListItem = mainSpell_1.get_popup().get_item_text(id)
	mainSpell_1.text = selectedSpellListItem
	var spellMetadata =  mainSpell_1.get_popup().get_item_metadata(id)
	set_spell_description(1, spellMetadata.descr)
	set_spell_range(1, spellMetadata.range)
	UsrData.spellSummarylist[0] = selectedSpellListItem
	spell1_Selected = true
	emit_signal("spell_selected", 0, id)
	emit_signal("signal_any_spell_selected")
	

func _on_popup_menu_spell_2_pressed(id):
	var selectedSpellListItem = mainSpell_2.get_popup().get_item_text(id)
	mainSpell_2.text = selectedSpellListItem
	var spellMetadata =  mainSpell_2.get_popup().get_item_metadata(id)
	set_spell_description(2, spellMetadata.descr)
	set_spell_range(2, spellMetadata.range)
	UsrData.spellSummarylist[1] = selectedSpellListItem
	spell2_Selected = true
	emit_signal("spell_selected", 1, id)
	emit_signal("signal_any_spell_selected")
	
func _on_popup_menu_spell_3_pressed(id):
	var selectedSpellListItem = mainSpell_3.get_popup().get_item_text(id)
	mainSpell_3.text = selectedSpellListItem
	var spellMetadata =  mainSpell_3.get_popup().get_item_metadata(id)
	set_spell_description(3, spellMetadata.descr)
	set_spell_range(3, spellMetadata.range)
	UsrData.spellSummarylist[2] = selectedSpellListItem
	spell3_Selected = true
	emit_signal("spell_selected", 2, id)
	emit_signal("signal_any_spell_selected")
	
	
func _on_any_spell_selected():
	if spell1_Selected and spell2_Selected and spell3_Selected:
		button_toAlignedSpells.disabled = false
		
		
func _on_spell_selected(menuIdx, spellID):
	# we have the spell id and its index
	# check in currently select if this menu has already a spell selected
	# if so, fetch that ID, and re-enable in all other dropdowns
	# add the currentspellID to the array, and disable in all other dropdowns.
	currentlySelectedSpellIDs[menuIdx] = spellID
	for popup in mainSpellMenuButtons:
		var idx = 0
		while idx < popup.item_count:
			var currentID = popup.get_item_id(idx)
			if currentlySelectedSpellIDs.has(currentID):
				popup.set_item_disabled(idx, true)
			else:
				popup.set_item_disabled(idx, false)
			idx += 1



# defocus the LineEdit when enter is pressed (on virtual keyboard)
func _on_line_edit_wizard_name_gui_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			wizardNameLineEdit.release_focus()


func _on_line_edit_wizard_name_focus_exited():
	print("Saving wizard name: " + wizardNameLineEdit.text)
	UsrData.currentWizardName = wizardNameLineEdit.text
