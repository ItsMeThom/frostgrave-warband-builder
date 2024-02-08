extends PanelContainer


@onready var spellTitle = $VBoxContainer/HBoxContainer_Title/VBoxContainer/Label_SpellTitle
@onready var spellSchool = $VBoxContainer/HBoxContainer_Title/VBoxContainer/Label_SpellSchool

@onready var rangeValue = $VBoxContainer/HBoxContainer/VBoxContainer/Label_RangeValue
@onready var castValue = $VBoxContainer/HBoxContainer/VBoxContainer2/Label_CastValue

@onready var spellDescr = $VBoxContainer/MarginContainer/RTL_descr



func populate(school, spellData):
	spellTitle.text = spellData.name
	rangeValue.text = spellData.range
	castValue.text = str(spellData.cast)
	spellSchool.text = school
	spellDescr.clear()
	spellDescr.append_text(spellData.descr)
	set_accent_colour(school)
	
	
func set_accent_colour(schoolName):
	var colorHexStr = Data.schoolColours.get(schoolName, "#FFFFFF")
	# Creates a local override for a theme StyleBox with the specified name. Local overrides always take precedence when fetching theme items for the control. An override can be removed with remove_theme_stylebox_override().
	# The snippet below assumes the child node MyButton has a StyleBoxFlat assigned.
	# Resources are shared across instances, so we need to duplicate it
	# to avoid modifying the appearance of all other buttons.
	var new_stylebox_normal = self.get_theme_stylebox("panel").duplicate()
	new_stylebox_normal.border_color = Color(colorHexStr)
	self.add_theme_stylebox_override("panel", new_stylebox_normal)

