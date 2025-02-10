extends CharacterBody2D

signal on_health_changed
signal on_hunger_changed

var speed := 3:
	set(value):
		speed = clamp(value,1,6)
	get:
		return speed

var dog_stats = {
	"health_stats": {
		"MaxHealth": 100,
		"CurrentHealth": 100
	},
	"hunger_stats": {
		"MaxHunger": 100,
		"CurrentHunger": 0,
		"HungerIncreaseTime": 0.8,
		"HungerIncreaseAmount": 20
	},
}

var destination: Vector2
var is_moving: bool = false


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
	
	var hunger_stats = dog_stats["hunger_stats"]
	var _current_hunger = hunger_stats["CurrentHunger"]
	var _hunger_increase = hunger_stats["HungerIncreaseAmount"]
	var _increase_delay = hunger_stats["HungerIncreaseTime"]
	
	#check if hunger is less then max hunger
	if _current_hunger < hunger_stats["MaxHunger"]:
		_current_hunger += _hunger_increase #increase hunger
		dog_stats["hunger_stats"]["CurrentHunger"] = _current_hunger #update current hunger in dict
		on_hunger_changed.emit() #broadcast hunger change
		await get_tree().create_timer(_increase_delay).timeout #delay increasing hunger again
		hungry()
	else:
		dog_stats["hunger_stats"]["CurrentHunger"] = hunger_stats["MaxHunger"]
		on_hunger_changed.emit()

func straving():
	pass
	
func get_current_hunger() -> float:
	return dog_stats["hunger_stats"]["CurrentHunger"]
	
func get_current_health() -> int:
	return dog_stats["health_stats"]["CurrentHealth"]
