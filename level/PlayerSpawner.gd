extends Marker3D

@export var personaje_por_defecto: CharacterData 

func _ready():
	# Esperamos un microsegundo para que todo el sistema cargue bien
	await get_tree().process_frame
	
	var datos_a_cargar: CharacterData = null

	# 1. ¿Viene del menú?
	if ScenesManager.selected_character != null:
		print("DEBUG: Detectado personaje del menú")
		datos_a_cargar = ScenesManager.selected_character
	
	# 2. Si no, ¿hay uno por defecto?
	elif personaje_por_defecto != null:
		print("DEBUG: Usando personaje por defecto del Inspector")
		datos_a_cargar = personaje_por_defecto
		
	# 3. ¡ACCION!
	if datos_a_cargar != null:
		if datos_a_cargar.model_scene == null:
			print("ERROR: El Resource tiene nombre, pero el hueco 'Model Scene' está vacío")
			return
			
		var jugador = datos_a_cargar.model_scene.instantiate()
		# Lo añadimos a la raíz del nivel para que no herede transformaciones raras
		get_tree().current_scene.add_child(jugador)
		jugador.global_position = self.global_position
		
		# Forzamos que se pueda mover
		if "esta_activo" in jugador:
			jugador.esta_activo = true
		if "puede_moverse" in jugador:
			jugador.puede_moverse = true
			
		print("PERSONAJE INSTANCIADO CON ÉXITO")
	else:
		print("ERROR CRÍTICO: No hay nada en ScenesManager ni en el Inspector")
