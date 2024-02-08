extends PanelContainer


@onready var weaponName = $VBoxContainer/HBoxContainer_Title/VBoxContainer/Label_WeaponTitle
@onready var weaponSlot = $VBoxContainer/HBoxContainer_Title/VBoxContainer/Label_WeaponSlot
@onready var rangeValue = $VBoxContainer/HBoxContainer/VBoxContainer/Label_RangeValue
@onready var dmgModValue = $VBoxContainer/HBoxContainer/VBoxContainer2/Label_DmgValue
@onready var descr  = $VBoxContainer/MarginContainer/RTL_descr


func populate(wepMetadata):
	weaponName.text = wepMetadata.name
	weaponSlot.text = parse_slot(wepMetadata.slots)
	rangeValue.text = wepMetadata.range
	dmgModValue.text = parse_stat(wepMetadata.damage)
	descr.clear()
	descr.append_text(wepMetadata.descr)


func parse_stat(stat):
	if stat < 0:
		return str(stat)
	else:
		return "+" + str(stat)

func parse_slot(slot):
	if slot <= 0:
		return "free"
	elif slot == 1:
		return str(slot) + " Slot"
	else:
		return str(slot) + " Slots"
