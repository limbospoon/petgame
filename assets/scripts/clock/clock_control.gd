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

enum EDay_State{
	AM,
	PM
}
var day_state:EDay_State = EDay_State.AM
var day_state_changed: bool = false

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
	
	if current_hour > 11 and not day_state_changed:
		change_day_state()
	
	if current_hour > 12:
		current_hour = 1
		day_state_changed = false
	
	update_labels()
	await get_tree().create_timer(clock_speed).timeout
	if current_hour < 100:
		tick_clock_12()
	
	
func change_day_state():
	var current_day_state = day_state
	
	if current_day_state == EDay_State.AM:
		day_state = EDay_State.PM

	elif current_day_state == EDay_State.PM:
		day_state = EDay_State.AM
	
	#convert current day state to string
	ampm_Label.text = str(EDay_State.keys()[day_state]).to_lower()
	day_state_changed = true
	
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
	
