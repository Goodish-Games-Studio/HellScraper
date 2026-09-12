extends Node

signal host_created()

const LOBBY_TYPE := Steam.LOBBY_TYPE_FRIENDS_ONLY
const MAX_MEMBERS := 6

var peer: SteamMultiplayerPeer

 
func _ready() -> void:
	Steam.initRelayNetworkAccess()
	Steam.lobby_created.connect(on_lobby_created)
	Steam.lobby_joined.connect(on_lobby_joined)
	Steam.join_requested.connect(on_join_requested)


func _process(delta: float) -> void:
	Steam.run_callbacks()


func host_lobby() -> void:
	Steam.createLobby(LOBBY_TYPE, MAX_MEMBERS)


#Called when creating a lobby locally
func on_lobby_created(connect: int, lobby_id: int) -> void:
	#We are the host cause we made the lobby
	if connect == Steam.RESULT_OK:
		peer = SteamMultiplayerPeer.new()
		multiplayer.multiplayer_peer = peer
		host_created.emit()


#Called when joining a lobby as either host or friend
func on_lobby_joined(lobby_id: int, permissions: int, locked: bool, response: int) -> void:
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		#if we made the lobby we shouldnt create a new client peer
		if Steam.getLobbyOwner(lobby_id) == Steam.getSteamID():
			return
		peer = SteamMultiplayerPeer.new()
		peer.server_relay = true
		multiplayer.multiplayer_peer = peer


#Called when attempting to join through steam interface
func on_join_requested(lobby_id: int, steam_id: int) -> void:
	#emits the lobby_joined signal
	Steam.joinLobby(lobby_id)
