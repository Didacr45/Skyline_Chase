extends Control
class_name Level_Selector

# Nodos de cada nivel
@onready var lvl1 = $Lvl1
@onready var lvl2 = $Lvl2
@onready var lvl3 = $Lvl3
@onready var lvl4 = $Lvl4
@onready var lvl5 = $Lvl5

func _ready() -> void:
	get_tree().paused = false
	pintar_todas_estrellas()

func pintar_todas_estrellas():
	var todas = DatabaseManager.cargar_todas_estrellas()
	pintar_estrellas(lvl1, todas.get(1, 0), "estrella1", "estrella2", "estrella3")
	pintar_estrellas(lvl2, todas.get(2, 0), "estrella4", "estrella5", "estrella6")
	pintar_estrellas(lvl3, todas.get(3, 0), "estrella7", "estrella8", "estrella9")
	pintar_estrellas(lvl4, todas.get(4, 0), "estrella10", "estrella11", "estrella12")
	pintar_estrellas(lvl5, todas.get(5, 0), "estrella13", "estrella14", "estrella15")

func pintar_estrellas(lvl_node: Node, cantidad: int, n1: String, n2: String, n3: String):
	var nombres = [n1, n2, n3]
	for i in range(3):
		var estrella = lvl_node.get_node(nombres[i])
		if i < cantidad:
			estrella.modulate = Color(1, 0.85, 0)    # dorada
		else:
			estrella.modulate = Color(0.25, 0.25, 0.25)  # gris

func _on_lvl_1_pressed() -> void:
	ScenesManager.ir_a_nivel(1, "res://escenas/LVLS/gamelv1.tscn")
func _on_lvl_2_pressed() -> void:
	ScenesManager.ir_a_nivel(2, "res://escenas/LVLS/gamelv2.tscn")
func _on_lvl_3_pressed() -> void:
	ScenesManager.ir_a_nivel(3, "res://escenas/LVLS/gamelv3.tscn")
func _on_lvl_4_pressed() -> void:
	ScenesManager.ir_a_nivel(4, "res://escenas/LVLS/gamelv4.tscn")
func _on_lvl_5_pressed() -> void:
	ScenesManager.ir_a_nivel(5, "res://escenas/LVLS/gamelv5.tscn")
