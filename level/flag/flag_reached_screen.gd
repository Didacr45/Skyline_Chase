extends CanvasLayer

@onready var _animation_player: AnimationPlayer = %AnimationPlayer
var siguiente_escena_path: String
var nombre_actual = get_tree().current_scene.name
var numero_nivel = nombre_actual.to_int() 
var siguiente_numero = numero_nivel + 1

func _ready() -> void:
	Events.flag_reached.connect(func on_flag_reached() -> void:
		await get_tree().create_timer(1.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		ScenesManager.proximo_nivel = siguiente_escena_path
		ScenesManager.ir_a_victoria() 
		ScenesManager.preparar_siguiente_nivel()
		ScenesManager.ir_a_victoria()
	)
