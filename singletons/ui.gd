extends CanvasLayer

@onready var commMessages = %"comms-messages"

@onready var commMessageScene = preload("res://ui/comms-message/comms-message.tscn")

@onready var sfx_bus = AudioServer.get_bus_index("sfx")
@onready var bgm_bus = AudioServer.get_bus_index("bgm")

var off_screen_x = 200
var off_screen_tween_interval = 0.6
var comm_message_expire_time_seconds = 5.0

var message_queue: Array[String] = []

func _ready() -> void:
    %game_over.visible = false
    %player_win.visible = false
    %introduction.visible = true
    Global.on_game_over.connect(_on_game_over)
    Global.on_restart_game.connect(_on_restart_game)
    
    %sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
    %bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus))

func _process(_delta: float):
    if message_queue.size() > 0 && comm_messages_ready():
        _add_comm_message(message_queue.pop_front())

func add_comm_message(message: String) -> void:
    message_queue.push_back(message)

func comm_messages_ready() -> bool:
    var add_comm = true
    for m: CommsMessage in commMessages.get_children():
        if m.is_growing:
            add_comm = false
            break
    return add_comm

func _add_comm_message(message: String) -> void:
    Log.info("Msg: %s" % message)
    var commsMessage: CommsMessage = commMessageScene.instantiate()
    commMessages.add_child(commsMessage)
    commsMessage.message = message
    commsMessage.set_expiry_time(comm_message_expire_time_seconds)
    commMessages.move_child(commsMessage, 0)
    commsMessage.grow()

func _on_game_over(reason: String) -> void:
    Global.fade_play_screen(0.6)
    var total_seconds = Global.game_duration_seconds()
    var seconds = total_seconds % 60
    var minutes = floori((total_seconds - seconds) / 60)
    if reason == "player_win":
        %player_win.visible = true
        %win_info.text = "The enemy ship was destroyed in %s minutes and %s seconds" % [reason, minutes, seconds]
    else:
        %game_over.visible = true
        %game_over_reason.text = "%s\nYou lasted %s minutes and %s seconds" % [reason, minutes, seconds]

func _on_restart_game() -> void:
    Global.fade_play_screen(0.0)
    %game_over.visible = false
    %player_win.visible = false
    message_queue.clear()
    for m: CommsMessage in commMessages.get_children():
        m.queue_free()

func _on_restart_button_pressed() -> void:
    Global.restart_game()

func _on_bgm_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(bgm_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))

func _on_start_button_pressed() -> void:
    Global.start_game()
    %game_over.visible = false
    %player_win.visible = false
    %introduction.visible = false
