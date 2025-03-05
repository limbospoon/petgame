class_name StateMachine
extends Node

@export var initial_state: State = null
@onready var state: State = (func get_initial_state() -> State: 
	return initial_state if initial_state != null else get_child(0)).call()
	
func _ready() -> void:
	#give every state a reference to the state machine
	for state_node: State in find_children("*", "State"):
		state_node.onfinished.connect(_transition_to_next_state)
		
	await owner.ready
	print(owner.name)
	state._enter("")
	
func _transition_to_next_state(next_state: String, data: Dictionary) -> void:
	#check if next state is valid
	if not has_node(next_state):
		printerr(owner.name + ": Trying to transition to state " + 
			next_state + " but it does not exist")
		return
		
	var previous_state := state.name
	state._exit()
	state = get_node(next_state)
	state._enter(previous_state, data)
	
func _unhandled_input(event: InputEvent) -> void:
	state._handle_input(event)

func _process(delta: float) -> void:
	state._update(delta)

func _physics_process(delta: float) -> void:
	state._physics_update(delta)
	
