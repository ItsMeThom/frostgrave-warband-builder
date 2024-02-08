extends BoxContainer

var cardTemplate = preload("res://scenes/soldier_card.tscn")
var rosterTemplate = preload("res://scenes/roster_info.tscn")

@onready var availablSoldierCardsContainer = $VBoxContainer/ScrollContainer_TroopCards/VBoxContainer_TroopCards
@onready var rosterContainer = $VBoxContainer/ScrollContainer_Roster/VBoxContainer_Roster
@onready var warbandTotalCostLabel = $VBoxContainer/Label_WarbandValue
@onready var buttonToSummary = $VBoxContainer/VBoxContainer/MarginContainer/Button_toSummary

signal signal_to_summary_pressed
signal apprentice_purchased
var totalCost = 0

func populate_soldier_cards():
	for soldierName in Data.soldiers.keys():
		var card = cardTemplate.instantiate()
		availablSoldierCardsContainer.add_child(card)
		card.populate_card(soldierName, Data.soldiers.get(soldierName), _on_card_buy_button_pressed)


func _on_card_buy_button_pressed(soldierName, soldierMetadata):
	var rosterLine = rosterTemplate.instantiate()
	rosterContainer.add_child(rosterLine)
	rosterLine.populate_info(soldierName, soldierMetadata, true, _on_roster_line_removed)
	totalCost += soldierMetadata.cost
	update_total_cost_label()


func update_total_cost_label():
	warbandTotalCostLabel.text = "Warband: " + str(totalCost) + "gc"


func reset_page():
	totalCost = 0
	update_total_cost_label()
	for child in rosterContainer.get_children():
		child.queue_free()

func _ready():
	populate_soldier_cards() 


func _on_roster_line_removed(cost):
	totalCost -= cost
	update_total_cost_label()


func _on_button_to_summary_pressed():
	UsrData.currentSoldierRoster = []
	for line in rosterContainer.get_children():
		var metaData = line.soldierMetadata
		UsrData.currentSoldierRoster.append(metaData)
	emit_signal("signal_to_summary_pressed")
	

func _on_apprentice_purchased():
	pass
	# if the apprentice weapon dropdown is not visible, make it so
	# todo: if aprentice is removed, remove and clear the dropdown
