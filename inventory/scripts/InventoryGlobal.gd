extends Node

@onready var hotbar: Inv = preload("res://inventory/hotbar.tres")
@onready var inventory: Inv = preload("res://inventory/inventory.tres")
@onready var full_hotbar = false


signal update


func insert_hot(item):
	hotbar.insert(item)

func insert_inv(item):
	inventory.insert(item)
