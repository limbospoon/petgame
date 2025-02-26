extends Control

signal on_retry

@onready var scene_manager = %SceneManager
var level_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_game_state_changed():
	var current_state = level_manager.get_game_state()
	#check if game is over
	if current_state == level_manager.EGame_State.GAMEOVER:
		visible = true


func _on_try_again_button_button_up():
	on_retry.emit()
	visible = false


func _on_scene_manager__on_scene_loaded():
	if level_manager == null:
		level_manager = scene_manager.get_current_scene().get_node("%LevelManager")
	
	if level_manager != null:
		level_manager.on_game_state_changed.connect(_on_game_state_changed)		
