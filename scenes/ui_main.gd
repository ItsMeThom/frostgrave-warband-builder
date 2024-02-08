extends Control


@export var _ColorScheme: UIColourSchemeResource = preload("res://Resources/ColourSchemes/Solarized.tres")

@onready var ui_background = $BG
@onready var pageHeaderLabel = $MarginContainer/VBoxContainer/AppHeader/Label


enum pages {HOME, SPELL_MAIN, SPELL_ALIGNED, SPELL_NEUTRAL, WIZARD_SUMMARY, WARBAND, SAVED_WIZARDS, SPELL_REFERENCE, WEAPON_REFERENCE}
var currentActivePage = pages.HOME

func set_color_scheme():
	ui_background.color = Color(_ColorScheme.background)
	pageHeaderLabel.label_settings.font_color = Color(_ColorScheme.foreground)



# Called when the node enters the scene tree for the first time.
func _ready():
	set_color_scheme()
	$MarginContainer/VBoxContainer/Body/Page_SpellReference.populate()
	$MarginContainer/VBoxContainer/Body/Page_WeaponReference.populate()


func _on_button_create_wizard_pressed():
	currentActivePage = pages.SPELL_MAIN
	$MarginContainer/VBoxContainer/Body/Page_Home.visible = false
	$MarginContainer/VBoxContainer/Body/Page_SpellsMain.populate()
	$MarginContainer/VBoxContainer/Body/Page_SpellsMain.visible = true
	$MarginContainer/VBoxContainer/Body/Page_SpellsMain.force_focus_wizard_name_edit()

func _on_button_to_aligned_spells_pressed():
	currentActivePage = pages.SPELL_ALIGNED
	$MarginContainer/VBoxContainer/Body/Page_SpellsMain.visible = false
	$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.populate()
	$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.visible = true
	


func _on_button_to_neutral_spells_pressed():
	currentActivePage = pages.SPELL_NEUTRAL
	$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.visible = false
	$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.populate()
	$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.visible = true



func _on_button_to_warband_pressed():
	$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.visible = false
	# $MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.populate()
	$MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.visible = true
	currentActivePage = pages.WARBAND


func _on_button_to_summary_pressed():
	currentActivePage = pages.WIZARD_SUMMARY
	$MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.visible = false
	$MarginContainer/VBoxContainer/Body/Page_Summary.populate()
	$MarginContainer/VBoxContainer/Body/Page_Summary.visible = true


func _on_on_wizard_saved_to_disk():
	# reset each page
	# reset selected spells in Data
	# show homepage
	currentActivePage = pages.HOME
	$MarginContainer/VBoxContainer/Body/Page_Summary.visible = false
	$MarginContainer/VBoxContainer/Body/Page_SpellsMain.reset_page()
	$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.reset_page()
	$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.reset_page()
	$MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.reset_page()
	UsrData.reset_selected_school()
	UsrData.reset_spell_summary_list()
	UsrData.clear_temp_wizard()
	$MarginContainer/VBoxContainer/Body/Page_Home.visible = true


func _on_button_view_wizards_pressed():
	$MarginContainer/VBoxContainer/Body/Page_Home.visible = false
	$MarginContainer/VBoxContainer/Body/Page_SavedWizards.populate()
	$MarginContainer/VBoxContainer/Body/Page_SavedWizards.visible = true
	currentActivePage = pages.SAVED_WIZARDS



func _on_button_view_spell_list_pressed():
	$MarginContainer/VBoxContainer/Body/Page_SpellReference.visible = true
	# $MarginContainer/VBoxContainer/Body/Page_SpellReference.populate()
	$MarginContainer/VBoxContainer/Body/Page_Home.visible = false
	currentActivePage = pages.SPELL_REFERENCE



func _on_button_view_weapon_list_pressed():
	$MarginContainer/VBoxContainer/Body/Page_WeaponReference.visible = true
	$MarginContainer/VBoxContainer/Body/Page_Home.visible = false
	currentActivePage = pages.WEAPON_REFERENCE


func _on_button_spellMain_back_pressed():
	match currentActivePage:
		pages.HOME:
			# inform all children we about to quit
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit(0) # exit application
		pages.SPELL_MAIN:
			$MarginContainer/VBoxContainer/Body/Page_Home.visible = true
			$MarginContainer/VBoxContainer/Body/Page_SpellsMain.visible = false
			currentActivePage = pages.HOME
		pages.SPELL_ALIGNED:
			$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.visible = false
			$MarginContainer/VBoxContainer/Body/Page_SpellsMain.visible = true
			currentActivePage = pages.SPELL_MAIN
		pages.SPELL_NEUTRAL:
			$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.visible = false
			$MarginContainer/VBoxContainer/Body/Page_SpellsAligned.visible = true
			currentActivePage = pages.SPELL_ALIGNED
		pages.WARBAND:
			$MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.visible = false
			$MarginContainer/VBoxContainer/Body/Page_SpellsNeutral.visible = true
			currentActivePage = pages.SPELL_NEUTRAL
		pages.WIZARD_SUMMARY:
			$MarginContainer/VBoxContainer/Body/Page_Summary.visible = false
			$MarginContainer/VBoxContainer/Body/Page_WarbandBuilder.visible = true
			currentActivePage = pages.WARBAND
		pages.SAVED_WIZARDS:
			$MarginContainer/VBoxContainer/Body/Page_SavedWizards.visible = false
			# force reset here since we load when the button is pressed
			$MarginContainer/VBoxContainer/Body/Page_SavedWizards.reset() 
			$MarginContainer/VBoxContainer/Body/Page_Home.visible = true
			currentActivePage = pages.HOME
		pages.SPELL_REFERENCE:
			$MarginContainer/VBoxContainer/Body/Page_SpellReference.visible = false
			$MarginContainer/VBoxContainer/Body/Page_Home.visible = true
			currentActivePage = pages.HOME
		pages.WEAPON_REFERENCE:
			$MarginContainer/VBoxContainer/Body/Page_WeaponReference.visible = false
			$MarginContainer/VBoxContainer/Body/Page_Home.visible = true
			currentActivePage = pages.HOME






