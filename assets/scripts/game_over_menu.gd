extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_try_again_button_button_up():
	get_tree().reload_current_scene()


func _on_house_scene_on_game_state_changed():
	var game_manager_ref = $"../.."
	var current_state = game_manager_ref.get_game_state()
	#check if game is over
	if current_state == game_manager_ref.EGame_State.GAMEOVER:
		visible = true
