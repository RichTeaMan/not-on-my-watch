class_name CommsMessage extends MarginContainer

@export var message: String = "Test message": set = _set_message, get = _get_message

@onready var label: Label = %"message-label"
@onready var margin: MarginContainer = %message_margin

var is_growing = false
var grow_time = 0.5
var grow_size = 40
var grow_interval = 0
var remaining_grow_time = 0.0
var padding = 6
var expiry_time = 100_000_000 # a very large number

var moving_off_screen = false

func _process(delta: float):
    if moving_off_screen:
        return
    if !is_growing:
        expiry_time -= delta
        if expiry_time <= 0.0:
            move_off_screen()
        return
    remaining_grow_time -= delta
    if label["theme_override_constants/margin_bottom"] < padding:
        label["theme_override_constants/margin_bottom"] += grow_interval * delta
    else:
        label["theme_override_constants/margin_bottom"] = padding
    if remaining_grow_time < 0.0:
        is_growing = false
        remaining_grow_time = 0.0
        custom_minimum_size.y = grow_size
        
        margin.visible = true
    else:
        custom_minimum_size.y = custom_minimum_size.y + (grow_interval * delta)

func _set_message(_message: String):
    label.text = _message

func _get_message() -> String:
    return label.text

func move_off_screen():
    moving_off_screen = true
    var tween = get_tree().create_tween()
    tween.tween_property(self, "position:x", size.x * 2, 5.0).set_trans(Tween.TRANS_LINEAR)
    tween.tween_callback(queue_free)

func grow():
    var font: Font = label["theme_override_fonts/font"]
    var font_size: int = label["theme_override_font_sizes/font_size"]
    label["theme_override_constants/margin_bottom"] = 0
    var label_size = font.get_multiline_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, 300, font_size)
    grow_size = label_size.y + margin["theme_override_constants/margin_bottom"] + margin["theme_override_constants/margin_top"]
    grow_interval = grow_size / grow_time
    margin.visible = false
    custom_minimum_size.y = 0.0
    size.y = 0
    remaining_grow_time = grow_time
    is_growing = true

func set_expiry_time(p_expiry_time: int):
    expiry_time = p_expiry_time
