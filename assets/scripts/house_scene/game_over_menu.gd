extends Control

signal on_retry

@onready var level_manager = get_node("%LevelManager")
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_manager_on_game_state_changed():
	var game_manager_ref = level_manager
	var current_state = game_manager_ref.get_game_state()
	#check if game is over
	if current_state == game_manager_ref.EGame_State.GAMEOVER:
		visible = true


func _on_try_again_button_button_up():
	on_retry.emit()
