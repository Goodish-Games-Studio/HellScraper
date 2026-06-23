extends Node
 

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var player_scene = preload("res://Scenes/Player/Player.tscn")

var players_spawn_node


func host_game() -> void:
	players_spawn_node = get_tree().get_current_scene().get_node("players")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(add_player) #add a player when one joins
	multiplayer.peer_disconnected.connect(remove_player)

func join_game():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP,SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer


func add_player(id: int):
	var player_to_add = player_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	players_spawn_node.add_child(player_to_add, true)

func remove_player(id: int):
	pass
