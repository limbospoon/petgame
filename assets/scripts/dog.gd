extends CharacterBody2D

signal on_health_changed
signal on_hunger_changed
signal on_death

@onready var _animated_sprite = $AnimatedSprite2D #get the AnimateSprite2D on the dog

var speed := 3:
	set(value):
		speed = clamp(value,1,6)
	get:
		return speed

enum EDog_Hunger_State {
	NORMAl,
	STARVING
}
var dog_hunger_state: EDog_Hunger_State

enum EDog_State {
	ALIVE,
	DEAD
}
var dog_state: EDog_State = EDog_State.ALIVE

var dog_stats = {
	"health_stats": {
		"MaxHealth": 100,
		"CurrentHealth": 100
	},
	"hunger_stats": {
		"MaxHunger": 100,
		"CurrentHunger": 0,
		"HungerIncreaseTime": 0.8,
		"HungerIncreaseAmount": 20,
		"HealthDamage": 2
	},
}

var destination: Vector2
var is_moving: bool = false

func _ready():
	hungry()

func _process(delta):
	pass

func set_destination(pos: Vector2):
	destination = pos

func move_to_position(threshold: float = 10) -> bool:
	
	var dist = (destination - position).length()
	var direction = (destination - position).normalized()
	
	#check if target destination is to the left or right
	var dot = (direction.x * Vector2.RIGHT.x) + (direction.y * Vector2.RIGHT.y)
	
	if dot < 0:
		_animated_sprite.flip_h = false
	else:
		_animated_sprite.flip_h = true
		
	if dist > threshold: #keep moving until we have reached our goal
		_animated_sprite.play("walking")
		is_moving = true
		position += direction * speed
		
		if dog_state == EDog_State.DEAD:
			return false
		
		await get_tree().create_timer(get_process_delta_time()).timeout
		move_to_position()
	elif dist < threshold: #stop moving when we reached our goal
		is_moving = false
		_animated_sprite.play("idle-bark")
		return true
	
	return false

#Called when mouse is released
func _on_camera_2d_mouse_clicked():
	
	if dog_state == EDog_State.DEAD:
		is_moving = false
		return
	
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
	var _max_hunger = hunger_stats["MaxHunger"]
	var _hunger_increase = hunger_stats["HungerIncreaseAmount"]
	var _increase_delay = hunger_stats["HungerIncreaseTime"]
	
	#check if hunger is less then max hunger
	if _current_hunger < _max_hunger:
		_current_hunger += _hunger_increase #increase hunger
		dog_stats["hunger_stats"]["CurrentHunger"] = _current_hunger #update current hunger in dict
		on_hunger_changed.emit() #broadcast hunger change
		await get_tree().create_timer(_increase_delay).timeout #delay increasing hunger again
		hungry()
	elif _current_hunger >= _max_hunger:
		dog_stats["hunger_stats"]["CurrentHunger"] = _max_hunger #et CurrentHunger to MaxHunger
		on_hunger_changed.emit() #update ui
		dog_hunger_state = EDog_Hunger_State.STARVING #set state to starving TODO: make use of the state
		starving()

func starving():
	
	var health_damage = dog_stats["hunger_stats"]["HealthDamage"]
	var damage_delay = dog_stats["hunger_stats"]["HungerIncreaseTime"]
	var max_hunger = dog_stats["hunger_stats"]["MaxHunger"]
	
	#deal health damage as long as hunger is Max
	if get_current_hunger() >= max_hunger:
		dog_stats["health_stats"]["CurrentHealth"] -= health_damage #decrease health
		on_health_changed.emit()
		
		if dog_stats["health_stats"]["CurrentHealth"] <= 0:
			dog_state = EDog_State.DEAD
			on_death.emit()
			return
		
		await get_tree().create_timer(damage_delay).timeout #delay for next damage tick
		starving()
	else:
		dog_hunger_state = EDog_Hunger_State.NORMAl #Not starving so set state back
		hungry()
		
func get_current_hunger() -> float:
	return dog_stats["hunger_stats"]["CurrentHunger"]
	
func get_current_health() -> int:
	return dog_stats["health_stats"]["CurrentHealth"]

func restore_hunger(amount: int) -> void:
	dog_stats["hunger_stats"]["CurrentHunger"] -= amount
	on_hunger_changed.emit()
