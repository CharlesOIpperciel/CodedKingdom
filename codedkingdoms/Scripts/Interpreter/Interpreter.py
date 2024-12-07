from godot import exposed, export
from godot import *

import math
import threading
import re

# # # EXPOSED FUNCTIONS # # #
_commands = None
# Whenever you add an exposed function, please add its name here
illegal_overrides = [
	"move",
	"jump",
	"teleport",
	"distance_to_wall",
	"on_number",
	"can_write",
	"write_number",
	"read_number"
]

def move(direction):
	err = _commands.move(direction)
	if err != None:
		# TODO : could this be another error type?
		raise Exception(str(err))

def jump(direction):
	err = _commands.jump(direction)
	if err != None:
		# TODO : could this be another error type?
		raise Exception(str(err))

def distance_to_wall(direction):
	# TODO : throw an exception if direction is invalid
	ret = _commands.distance_to_wall(direction)
	if str(ret) == "WrongDirection":
		raise Exception("InvalidArguments")
	else:
		return ret
		
def on_number():
	return _commands.on_number()

def can_write():
	if not on_number():
		raise Exception("NotOnNumber")
	return _commands.can_write()

def write_number(number):
	if not on_number():
		raise Exception("NotOnNumber")
	return _commands.write_number(number)

def read_number():
	if not on_number():
		raise Exception("NotOnNumber")
	return _commands.read_number()

def teleport(distance, direction):
	err = _commands.teleport(distance, direction)
	if err != None:
		# TODO : could this be another error type?
		raise Exception(str(err))
# # # EXPOSED FUNCTIONS # # #

@exposed
class Interpreter(Node):
	def _ready(self):
		global _commands
		_commands = self.get_node("Commands")
		self.player = self.get_node("../Player")
		self.level = self.get_node("../..")
		self.control = self.get_node("../../../HUD")
		self.potatoe = "potatoe"
		self._compile_regex()
		self.add_to_group("interpreter")
		
	def _execute_code(self, _code):
		self._code = str(_code)
		self._is_safe = self._is_code_safe()
				
		if not self._is_safe[0]:
			self.display_exception(f"Unsafe code at position `{self._is_safe[1]}`, usage of forbidden statement `{self._is_safe[2]}`")
			return
		try:
			thread = threading.Thread(target=self._do_execute_code)
			thread.start()
		except Exception as e:
			print(f"An error occured: {e}")
	
	def _do_execute_code(self):
		try:
			self.disable_execute_button()
			self.enable_stop_button()
			exec(self._code, globals())
			# The player code is complete here. Verify if the player won.
			checkpoint_satisfied = self.level.check_win_conditions()
			if not checkpoint_satisfied:
				self.display_exception("Wrong solution :(\nTry again!")
			# If the player failed to complete this level, reset to the last
			# checkpoint, and then allow them to retry.
		except RecursionError as e:
			self.display_exception("Stack overflow: the most probable cause for this exception is a function calling itself with no end condition. Are you doing infinite recursion?")	
		except Exception as e:
			error_message = ""
			if e.args[0] == 'Oom':
				error_message = "Out of mana. Try a more efficient way to solve this puzzle."
				self.display_exception(error_message)
			elif e.args[0] == 'HitWall':
				error_message = "Hit a wall. Try a different path next time."
				self.display_exception(error_message)
			elif e.args[0] == 'HitCeiling':
				error_message = "Hit a Ceiling. Try a different path next time."
				self.display_exception(error_message)
			elif e.args[0] == 'ActionCancelled':
				# This is a special case of exception, where the exception is thrown by
				# the action of the player. No need to display it to the player in this case.
				self.get_tree().get_nodes_in_group("player")[0].reset_to_last_checkpoint()
				self.enable_execute_button()
			else:
				error_message = f"{e}"
				self.display_exception(error_message)
		finally:
			self.disable_stop_button()
	
	def enable_execute_button(self):
		self.control.enable_execute_button()
	
	def disable_execute_button(self):
		self.control.disable_execute_button()
	
	def enable_stop_button(self):
		self.control.enable_stop_button()
	
	def disable_stop_button(self):
		self.control.disable_stop_button()
		
	def leave_group(self):
		self.remove_from_group("interpreter")

	def display_exception(self, error_message):
		self.control.display_exception(error_message)

	def _compile_regex(self):
		pattern = ""
		if len(illegal_overrides) == 0:
			self.pattern = None
			return
		pattern += self._format_illegal_override(illegal_overrides[0])
		pattern += f"|{self._format_illegal_assignment(illegal_overrides[0])}"
		for i in range(1, len(illegal_overrides)):
			pattern += f"|{self._format_illegal_override(illegal_overrides[i])}"
			pattern += f"|{self._format_illegal_assignment(illegal_overrides[i])}"
		for forbidden in forbiddens:
			pattern += f"|{forbidden}"
		for property in properties:
			pattern += f"|{self._format_illegal_assignment(property)}"
		for method in methods:
			pattern += f"|{method}"
		self.pattern = re.compile(pattern)
		# never remove a test, they say. 
		#self._test_regex()
		#self._test_find_first_illegal_redefinition("def   move(\"RIGHT\")")
		return

	def _format_illegal_override(self, override):
		return f"def +{override}"
	
	def _format_illegal_assignment(self, assignment):
		return f"^{assignment} *=| +{assignment} *="

	def _test_regex(self):
		_test_strings = [
			"balbal\n\ndef    movepafafaefi\n\ndefteleport     \n\ndef teleport():\n\tmove",
			"def   a_legitimate_function():\n\tmove(\"RIGHT\")",
			"great_variable_name = read_number()",
			"move= asdfasdf asdfasdfasdf\n\n",
			"potatoe   move    =asdfadfhauoifhe",
			"move= set_process"
		]
		_expected = [
			["def    move", "def teleport"],
			[],
			[],
			["move="],
			["   move    ="],
			["move=", "set_process"]
		]
		
		for i in range(len(_test_strings)):
			results = self.pattern.findall(_test_strings[i])
			if len(results) != len(_expected[i]):
				print(f"wrong number of match found for test case {i}")
			for j in range(len(results)):
				match_found = results[j]
				expected = _expected[i][j]
				if match_found != expected:
					print(f"Error: expected: {expected} ::: got: {match_found}")

	def _test_find_first_illegal_redefinition(self, user_code):
		if self._find_illegal_code(user_code) != "def   move":
			print("Wrong match found")

	def _find_illegal_code(self, user_code):
		if self.pattern == None:
			print("Regex not initialized")
			return None
		found = self.pattern.search(user_code)
		if found is None:
			return None
		return found.group(0)

	def _is_code_safe(self):
		"""
		Check if the code contains unsafe imports or expressions.
		
		"""

		illegal_code = self._find_illegal_code(self._code)
		if illegal_code != None:
			return (False, self._code.find(illegal_override), illegal_override)
		
		return (True, )


forbiddens = [
	"__import__",
	"import",
	" open\(",
	"_code",
	"_is_safe",
	"exec\(",
	"exit\(",
	"globals\(",
	"locals\(",
	"_execute_code",
	"thread",
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
