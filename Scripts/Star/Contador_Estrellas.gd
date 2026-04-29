extends CanvasLayer

var label_numero : Label
var estrellas: int = 0
var escala_original: Vector2

func _ready() -> void:
	label_numero = $ContadorEstrellas
	label_numero.text = str(estrellas)
	escala_original = label_numero.scale
	Events.flag_reached.connect(_on_flag_reached)
	Events.estrella_recogida_global.connect(_on_estrella_recogida)

func _on_flag_reached() -> void:
	var nivel = ScenesManager.nivel_actual
	var previas = DatabaseManager.cargar_estrellas(nivel)
	if estrellas > previas:
		DatabaseManager.guardar_estrellas(nivel, estrellas)

func _on_estrella_recogida():
	estrellas += 1
	label_numero.text = str(estrellas)
	animar_contador()

func animar_contador():
	var tween = create_tween()
	tween.tween_property(label_numero, "scale", escala_original * 1.4, 0.1)
	tween.tween_property(label_numero, "scale", escala_original, 0.15)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
