extends Node
class_name GameEvents

const Enums = preload("res://Enums.gd")

signal something_happened(payload, category: Enums.EVENT_CATEGORY)

func handle_event(category: Enums.EVENT_CATEGORY , payload):
	something_happened.emit(category, payload)
