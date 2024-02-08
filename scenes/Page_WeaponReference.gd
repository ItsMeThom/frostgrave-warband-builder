extends BoxContainer



@onready var weaponListBox = $VBoxContainer/ScrollContainer/VBoxContainer_weaponList

var weaponCardTemplate = preload("res://scenes/weapon_reference_card.tscn")

func populate():
	for wep in Data.weapons:
		var weapon = weaponCardTemplate.instantiate()
		weaponListBox.add_child(weapon)
		weapon.populate(wep)
