extends Node

@onready var hour_label = %Hour
@onready var minute_label = %Minutes
@onready var ampm_Label = %ampm

var current_hour: int = 0
var current_minute: int = 0
var clock_speed: float = 0.000000000003


enum EClock_Type {
	TWENTY_FOUR_HOUR,
	TWELVE_HOUR
}

var clock_type:EClock_Type = EClock_Type.TWELVE_HOUR
var is_morning: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if clock_type == EClock_Type.TWELVE_HOUR:
		ampm_Label.visible = true
		current_hour = 12
		tick_clock_12()
	elif clock_type == EClock_Type.TWENTY_FOUR_HOUR:
		tick_clock_24()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tick_clock_24():
	
	tick_minutes()
	
	if current_hour > 23:
		current_hour = 0
	
	update_labels()
	await get_tree().create_timer(clock_speed).timeout
	if current_hour < 100:
		tick_clock_24()

func tick_clock_12():
	
	tick_minutes()
	
	if current_hour > 11:
		is_morning = !is_morning
	
	if current_hour > 12:
		current_hour = 1
		
		
	if not is_morning:
		ampm_Label.text = "pm"
	else:
		ampm_Label.text = "am"
	
	update_labels()
	await get_tree().create_timer(clock_speed).timeout
	if current_hour < 100:
		tick_clock_12()
	
func update_labels():
	
	if current_hour < 10:
		hour_label.text = str("0", current_hour, ":")
	else:
		hour_label.text = str(current_hour, ":")
	
	if current_minute < 10:		
		minute_label.text = str("0", current_minute)
	else:
		minute_label.text = str(current_minute)
		
func tick_minutes():
	current_minute += 1
	
	if current_minute > 59:
		current_minute = 0
		current_hour += 1
	
