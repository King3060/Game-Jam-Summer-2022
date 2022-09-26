extends Node


var change_scene_to: String
var change_scene_transition: bool

onready var cur_scene := $Splash

func _ready() -> void:
	change_scene("res://scenes/title/title.tscn")


func change_scene(to: String, transition := true) -> void:
	change_scene_to = to
	change_scene_transition = transition
	if transition:
		$AnimationPlayer.play("to_black")
	else:
		call_deferred("change_scene_deferred")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "to_black":
		change_scene_deferred()


func change_scene_deferred() -> void:
	if cur_scene:
		cur_scene.free()
	cur_scene = load(change_scene_to).instance()
	add_child(cur_scene)
	move_child(cur_scene, 0)
	if cur_scene.has_signal("change_scene"):
		cur_scene.connect("change_scene", self, "change_scene")
	if change_scene_transition:
		$AnimationPlayer.play("from_black")
