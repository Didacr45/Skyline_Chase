extends Control


func _on_salir_pressed() -> void:
	ScenesManager.ir_a_selector()

func _on_siguiente_pressed() -> void:
	ScenesManager.cargar_siguiente_nivel()
