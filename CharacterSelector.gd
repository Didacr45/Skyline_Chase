extends Node3D

@export var characters: Array[CharacterData] = []
var current_index: int = 0
var current_model: Node = null

@onready var spawn_point = $CharacterSpawn

func _ready():
	if characters.size() > 0:
		update_character()

func update_character():
	if current_model:
		current_model.queue_free()
	
	var data = characters[current_index]
	if data and data.model_scene:
		current_model = data.model_scene.instantiate()
		spawn_point.add_child(current_model)
		
		# --- ESTA ES LA MEJORA ---
		# Buscamos si el caballero tiene la variable 'esta_activo' y la apagamos
		if "esta_activo" in current_model:
			current_model.esta_activo = false
		# -------------------------

func _on_next_pressed():
	current_index = (current_index + 1) % characters.size()
	update_character()

func _on_previous_pressed():
	current_index = (current_index - 1 + characters.size()) % characters.size()
	update_character()

func _on_play_button_pressed():
	if characters.size() > 0:
		ScenesManager.selected_character = characters[current_index]
		get_tree().change_scene_to_file("res://level/level1.tscn")
