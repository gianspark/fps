extends CharacterBody2D

var SPEED : int = 10000

@export var INITIAL_GUN : Node2D
var ACTUAL_GUN_SELECTED : Node2D

@onready var camera_2d : Camera2D = $Camera2D
@onready var ak_47 : Node2D = $GunSlots/Slot1/Ak47
@onready var revolver : Node2D = $GunSlots/Slot2/Revolver

func _ready() -> void:
	ACTUAL_GUN_SELECTED = INITIAL_GUN
	ACTUAL_GUN_SELECTED.show()
	$MultiplayerSynchronizer.set_multiplayer_authority(name.to_int())
	if(name.to_int() == multiplayer.get_unique_id()):
		camera_2d.make_current()
	

func _input(event : InputEvent) -> void:
	if($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()):
		if(event.is_action_pressed("recargar")):
			ACTUAL_GUN_SELECTED.input_event("recargar")
		if(event.is_action_pressed("info")):
			ACTUAL_GUN_SELECTED.input_event("info")
		
		if(event.is_action_pressed("slot1")):
			select_gun($GunSlots/Slot1.get_children())
		if(event.is_action_pressed("slot2")):
			select_gun($GunSlots/Slot2.get_children())
		if(event.is_action_pressed("slot3")):
			pass

func select_gun(gun : Array[Node]) -> void:
	if(gun.is_empty()):
		return
	if(gun[0] == ACTUAL_GUN_SELECTED):
		return
	ACTUAL_GUN_SELECTED.hide()
	ACTUAL_GUN_SELECTED = gun[0]
	ACTUAL_GUN_SELECTED.show()

func _process(delta) -> void:
	if($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()):
		if(Input.is_action_pressed("disparar")):
			ACTUAL_GUN_SELECTED.input_event("disparar")
		movement(delta)

func movement(delta) -> void:
	var direction : Vector2 = Vector2.ZERO
	
	if(Input.is_action_pressed("abajo")):
		direction += Vector2(0,1)
	if(Input.is_action_pressed("arriba")):
		direction += Vector2(0,-1)
	if(Input.is_action_pressed("izquierda")):
		direction += Vector2(-1,0)
	if(Input.is_action_pressed("derecha")):
		direction += Vector2(1,0)
	
	direction = direction.normalized()
	
	velocity = SPEED * direction * delta
	
	move_and_slide()
