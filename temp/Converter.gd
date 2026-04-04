extends RichTextLabel

func _ready() -> void:
	var outputFile: FileAccess = FileAccess.open("res://temp/output.txt", FileAccess.WRITE)
	var txt: String = ""
	for character: String in text:
		if character == "\t":
			txt += "[\\t]"
		elif character == "\n":
			txt += "[\\n]"
		else:
			txt += character
	print(txt)
	outputFile.store_string(txt)
