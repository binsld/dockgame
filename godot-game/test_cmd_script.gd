extends Label
var input_field: TextEdit
@export var websocket_url = "ws://localhost:8765/ws"
var socket = WebSocketPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get output node
	input_field = get_node(^"../TextEdit")
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Start connection. Wait 2 seconds end send "Init" message
		await get_tree().create_timer(2).timeout
		socket.send_text("Init")

func _process(delta: float) -> void:
	socket.poll()
	# get connection state
	var state = socket.get_ready_state()

	# if state is open. read "inbox"
	if state == WebSocketPeer.STATE_OPEN:
		#socket.send_text("Test packet")
		while socket.get_available_packet_count():
			var data = socket.get_packet().get_string_from_utf8()
			if data.length() > 0:
				self.text = data

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# Stop polling if connection closed
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false)

# send message to server
func _send() -> void:
	socket.send_text(input_field.text)
