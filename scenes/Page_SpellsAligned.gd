extends BoxContainer

signal signal_aligned_spell_selected

@onready var alignedSchool1_Title = $VBoxContainer2/ScrollContainer/VBoxContainer/Label_AlignedSchool_1
@onready var alignedSchool2_Title = $VBoxContainer2/ScrollContainer/VBoxContainer/Label_AlignedSchool_2
@onready var alignedSchool3_Title = $VBoxContainer2/ScrollContainer/VBoxContainer/Label_AlignedSchool_3

@onready var alignedSpell1_MenuButton = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/MenuButton_AlignedSchool_1
@onready var alignedSpell2_MenuButton = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/MenuButton_AlignedSchool_2
@onready var alignedSpell3_MenuButton = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_3/MenuButton_AlignedSchool_3

@onready var spell1_Desc = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/Desc_Spell1
@onready var spell2_Desc = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/Desc_Spell2
@onready var spell3_Desc = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_3/Desc_Spell3
@onready var spellDescriptionLabels = [spell1_Desc, spell2_Desc, spell3_Desc]

@onready var spell1RangeLabel = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_1/Range_Spell1
@onready var spell2RangeLabel = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_2/Range_Spell2
@onready var spell3RangeLabel = $VBoxContainer2/ScrollContainer/VBoxContainer/VBoxContainer_SpellSelector_3/Range_Spell3
@onready var spellRangeLabels = [spell1RangeLabel, spell2RangeLabel, spell3RangeLabel]

var spell1_Selected = false
var spell2_Selected = false
var spell3_Selected = false

@onready var button_toNeturalSpells = $VBoxContainer2/VBoxContainer/MarginContainer/Button_ToNeutralSpells

func ready_aligned_school_dropdowns():
	alignedSpell1_MenuButton.get_popup().id_pressed.connect(_on_aligned_school_1_pressed)
	alignedSpell2_MenuButton.get_popup().id_pressed.connect(_on_aligned_school_2_pressed)
	alignedSpell3_MenuButton.get_popup().id_pressed.connect(_on_aligned_school_3_pressed)
	

func _ready():
	ready_aligned_school_dropdowns()
	clear_spell_descriptions()
	clear_spell_ranges()
	signal_aligned_spell_selected.connect(on_aligned_spell_selected)


func populate():
	reset_page()
	alignedSchool1_Title.text = UsrData.selectedSchool.aligned[0]
	_populate_dropdown(alignedSpell1_MenuButton.get_popup(), UsrData.selectedSchool.aligned[0])
	alignedSchool2_Title.text = UsrData.selectedSchool.aligned[1]
	_populate_dropdown(alignedSpell2_MenuButton.get_popup(), UsrData.selectedSchool.aligned[1])
	alignedSchool3_Title.text = UsrData.selectedSchool.aligned[2]
	_populate_dropdown(alignedSpell3_MenuButton.get_popup(), UsrData.selectedSchool.aligned[2])

func _populate_dropdown(dropdown, school_name):
	dropdown.clear()
	var alignedSchool = Data.schools.get(school_name)
	var idx = 0
	for spell in alignedSchool.spells:
		var alignedCast = spell.cast + 2
		var menu_item = str(spell.name + " (" + str(alignedCast) + ")")
		dropdown.add_item(menu_item)
		dropdown.set_item_metadata(idx, spell)
		idx += 1


func set_spell_range(spellNumber, rangeText):
	var rangeLabel: RichTextLabel = spellRangeLabels[spellNumber - 1]
	rangeLabel.clear()
	rangeLabel.append_text("[b]Range:[/b] " + rangeText + " ")


func set_spell_description(spell_number, description):
	var description_label: RichTextLabel = spellDescriptionLabels[spell_number-1]
	description_label.clear()
	description_label.add_text(description)


func clear_spell_descriptions():
	for rtl in spellDescriptionLabels:
		if rtl is RichTextLabel:
			rtl.clear()


func clear_spell_ranges():
	for l in spellRangeLabels:
		if l is RichTextLabel:
			l.clear()
			


func reset_page():
	clear_spell_descriptions()
	clear_spell_ranges()
	alignedSpell1_MenuButton.text = Data.spellSelectDefaultText
	alignedSpell2_MenuButton.text = Data.spellSelectDefaultText
	alignedSpell3_MenuButton.text = Data.spellSelectDefaultText
	spell1_Selected = false
	spell2_Selected = false
	spell3_Selected = false
	button_toNeturalSpells.disabled = true

#####
# Signals
#####


func _on_aligned_school_1_pressed(id):
	var selectedSpellListItem = alignedSpell1_MenuButton.get_popup().get_item_text(id)
	alignedSpell1_MenuButton.text = selectedSpellListItem
	var spellMetadata =  alignedSpell1_MenuButton.get_popup().get_item_metadata(id)
	set_spell_description(1, spellMetadata.descr)
	set_spell_range(1, spellMetadata.range)
	spell1_Selected = true
	UsrData.spellSummarylist[3] = selectedSpellListItem
	emit_signal("signal_aligned_spell_selected")
	
func _on_aligned_school_2_pressed(id):
	var selectedSpellListItem = alignedSpell2_MenuButton.get_popup().get_item_text(id)
	alignedSpell2_MenuButton.text = selectedSpellListItem
	var spellMetadata =  alignedSpell2_MenuButton.get_popup().get_item_metadata(id)
	set_spell_description(2, spellMetadata.descr)
	set_spell_range(2, spellMetadata.range)
	spell2_Selected = true
	UsrData.spellSummarylist[4] = selectedSpellListItem
	emit_signal("signal_aligned_spell_selected")
	
func _on_aligned_school_3_pressed(id):
	var selectedSpellListItem = alignedSpell3_MenuButton.get_popup().get_item_text(id)
	alignedSpell3_MenuButton.text = selectedSpellListItem
	var spellMetadata =  alignedSpell3_MenuButton.get_popup().get_item_metadata(id)
	set_spell_description(3, spellMetadata.descr)
	set_spell_range(3, spellMetadata.range)
	spell3_Selected = true
	UsrData.spellSummarylist[5] = selectedSpellListItem
	emit_signal("signal_aligned_spell_selected")
	
func on_aligned_spell_selected():
	if spell1_Selected and spell2_Selected and spell3_Selected:
		button_toNeturalSpells.disabled = false
