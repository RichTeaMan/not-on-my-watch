extends Control

@onready var commMessages: VBoxContainer = %"comms-messages"

@onready var commMessageScene = preload("res://ui/comms-message/comms-message.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    %"game-over".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Global.game_finished:
        %"game-over".visible = true

func add_comm_message(message: String) -> void:
    var commsMessage = commMessageScene.instantiate()
    
    commMessages.add_child(commsMessage)
    commsMessage.message = message
    commMessages.move_child(commsMessage, 0)
