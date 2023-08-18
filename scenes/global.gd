extends Node

func save_dict(content: Dictionary, filename: String = "beer_with_me.dat"):
	var file = FileAccess.open("user://" + filename, FileAccess.WRITE_READ)
	var dict = file.get_var(true)
	if not dict:
		dict = {}
	for key in content:
		dict[key] = content[key]
	#print(dict)
	file.store_var(dict, true)

func load_dict(filename: String = "beer_with_me.dat"):
	var file
	var content
	if FileAccess.file_exists("user://" + filename):
		file = FileAccess.open("user://" + filename, FileAccess.READ)
		content = file.get_var(true)
	if not content:
		content = {}
	return content
