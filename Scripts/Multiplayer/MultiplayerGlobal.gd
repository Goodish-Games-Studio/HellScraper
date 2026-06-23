extends Node
 

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"


func host_game() -> void:
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
	pass

func remove_player(id: int):
	pass
