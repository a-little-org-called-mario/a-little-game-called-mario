extends Label

func _ready():
  GitHubApi.connect("contributors_loaded", self, "_on_contributors_loaded")
  
func _on_contributors_loaded(names):
  text = "                                                                                    " +\
         names.join(" ") +\
         "                                                                                    "
