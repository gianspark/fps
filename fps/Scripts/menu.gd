extends Control

@export var address : String = "127.0.0.1"
var port : int = 8910
var peer

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func peer_connected(id) -> void:
	print("CONECTADO " + str(id))

func peer_disconnected(id) -> void:
	print("DESCONECTADO " + str(id))

func connected_to_server() -> void:
	print("CONECTADO AL SERVER")
	SendPlayerInfo.rpc_id(1,$VBoxContainer/LineEdit.text, multiplayer.get_unique_id())

func connection_failed() -> void:
	print("FALLO CONEXION")

func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port,2)
	if (error != OK):
		print("ERROR" + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	SendPlayerInfo($VBoxContainer/LineEdit.text, multiplayer.get_unique_id())
	print("READY FOR GAMIN!")
	
func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address,port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_init_button_down() -> void:
	StartGame.rpc()

@rpc("any_peer")
func SendPlayerInfo(names, id) -> void:
	if (!GlobalManager.players.has(id)):
		GlobalManager.players[id] = {
			"id" = id,
			"name" = names,
			"score" = 0
		}
	if (multiplayer.is_server()):
		for i in GlobalManager.players:
			SendPlayerInfo.rpc(GlobalManager.players[i].name, i)

@rpc("any_peer","call_local")
func StartGame() -> void:
	var scene = load("res://main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
