extends Node2D

@onready var weapon_skin : Sprite2D = $WeaponSkin
@onready var reload_cooldown : Timer = $ReloadCooldown
@onready var marker_2d : Marker2D = $Marker2D
@onready var gun_cooldown : Timer = $GunCooldown

const BULLET : PackedScene = preload("res://bullet.tscn")


@export var gun_data : GunTemplate
var shoot_cooldown : bool = true
var reload_cooldown_bool : bool = true
var id : int

func _ready() -> void:
	weapon_skin.texture = gun_data.gun_texture
	gun_cooldown.wait_time = gun_data.bullet_cooldown
	reload_cooldown.wait_time = gun_data.bullet_reload
	for i in GlobalManager.players:
		if(i == get_parent().get_parent().get_parent().name.to_int()):
			$MultiplayerSynchronizer.set_multiplayer_authority(i)

func _process(_delta) -> void:
	if($MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()):
		gun_view()
	
func gun_view() -> void:
	look_at(get_global_mouse_position())
	
	if(get_global_mouse_position().x>global_position.x):
		weapon_skin.flip_v = false
	else:
		weapon_skin.flip_v = true

func input_event(event : String) -> void:
	match event:
		"disparar":
			if(shoot_cooldown):
				click_event()
		"recargar":
			if(reload_cooldown):
				reload()
		"info":
			info()

func click_event() -> void:
	if(gun_data.is_shootable()):
		gun_data.shoot()
		shoot.rpc(get_global_mouse_position())
	else:
		reload()

@rpc("any_peer","call_local")
func shoot(mouse_pos) -> void:
	var bullet = BULLET.instantiate()
	bullet.send_data(gun_data.bullet_speed,rotation_degrees,marker_2d.global_position,mouse_pos)
	gun_cooldown.start()
	shoot_cooldown = false
	get_tree().call_group("MAIN","add_bullet",bullet)

func reload() -> void:
	if(gun_data.reloadable() and reload_cooldown_bool):
		reloading()
	else:
		return

func reloading() -> void:
	reload_cooldown_bool = false
	reload_cooldown.start()
	print("RELOADING...")

func _on_reload_cooldown_timeout() -> void:
	reload_cooldown_bool = true
	gun_data.reload()
	print("DONE")

func info() -> void:
	gun_data.info()

func _on_gun_cooldown_timeout() -> void:
	shoot_cooldown = true
