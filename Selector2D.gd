extends Control

# Aquí arrastraremos las fotos de los personajes
@export var fotos_personajes: Array[Texture2D] = []
# Aquí arrastraremos los Recursos (.tres) que ya creamos antes
@export var datos_personajes: Array[CharacterData] = []

var indice: int = 0

@onready var visualizador = $TextureRect # El nodo que muestra la foto
@onready var nombre_label = $Label       # Un texto para el nombre

func _ready():
	actualizar_interfaz()

func actualizar_interfaz():
	if fotos_personajes.size() > 0:
		visualizador.texture = fotos_personajes[indice]
		nombre_label.text = datos_personajes[indice].name

func _on_button_3_pressed() -> void:
	# Guardamos el personaje elegido en el Autoload (ScenesManager)
	ScenesManager.selected_character = datos_personajes[indice]
	# Saltamos al nivel 3D
	get_tree().change_scene_to_file("res://level/leve1.tscn")


func _on_button_2_pressed() -> void:
	indice = (indice + 1) % fotos_personajes.size()
	actualizar_interfaz()



func _on_button_pressed() -> void:
	indice = (indice - 1 + fotos_personajes.size()) % fotos_personajes.size()
	actualizar_interfaz()
