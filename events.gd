extends Node
class_name GameEvents
#@onready var ev = get_node("/root/tutorial")



signal roomChanged(room: String)
signal playerMoved(position: Vector2)
signal something_happened(tag: String)


func handle_event(event):
	#await ev.ready
	something_happened.emit(event)
