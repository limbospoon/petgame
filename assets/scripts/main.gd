extends Node2D

signal on_game_state_changed

enum EGame_State {
	NORMAL,
	GAMEOVER
}
var game_state: EGame_State = EGame_State.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dog_on_death():
	game_state = EGame_State.GAMEOVER
	on_game_state_changed.emit()
	print("GameOver") # Replace with function body.
