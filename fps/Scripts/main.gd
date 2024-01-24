extends Node2D

const CHARACTER = preload("res://character.tscn")

func _ready() -> void:
	var index = 1
	for i in GlobalManager.players:
		var character = CHARACTER.instantiate()
		character.name = str(GlobalManager.players[i].id)
		add_child(character)
		for j in get_tree().get_nodes_in_group("spawn"):
			if(j.name == str(index)):
				character.global_position = j.global_position
		index+=1

func add_bullet(bullet : CharacterBody2D) -> void:
	$BulletGroup.add_child(bullet)

