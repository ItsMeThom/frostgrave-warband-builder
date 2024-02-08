extends Control


@onready var wizardName = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Header/Label_WizardName
@onready var wizardSchool = $PanelContainer/MarginContainer/VBoxContainer/Label_WizardSchool
@onready var moveValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer/Label_MoveValue
@onready var fightValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer2/Label_FightValue
@onready var shootValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer3/Label_ShootValue
@onready var armValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer4/Label_ArmValue
@onready var willValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer5/Label_WillValue
@onready var healthValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer_Stats/VBoxContainer6/Label_HealthValue
# spell list
@onready var spellListBox = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer_spellList

# roster list
@onready var rosterListBox = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainerRoster/VBoxContainer_RosterList

var spellListTheme = preload("res://Resources/themes/spell_list.tres")

var rosterLineTemplate = preload("res://scenes/roster_info.tscn")

signal signal_on_wizard_deleted

func populate(data, deleteSignalReceiver):
	wizardName.text = data.name
	wizardSchool.text = data.school
	moveValue.text = str(data.move)
	fightValue.text = create_stat_mod_string(data.fight)
	shootValue.text = create_stat_mod_string(data.shoot)
	armValue.text = str(data.armour)
	willValue.text = create_stat_mod_string(data.will)
	healthValue.text = str(data.health)
	for spell in data.spells:
		var spellLabel = Label.new()
		spellListBox.add_child(spellLabel)
		spellLabel.text = spell
		spellLabel.theme = spellListTheme
	for soldier in data.roster:
		var rosterLine = rosterLineTemplate.instantiate()
		rosterListBox.add_child(rosterLine)
		rosterLine.populate_info(soldier.name, soldier)
	signal_on_wizard_deleted.connect(deleteSignalReceiver)

func create_stat_mod_string(statValue) -> String:
	if statValue >= 0:
		return "+" + str(statValue)
	else:
		return str(statValue)


func _on_button_delete_saved_pressed():
	emit_signal("signal_on_wizard_deleted", wizardName.text)
	self.queue_free()
