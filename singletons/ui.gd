extends CanvasLayer

@onready var commMessages: VBoxContainer = %"comms-messages"

@onready var commMessageScene = preload("res://ui/comms-message/comms-message.tscn")
# Called when the node enters the scene tree for the first time.
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

func _on_game_over(reason: String) -> void:
    %game_over.visible = true
    %game_over_reason.text = reason
