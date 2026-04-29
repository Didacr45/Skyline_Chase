extends Node
var db : SQLite
const DB_PATH := "user://game_data.db"

func  _ready():
	db = SQLite.new()
	db.path = DB_PATH
	db.open_db()
	crear_tablas()

func crear_tablas():
	var progreso := """
    CREATE TABLE IF NOT EXISTS progreso (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nivel INTEGER,
        vidas INTEGER
    );
	"""
	db.query(progreso)

	# Añade esto aquí
	var estrellas := """
    CREATE TABLE IF NOT EXISTS estrellas (
        nivel INTEGER PRIMARY KEY,
        cantidad INTEGER DEFAULT 0
    );
	"""
	db.query(estrellas)

func guardar_estrellas(nivel: int, cantidad: int):
	db.query_with_bindings(
		"INSERT OR REPLACE INTO estrellas (nivel, cantidad) VALUES (?, ?);",
		[nivel, cantidad]
	)
	
func guardar_progreso(nivel:int, vidas:int):
	db.query("DELETE FROM progreso;")
	db.query_with_bindings(
		"INSERT INTO progreso (nivel, vidas) VALUES (?, ?);",
		[nivel, vidas]
	)
func cargar_estrellas(nivel: int) -> int:
	db.query_with_bindings(
		"SELECT cantidad FROM estrellas WHERE nivel = ?;",
		[nivel]
	)
	if db.query_result.is_empty():
		return 0
	return db.query_result[0]["cantidad"]

func cargar_todas_estrellas() -> Dictionary:
	db.query("SELECT nivel, cantidad FROM estrellas;")
	var resultado := {}
	for fila in db.query_result:
		resultado[fila["nivel"]] = fila["cantidad"]
	return resultado
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		borrar_estrellas()

func borrar_estrellas() -> void:
	db.query("DELETE FROM estrellas;")
