extends CharacterBody2D

signal on_health_changed
signal on_hunger_changed

var speed := 3:
	set(value):
		speed = clamp(value,1,6)
	get:
		return speed

var health := 100:
	set(value):
		health = clamp(value,0,100)
		on_health_changed.emit()
	get:
		return health

var hunger_stats = {
		"MaxHunger": 100,
		"CurrentHunger": 0,
		"HungerIncreaseTime": 8.0,
		"HungerIncreaseAmount": 0.3
}

var destination: Vector2
var is_moving: bool = false

var _hunger_stats:
	get:
		return hunger_stats

func _ready():
	hungry()

func set_destination(pos: Vector2):
	destination = pos

func move_to_position(threshold: float = 10) -> bool:
	
	var dist = (destination - position).length()
	var direction = (destination - position).normalized()
		
	if dist > threshold: #keep moving until we have reached our goal
		is_moving = true
		position += direction * speed
		await get_tree().create_timer(get_process_delta_time()).timeout
		move_to_position()
	elif dist < threshold: #stop moving when we reached our goal
		is_moving = false
		return true
	
	return false

#Called when mouse is released
func _on_camera_2d_mouse_clicked():
	
	var mouse_pos = get_global_mouse_position()
	destination = mouse_pos #Set destination to mouse pos
	
	#set target destination
	set_destination(mouse_pos)
	
	#check if we are already moving if not then move
	if not is_moving:
		move_to_position()

func hungry():
	
	var _current_hunger = hunger_stats["CurrentHunger"]
	var _hunger_increase = hunger_stats["HungerIncreaseAmount"]
	var _increase_delay = hunger_stats["HungerIncreaseTime"]
	
	#check if hunger is less then max hunger
	if _current_hunger < hunger_stats["MaxHunger"]:
		_current_hunger += _hunger_increase #increase hunger
		hunger_stats["CurrentHunger"] = _current_hunger #update current hunger in dict
		on_hunger_changed.emit() #broadcast hunger change
		await get_tree().create_timer(_increase_delay).timeout #delay increasing hunger again
		hungry()
	else:
		hunger_stats["CurrentHunger"] = hunger_stats["MaxHunger"]
		on_hunger_changed.emit()
