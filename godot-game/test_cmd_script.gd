extends Label
var input_field: TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_field = get_node(^"../TextEdit")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _send() -> void:
	self.text = input_field.text
	 # Replace with function body.
