extends Node2D


onready var bg_music = $mainmenu


# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	bg_music.stop()


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Credits_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
