extends CanvasLayer

@export var max_vidas := 3
var vidas_actuales := 3

@onready var vidas := get_children()

func _ready() -> void:
	print("Número de corazones: ", vidas.size())
	print("Vidas actuales: ", vidas_actuales)
	actualizar_vidas()
	Events.kill_plane_touched.connect(caer_del_mapa)
	Events.player_damaged.connect(recibir_daño)
	Events.player_healed.connect(recuperar_toda_la_vida)
	for corazon in vidas:
		animar_latido(corazon)
		# Si no quedan vidas game over
	if vidas_actuales <= 0:
		game_over()

func recibir_daño(cantidad: int) -> void:

	# Comprobamos que el índice es válido antes de animar
	if vidas_actuales > 0 and vidas_actuales <= vidas.size():
		var corazon_perdido := vidas[vidas_actuales - 1]
		animar_corazon_perdido(corazon_perdido)

	vidas_actuales -= cantidad
	vidas_actuales = clamp(vidas_actuales, 0, max_vidas)

	await get_tree().create_timer(0.3).timeout
	actualizar_vidas()

	if vidas_actuales <= 0:
		game_over()

func caer_del_mapa() -> void:
	# Comprobamos que el índice es válido antes de animar
	if vidas_actuales > 0 and vidas_actuales <= vidas.size():
		var corazon_perdido := vidas[vidas_actuales - 1]
		animar_corazon_perdido(corazon_perdido)

	vidas_actuales -= 1
	vidas_actuales = clamp(vidas_actuales, 0, max_vidas)

	await get_tree().create_timer(0.3).timeout
	actualizar_vidas()

	if vidas_actuales == 0:
		game_over()

func actualizar_vidas() -> void:
	for i in range(vidas.size()):
		vidas[i].visible = i < vidas_actuales

	if vidas_actuales == 1:
		animar_latido(vidas[0], 0.25)
	elif vidas_actuales > 1:
		for i in range(vidas_actuales):
			animar_latido(vidas[i], 0.5)

func game_over() -> void:
	ScenesManager.ir_a_game_over()

func animar_latido(corazon: TextureRect, duracion: float = 0.5) -> void:
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(corazon, "scale", Vector2(1.05, 1.05), duracion)
	tween.tween_property(corazon, "scale", Vector2(1.0, 1.0), duracion)

func animar_corazon_perdido(corazon: TextureRect) -> void:
	var tween := create_tween()
	tween.tween_property(corazon, "scale", Vector2(1.4, 1.4), 0.15)
	tween.tween_property(corazon, "modulate:a", 0.0, 0.2)

func recuperar_toda_la_vida() -> void:
	# 1. ACTUALIZAR LA VARIABLE PRIMERO
	# Si no hacemos esto primero, el resto del código no sabe cuánta vida hay
	var vidas_previas = vidas_actuales
	vidas_actuales = max_vidas 
	
	print("Curando... De ", vidas_previas, " a ", vidas_actuales)

	# 2. EL FLASH (Efecto visual inmediato)
	for corazon in vidas:
		var flash = create_tween()
		corazon.modulate = Color(2, 2, 2) # Brillo HDR
		flash.tween_property(corazon, "modulate", Color.WHITE, 0.3)

	# 3. ANIMACIÓN DE APARICIÓN (Cascada)
	for i in range(vidas.size()):
		var corazon = vidas[i]
		
		# Solo animamos los corazones que estaban "muertos"
		if i >= vidas_previas:
			corazon.visible = true
			corazon.modulate.a = 0.0
			corazon.scale = Vector2(0.5, 0.5)
			
			var tw := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tw.parallel().tween_property(corazon, "modulate:a", 1.0, 0.4)
			tw.parallel().tween_property(corazon, "scale", Vector2(1.0, 1.0), 0.4)
			
			# Importante: Esperar un poquito para el siguiente
			await get_tree().create_timer(0.1).timeout

	# 4. REFRESCAR TODO AL FINAL
	actualizar_vidas()

func animar_recuperacion_corazon(corazon: TextureRect) -> void:
	corazon.visible = true
	corazon.modulate.a = 0.0 
	corazon.scale = Vector2(0.5, 0.5)
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.parallel().tween_property(corazon, "modulate:a", 1.0, 0.4)
	tween.parallel().tween_property(corazon, "scale", Vector2(1.0, 1.0), 0.4)
	
	tween.tween_callback(func(): animar_latido(corazon))
	actualizar_vidas()
