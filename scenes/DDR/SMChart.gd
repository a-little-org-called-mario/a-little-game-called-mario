class_name SMChart

## Head data
## note (jamspoon): some of this likely will never be implemented in dance mode, so feel free to prune
var title: String
var subtitle: String
var artist: String
var title_translit: String
var subtitle_translit: String
var artist_translit: String
var genre: String
var credit: String
var banner: Texture = null # we'll only populate these if we decide we want to use banner / bg
var background: Texture = null # ^
var lyrics: String = ""     # likely never to be used
var cd_title: String
var music: AudioStream
var offset: float
var bpm = []                    # array of { beat: float, bpm: float }
var stops = []                  #          { beat: float, seconds: float}
var sample_start: float
var sample_length: float
var selectable: bool

## Chart data
var chart_lists = []  # this will be populated by SMChartLists

func _init (): pass
