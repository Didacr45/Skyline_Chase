extends CharacterBody3D

@export var speed: float = 3.0
@export var gravity: float = 9.8
@export var attack_damage: int = 1
@export var attack_cooldown: float = 2.0
@export var attack_range: float = 1.0
@export var rotation_speed: float = 5.0

@export_group("Vida")
@export var max_health: int = 1

# Ruta específica del Mago
@onready var anim_player: AnimationPlayer = $Skeleton_Mage/AnimationPlayer
@onready var detection_area: Area3D = $DetectionArea

const ANIM_IDLE   = "Animation_Items/Idle_A"
const ANIM_WALK   = "AnimationMovement/Walking_B"
const ANIM_ATTACK = "Animation_Items/Throw"
const ANIM_DEATH  = "Animation_Items/Death_B"

enum State { PATROL, ATTACK, DEAD }
var current_state: State = State.PATROL
var move_direction: Vector3 = Vector3.ZERO
var player: Node = null
var can_attack: bool = true
var is_attacking: bool = false
var current_health: int = 0

func _ready() -> void:
	current_health = max_health
	add_to_group("enemigo") 
	
	if detection_area:
		detection_area.body_entered.connect(_on_player_entered)
		detection_area.body_exited.connect(_on_player_exited)
	
	if Events.has_signal("player_attack"):
		Events.player_attack.connect(_on_player_attack) 
	
	_play_anim(ANIM_IDLE)
	_start_random_movement()
	_update_health_bar()

func _physics_process(delta: float) -> void:
	# Si está muerto, ni gravedad ni movimiento
	if current_state == State.DEAD:
		return

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	match current_state:
		State.PATROL:
			_patrol(delta)
		State.ATTACK:
			_attack_behavior(delta)

	move_and_slide()

# ─────────────────────────────────────────
#  SISTEMA DE VIDA Y MUERTE (ARREGLADO)
# ─────────────────────────────────────────

func take_damage(amount: int) -> void:
	if current_state == State.DEAD:
		return

	current_health -= amount
	current_health = max(current_health, 0)
	_update_health_bar()
	
	print("Mago dañado, papito. Vida: ", current_health)

	if current_health <= 0:
		_die()

func _on_player_attack(damage: int) -> void:
	# ARREGLO: Eliminada la condición de 'player != null'
	# Ahora recibe daño siempre que llegue la señal y no esté muerto
	if current_state != State.DEAD:
		take_damage(damage)

func _update_health_bar() -> void:
	var bar = get_node_or_null("HealthBar3D/SubViewport/ProgressBar")
	if bar:
		bar.max_value = max_health
		bar.value = current_health

func _die() -> void:
	if current_state == State.DEAD: return
	current_state = State.DEAD
	
	# 1. CONGELAR AL MAGO
	set_physics_process(false)
	velocity = Vector3.ZERO
	collision_layer = 0
	collision_mask = 0
	
	# 2. LIMPIEZA DE UI Y DETECCIÓN
	var hb = get_node_or_null("HealthBar3D")
	if hb: hb.hide()
	if detection_area:
		detection_area.monitoring = false
		detection_area.monitorable = false
	
	# 3. ANIMACIÓN DE MUERTE
	if anim_player:
		anim_player.stop() 
		if anim_player.has_animation(ANIM_DEATH):
			anim_player.play(ANIM_DEATH)
			await anim_player.animation_finished
	
	# 4. BORRADO
	queue_free()

# ─────────────────────────────────────────
#  MOVIMIENTO Y LÓGICA
# ─────────────────────────────────────────

func _play_anim(anim_name: String) -> void:
	if anim_player and anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

func _patrol(delta: float) -> void:
	if is_on_wall():
		_pick_random_direction()

	velocity.x = speed * move_direction.x
	velocity.z = speed * move_direction.z

	if move_direction == Vector3.ZERO:
		_play_anim(ANIM_IDLE)
	else:
		_play_anim(ANIM_WALK)
		_look_at(global_position + move_direction, delta)

func _look_at(target: Vector3, delta: float) -> void:
	target.y = global_position.y
	var diff = target - global_position
	if diff.length() > 0.1:
		var target_basis = Basis.looking_at(-diff.normalized(), Vector3.UP)
		basis = basis.slerp(target_basis, rotation_speed * delta)

func _start_random_movement() -> void:
	while current_state != State.DEAD:
		if not is_inside_tree(): return
		
		if current_state == State.PATROL:
			_pick_random_direction()
			
		await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

func _pick_random_direction() -> void:
	var directions = [Vector3.RIGHT, Vector3.LEFT, Vector3.FORWARD, Vector3.BACK, Vector3.ZERO]
	move_direction = directions[randi() % directions.size()].normalized()

func _attack_behavior(delta: float) -> void:
	if player == null:
		current_state = State.PATROL
		return

	var dist = global_position.distance_to(player.global_position)
	_look_at(player.global_position, delta)

	if dist > attack_range:
		_play_anim(ANIM_WALK)
		var dir = (player.global_position - global_position).normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = 0; velocity.z = 0
		if can_attack: _do_attack()

func _do_attack() -> void:
	can_attack = false
	is_attacking = true
	_play_anim(ANIM_ATTACK)
	Events.player_damaged.emit(attack_damage)
	await get_tree().create_timer(attack_cooldown).timeout
	is_attacking = false
	can_attack = true

# ─────────────────────────────────────────
#  SEÑALES
# ─────────────────────────────────────────

func _on_player_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body
		if current_state != State.DEAD:
			current_state = State.ATTACK

func _on_player_exited(body: Node) -> void:
	if body == player:
		player = null
		if current_state != State.DEAD:
			current_state = State.PATROL
