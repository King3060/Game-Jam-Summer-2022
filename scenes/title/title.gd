extends Control


signal change_scene(to)


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


func _on_Start_pressed() -> void:
	if $AnimationPlayer.is_playing():
		return
	emit_signal("change_scene", "res://scenes/title/custom.tscn")
