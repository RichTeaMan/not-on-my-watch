extends CanvasLayer

@onready var commMessages = %"comms-messages"

@onready var commMessageScene = preload("res://ui/comms-message/comms-message.tscn")

var off_screen_x = 200
var off_screen_tween_interval = 0.6
var comm_message_expire_time_seconds = 5.0

func _ready() -> void:
    %game_over.visible = false
    Global.on_game_over.connect(_on_game_over)

func add_comm_message(message: String) -> void:
    Log.info("Msg: %s" % message)
    var commsMessage: CommsMessage = commMessageScene.instantiate()
    commMessages.add_child(commsMessage)
    commsMessage.message = message
    commsMessage.set_expiry_time(comm_message_expire_time_seconds)
    commMessages.move_child(commsMessage, 0)
    commsMessage.grow()

func _on_game_over(reason: String) -> void:
    %game_over.visible = true
    %game_over_reason.text = reason
