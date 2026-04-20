extends Node

var ultima_escena_jugada : String = "" # Aquí guardaremos el nivel
signal game_paused(paused: bool)

func pause_game(paused: bool) -> void:
	if get_tree().paused == paused:
		return
	get_tree().paused = paused
	game_paused.emit(paused)

# Función NUEVA para ir al Game Over guardando el nivel actual
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
