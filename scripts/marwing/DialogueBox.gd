extends Popup

var current_line := 0
var convo = []
var typing := false
var done := false
export var auto := false            # whether or not the dialogue should auto-continue, or require user input to proceed

func _process (dt: float):
    if not visible:
        $VoicePlayer.stop()    # keeps final voice line from continuing to play if the player exits out
    else:
        $Tick.hide()

        if not typing:
            if auto and not $VoicePlayer.playing:
                start_line(current_line+1)
            elif not auto:
                $Tick.show()    # indicate that we can move on
                if Input.is_action_just_pressed("ui_accept"):
                    start_line(current_line+1)
                    $SFXPlayer.play()    # audio feedback we're moving to the next line
        elif $Label.percent_visible <= 1:
            var delta := dt * (0.9 if Input.is_action_pressed("ui_accept") else 0.45)
            $Label.percent_visible = $Label.percent_visible + delta
            if $Label.percent_visible >= 1:
                $Label.percent_visible = 1
                typing = false

func start_line (line: int):
    if line < 0: return        # should likely never be a negative int, but better safe than sorry
    
    if line >= convo.size():
        hide()
        done = true
        return

    current_line = line
    typing = true
    $Label.bbcode_text = tr(convo[line].text)
    $Label.percent_visible = 0

    if ResourceLoader.exists(convo[line].portrait):
        var image = ResourceLoader.load(convo[line].portrait)
        $Portrait.texture = image

    # can be localized with Remaps, if this pr ever even gets added
    if ResourceLoader.exists(convo[line].audio):
        var audio = ResourceLoader.load(convo[line].audio)
        audio.loop_mode = 0
        $VoicePlayer.stream = audio
        $VoicePlayer.play()