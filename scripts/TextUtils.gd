class_name TextUtils
extends Object


static func right(text: String) -> String:
	return "[right]%s[/right]" % text


static func center(text: String) -> String:
	return "[center]%s" % text


static func rainbow(text: String) -> String:
	return "[rainbow freq=0.5 sat=1 val=1]%s[/rainbow]" % text


static func wave(text: String) -> String:
	return "[wave amp=50 freq=2]%s[/wave]" % text
