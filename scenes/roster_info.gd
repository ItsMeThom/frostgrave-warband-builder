extends Control

@onready var soldierName = $HBoxContainer/Label_soldierName
@onready var statLine = $HBoxContainer/MarginContainer/RTL_statLine
@onready var buttonRemove = $HBoxContainer/Button_remove


var unitCost = 0
var soldierMetadata = null

signal on_soldier_removed_from_roster

# takes the removable parameter as an option, which if true,
# requires the remove_signal_receiver to be set. This enabled
# the remove button and wires up a receiver for the signal emitted
# when it is pressed
func populate_info(newSoldierName, data, removable=false, remove_signal_receiver=null):
	soldierMetadata = data
	soldierName.text = newSoldierName
	unitCost = data.cost
	var statString = \
	"[b] M[/b] " + str(data.move) +\
	"[b] F[/b] " + parse_stat(data.fight) +\
	"[b] S[/b] " + parse_stat(data.shoot) +\
	"[b] A[/b] " + str(data.armour) +\
	"[b] W[/b] " + parse_stat(data.will) +\
	"[b] H[/b] " + str(data.health)
	statLine.clear()
	statLine.append_text(statString)
	
	if removable:
		buttonRemove.visible = true
		# wire up signal to receiver
		on_soldier_removed_from_roster.connect(remove_signal_receiver, unitCost)


func parse_stat(stat):
	if stat < 0:
		return str(stat)
	else:
		return "+" + str(stat)

func _ready():
	buttonRemove.visible = false

func _on_button_remove_pressed():
	emit_signal("on_soldier_removed_from_roster", unitCost)
	# remove this node
	self.queue_free()
