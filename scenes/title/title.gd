extends Control



func _on_Credits_pressed() -> void:
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("to_credits")


func _on_Back_pressed() -> void:
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("to_title")


func _on_RichTextLabel_meta_clicked(meta) -> void:
	OS.shell_open(meta)
