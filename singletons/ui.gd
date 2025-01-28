extends CanvasLayer

@onready var commMessages: VBoxContainer = %"comms-messages"

@onready var commMessageScene = preload("res://ui/comms-message/comms-message.tscn")

var off_screen_x = 200
var off_screen_tween_interval = 0.6
var comm_message_expire_time_seconds = 5.0

func _ready() -> void:
    %game_over.visible = false
    Global.on_game_over.connect(_on_game_over)

func _process(delta: float) -> void:
    pass

func add_comm_message(message: String) -> void:
    var commsMessage = commMessageScene.instantiate()
    commMessages.add_child(commsMessage)
    commsMessage.message = message
    commMessages.move_child(commsMessage, 0)
    
    var tween = get_tree().create_tween()
    tween.tween_property(commsMessage, "position:x", off_screen_x, 0.0)
    tween.tween_property(commsMessage, "position:x", 0, off_screen_tween_interval)
    tween.tween_interval(comm_message_expire_time_seconds)
    tween.tween_property(commsMessage, "position:x", off_screen_x, off_screen_tween_interval)
    tween.tween_callback(commsMessage.queue_free)

func _on_game_over(reason: String) -> void:
    %game_over.visible = true
    %game_over_reason.text = reason
