extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_on_game_state_changed():
	var main_ref = $"../.."
	var current_state = main_ref.get_game_state()
	#check if game is over
	if current_state == main_ref.EGame_State.GAMEOVER:
		visible = true
