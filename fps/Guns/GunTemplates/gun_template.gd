extends Resource
class_name GunTemplate

enum  type{PRIMARY,SECONDARY}

@export var gun_name : String = ""
@export var bullet_capacity : int = 0
@export var ACTUAL_BULLET : int = 0
@export var bullet_total : int = 0
@export var bullet_speed : int = 0
@export var bullet_cooldown : float = 0.0
@export var bullet_reload : float = 0.0
@export var gun_type : type
@export var gun_texture : AtlasTexture

func reloadable() -> bool:
	if(ACTUAL_BULLET == bullet_capacity or bullet_total == 0):
		return false
	else:
		return true

func reload() -> void:
	var bullet_needed : int = bullet_capacity - ACTUAL_BULLET
	if(bullet_total-bullet_needed < 0):
		ACTUAL_BULLET += bullet_total
		bullet_total = 0
	else:
		bullet_total -= bullet_needed
		ACTUAL_BULLET = bullet_capacity

func is_shootable() -> bool:
	if(ACTUAL_BULLET!=0):
		return true
	else:
		return false

func shoot() -> void:
	ACTUAL_BULLET-=1

func info() -> void:
	print(bullet_capacity)
	print(ACTUAL_BULLET)
	print(bullet_total)
