extends Node

var nivel_actual := 1
var ultima_escena_jugada : String = "" # Aquí guardaremos el nivel
var proximo_nivel : String = ""
var siguiente_numero = nivel_actual + 1
signal game_paused(paused: bool)

func pause_game(paused: bool) -> void:
	if get_tree().paused == paused:
		return
	get_tree().paused = paused
	game_paused.emit(paused)
	
func preparar_siguiente_nivel():
	proximo_nivel = "res://escenas/niveles/Nivel" + str(siguiente_numero) + ".tscn"
	print("Siguiente nivel preparado: ", proximo_nivel)

func ir_a_selector() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://escenas/GUI/SelectorNivel.tscn")

func ir_a_victoria():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://escenas/GUI/victoria.tscn")

func cargar_siguiente_nivel():
	if proximo_nivel != "":
		get_tree().change_scene_to_file(proximo_nivel)
	else:
		# Por si acaso, si no hay nivel, vuelve al menú
		get_tree().change_scene_to_file("res://escenas/MenuPrincipal.tscn")

# Funcion para ir al selector nivel guardando el nivel actual
func ir_a_nivel(numero: int, path: String) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	nivel_actual = numero
	get_tree().change_scene_to_file(path)

# Función para ir al Game Over guardando el nivel actual
func ir_a_game_over():
	if get_tree().current_scene:
		ultima_escena_jugada = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://escenas/GUI/GameOver.tscn")

# Modificamos reintentar para que use la variable guardada
func reintentar():
	if ultima_escena_jugada != "":
		get_tree().paused = false
		get_tree().change_scene_to_file(ultima_escena_jugada)
	else:
		# Por si acaso, si no hay nada guardado, que no se rompa
		print("No hay escena previa guardada")
