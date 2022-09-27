extends CanvasLayer


var lines := []
var current := -1

onready var speech := $Control/Speech


func _ready() -> void:
	speech.hide()
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if $Timer.is_stopped():
			advance()
		else:
			$Timer.stop()
			speech.percent_visible = 1.0


func show_dialogue(l: Array) -> void:
	lines = l
	current = -1
	speech.show()
	set_process_input(true)
	advance()


func advance() -> void:
	current += 1
	if current >= lines.size():
		speech.hide()
		set_process_input(false)
		return
	speech.bbcode_text = "[center]%s[/center]" % lines[current]
	speech.percent_visible = 0
	$Timer.start()


func _on_Timer_timeout() -> void:
	if not speech.percent_visible == 1.0:
		speech.visible_characters += 1
		$Timer.start()
