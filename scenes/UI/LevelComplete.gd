extends CanvasLayer


func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Button.connect("pressed", self, "on_next_button_pressed" )


func on_next_button_pressed():
	LevelManager.increment_level()
 
