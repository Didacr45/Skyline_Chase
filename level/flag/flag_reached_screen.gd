extends CanvasLayer

@onready var _animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	Events.flag_reached.connect(func on_flag_reached() -> void:
		# Guardamos la escena actual antes de irnos a victoria
		# Así, si el jugador pulsa "Reintentar", volverá aquí
		ScenesManager.ultima_escena_jugada = get_tree().current_scene.scene_file_path
		
		# ... (el resto de tu código para calcular el siguiente nivel) ...
		var nombre_escena = get_tree().current_scene.name
		var nivel_donde_estoy = nombre_escena.to_int()
		ScenesManager.nivel_actual = nivel_donde_estoy
		ScenesManager.proximo_nivel = "res://escenas/LVLS/gamelv" + str(nivel_donde_estoy + 1) + ".tscn"
		
		# Animación y cambio de escena
		await get_tree().create_timer(1.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		ScenesManager.ir_a_victoria()
	)
