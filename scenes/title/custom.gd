extends Control


const OPTIONS := ["torsos", "tails", "legs", "arms", "heads", "eyes", "horns", "ears"]
const SPRITE_PATH := "res://scenes/player/sprites/"

var sprites := {}
var indexes := {}


func _ready() -> void:
	var dir := Directory.new()
	for option in OPTIONS:
		dir.open(SPRITE_PATH + option)
		dir.list_dir_begin(false, false)
		var images := []
		var file := dir.get_next()
		while file:
			if not dir.current_is_dir() and file.ends_with(".png.import"):
				images.append(load(SPRITE_PATH + option + "/" + file.replace(".import", "")))
			file = dir.get_next()
		dir.list_dir_end()
		var key: String = option.substr(0, len(option) - 1).capitalize()
		sprites[key] = images
		indexes[key] = 0
	for child in $VBox/MarginContainer/Sprites/Options.get_children():
		child.get_child(0).connect("pressed", self, "on_button_pressed", [child.name, child.get_child(0)])
		child.get_child(2).connect("pressed", self, "on_button_pressed", [child.name, child.get_child(2)])


func on_button_pressed(n: String, button: TextureButton) -> void:
	if button.name == "Left":
		indexes[n] -= 1
		button.disabled = indexes[n] == 0
		button.get_parent().get_child(2).disabled = indexes[n] == sprites[n].size() - 1
	else:
		indexes[n] += 1
		button.disabled = indexes[n] == sprites[n].size() - 1
		button.get_parent().get_child(0).disabled = indexes[n] == 0
	$VBox/MarginContainer/Sprites/Control.get_node(n).texture = sprites[n][indexes[n]]
