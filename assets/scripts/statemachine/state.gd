class_name State 
extends Node

#signal for moving to next state
signal onfinished(next_state: String, data: Dictionary)

#Called when receiving unhandle inputs
func _handle_input(_event: InputEvent) -> void:
	pass
	
#called on main engine loop
func _update(_delta: float) -> void:
	pass

#called on engine physics update
func _physics_update(_delta: float) -> void:
	pass
	
#called when entering state
func _enter(previous_state: String, data:= {}) -> void:
	pass
	
#called when leaving state
func _exit() -> void:
	pass
