extends CanvasLayer


const SAVE_DIR := "user://saves/"
const SAVE_ENDING := ".ini"
const DATE_FORMAT := "%04d/%02d/%02d %02d:%02d:%02d"

const SaveButton := preload("res://scenes/autoloads/save_button.tscn")

var last_file_name := 0
var saves := []


func _ready() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir(SAVE_DIR)
		return
	if not dir.open(SAVE_DIR) == OK:
		return
	dir.list_dir_begin(true, true)
	var file_name := dir.get_next()
	while file_name:
		if not dir.current_is_dir() and file_name.ends_with(SAVE_ENDING) and file_name.get_basename().is_valid_integer():
			var config := ConfigFile.new()
			if not config.load(SAVE_DIR + file_name) == OK:
				continue
			var datetime = config.get_value("metadata", "time", {})
			if not datetime is Dictionary or datetime.empty() or not datetime.has_all(["year", "month", "day", "weekday", "dst", "hour", "minute", "second"]):
				continue
			add_save_button(datetime)
			saves.append(file_name)
			last_file_name = int(file_name) + 1
		file_name = dir.get_next()
	dir.list_dir_end()


func add_save_button(datetime: Dictionary, position := -1) -> void:
	var b: MenuButton = SaveButton.instance()
	b.text = DATE_FORMAT % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]
	$PopupPanel/VBoxContainer/ScrollContainer/VBoxContainer/Slots.add_child(b)
	if not position == -1:
		$PopupPanel/VBoxContainer/ScrollContainer/VBoxContainer/Slots.move_child(b, position)
	b.connect("load_requested", self, "on_load_requested", [b])
	b.connect("overwrite_requested", self, "on_overwrite_requested", [b])
	b.connect("delete_requested", self, "on_delete_requested", [b])


func on_load_requested(_b: MenuButton) -> void:
	$PopupPanel.hide()
	

func on_overwrite_requested(b: MenuButton) -> void:
	var datetime := OS.get_datetime()
	save(datetime, saves[b.get_index()], false)
	b.text = DATE_FORMAT % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second]


func on_delete_requested(b: MenuButton) -> void:
	var dir := Directory.new()
	dir.remove(SAVE_DIR + saves[b.get_index()])
	saves.remove(b.get_index())
	b.queue_free()


func save(datetime: Dictionary, file_name: String, make_new_button := true) -> void:
	var config := ConfigFile.new()
	config.set_value("metadata", "time", datetime)
	config.save(SAVE_DIR + file_name)
	if make_new_button:
		add_save_button(datetime, 0)
	

func show_save_load(can_save := true) -> void:
	get_tree().paused = true
	$PopupPanel.popup_centered()
	$PopupPanel/VBoxContainer/New.disabled = not can_save
	for button in $PopupPanel/VBoxContainer/ScrollContainer/VBoxContainer/Slots.get_children():
		button.get_popup().set_item_disabled(1, not can_save)


func _on_PopupPanel_popup_hide() -> void:
	get_tree().paused = false


func _on_New_pressed() -> void:
	var file_name := str(last_file_name) + SAVE_ENDING
	save(OS.get_datetime(), file_name)
	saves.append(file_name)
	last_file_name += 1


func _on_Clear_pressed() -> void:
	var dir := Directory.new()
	for save in saves:
		dir.remove(SAVE_DIR + save)
	saves = []
	for button in $PopupPanel/VBoxContainer/ScrollContainer/VBoxContainer/Slots.get_children():
		button.queue_free()
	last_file_name = 0
