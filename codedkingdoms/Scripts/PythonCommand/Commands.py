from godot import exposed, export
from godot import *

@exposed
class Commands(Node):
	def _ready(self):
		self.command_manager = self.get_node("../../Player/CommandManager")
		
	def move(self, direction):
		return self.command_manager.walk(direction)
	
	def jump(self, direction):
		return self.command_manager.jump(direction)
	
	def distance_to_wall(self, direction):
		return self.command_manager.distance_to_wall(direction)

	def teleport(self, distance, direction):
		return self.command_manager.teleport(distance, direction)
		
	def on_number(self):
		return self.command_manager.on_number()

	def can_write(self):
		return self.command_manager.can_write()

	def write_number(self, number):
		return self.command_manager.write_number(number)

	def read_number(self):
		return self.command_manager.read_number()
