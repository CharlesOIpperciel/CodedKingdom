from godot import exposed, export
from godot import *

import math

@exposed
class PythonInterpreter(Node):
	"""
	14. Longest Common Prefix

	Write a function to find the longest common prefix string amongst an array of strings.
	If there is no common prefix, return an empty string "".

	Example 1:
	Input: strs = ["flower","flow","flight"]
	Output: "fl"

	Example 2:
	Input: strs = ["dog","racecar","car"]
	Output: ""
	Explanation: There is no common prefix amongst the input strings.
	
	Solution: 
	
	def P1(strs):
	if len(strs) <= 1:
		return strs[0]
		
	strs.sort(key=len)
	tribute = strs[0]
	index = 0
	cond = True
	while cond and index != len(tribute):
		for word in strs:
			if tribute[index] != word[index]:
				return tribute[:index]
		index += 1
	return tribute[:index]
	
	"""

	def _run_tests(self, _code, _puzzle):
		self._code = str(_code)
		self._puzzle = str(_puzzle)
		self._is_safe = self._is_code_safe()
		
		if not self._is_safe[0]:
			print(f"User code unsafe at position `{self._is_safe[1]}`, usage of forbidden statement `{self._is_safe[2]}`")
			return
		
		for i in range(len(_tests[self._puzzle])):
			self._run_test(i, _tests[self._puzzle][i])
	
	def _run_test(self, i, _test):
		result_output = self._capture_output(_test[0])
		if result_output == _test[1]:
			print(f"{self._puzzle} Test {i + 1}: Passed")
		else:
			print(f"{self._puzzle} Test {i + 1}: Failed (input = {_test[0]}) Expected: {_test[1]}, Got: {result_output}")
	def _capture_output(self, input):
		"""
		Capture the printed output from executing user code.
		
		*** Keep in mind that if you print() in this method, it will get captured. ***
		
		"""
		
		#old_stdout = sys.stdout  # Save the current stdout
		#new_stdout = io.StringIO()  # Create a new string buffer
		#sys.stdout = new_stdout  # Redirect stdout to the buffer
		try:
			_output = None
			local_namespace = {'_output': _output}
			#try:
			test_code = self._code + f"\n_output = ({self._puzzle}({input}))"
			exec(test_code, globals(), local_namespace)
		except Exception as e:
			print(f"An error occured: {e}")
		
		return local_namespace['_output']

	def _is_code_safe(self):
		"""
		Check if the code contains unsafe imports or expressions.
		
		"""
		
		forbiddens = [
			"__import__",
			"import",
			" open(",
			"_code",
			"_is_safe",
			"exec(",
			"exit(",
			"globals(",
			"locals(",
		]
		
		properties = [
			"auto_translate_mode",
			"editor_description",
			"multiplayer",
			"name",
			"owner",
			"physics_interpolation_mode",
			"process_mode",
			"process_physics_priority",
			"process_priority",
			"process_thread_group",
			"process_thread_group_order",
			"process_thread_messages",
			"scene_file_path",
			"unique_name_in_owner",
		]
		
		methods = [
			"_enter_tree",
			"_exit_tree",
			"_get_configuration_warnings",
			"_input",
			"_physics_process",
			"_process",
			"_ready",
			"_shortcut_input",
			"_unhandled_input",
			"_unhandled_key_input",
			"add_child",
			"add_sibling",
			"add_to_group",
			"atr",
			"atr_n",
			"call_deferred_thread_group",
			"call_thread_safe",
			"can_process",
			"create_tween",
			"duplicate",
			"find_child",
			"find_children",
			"find_parent",
			"get_child",
			"get_child_count",
			"get_children",
			"get_groups",
			"get_index",
			"get_last_exclusive_window",
			"get_multiplayer_authority",
			"get_node",
			"get_node_and_resource",
			"get_node_or_null",
			"get_parent",
			"get_path",
			"get_path_to",
			"get_physics_process_delta_time",
			"get_process_delta_time",
			"get_scene_instance_load_placeholder",
			"get_tree",
			"get_tree_string",
			"get_tree_string_pretty",
			"get_viewport",
			"get_window",
			"has_node",
			"has_node_and_resource",
			"is_ancestor_of",
			"is_displayed_folded",
			"is_editable_instance",
			"is_greater_than",
			"is_in_group",
			"is_inside_tree",
			"is_multiplayer_authority",
			"is_node_ready",
			"is_part_of_edited_scene",
			"is_physics_processing",
			"is_processing",
			"is_processing_input",
			"is_processing_shortcut_input",
			"is_processing_unhandled_input",
			"is_processing_unhandled_key_input",
			"move_child",
			"notify_deferred_thread_group",
			"notify_thread_safe",
			"propagate_call",
			"propagate_notification",
			"queue_free",
			"remove_child",
			"remove_from_group",
			"reparent",
			"replace_by",
			"request_ready",
			"rpc",
			"rpc_config",
			"rpc_id",
			"set_deferred_thread_group",
			"set_display_folded",
			"set_editable_instance",
			"set_multiplayer_authority",
			"set_physics_process",
			"set_process",
			"set_process_input",
			"set_process_shortcut_input",
			"set_process_unhandled_input",
			"set_process_unhandled_key_input",
			"set_scene_instance_load_placeholder",
			"set_thread_safe",
			"update_configuration_warnings",
		]
		
		for forbidden in forbiddens:
			if forbidden in self._code:
				return (False, self._code.find(forbidden), forbidden)
		for property in properties:
			if property in self._code:
				return (False, self._code.find(property), property)
				
		for method in methods:
			if method in self._code:
				return (False, self._code.find(method), method)

		return (True, )


_tests = {
	"P1": [
		('["flow", "flower", "flowery"]', "flow\n"),
		('["dog", "dodge", "doggy"]', "do\n"),
		('["dog", "racecar", "cat"]', "\n"),
	]
}

