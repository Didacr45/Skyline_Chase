extends CanvasLayer
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	Events.flag_reached.connect(func on_flag_reached() -> void:
		await get_tree().create_timer(1.0).timeout
		_animation_player.play("fade_in")
		await _animation_player.animation_finished
		ScenesManager.ir_a_selector()
	)
