class_name Log

static func info(message: String) -> void:
    print("[%s] %s" % [ Time.get_datetime_string_from_system(), message ])
