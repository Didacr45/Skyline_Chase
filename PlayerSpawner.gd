extends Marker3D

func _ready():
	# Si venimos del selector, ScenesManager tendrá al personaje guardado
	if ScenesManager.selected_character:
		var data = ScenesManager.selected_character
		var player = data.model_scene.instantiate()
		
		# Lo metemos en el nivel
		get_parent().add_child.call_deferred(player)
		
		# Lo movemos a la posición de este marcador
		player.global_position = global_position
