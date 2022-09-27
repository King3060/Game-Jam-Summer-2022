extends Control


signal change_scene(to)

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
	for i in 8:
		var child := $VBox/Marg/Sprites/Options.get_child(i)
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
	$VBox/Marg/Sprites/Control.get_node(n).texture = sprites[n][indexes[n]]


func on_color_changed(color: Color, i: int) -> void:
	if i == 0:
		$VBox/Marg/Sprites/Control/Torso.material["shader_param/main_replace"] = color
	else:
		$VBox/Marg/Sprites/Control/Torso.material["shader_param/secondary_replace"] = color


func _on_Random_pressed() -> void:
	var main_color := Color(randf(), randf(), randf(), 1.0)
	$VBox/Marg/Sprites/Options/Colors/Main/ColorPickerButton.color = main_color
	on_color_changed(main_color, 0)
	var secondary_color := Color(randf(), randf(), randf(), 1.0)
	$VBox/Marg/Sprites/Options/Colors/Secondary/ColorPickerButton.color = secondary_color
	on_color_changed(secondary_color, 1)
	for option in OPTIONS:
		var key: String = option.substr(0, len(option) - 1).capitalize()
		var rand: int = randi() % sprites[key].size()
		indexes[key] = rand
		$VBox/Marg/Sprites/Control.get_node(key).texture = sprites[key][rand]
		var hbox := $VBox/Marg/Sprites/Options.get_node(key)
		hbox.get_child(0).disabled = rand == 0
		hbox.get_child(2).disabled = rand == sprites[key].size() - 1


func _on_Continue_pressed() -> void:
	if get_tree().current_scene == self:
		return
	for option in OPTIONS:
		var key: String = option.substr(0, len(option) - 1).capitalize()
		get_tree().current_scene.player_sprites[key] = $VBox/Marg/Sprites/Control.get_node(key).texture
	emit_signal("change_scene", "res://scenes/test/test.tscn")
