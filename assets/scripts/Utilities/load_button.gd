extends Button

@onready var saver = %Saver

func _on_button_up():
	saver.load()
