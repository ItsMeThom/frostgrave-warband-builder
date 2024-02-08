extends BoxContainer

@onready var wizardList = $VBoxContainer/ScrollContainer/VBoxContainer_wizardList

var wizardCard = preload("res://scenes/saved_wizard.tscn")

func populate():
	UsrData.loadSavedWizards()
	for wiz in UsrData.savedWizards:
		var wizCard = wizardCard.instantiate()
		wizardList.add_child(wizCard)
		wizCard.populate(wiz, UsrData.delete_saved_wizard)

func reset():
	for child in wizardList.get_children():
		child.queue_free()
