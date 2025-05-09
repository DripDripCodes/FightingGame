extends ColorRect

@export var text = ""
@export var character: PackedScene
func _ready():
	$RichTextLabel2.text = text
