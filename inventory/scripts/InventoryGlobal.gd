extends Node

@onready var hotbar: Inv = preload("res://inventory/hotbar.tres")
@onready var inventory: Inv = preload("res://inventory/inventory.tres")
@onready var full_hotbar = false

@onready var hot_selected = 0
@onready var item_selected: String
@onready var selected = false

@onready var inv_swap_selected: int #0-8 is hotbar, 9-43 is inventory


signal update


func insert_hot(item):
	hotbar.insert(item)

func insert_inv(item):
	inventory.insert(item)
