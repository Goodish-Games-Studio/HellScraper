extends Node3D


func host_game():
	$"Multiplayer ui".hide()
	MultiplayerGlobal.host_game()

func join_game():
	$"Multiplayer ui".hide()
	MultiplayerGlobal.join_game()
