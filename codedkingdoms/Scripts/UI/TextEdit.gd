extends TextEdit

# Define colors
const COLOR_COMMENT = Color(0.5, 0.5, 0.5)  # Grey for comments
const COLOR_STRING = Color(0.2, 0.8, 0.2)   # Green for strings
const COLOR_FUNCTION = Color(0.3, 0.3, 0.9) # Blue for function names
const COLOR_KEYWORD = Color(0.9, 0.2, 0.2)  # Red for keywords

# List of Python reserved keywords
const PYTHON_KEYWORDS = [
	"False", "None", "True", "and", "as", "assert", "async", "await",
	"break", "class", "continue", "def", "del", "elif", "else", "except",
	"finally", "for", "from", "global", "if", "import", "in", "is",
	"lambda", "nonlocal", "not", "or", "pass", "raise", "return", "try",
	"while", "with", "yield"
]

func _ready():
	var _dump = connect("text_changed", self, "_on_text_changed")
	update_syntax_highlighting()

func _on_text_changed():
	update_syntax_highlighting()

func update_syntax_highlighting():
	# Clear all color regions
	clear_colors()

	var line_count = get_line_count()

	for i in range(line_count):
		var line = get_line(i)
		
		# Highlight comments
		highlight_comments(line)
		
		# Highlight function definitions (using "def" keyword)
		highlight_functions(line)

		# Highlight reserved keywords
		highlight_keywords(line)

# Highlight comments (anything starting with #)
func highlight_comments(line_text: String):
	var comment_pos = line_text.find("#")
	if comment_pos != -1:
		add_color_region("#", str(line_text.length()), COLOR_COMMENT, true)  # line_only set to true

func highlight_functions(line_text: String):
	var def_pos = line_text.find("def ")
	if def_pos != -1:
		var start_function_name = def_pos + 4
		var end_function_name = line_text.find("(", start_function_name)
		if end_function_name != -1:
			add_color_region(line_text.substr(start_function_name, end_function_name - start_function_name), "", COLOR_FUNCTION, true)

# Highlight Python reserved keywords
func highlight_keywords(line_text: String):
	for keyword in PYTHON_KEYWORDS:
		var start_pos = line_text.find(keyword)
		while start_pos != -1:
			#print(line_text)
			#print(start_pos)
			#print(keyword, " ", keyword.length())
			add_color_region(line_text.substr(start_pos, keyword.length()), "", COLOR_KEYWORD, true)
			start_pos = line_text.find(keyword, start_pos + keyword.length())
			#print(start_pos)
			#print()
