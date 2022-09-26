extends Control



func _on_Credits_pressed() -> void:
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("to_credits")


func _on_Back_pressed() -> void:
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("to_title")
