# Fetches contributor info from github.
extends Node

var contributors: Array = []

signal contributors_loaded(names)


func _ready():
	# Don't call the github api while testing in the editor
	# because we don't need it.
#	if OS.has_feature("editor"):
#		return
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	http_request.request(
		"https://api.github.com/repos/a-little-org-called-mario/a-little-game-called-mario/contributors"
	)
	yield(http_request, "request_completed")
	http_request.queue_free()


func _on_request_completed(result, _response_code, _headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	if _response_code != 200:
		print()
		print("ERROR: Got response code {code} while trying to get github contributors".format({
			"code": _response_code
		}))
		print("   BODY: {body}".format({
			"body": JSON.parse(body.get_string_from_utf8()).result
		}))
		print()
		return

	var json = JSON.parse(body.get_string_from_utf8())
	contributors = json.result
	var names: PoolStringArray = []
	for contributor in contributors:
		names.append(contributor["login"])

	emit_signal("contributors_loaded", names)
