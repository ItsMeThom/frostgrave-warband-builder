extends BoxContainer


@onready var spell1 = $VBoxContainer/Label_Spell
@onready var spell2 = $VBoxContainer/Label_Spell2
@onready var spell3 = $VBoxContainer/Label_Spell3
@onready var spell4 = $VBoxContainer/Label_Spell4
@onready var spell5 = $VBoxContainer/Label_Spell5
@onready var spell6 = $VBoxContainer/Label_Spell6
@onready var spell7 = $VBoxContainer/Label_Spell7
@onready var spell8 = $VBoxContainer/Label_Spell8

@onready var spellSummary = [spell1, spell2, spell3, spell4, spell5, spell6, spell7, spell8]

@onready var wizardName = $VBoxContainer/Label_WizardTitle
# statlabels
@onready var moveValue = $VBoxContainer/HBoxContainer/VBoxContainer/Label_MoveValue
@onready var fightValue = $VBoxContainer/HBoxContainer/VBoxContainer2/Label_FightValue
@onready var shootValue = $VBoxContainer/HBoxContainer/VBoxContainer3/Label_ShootValue
@onready var armourValue = $VBoxContainer/HBoxContainer/VBoxContainer4/Label_ArmValue
@onready var willValue = $VBoxContainer/HBoxContainer/VBoxContainer5/Label_WillValue
@onready var healthValue = $VBoxContainer/HBoxContainer/VBoxContainer6/Label_HealthValue

@onready var rosterContainer = $VBoxContainer/ScrollContainer/VBoxContainer_WarbandRoster

@onready var buttonSaveWizard = $VBoxContainer/VBoxContainer2/MarginContainer2/Button_SaveWizard
var saveButtonDefaultText = "Save Wizard"

var rosterTemplate = preload("res://scenes/roster_info.tscn")

signal on_wizard_saved_to_disk

func populate():
	clear_roster()
	buttonSaveWizard.text = saveButtonDefaultText
	buttonSaveWizard.disabled = false
	var idx = 0
	for spell in UsrData.spellSummarylist:
		spellSummary[idx].text = spell
		idx += 1
	wizardName.text = UsrData.currentWizardName
	
	for soldierData in UsrData.currentSoldierRoster:
		var rosterLine = rosterTemplate.instantiate()
		rosterContainer.add_child(rosterLine)
		rosterLine.populate_info(soldierData.name, soldierData)

func reset():
	clear_roster()

func clear_roster():
	for soldier in rosterContainer.get_children():
		soldier.queue_free()

func _save_wizard():
	# todo: not this, it should read FROM usrData not write to it
	var saveableWizard = Data.wizardSaveTemplate
	saveableWizard["name"] = UsrData.currentWizardName
	saveableWizard["school"] = UsrData.currentWizardSchoolName
	saveableWizard["move"] = float(moveValue.text)
	saveableWizard["fight"] = float(fightValue.text)
	saveableWizard["shoot"] = float(shootValue.text)
	saveableWizard["armour"] = float(armourValue.text)
	saveableWizard["will"] = float(willValue.text)
	saveableWizard["health"] = float(healthValue.text)
	saveableWizard["spells"] = []
	for spell in UsrData.spellSummarylist:
		saveableWizard["spells"].append(spell)
	saveableWizard["roster"] = []
	for soldier in UsrData.currentSoldierRoster:
		saveableWizard["roster"].append(soldier)
		
	UsrData.save_wizard(saveableWizard, saveableWizard["name"])
	


func _on_button_save_wizard_pressed():
	_save_wizard()
	emit_signal("on_wizard_saved_to_disk")
