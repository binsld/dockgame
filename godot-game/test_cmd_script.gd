extends Label
var input_field: TextEdit
@export var websocket_url = "ws://localhost:8765/ws"
var socket = WebSocketPeer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_field = get_node(^"../TextEdit")
		# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	print(err, OK)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Wait for the socket to connect.
		await get_tree().create_timer(2).timeout

		# Send data.
		socket.send_text("Init")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.
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

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.

func _send() -> void:
	socket.send_text(input_field.text)
