extends BoxContainer

@onready var spellListBox = $VBoxContainer/ScrollContainer/VBoxContainer_spellList
@onready var spellSchoolMenu = $VBoxContainer/VBoxContainer_PageTitle/MenuButton_SpellSchool


var spellCardTemplate = preload("res://scenes/spell_reference_card.tscn")


const allSchoolsOptionText = "All Schools"

func populate():
	reset()
	for schoolName in Data.schools.keys():
		var school = Data.schools[schoolName]
		for spell in school.spells:
			var card = spellCardTemplate.instantiate()
			spellListBox.add_child(card)
			card.populate(schoolName, spell)
	ready_spellschool_menu()

func reset():
	for child in spellListBox.get_children():
		child.queue_free()


func ready_spellschool_menu():
	var spellMenuPopup = spellSchoolMenu.get_popup()
	spellMenuPopup.clear()
	spellMenuPopup.add_item(allSchoolsOptionText)
	for key in Data.schools.keys():
		spellMenuPopup.add_item(key)
	spellMenuPopup.id_pressed.connect(_on_popup_menu_spell_school_pressed)

	
func _on_popup_menu_spell_school_pressed(id):
	reset_list_to_default()
	var selectedSchool = spellSchoolMenu.get_popup().get_item_text(id)
	if selectedSchool != allSchoolsOptionText:
		filter_list_by_school(selectedSchool)
	spellSchoolMenu.text = selectedSchool
	
	
func filter_list_by_school(school):
	for card in spellListBox.get_children():
		if card.spellSchool.text != school:
			card.visible = false


func reset_list_to_default():
	for card in spellListBox.get_children():
		card.visible = true
