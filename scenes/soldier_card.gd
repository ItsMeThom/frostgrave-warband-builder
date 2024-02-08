extends Control


var soldierMetadata = null


@onready var soldierName = $VBoxContainer/MarginContainer/HBoxContainer_Header/Label_SoldierName
@onready var soldierType = $VBoxContainer/MarginContainer/HBoxContainer_Header/Label_SoldierType

@onready var stat_Move = $VBoxContainer/HBoxContainer_Stats/VBoxContainer/Label_MoveValue
@onready var stat_Fight = $VBoxContainer/HBoxContainer_Stats/VBoxContainer2/Label_FightValue
@onready var stat_Shoot = $VBoxContainer/HBoxContainer_Stats/VBoxContainer3/Label_ShootValue
@onready var stat_Armour = $VBoxContainer/HBoxContainer_Stats/VBoxContainer4/Label_ArmValue
@onready var stat_Will = $VBoxContainer/HBoxContainer_Stats/VBoxContainer5/Label_WillValue
@onready var stat_Health = $VBoxContainer/HBoxContainer_Stats/VBoxContainer6/Label_HealthValue

@onready var gearLabel = $VBoxContainer/RTL_Gear
@onready var descrLabel = $VBoxContainer/RTL_Descr

@onready var buyButton = $VBoxContainer/MarginContainer/HBoxContainer_Header/Button_buySoldier

signal on_soldier_purchase_made

func set_soldierName(newName):
	soldierName.text = newName


func set_soldierCost(newCost):
	buyButton.text = "+" + str(newCost) + " gc"


func set_soldierType(newType):
	soldierType.text = newType


func create_stat_mod_string(statValue) -> String:
	if statValue >= 0:
		return "+" + str(statValue)
	else:
		return str(statValue)


func set_stat_label(label: Label, statValue: float, is_modifier: bool):
	if is_modifier:
		label.text = create_stat_mod_string(statValue)
	else:
		label.text = str(statValue)


func set_gear_label(gear: Array):
	var gearStr = "[b]Gear:[/b] " + ", ".join(gear)
	gearLabel.clear()
	gearLabel.append_text(gearStr)


func set_description_infobox(descr):
	descrLabel.clear()
	descrLabel.append_text(descr)


func shrink_card():
	# if theres no description for the soldier, shrink the card and hide that label.
	self.set_custom_minimum_size(Vector2(340, 140))
	descrLabel.visible = false


func populate_card(name, data, purchase_signal_receiver):
	# set card size depending on if there is a decription or not:
	if data.descr.length() == 0:
		shrink_card()
	soldierMetadata = data
	set_soldierName(name)
	set_soldierCost(data.cost)
	set_soldierType(data.type)
	# stats
	set_stat_label(stat_Move, data.move, false)
	set_stat_label(stat_Fight, data.fight, true)
	set_stat_label(stat_Shoot, data.shoot, true)
	set_stat_label(stat_Armour, data.armour, false)
	set_stat_label(stat_Will, data.will, true)
	set_stat_label(stat_Health, data.health, false)
	set_description_infobox(data.descr)
	set_gear_label(data.equipment)
	
	# wire buy button
	attach_buy_button_signal(purchase_signal_receiver)

# pass a callable method from a parent or other node
# that the buy button will attach to
func attach_buy_button_signal(receiver_method: Callable):
	on_soldier_purchase_made.connect(receiver_method)




func _ready():
	populate_card("Infantryman", {
		"type": "Regular",
		"move": 6,
		"fight": 3,
		"shoot": 0,
		"armour": 11,
		"will": 0,
		"health": 10,
		"cost": 50,
		"equipment": ["Two Handed Weapon", "Light Armour"],
		"descr": "Im a nonzero length description"
	}, _on_button_buy_soldier_pressed)


func _on_button_buy_soldier_pressed():
	# buy button signal received here, emits signal to programatically attached
	# caller with soldier metadata
	print("buy pressed")
	emit_signal("on_soldier_purchase_made", soldierName.text, soldierMetadata)
